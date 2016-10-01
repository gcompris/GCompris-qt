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

    createGroup("default", {"a", "b"});
    createUser("a", "", {"default"});
    createUser("b", "", {"default"});
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

void MessageHandler::createGroup(const QString &newGroup, const QStringList &users)
{
    qDebug() << "createGroup '" << newGroup << "'";
    GroupData *c = new GroupData();
    c->m_name = newGroup;
    for(const QString &user: users)
        c->m_members << user;
    m_groups.push_back((QObject*)c);
    emit newGroups();
}

void MessageHandler::createUser(const QString &newUser, const QString &avatar, const QStringList &groups)
{
    qDebug() << "createUser '" << newUser << "'";
    UserData *u = new UserData();
    u->setName(newUser);
    u->setAvatar(avatar);
//    for(const QString &group: groups)
//  todo find group + add user       u->m_members << user;
    m_users.push_back((QObject*)u);
    emit newUsers();
}

void MessageHandler::updateUser(const QString &oldUser, const QString &newUser, const QString &avatar, const QStringList &groups)
{
    for (QObject *oUser: m_users) {
        UserData *user = (UserData *) oUser;
        if (user->getName() == oldUser) {
            user->setName(newUser);
            emit newUsers();
            break;
        }
    }
}

void MessageHandler::removeUserFromAllGroups(const UserData *user)
{
   for (QObject *oGroup: m_groups) {
        GroupData *group = (GroupData *) oGroup;
        group->m_members.removeAll(user->getName());
   }
}

void MessageHandler::deleteUser(const QString &userName)
{
    for (QObject *oUser: m_users) {
        UserData *user = (UserData *) oUser;
        if (user->getName() == userName) {
            m_users.removeAll(user);
            removeUserFromAllGroups(user);
            delete user;
            emit newUsers();
        }
    }
}

void MessageHandler::onLoginReceived(const ClientData &who, const Login &data)
{
    qDebug() << "Login received '" << data._name << "'";
    ClientData *c = getClientData(who);
    for(QObject *oUser: m_users) {
        UserData *user = (UserData*)oUser;
        // todo Check that we don't find a client with the same login! else it will probably means a child didn't choose the good login

        qDebug() << user->getName() << data._name;
        if(user->getName() == data._name) {
            c->setUser(user);
            return;
        }
    }
    // Should not happen when login will be done properly... todo display an error message
    qDebug() << "Error: login " << data._name << " received, but no user found";
}

void MessageHandler::onActivityDataReceived(const ClientData &who, const ActivityRawData &act)
{
    qDebug() << "Activity: " << act.activityName << ", date: " << act.date << ", data:" << act.data;
    ClientData *c = getClientData(who);
    c->getUserData()->addData(act);
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
    c->setUser(nullptr);
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
