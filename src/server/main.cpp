/* GCompris - main.cpp
 *
 * SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
#include <QtDebug>
#include <QApplication>
#include <QQuickWindow>
#include <QQmlApplicationEngine>
#include <QStandardPaths>
#include <QTranslator>

#include "GComprisPlugin.h"
#include "ApplicationInfo.h"
#include "ActivityInfoTree.h"

#include <QFontDatabase>
#include <QResource>
// #include <config.h>

#include <QQmlContext>

#include "controllers/database-controller.h"
#include "controllers/network-controller.h"
#include "netconst.h"

#include <openssl/err.h>

#define GCOMPRIS_SERVER_APPLICATION_NAME "gcompris-server"

int main(int argc, char *argv[])
{
    ERR_load_crypto_strings();     
    // Disable it because we already support HDPI display natively
    qunsetenv("QT_DEVICE_PIXEL_RATIO");

    QApplication app(argc, argv);
    //    app.setOrganizationName("KDE");           // set config dir to ~/.config/KDE
    app.setOrganizationName("gcompris"); // set config dir to ~/.config/gcompris
    app.setApplicationName(GCOMPRIS_SERVER_APPLICATION_NAME);
    app.setOrganizationDomain("kde.org");

#if defined(Q_OS_MAC)
    // Sandboxing on MacOSX as documented in:
    // http://doc.qt.io/qt-5/osx-deployment.html
    QDir dir(QGuiApplication::applicationDirPath());
    dir.cdUp();
    dir.cd("Plugins");
    QGuiApplication::setLibraryPaths(QStringList(dir.absolutePath()));
#endif

    GComprisPlugin plugin;
    plugin.registerTypes("GCompris");
    ActivityInfoTree::registerResources();

    //    if (!QResource::registerResource(ApplicationInfo::getFilePath("core.rcc")))
    //        qDebug() << "Failed to load the resource file " << ApplicationInfo::getFilePath("core.rcc");
    if (!QResource::registerResource(ApplicationInfo::getFilePath("activities_light.rcc")))
        qDebug() << "Failed to load the resource file " << ApplicationInfo::getFilePath("activities_light.rcc");
    if (!QResource::registerResource(ApplicationInfo::getFilePath("server.rcc")))
        qDebug() << "Failed to load the resource file " << ApplicationInfo::getFilePath("server.rcc");

    qmlRegisterUncreatableMetaObject(
        netconst::staticMetaObject, // meta object created by Q_NAMESPACE macro
        "GCompris", // import statement (can be any string)
        1, 0, // major and minor version of the import
        "NetConst", // name in QML (does not have to match C++ name)
        "Error: only enums" // error in case someone tries to create a MyNamespace object
    );

    // Create QStandardPaths::GenericDataLocation if needed
    QString path = QStandardPaths::writableLocation(QStandardPaths::GenericDataLocation) + "/" + GCOMPRIS_SERVER_APPLICATION_NAME;
    if (!QDir(path).exists()) {
        QDir().mkdir(path);
    }

    // Load translations
    QTranslator translator;
    if (!translator.load("gcompris_" + QLocale::system().name(), QString("%1/%2/translations").arg(QCoreApplication::applicationDirPath(), GCOMPRIS_DATA_FOLDER))) {
        qDebug() << "Unable to load translation for locale " << QLocale::system().name() << ", use en_US by default";
    }
    // Apply translation
    app.installTranslator(&translator);

    // Set global font
    qint32 fontId = QFontDatabase::addApplicationFont(":/gcompris/src/server/resource/fa-solid-900.ttf");
    QStringList fontList = QFontDatabase::applicationFontFamilies(fontId);
    QString family = fontList.first();
    QGuiApplication::setFont(QFont(family));

    // Create the engine and Main qml object
    QQmlApplicationEngine engine;

    controllers::DatabaseController databaseController;
    engine.rootContext()->setContextProperty("databaseController", &databaseController);
    controllers::NetworkController networkController;
    engine.rootContext()->setContextProperty("networkController", &networkController);

    qmlRegisterType<controllers::NetworkController>("CM", 1, 0, "NetworkController");

    engine.load(QUrl("qrc:/gcompris/src/server/Main.qml"));

    // add import path for shipped qml modules:
    engine.addImportPath(QStringLiteral("%1/../lib/qml").arg(QCoreApplication::applicationDirPath()));

    QObject *topLevel = engine.rootObjects().value(0);

    QQuickWindow *window = qobject_cast<QQuickWindow *>(topLevel);
    if (!window) {
        qWarning("Error: Your root item has to be a Window.");
        return -1;
    }

    window->setIcon(QIcon(QPixmap(QString::fromUtf8(":/gcompris/src/server/resource/gcompris-icon.png"))));

    window->show();
    return app.exec();
}
