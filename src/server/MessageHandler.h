/* GComprisServer - MessageHandler.h
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
#ifndef MESSAGEHANDLER_H
#define MESSAGEHANDLER_H

#include "Messages.h"
#include <QObject>

class Server;

class MessageHandler: public QObject
{
    Q_OBJECT
public:
    MessageHandler(const Server &server);

public slots:
    void onLoginReceived(const Login &data);

 private:
    const Server &_server;
};

#endif
