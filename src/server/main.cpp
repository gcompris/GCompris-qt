/* GCompris - main.cpp
 *
 * Copyright (C) 2016 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
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
#include <QApplication>
#include <QQuickWindow>
#include <QQmlApplicationEngine>
#include <QStandardPaths>
#include "Server.h"
#include "Database.h"
#include "MessageHandler.h"

#include "ApplicationInfo.h"
#include "ApplicationSettings.h"
#include "ActivityInfoTree.h"
#include "File.h"
#include "DownloadManager.h"

#include <QResource>
#include <config.h>

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

    ActivityInfoTree::init();
    ApplicationInfo::init();
    ApplicationSettings::init();
    File::init();
    DownloadManager::init();
    Server::init();
    Database::init();
    MessageHandler::init();

    if(!QResource::registerResource(ApplicationInfo::getFilePath("core.rcc")))
        qDebug() << "Failed to load the resource file " << ApplicationInfo::getFilePath("core.rcc");
    if(!QResource::registerResource(ApplicationInfo::getFilePath("server.rcc")))
        qDebug() << "Failed to load the resource file " << ApplicationInfo::getFilePath("server.rcc");

    QQmlApplicationEngine engine(QUrl("qrc:/gcompris/src/server/main.qml"));
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
