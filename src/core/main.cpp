/* GCompris - main.cpp
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
#include <QtDebug>
#include <QApplication>
#include <QQuickWindow>
#include <QQmlApplicationEngine>
#include <QQmlComponent>
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
    uchar *data = (uchar *)malloc(file.size());

    if (!file.exists())
        qDebug() << "file assets:/share/GCompris/gcompris_" << locale << ".qm does not exist";

    in.readRawData((char *)data, file.size());

    if (!translator.load(data, file.size())) {
        qDebug() << "Unable to load translation for locale " << locale << ", use en_US by default";
        free(data);
        return false;
    }
    // Do not free data, it is still needed by translator
    return true;
}

/**
 * Checks if the locale is supported. Locale may have been removed because
 * translation progress was not enough or invalid language put in configuration.
 */
bool isSupportedLocale(const QString &locale)
{
    bool isSupported = false;
    QQmlEngine engine;
    QQmlComponent component(&engine, QUrl("qrc:/gcompris/src/core/LanguageList.qml"));
    QObject *object = component.create();
    if (!object) {
        qWarning() << "isSupportedLocale:" << component.errors();
        return false;
    }
    QVariant variant = object->property("languages");
    QJSValue languagesList = variant.value<QJSValue>();
    const int length = languagesList.property("length").toInt();
    for (int i = 0; i < length; ++i) {
        if (languagesList.property(i).property("locale").toString() == locale) {
            isSupported = true;
        }
    }
    delete object;
    return isSupported;
}
// Return the locale
QString loadTranslation(const QSettings &config, QTranslator &translator)
{
    QString locale = config.value("General/locale", GC_DEFAULT_LOCALE).toString();

    if (!isSupportedLocale(locale)) {
        qDebug() << "locale" << locale << "not supported, defaulting to" << GC_DEFAULT_LOCALE;
        locale = GC_DEFAULT_LOCALE;
        ApplicationSettings::getInstance()->setLocale(locale);
    }

    if (locale == GC_DEFAULT_LOCALE)
        locale = QString(QLocale::system().name() + ".UTF-8");

    if (locale == "C.UTF-8")
        locale = "en_US.UTF-8";

    // Load translation
    // Remove .UTF8
    locale.remove(".UTF-8");

#if defined(Q_OS_ANDROID)
    if (!loadAndroidTranslation(translator, locale))
        loadAndroidTranslation(translator, ApplicationInfo::localeShort(locale));
#else

#if (defined(Q_OS_LINUX) || defined(Q_OS_UNIX))
    // only useful for translators: load from $application_dir/../share/... if exists as it is where kde scripts install translations
    if (translator.load("gcompris_qt.qm", QString("%1/../share/locale/%2/LC_MESSAGES").arg(QCoreApplication::applicationDirPath(), locale))) {
        qDebug() << "load translation for locale " << locale << " in " << QString("%1/../share/locale/%2/LC_MESSAGES").arg(QCoreApplication::applicationDirPath(), locale);
    }
    else if (translator.load("gcompris_qt.qm", QString("%1/../share/locale/%2/LC_MESSAGES").arg(QCoreApplication::applicationDirPath(), locale.split('_')[0]))) {
        qDebug() << "load translation for locale " << locale << " in " << QString("%1/../share/locale/%2/LC_MESSAGES").arg(QCoreApplication::applicationDirPath(), locale.split('_')[0]);
    }
    else
#endif
        if (!translator.load("gcompris_" + locale, QString("%1/%2/translations").arg(QCoreApplication::applicationDirPath(), GCOMPRIS_DATA_FOLDER))) {
        qDebug() << "Unable to load translation for locale " << locale << ", use en_US by default";
    }
#endif
    return locale;
}

