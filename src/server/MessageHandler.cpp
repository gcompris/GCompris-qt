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

    GroupData *group = createGroup("default");
    UserData *user1 = createUser("a", "", { "default" });
    UserData *user2 = createUser("b", "");
    group->addUser(user2); // same as putting directly the group
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
    qmlRegisterType<UserData>();
    qmlRegisterType<GroupData>();

    qmlRegisterSingletonType<MessageHandler>("GCompris", 1, 0,
            "MessageHandler",
            systeminfoProvider);
}

GroupData *MessageHandler::createGroup(const QString &newGroup, const QStringList &users)
{
    qDebug() << "createGroup '" << newGroup << "'";
    GroupData *c = new GroupData();
    c->setName(newGroup);
    for(const QString &username: users)
        c->addUser(getUser(username));
    m_groups.push_back((QObject*)c);
    emit newGroups();
    return c;
}

GroupData *MessageHandler::updateGroup(const QString &oldGroupName, const QString &newGroupName, const QStringList &users)
{
    qDebug() << "updateGroup '" << newGroupName << "'";
    GroupData *c = getGroup(oldGroupName);
    c->setName(newGroupName);

    c->removeAllUsers();
    for(const QString &aUser: users) {
        UserData *user = getUser(aUser);
        c->addUser(user);
    }
    emit newGroups();
    return c;
}

void MessageHandler::deleteGroup(const QString &groupName)
{
    qDebug() << "deleteGroup '" << groupName << "'";
    GroupData *c = getGroup(groupName);
    qDebug() << c;
    m_groups.removeAll(c);
    delete c;
    emit newGroups();
}

UserData *MessageHandler::createUser(const QString &newUser, const QString &avatar, const QStringList &groups)
{
    qDebug() << "createUser '" << newUser << "' in groups " << groups;
    UserData *u = new UserData();
    u->setName(newUser);
    u->setAvatar(avatar);
    for(const QString &aGroup: groups) {
        GroupData *group = getGroup(aGroup);
        group->addUser(u);
    }
    m_users.push_back((QObject*)u);
    emit newUsers();
    return u;
}

UserData *MessageHandler::updateUser(const QString &oldUser, const QString &newUser, const QString &avatar, const QStringList &groups)
{
    UserData *user = getUser(oldUser);
    if (user) {
        user->setName(newUser);
        // for each group, remove the user if not in the new groups and add it in the new ones
        removeUserFromAllGroups(user);
        for(const QString &aGroup: groups) {
            GroupData *group = getGroup(aGroup);
            group->addUser(user);
        }
        emit newUsers();
    }
    return user;
}

UserData *MessageHandler::getUser(const QString &userName)
{
    for (QObject *oUser: m_users) {
        UserData *user = (UserData *) oUser;
        if (user->getName() == userName) {
            return user;
        }
    }
    return nullptr;
}

GroupData *MessageHandler::getGroup(const QString &groupName)
{
    for (QObject *oGroup: m_groups) {
        GroupData *group = (GroupData *) oGroup;
        if (group->getName() == groupName) {
            return group;
        }
    }
    return nullptr;
}

void MessageHandler::removeUserFromAllGroups(UserData *user)
{
   for (QObject *oGroup: m_groups) {
        GroupData *group = (GroupData *) oGroup;
        group->removeUser(user);
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
    if(c && c->getUserData())
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
