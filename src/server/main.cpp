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
#include "serverMasterController/controllers/command-controller.h"
#include "serverMasterController/controllers/navigation-controller.h"
#include <data/enumerator-decorator.h>
#include <data/string-decorator.h>
#include "serverMasterController/framework/command.h"
#include <models/GroupData.h>
#include <models/address.h>
#include <models/client.h>
#include <models/client-search.h>
#include <models/contact.h>


#define GCOMPRIS_SERVER_APPLICATION_NAME "gcompris-server"

int main(int argc, char *argv[])
{
    // Disable it because we already support HDPI display natively
    qunsetenv("QT_DEVICE_PIXEL_RATIO");

    QApplication app(argc, argv);
    app.setOrganizationName("KDE");
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
    /*ActivityInfoTree::registerResources();
    Server::init();
    Database::init();
    MessageHandler::init();*/

    if(!QResource::registerResource(ApplicationInfo::getFilePath("core.rcc")))
        qDebug() << "Failed to load the resource file " << ApplicationInfo::getFilePath("core.rcc");
    if(!QResource::registerResource(ApplicationInfo::getFilePath("server.rcc")))
        qDebug() << "Failed to load the resource file " << ApplicationInfo::getFilePath("server.rcc");

    QQmlApplicationEngine engine;

    cm::controllers::MasterController masterController;
    engine.rootContext()->setContextProperty("masterController", &masterController);
    engine.load(QUrl("qrc:/gcompris/src/server/main.qml"));

    qmlRegisterType<cm::controllers::MasterController>("CM", 1, 0, "MasterController");
    qmlRegisterType<cm::controllers::NavigationController>("CM", 1, 0, "NavigationController");
    qmlRegisterType<cm::controllers::CommandController>("CM", 1, 0, "CommandController");
    qmlRegisterType<cm::framework::Command>("CM", 1, 0, "Command");
    qmlRegisterType<cm::data::EnumeratorDecorator>("CM", 1, 0, "EnumeratorDecorator");
    qmlRegisterType<cm::data::StringDecorator>("CM", 1, 0, "StringDecorator");
    qmlRegisterType<GroupData>("CM", 1, 0, "GroupData");
    qmlRegisterType<cm::models::Address>("CM", 1, 0, "Address");
    qmlRegisterType<cm::models::Client>("CM", 1, 0, "Client");
    qmlRegisterType<cm::models::Contact>("CM", 1, 0, "Contact");

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