int main(int argc, char *argv[])
{
    // Disable it because we already support HDPI display natively
    qunsetenv("QT_DEVICE_PIXEL_RATIO");

    QApplication app(argc, argv);
#if defined(UBUNTUTOUCH)
    app.setOrganizationName("org.kde.gcompris");
#else
    app.setOrganizationName("KDE");
#endif
    app.setApplicationName(GCOMPRIS_APPLICATION_NAME);
    app.setOrganizationDomain("kde.org");
    app.setApplicationVersion(ApplicationInfo::GCVersion());
    // Set desktop file name, as the built-in (orgDomain + appName) is not
    // the one we use (because appName is gcompris-qt, not gcompris)
    QGuiApplication::setDesktopFileName("org.kde.gcompris");

    // add a variable to disable default fullscreen on Mac, see below..
#if defined(Q_OS_MAC)
    // Sandboxing on MacOSX as documented in:
    // https://doc.qt.io/qt-5/osx-deployment.html
    QDir dir(QGuiApplication::applicationDirPath());
    dir.cdUp();
    dir.cd("Plugins");
    QGuiApplication::setLibraryPaths(QStringList(dir.absolutePath()));
#endif

    // Local scope for config
#if defined(UBUNTUTOUCH)
    QSettings config(QStandardPaths::writableLocation(QStandardPaths::AppConfigLocation) + "/gcompris/" + GCOMPRIS_APPLICATION_NAME + ".conf",
                     QSettings::IniFormat);
#else
    QSettings config(QStandardPaths::writableLocation(QStandardPaths::GenericConfigLocation) + "/gcompris/" + GCOMPRIS_APPLICATION_NAME + ".conf",
                     QSettings::IniFormat);

#endif

    QCommandLineParser parser;
    parser.setApplicationDescription("GCompris is an educational software for children 2 to 10");
    parser.addHelpOption();
    parser.addVersionOption();
    QCommandLineOption exportActivitiesAsSQL("export-activities-as-sql", "Export activities as SQL");
    parser.addOption(exportActivitiesAsSQL);
    QCommandLineOption clDefaultCursor(QStringList() << "c"
                                                     << "cursor",
                                       QObject::tr("Run GCompris with the default system cursor."));
    parser.addOption(clDefaultCursor);
    QCommandLineOption clNoCursor(QStringList() << "C"
                                                << "nocursor",
                                  QObject::tr("Run GCompris without cursor (touch screen mode)."));
    parser.addOption(clNoCursor);
    QCommandLineOption clFullscreen(QStringList() << "f"
                                                  << "fullscreen",
                                    QObject::tr("Run GCompris in fullscreen mode."));
    parser.addOption(clFullscreen);
    QCommandLineOption clWindow(QStringList() << "w"
                                              << "window",
                                QObject::tr("Run GCompris in window mode."));
    parser.addOption(clWindow);
    QCommandLineOption clSound(QStringList() << "s"
                                             << "sound",
                               QObject::tr("Run GCompris with sound enabled."));
    parser.addOption(clSound);
    QCommandLineOption clMute(QStringList() << "m"
                                            << "mute",
                              QObject::tr("Run GCompris without sound."));
    parser.addOption(clMute);
    QCommandLineOption clWithoutKioskMode(QStringList() << "disable-kioskmode",
                                          QObject::tr("Disable the kiosk mode (default)."));
    parser.addOption(clWithoutKioskMode);
    QCommandLineOption clWithKioskMode(QStringList() << "enable-kioskmode",
                                       QObject::tr("Enable the kiosk mode."));
    parser.addOption(clWithKioskMode);

    QCommandLineOption clSoftwareRenderer(QStringList() << "software-renderer",
                                          QObject::tr("Use software renderer instead of openGL (slower but should run with any graphical card)."));
    parser.addOption(clSoftwareRenderer);
    QCommandLineOption clOpenGLRenderer(QStringList() << "opengl-renderer",
                                        QObject::tr("Use openGL renderer instead of software (faster but crash potentially depending on your graphical card)."));
    parser.addOption(clOpenGLRenderer);

    QCommandLineOption clStartOnActivity("launch",
                                         QObject::tr("Specify the activity when starting GCompris."), "activity");
    parser.addOption(clStartOnActivity);

    QCommandLineOption clListActivities(QStringList() << "l"
                                                      << "list-activities",
                                        QObject::tr("Outputs all the available activities on the standard output."));
    parser.addOption(clListActivities);

    QCommandLineOption clDifficultyRange("difficulty",
                                         QObject::tr("Specify the range of activity difficulty to display for the session. Either a single value (2), or a range (3-6). Values must be between 1 and 6."), "difficulty");
    parser.addOption(clDifficultyRange);

    QCommandLineOption clStartOnLevel("start-level",
                                      QObject::tr("Specify on which level to start the activity. Only used when --launch option is used."), "startLevel");
    parser.addOption(clStartOnLevel);

    parser.process(app);

    GComprisPlugin plugin;
    plugin.registerTypes("GCompris");
    ActivityInfoTree::registerResources();

    // Load translations
    QTranslator translator;
    loadTranslation(config, translator);
    // Apply translation
    app.installTranslator(&translator);

    // Tell media players to stop playing, it's GCompris time
    ApplicationInfo::getInstance()->requestAudioFocus();

    // For android, request the permissions if not already allowed
    ApplicationInfo::getInstance()->checkPermissions();

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

        if (!defaultCursor && !parser.isSet(clDefaultCursor))
            QGuiApplication::setOverrideCursor(
                QCursor(QPixmap(":/gcompris/src/core/resource/cursor.svg"),
                        0, 0));

        // Hide the cursor
        bool noCursor = config.value("General/noCursor", false).toBool();

        if (noCursor || parser.isSet(clNoCursor))
            QGuiApplication::setOverrideCursor(QCursor(Qt::BlankCursor));
    }

    // Update execution counter
    ApplicationSettings::getInstance()->setExeCount(ApplicationSettings::getInstance()->exeCount() + 1);

    if (parser.isSet(clFullscreen)) {
        isFullscreen = true;
    }
    if (parser.isSet(clWindow)) {
        isFullscreen = false;
    }
    if (parser.isSet(clMute)) {
        ApplicationSettings::getInstance()->setIsAudioEffectsEnabled(false);
        ApplicationSettings::getInstance()->setIsAudioVoicesEnabled(false);
    }
    if (parser.isSet(clSound)) {
        ApplicationSettings::getInstance()->setIsAudioEffectsEnabled(true);
        ApplicationSettings::getInstance()->setIsAudioVoicesEnabled(true);
    }
    if (parser.isSet(clWithoutKioskMode)) {
        ApplicationSettings::getInstance()->setKioskMode(false);
    }
    if (parser.isSet(clWithKioskMode)) {
        ApplicationSettings::getInstance()->setKioskMode(true);
    }
    if (parser.isSet(clSoftwareRenderer)) {
        ApplicationSettings::getInstance()->setRenderer(QStringLiteral("software"));
    }
    if (parser.isSet(clOpenGLRenderer)) {
        ApplicationSettings::getInstance()->setRenderer(QStringLiteral("opengl"));
    }

    // Set the renderer used
    const QString &renderer = ApplicationSettings::getInstance()->renderer();
    ApplicationInfo::getInstance()->setUseOpenGL(renderer != QLatin1String("software"));

    if (renderer == QLatin1String("software")) {
#if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
        QQuickWindow::setGraphicsApi(QSGRendererInterface::Software);
#else
        QQuickWindow::setSceneGraphBackend(QSGRendererInterface::Software);
#endif
    }
    else if (renderer == QLatin1String("opengl")) {
#if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
        QQuickWindow::setGraphicsApi(QSGRendererInterface::OpenGL);
#else
        QQuickWindow::setSceneGraphBackend(QSGRendererInterface::OpenGL);
#endif
    }

    // Start on specific activity
    if (parser.isSet(clStartOnActivity)) {
        QString startingActivity = parser.value(clStartOnActivity);
        int startingLevel = 0;
        if (parser.isSet(clStartOnLevel)) {
            bool isNumber = false;
            startingLevel = parser.value(clStartOnLevel).toInt(&isNumber);
            if (!isNumber || startingLevel < 0) {
                startingLevel = 0;
            }
        }
        // internally, levels start at 0
        ActivityInfoTree::setStartingActivity(startingActivity, startingLevel - 1);
    }

    QQmlApplicationEngine engine(QUrl("qrc:/gcompris/src/core/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::quit, DownloadManager::getInstance(),
                     &DownloadManager::shutdown);
    // add import path for shipped qml modules:
    engine.addImportPath(QStringLiteral("%1/../lib/qml")
                             .arg(QCoreApplication::applicationDirPath()));

#if __ANDROID__ && QT_VERSION >= QT_VERSION_CHECK(5, 14, 0)
    // Find box2d
    engine.addImportPath(QStringLiteral("assets:/"));
#endif

    ApplicationInfo::getInstance()->setBox2DInstalled(engine);

    if (parser.isSet(exportActivitiesAsSQL)) {
        ActivityInfoTree *menuTree(qobject_cast<ActivityInfoTree *>(ActivityInfoTree::menuTreeProvider(&engine, nullptr)));
        menuTree->exportAsSQL();
        return 0;
    }

    if (parser.isSet(clListActivities)) {
        ActivityInfoTree *menuTree(qobject_cast<ActivityInfoTree *>(ActivityInfoTree::menuTreeProvider(&engine, nullptr)));
        menuTree->listActivities();
        return 0;
    }
    // Start on specific difficulties
    if (parser.isSet(clDifficultyRange)) {
        QString difficultyRange = parser.value(clDifficultyRange);
        QStringList levels = difficultyRange.split(QStringLiteral("-"));
        quint32 minDifficulty = levels[0].toUInt();
        quint32 maxDifficulty = minDifficulty;
        // If we have a range, take the second value as max difficulty
        if (levels.size() > 1) {
            maxDifficulty = levels[1].toUInt();
        }
        if (minDifficulty > maxDifficulty) {
            qWarning() << "Minimal level must be lower than maximum level";
            return -1;
        }
        if (minDifficulty < 1 || minDifficulty > 6) {
            qWarning() << "Minimal level must between 1 and 6";
            return -1;
        }
        if (maxDifficulty < 1 || maxDifficulty > 6) {
            qWarning() << "Maximal level must between 1 and 6";
            return -1;
        }

        qDebug() << QStringLiteral("Setting difficulty between %1 and %2").arg(minDifficulty).arg(maxDifficulty);
        ApplicationSettings::getInstance()->setDifficultyFromCommandLine(minDifficulty, maxDifficulty);
        ActivityInfoTree::getInstance()->minMaxFiltersChanged(minDifficulty, maxDifficulty, false);
        ActivityInfoTree::getInstance()->filterByTag("favorite");
    }

    QObject *topLevel = engine.rootObjects().value(0);

    QQuickWindow *window = qobject_cast<QQuickWindow *>(topLevel);
    if (window == nullptr) {
        qWarning("Error: Your root item has to be a Window.");
        return -1;
    }
    ApplicationInfo::setWindow(window);

    window->setIcon(QIcon(QPixmap(QString::fromUtf8(":/gcompris/src/core/resource/gcompris-icon.png"))));

    if (isFullscreen) {
        window->showFullScreen();
    }
    else {
        window->show();
    }

    return app.exec();
}
