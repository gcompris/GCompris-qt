/* GComprisServer - MessageHandler.cpp
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

#include <QDebug>
#include "Server.h"
#include "MessageHandler.h"

MessageHandler* MessageHandler::_instance = 0;

MessageHandler::MessageHandler()
{
    Server &server = *Server::getInstance();
    connect(&server, &Server::loginReceived, this, &MessageHandler::onLoginReceived);
    connect(&server, &Server::activityDataReceived, this, &MessageHandler::onActivityDataReceived);
    connect(&server, &Server::newClientReceived, this, &MessageHandler::onNewClientReceived);
    connect(&server, &Server::clientDisconnected, this, &MessageHandler::onClientDisconnected);

    createGroup("default");    
}

MessageHandler* MessageHandler::getInstance()
{
    if (!_instance)
        _instance = new MessageHandler;
    return _instance;
}

QObject *MessageHandler::systeminfoProvider(QQmlEngine *engine,
        QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    return getInstance();
}

void MessageHandler::init()
{
    qmlRegisterSingletonType<MessageHandler>("GCompris", 1, 0,
            "MessageHandler",
            systeminfoProvider);
}

void MessageHandler::createGroup(const QString &newGroup)
{
    qDebug() << "createGroup '" << newGroup << "'";
    GroupData *c = new GroupData();
    c->m_name = newGroup;
    c->m_members << "log1" << "log2" << "log3";
    m_groups.push_back((QObject*)c);
    emit newGroups();
}

void MessageHandler::onLoginReceived(const Login &data)
{
    qDebug() << "Login received '" << data._name << "'";
}

void MessageHandler::onActivityDataReceived(const ActivityData &act)
{
    qDebug() << "Activity: " << act.activityName << ", date: " << act.date << ", data:" << act.data;
}

void MessageHandler::onNewClientReceived(const ClientData &client)
{
    qDebug() << "New client";
    ClientData *c = new ClientData(client);

    m_clients.push_back((QObject*)c);
    emit newClients();
}

void MessageHandler::onClientDisconnected(const ClientData &client)
{
    qDebug() << "client disconnected";
    ClientData *c = getClientData(client);
    m_clients.removeAll(c);
    delete c;
    emit newClients();
}

ClientData *MessageHandler::getClientData(const ClientData &cd)
{
    const QTcpSocket *socket = cd.getSocket();
    for (QObject *oc: m_clients) {
        ClientData *c = (ClientData *) oc;
        if (c->getSocket() == socket) {
            return c;
        }        
    }    
}
