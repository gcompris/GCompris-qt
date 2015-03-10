/* GCompris - main.cpp
 *
 * Copyright (C) 2014 Bruno Coudoin
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
#include <QtDebug>
#include <QtGui/QGuiApplication>
#include <QtQuick/QQuickWindow>
#include <QQmlApplicationEngine>
#include <QStandardPaths>
#include <QObject>
#include <QTranslator>
#include <QCommandLineParser>
#include <QCursor>
#include <QPixmap>
#include <QSettings>

#include "ApplicationInfo.h"
#include "ActivityInfoTree.h"
#include "File.h"
#include "DownloadManager.h"

bool loadAndroidTranslation(QTranslator &translator, const QString &locale)
{
    QFile file("assets:/gcompris_" + locale + ".qm");

    file.open(QIODevice::ReadOnly);
    QDataStream in(&file);
    uchar *data = (uchar*)malloc(file.size());

    if(!file.exists())
        qDebug() << "file assets:/" << locale << ".qm exists";

    in.readRawData((char*)data, file.size());

    if(!translator.load(data, file.size())) {
        qDebug() << "Unable to load translation for locale " <<
                    locale << ", use en_US by default";
        free(data);
        return false;
    }
    // Do not free data, it is still needed by translator
    return true;
}

int main(int argc, char *argv[])
{
	QGuiApplication app(argc, argv);
    app.setOrganizationName("KDE");
    app.setApplicationName(GCOMPRIS_APPLICATION_NAME);
    app.setOrganizationDomain("kde.org");
    app.setApplicationVersion(ApplicationInfo::GCVersion());

    QCommandLineParser parser;
    parser.setApplicationDescription("GCompris is an educational software for children 2 to 10");
    parser.addHelpOption();
    parser.addVersionOption();
    QCommandLineOption exportActivitiesAsSQL("export-activities-as-sql", "Export activities as SQL");
    parser.addOption(exportActivitiesAsSQL);
	QCommandLineOption clDefaultCursor(QStringList() << "c" << "cursor",
									   "run GCompris with the default system cursor.");
	parser.addOption(clDefaultCursor);
	QCommandLineOption clNoCursor(QStringList() << "C" << "nocursor",
									   "run GCompris without cursor (touch screen mode).");
	parser.addOption(clNoCursor);
	parser.process(app);


    ApplicationInfo::init();
	ActivityInfoTree::init();
    ApplicationSettings::init();
	File::init();
	DownloadManager::init();

    // Must be done after ApplicationSettings is constructed because we get an
    // async callback from the payment system
    ApplicationSettings::getInstance()->checkPayment();

    // Load configuration
    QString locale;
    // Getting fullscreen mode from config if exist, else true is default value
    bool isFullscreen = true;
    {
        // Local scope for config
        QSettings config(QStandardPaths::writableLocation(QStandardPaths::GenericConfigLocation) +
                         "/gcompris/" + GCOMPRIS_APPLICATION_NAME + ".conf",
                         QSettings::IniFormat);
        // Get locale
        if(config.contains("General/locale")) {
            locale = config.value("General/locale").toString();
        } else {
            locale = GC_DEFAULT_LOCALE;
        }
        if(locale == GC_DEFAULT_LOCALE)
            locale = QString(QLocale::system().name() + ".UTF-8");

        if(config.contains("General/fullscreen")) {
            isFullscreen = config.value("General/fullscreen").toBool();
        }

		// Set the cursor image
		bool defaultCursor = false;
		if(config.contains("General/defaultCursor")) {
			defaultCursor = config.value("General/defaultCursor").toBool();
		}
		if(!defaultCursor && !parser.isSet(clDefaultCursor))
			QGuiApplication::setOverrideCursor(
						QCursor(QPixmap(":/gcompris/src/core/resource/cursor.png"),
								0, 0));

		// Hide the cursor
		bool noCursor = false;
		if(config.contains("General/noCursor")) {
			noCursor = config.value("General/noCursor").toBool();
		}
		if(noCursor || parser.isSet(clNoCursor))
			QGuiApplication::setOverrideCursor(QCursor(Qt::BlankCursor));
    }

    // Load translation
    // Remove .UTF8
    locale.remove(".UTF-8");
    // Look for a translation using this
    QTranslator translator;

#if defined(Q_OS_ANDROID)
    if(!loadAndroidTranslation(translator, locale))
        loadAndroidTranslation(translator, ApplicationInfo::localeShort(locale));
#else

    if(!translator.load("gcompris_" + locale, QString("%1/%2/translations").arg(QCoreApplication::applicationDirPath(), GCOMPRIS_DATA_FOLDER))) {
        qDebug() << "Unable to load translation for locale " <<
                    locale << ", use en_US by default";
    }
#endif

    // Apply translation
    app.installTranslator(&translator);

    // Update execution counter
    ApplicationSettings::getInstance()->setExeCount(ApplicationSettings::getInstance()->exeCount() + 1);

    // Register voices-resources for current locale, updates/downloads only if
    // not prohibited by the settings
    DownloadManager::getInstance()->updateResource(DownloadManager::getInstance()
        ->getVoicesResourceForLocale(locale));

	QQmlApplicationEngine engine(QUrl("qrc:/gcompris/src/core/main.qml"));
	QObject::connect(&engine, SIGNAL(quit()), DownloadManager::getInstance(),
            SLOT(shutdown()));

    if(parser.isSet(exportActivitiesAsSQL)) {
        ActivityInfoTree *menuTree(qobject_cast<ActivityInfoTree*>(ActivityInfoTree::menuTreeProvider(&engine, NULL)));
        menuTree->exportAsSQL();
        exit(0);
    }

    QObject *topLevel = engine.rootObjects().value(0);

    QQuickWindow *window = qobject_cast<QQuickWindow *>(topLevel);
    if (!window) {
		qWarning("Error: Your root item has to be a Window.");
		return -1;
	}

    ApplicationInfo::setWindow(window);

    window->setIcon(QIcon(QPixmap(QString::fromUtf8(":/gcompris/src/core/resource/gcompris-icon.png"))));

    if(isFullscreen) {
        window->showFullScreen();
    }
    else {
        window->show();
    }

	return app.exec();

}
