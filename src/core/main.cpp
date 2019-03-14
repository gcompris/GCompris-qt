/* GCompris - main.cpp
 *
 * Copyright (C) 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
#include <QtDebug>
#include <QApplication>
#include <QQuickWindow>
#include <QQmlApplicationEngine>
#include <QStandardPaths>
#include <QObject>
#include <QTranslator>
#include <QCommandLineParser>
#include <QCursor>
#include <QPixmap>
#include <QSettings>

#include "GComprisPlugin.h"
#include "ApplicationInfo.h"
#include "ActivityInfoTree.h"
#include "DownloadManager.h"

bool loadAndroidTranslation(QTranslator &translator, const QString &locale)
{
    QFile file("assets:/share/GCompris/gcompris_" + locale + ".qm");

    file.open(QIODevice::ReadOnly);
    QDataStream in(&file);
    uchar *data = (uchar*)malloc(file.size());

    if(!file.exists())
        qDebug() << "file assets:/share/GCompris/gcompris_" << locale << ".qm does not exist";

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

// Return the locale
QString loadTranslation(QSettings &config, QTranslator &translator)
{
    QString locale;
    // Get locale
    locale = config.value("General/locale", GC_DEFAULT_LOCALE).toString();

    if(locale == GC_DEFAULT_LOCALE)
        locale = QString(QLocale::system().name() + ".UTF-8");

    if(locale == "C.UTF-8" || locale == "en_US.UTF-8")
        return "en_US";

    // Load translation
    // Remove .UTF8
    locale.remove(".UTF-8");

#if defined(Q_OS_ANDROID)
    if(!loadAndroidTranslation(translator, locale))
        loadAndroidTranslation(translator, ApplicationInfo::localeShort(locale));
#else

#if (defined(Q_OS_LINUX) || defined(Q_OS_UNIX))
    // only useful for translators: load from $application_dir/../share/... if exists as it is where kde scripts install translations
    if(translator.load("gcompris_qt.qm", QString("%1/../share/locale/%2/LC_MESSAGES").arg(QCoreApplication::applicationDirPath(), locale))) {
        qDebug() << "load translation for locale " << locale << " in " <<
            QString("%1/../share/locale/%2/LC_MESSAGES").arg(QCoreApplication::applicationDirPath(), locale);
    }
    else if(translator.load("gcompris_qt.qm", QString("%1/../share/locale/%2/LC_MESSAGES").arg(QCoreApplication::applicationDirPath(), locale.split('_')[0]))) {
        qDebug() << "load translation for locale " << locale << " in " <<
            QString("%1/../share/locale/%2/LC_MESSAGES").arg(QCoreApplication::applicationDirPath(), locale.split('_')[0]);
    }
    else
#endif
    if(!translator.load("gcompris_" + locale, QString("%1/%2/translations").arg(QCoreApplication::applicationDirPath(), GCOMPRIS_DATA_FOLDER))) {
        qDebug() << "Unable to load translation for locale " <<
                    locale << ", use en_US by default";
    }
#endif
    return locale;
}

int main(int argc, char *argv[])
{
    // Disable it because we already support HDPI display natively
    qunsetenv("QT_DEVICE_PIXEL_RATIO");

    QApplication app(argc, argv);
    app.setOrganizationName("KDE");
    app.setApplicationName(GCOMPRIS_APPLICATION_NAME);
    app.setOrganizationDomain("kde.org");
    app.setApplicationVersion(ApplicationInfo::GCVersion());
    
    //add a variable to disable default fullscreen on Mac, see below..
#if defined(Q_OS_MAC)
    // Sandboxing on MacOSX as documented in:
    // http://doc.qt.io/qt-5/osx-deployment.html
    QDir dir(QGuiApplication::applicationDirPath());
    dir.cdUp();
    dir.cd("Plugins");
    QGuiApplication::setLibraryPaths(QStringList(dir.absolutePath()));
#endif

    // Local scope for config
    QSettings config(QStandardPaths::writableLocation(QStandardPaths::GenericConfigLocation) +
                     "/gcompris/" + GCOMPRIS_APPLICATION_NAME + ".conf",
                     QSettings::IniFormat);

    // Load translations
    QTranslator translator;
    loadTranslation(config, translator);
    // Apply translation
    app.installTranslator(&translator);

    QCommandLineParser parser;
    parser.setApplicationDescription("GCompris is an educational software for children 2 to 10");
    parser.addHelpOption();
    parser.addVersionOption();
    QCommandLineOption exportActivitiesAsSQL("export-activities-as-sql", "Export activities as SQL");
    parser.addOption(exportActivitiesAsSQL);
    QCommandLineOption clDefaultCursor(QStringList() << "c" << "cursor",
                                       QObject::tr("Run GCompris with the default system cursor."));
    parser.addOption(clDefaultCursor);
    QCommandLineOption clNoCursor(QStringList() << "C" << "nocursor",
                                       QObject::tr("Run GCompris without cursor (touch screen mode)."));
    parser.addOption(clNoCursor);
    QCommandLineOption clFullscreen(QStringList() << "f" << "fullscreen",
                                       QObject::tr("Run GCompris in fullscreen mode."));
    parser.addOption(clFullscreen);
    QCommandLineOption clWindow(QStringList() << "w" << "window",
                                       QObject::tr("Run GCompris in window mode."));
    parser.addOption(clWindow);
    QCommandLineOption clSound(QStringList() << "s" << "sound",
                                       QObject::tr("Run GCompris with sound enabled."));
    parser.addOption(clSound);
    QCommandLineOption clMute(QStringList() << "m" << "mute",
                                       QObject::tr("Run GCompris without sound."));
    parser.addOption(clMute);
    QCommandLineOption clWithoutKioskMode(QStringList() << "disable-kioskmode",
                                       QObject::tr("Disable the kiosk mode (default)."));
    parser.addOption(clWithoutKioskMode);
    QCommandLineOption clWithKioskMode(QStringList() << "enable-kioskmode",
                                       QObject::tr("Enable the kiosk mode."));
    parser.addOption(clWithKioskMode);

    QCommandLineOption clSoftwareRenderer(QStringList() << "software-renderer",
                                       QObject::tr("Use software renderer instead of openGL (slower but should run with any graphical card, needs Qt 5.8 minimum)."));
    parser.addOption(clSoftwareRenderer);
    QCommandLineOption clOpenGLRenderer(QStringList() << "opengl-renderer",
                                       QObject::tr("Use openGL renderer instead of software (faster but crash potentially depending on your graphical card)."));
    parser.addOption(clOpenGLRenderer);

    parser.process(app);

    GComprisPlugin plugin;
    plugin.registerTypes("GCompris");
    ActivityInfoTree::registerResources();

    // Tell media players to stop playing, it's GCompris time
    ApplicationInfo::getInstance()->requestAudioFocus();

    // Must be done after ApplicationSettings is constructed because we get an
    // async callback from the payment system
    ApplicationSettings::getInstance()->checkPayment();

    // Disable default fullscreen launch on Mac as it's a bit broken, window is behind desktop bars
#if defined(Q_OS_MAC)
    bool isFullscreen = false;
#else
    // for other platforms, fullscreen is the default value
    bool isFullscreen = true;
#endif
    {
        isFullscreen = config.value("General/fullscreen", isFullscreen).toBool();

        // Set the cursor image
        bool defaultCursor = config.value("General/defaultCursor", false).toBool();

        if(!defaultCursor && !parser.isSet(clDefaultCursor))
            QGuiApplication::setOverrideCursor(
                                               QCursor(QPixmap(":/gcompris/src/core/resource/cursor.svg"),
                                                       0, 0));

        // Hide the cursor
        bool noCursor = config.value("General/noCursor", false).toBool();

        if(noCursor || parser.isSet(clNoCursor))
            QGuiApplication::setOverrideCursor(QCursor(Qt::BlankCursor));
    }

    // Update execution counter
    ApplicationSettings::getInstance()->setExeCount(ApplicationSettings::getInstance()->exeCount() + 1);

    if(parser.isSet(clFullscreen)) {
        isFullscreen = true;
    }
    if(parser.isSet(clWindow)) {
        isFullscreen = false;
    }
    if(parser.isSet(clMute)) {
        ApplicationSettings::getInstance()->setIsAudioEffectsEnabled(false);
        ApplicationSettings::getInstance()->setIsAudioVoicesEnabled(false);
    }
    if(parser.isSet(clSound)) {
        ApplicationSettings::getInstance()->setIsAudioEffectsEnabled(true);
        ApplicationSettings::getInstance()->setIsAudioVoicesEnabled(true);
    }
    if(parser.isSet(clWithoutKioskMode)) {
        ApplicationSettings::getInstance()->setKioskMode(false);
    }
    if(parser.isSet(clWithKioskMode)) {
        ApplicationSettings::getInstance()->setKioskMode(true);
    }
    if(parser.isSet(clSoftwareRenderer)) {
        ApplicationSettings::getInstance()->setRenderer(QStringLiteral("software"));
    }
    if(parser.isSet(clOpenGLRenderer)) {
        ApplicationSettings::getInstance()->setRenderer(QStringLiteral("opengl"));
    }

    // Set the renderer used
    const QString &renderer = ApplicationSettings::getInstance()->renderer();
    ApplicationInfo::getInstance()->setUseOpenGL(renderer != QLatin1String("software"));

#if QT_VERSION >= QT_VERSION_CHECK(5, 8, 0)
    if(renderer == QLatin1String("software"))
       QQuickWindow::setSceneGraphBackend(QSGRendererInterface::Software);
    else if(renderer == QLatin1String("opengl"))
       QQuickWindow::setSceneGraphBackend(QSGRendererInterface::OpenGL);
#endif

    QQmlApplicationEngine engine(QUrl("qrc:/gcompris/src/core/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::quit, DownloadManager::getInstance(),
                     &DownloadManager::shutdown);
    // add import path for shipped qml modules:
#ifdef SAILFISHOS
    engine.addImportPath(QStringLiteral("%1/../share/%2/lib/qml")
                         .arg(QCoreApplication::applicationDirPath()).arg(GCOMPRIS_APPLICATION_NAME));
#else
    engine.addImportPath(QStringLiteral("%1/../lib/qml")
                         .arg(QCoreApplication::applicationDirPath()));
#endif

    ApplicationInfo::getInstance()->setBox2DInstalled(engine);

    if(parser.isSet(exportActivitiesAsSQL)) {
        ActivityInfoTree *menuTree(qobject_cast<ActivityInfoTree*>(ActivityInfoTree::menuTreeProvider(&engine, nullptr)));
        menuTree->exportAsSQL();
        exit(0);
    }

    QObject *topLevel = engine.rootObjects().value(0);

    QQuickWindow *window = qobject_cast<QQuickWindow *>(topLevel);
    if (window == nullptr) {
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
