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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
#include <QtDebug>
#include <QApplication>
#include <QStandardPaths>
#include <QSettings>
#include "Server.h"
#include "MessageHandler.h"

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

    Server server;
    server.show();
    
    MessageHandler listener(server);
    
    // Local scope for config
    QSettings config(QStandardPaths::writableLocation(QStandardPaths::GenericConfigLocation) +
                     "/gcompris/" + GCOMPRIS_SERVER_APPLICATION_NAME + ".conf",
                     QSettings::IniFormat);

    return app.exec();
}
