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
/*#include "Server.h"
#include "Database.h"
#include "MessageHandler.h"*/

#include <QtCrypto>

#include "GComprisPlugin.h"
#include "ApplicationInfo.h"
#include "ApplicationSettings.h"
#include "ActivityInfoTree.h"
#include "File.h"
#include "DownloadManager.h"

#include <QResource>
#include <config.h>

#include <QQuickStyle>
#include <QQmlContext>

#include "serverMasterController/controllers/master-controller.h"
#include "serverMasterController/controllers/network-controller.h"
#include "serverMasterController/controllers/command-controller.h"
#include "serverMasterController/controllers/navigation-controller.h"
#include "serverMasterController/framework/command.h"
#include <models/GroupData.h>
#include <models/UserData.h>

#define GCOMPRIS_SERVER_APPLICATION_NAME "gcompris-server"

int main(int argc, char *argv[])
{
    // Disable it because we already support HDPI display natively
    qunsetenv("QT_DEVICE_PIXEL_RATIO");

    QApplication app(argc, argv);
    app.setOrganizationName("KDE");
    app.setApplicationName(GCOMPRIS_SERVER_APPLICATION_NAME);
    app.setOrganizationDomain("kde.org");

    // Initialise QCA
    QCA::Initializer init;
 
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
    /*ActivityInfoTree::registerResources();
    Server::init();
    Database::init();
    MessageHandler::init();*/

    if (!QResource::registerResource(ApplicationInfo::getFilePath("core.rcc")))
        qDebug() << "Failed to load the resource file " << ApplicationInfo::getFilePath("core.rcc");
    if (!QResource::registerResource(ApplicationInfo::getFilePath("server.rcc")))
        qDebug() << "Failed to load the resource file " << ApplicationInfo::getFilePath("server.rcc");

    QQmlApplicationEngine engine;

    controllers::MasterController masterController;
    engine.rootContext()->setContextProperty("masterController", &masterController);
    controllers::NetworkController networkController;
    networkController.setMasterController(&masterController);

    engine.rootContext()->setContextProperty("networkController", &networkController);
    engine.load(QUrl("qrc:/gcompris/src/server/main.qml"));

    qmlRegisterType<controllers::MasterController>("CM", 1, 0, "MasterController");
    qmlRegisterType<controllers::NetworkController>("CM", 1, 0, "NetworkController");
    qmlRegisterType<controllers::NavigationController>("CM", 1, 0, "NavigationController");
    qmlRegisterType<controllers::CommandController>("CM", 1, 0, "CommandController");
    qmlRegisterType<framework::Command>("CM", 1, 0, "Command");
    qmlRegisterType<GroupData>("CM", 1, 0, "GroupData");
    qmlRegisterType<UserData>("CM", 1, 0, "UserData");
    qmlRegisterUncreatableType<ConnectionStatus>("CM", 1, 0, "ConnectionStatus", "Not creatable as it is an enum type");

    // add import path for shipped qml modules:
    engine.addImportPath(QStringLiteral("%1/../lib/qml")
                             .arg(QCoreApplication::applicationDirPath()));

    QObject *topLevel = engine.rootObjects().value(0);

    QQuickWindow *window = qobject_cast<QQuickWindow *>(topLevel);
    if (!window) {
        qWarning("Error: Your root item has to be a Window.");
        return -1;
    }

    window->setIcon(QIcon(QPixmap(QString::fromUtf8(":/gcompris/src/core/resource/gcompris-icon.png"))));

    window->show();
    return app.exec();
}
