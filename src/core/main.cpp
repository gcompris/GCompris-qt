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
	app.setOrganizationName("GCompris");
    app.setApplicationName("GCompris");
    app.setOrganizationDomain("kde.org");

    ApplicationInfo::init();
	ActivityInfoTree::init();
    ApplicationSettings::init();
	File::init();

    // Load configuration
    QString locale;
    // Getting fullscreen mode from config if exist, else true is default value
    bool isFullscreen = true;
    {
        // Local scope for config
        QSettings config(QStandardPaths::writableLocation(QStandardPaths::GenericConfigLocation) +
                         "/gcompris/GCompris.conf",
                         QSettings::IniFormat);
        // Get locale
        if(config.contains("General/locale")) {
            locale = config.value("General/locale").toString();
            isFullscreen = config.value("General/fullscreen").toBool();
        } else {
            locale = "en_US.UTF-8";
        }
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
    if(!translator.load("gcompris_" + locale, QCoreApplication::applicationDirPath())) {
        qDebug() << "Unable to load translation for locale " <<
                    locale << ", use en_US by default";
    }
#endif

    // Apply translation
    app.installTranslator(&translator);

	QQmlApplicationEngine engine(QUrl("qrc:/gcompris/src/core/main.qml"));
    QObject *topLevel = engine.rootObjects().value(0);

    QQuickWindow *window = qobject_cast<QQuickWindow *>(topLevel);
    if (!window) {
		qWarning("Error: Your root item has to be a Window.");
		return -1;
	}

    window->setIcon(QIcon(QPixmap(QString::fromUtf8(":/gcompris/src/core/resource/gcompris_icon.png"))));

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
