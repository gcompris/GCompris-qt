#include <QtDebug>
#include <QtGui/QGuiApplication>
#include <QtQuick/QQuickWindow>
#include <QtQml>
#include <QObject>
#include <QTranslator>

#include <QSettings>

#include "ApplicationInfo.h"
#include "ActivityInfoTree.h"
#include "File.h"

int main(int argc, char *argv[])
{
	QGuiApplication app(argc, argv);
	app.setOrganizationName("GCompris");
	app.setApplicationName("GCompris");
    app.setOrganizationDomain("kde.org");

    ApplicationInfo::init();
	ActivityInfoTree::init();
	File::init();

    // Load translation
    QString locale;
    bool isFullscreen = false;
    {
        // Local scope for config
        QSettings config(QStandardPaths::writableLocation(QStandardPaths::GenericConfigLocation) + "/gcompris/GCompris.conf",
                         QSettings::IniFormat);
        // Get locale
        if(config.contains("General/locale")) {
            locale = config.value("General/locale").toString();
            isFullscreen = config.value("General/fullscreen").toBool();
        }
        else {
            locale = "en_US.UTF-8";
        }
    }

    // Remove .UTF8
    locale.remove(".UTF-8");
    // Look for a translation using this
    QTranslator translator;
    if(!translator.load("gcompris_" + locale)) {
        qDebug() << "Unable to load translation, use en_US by default";
    }

    // Apply translation
    app.installTranslator(&translator);

    QQmlApplicationEngine engine(QUrl("qrc:/gcompris/src/core/main.qml"));
    QObject *topLevel = engine.rootObjects().value(0);

    QQuickWindow *window = qobject_cast<QQuickWindow *>(topLevel);
    if (!window) {
		qWarning("Error: Your root item has to be a Window.");
		return -1;
	}
    ApplicationInfo::setWindow(window);

    if(isFullscreen) {
        window->showFullScreen();
    }
    else {
        window->show();
    }

	return app.exec();

}
