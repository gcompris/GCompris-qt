/* GCompris - ClientData.cpp
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

#include <QString>
#include <QTcpSocket>
#include "ClientData.h"

ClientData::ClientData() : m_socket(0)
{
}
ClientData::ClientData(const ClientData &client)
{
    m_socket = client.m_socket;
    m_login = client.m_login;
}

ClientData::~ClientData()
{
}

const QTcpSocket *ClientData::getSocket() const
{
    return m_socket;
}

void ClientData::setSocket(const QTcpSocket *newSocket)
{
    m_socket = newSocket;
}

void ClientData::setLogin(const QString &newLogin)
{
    m_login = newLogin;
}
