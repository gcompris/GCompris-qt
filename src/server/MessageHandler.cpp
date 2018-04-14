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
#include "Database.h"
#include "MessageHandler.h"
#include "Authentication.h"
#include <QMultiMap>
#include <QMapIterator>

MessageHandler* MessageHandler::_instance = 0;

MessageHandler::MessageHandler()
{
    m_auth = new Authentication;
    Server &server = *Server::getInstance();
    connect(&server, &Server::loginReceived, this, &MessageHandler::onLoginReceived);
    connect(&server, &Server::activityDataReceived, this, &MessageHandler::onActivityDataReceived);
    connect(&server, &Server::newClientReceived, this, &MessageHandler::onNewClientReceived);
    connect(&server, &Server::clientDisconnected, this, &MessageHandler::onClientDisconnected);
    
    // retrieve all the existing users and groups

    QList<UserData*> users;
    Database::getInstance()->retrieveAllExistingUsers(users);
    for(auto it = users.begin(); it != users.end(); it++) {
        m_users.push_back(*it);
    }

    QList<GroupData* > groups;
    Database::getInstance()->retrieveAllExistingGroups(groups);
    for(auto it = groups.begin(); it != groups.end(); it++) {
        m_groups.push_back(*it);
    }

    // add users to their respective groups
    QMultiMap<QString, QString> groupUsers = Database::getInstance()->retrieveGroupUsers();
    QMapIterator<QString, QString> itr(groupUsers);
    while(itr.hasNext()) {
        itr.next();
        GroupData* grp = getGroup(itr.key());
        QList<QString> values = groupUsers.values(itr.key());
        for(const auto &user: values) {
            UserData* usr = getUser(user);
            if(grp && usr) {
                grp->addUser(usr);
            }
        }
    }
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
    getInstance();
    qmlRegisterType<UserData>();
    qmlRegisterType<GroupData>();

    qmlRegisterSingletonType<MessageHandler>("GCompris", 1, 0,
            "MessageHandler",
            systeminfoProvider);
}

void MessageHandler::createGroup(const QString &newGroup,
                                 const QString &description,
                                 const QStringList &users)
{
    //1. add group to database
    //2. make a new a group and add it to m_groups;
    qDebug() << "Create group" << users;
    if(Database::getInstance()->addGroup(newGroup, description,users)) {
        GroupData *c = new GroupData();
        c->setName(newGroup);
        c->setDescription(description);
        m_groups.push_back((QObject*)c);
        for(const auto &user: users) {
            UserData* usr = getUser(user);
            if(usr) {
                c->addUser(usr);
            }
        }
        emit newGroups();
    }
}

void MessageHandler::updateGroup(const QString &oldGroup,
                                 const QString &groupName,
                                 const QString &description,
                                 const QStringList& users)
{
    // todo
    // update in database:
    // * table groups (for the name)
    // * group_users (for all the users, remove previous group name and for each added user, add the group name)

    // if both OK, update the group to update the name, clean all the users and add them
}

void MessageHandler::deleteGroup(const QString &groupName)
{
    //delete from database
    if(Database::getInstance()->deleteGroup(groupName)) {
        GroupData *c = getGroup(groupName);
        qDebug() << c;
        m_groups.removeAll(c);
        delete c;
        emit newGroups();
    }
    else {
        qDebug() << "could not delete the group from database";
    }
}

void MessageHandler::createUser(const QString &name,
                                const QString &age,
                                const QString &password,
                                const QStringList &groups)
{
    //    Add the user in the database
    UserData *u = new UserData(name, age, password);
    if(Database::getInstance()->addUser(*u)) {
        qDebug() << "createUser '" << name << "' in groups " << groups;
        for(const QString &aGroup: groups) {
            GroupData *group = getGroup(aGroup);
            if(group) {
                group->addUser(u);
            }
        }
        m_users.push_back((QObject*)u);
        emit newUsers();
    }
    else {
        delete u;
        qDebug() << "Error while creating user " << name;
    }
}

void MessageHandler::addUserToGroup(const QStringList &groups, const QStringList &users)
{
    // 1. add user to group -In database;
    // 2. associate users with groups;
    for(const auto &user: users) {
        UserData* usr = getUser(user);

        for (const auto &group: groups) {
            if(Database::getInstance()->addUserToGroup(group, user)) {
                GroupData* grp = getGroup(group);
                if(grp && usr) {
                   grp->addUser(usr);
                }
            }
        }
    }

}


void MessageHandler::updateUser(const QString &oldUser,
                                const QString &newUser,
                                const QString &avatar,
                                const QStringList &groups)
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
    if(Database::getInstance()->deleteUser(userName)) {
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
    else {
        qDebug() << "Unable to delete" << userName;
    }
}

void MessageHandler::onLoginReceived(QTcpSocket *socket, const Login &data)
{
    qDebug() << "user request: " << data._name << " : " << data._password;
    if(m_auth && m_auth->loginAuth(data)) {
        qDebug() << "user verified: " << data._name << " : " << data._password;
        ClientData *c = getClientData(socket);

        for(QObject *oClient: m_clients) {
            ClientData *c = (ClientData*)oClient;
            if(c->getUserData() && c->getUserData()->getName() == data._name) {
                // found a client with the same user name.(i.e someone chose the wrong login)
                qDebug() << "a client with the same user name already exists";
                return;
                //todo:
                // return an error message to client and inform that you have chosen the wrong login
            }
        }
        for(QObject *oUser: m_users) {
            UserData *user = (UserData*)oUser;
            qDebug() << "received login " << data._name << " " << c->getSocket();
            if(user->getName() == data._name) {
                c->setUser(user);
                return;
            }
        }
        // Should not happen when login will be done properly... todo display an error message
        qDebug() << "Error: login " << data._name << " received, but no user found";
    }
    else
        qDebug() <<  "Authentication failed";
}

void MessageHandler::onActivityDataReceived(QTcpSocket* socket, const ActivityRawData &act)
{
    qDebug() << "Activity: " << act.activityName << ", date: " << act.date << ", data:" << act.data << ", user: " << act.username;

    Database::getInstance()->addDataToDatabase(act);
    
    ClientData* client = getClientData(socket);
    if(client) {
        if(client->getUserData()) {
            client->getUserData()->addData(act);
        }
    }
    emit newActivityData();
}

void MessageHandler::onNewClientReceived(QTcpSocket* socket)
{
    qDebug() << "New client";
    ClientData *c = new ClientData;
    c->setSocket(socket);
    m_clients.push_back((QObject*)c);
    emit newClients();
}

void MessageHandler::onClientDisconnected(QTcpSocket* socket)
{
    qDebug() << "client disconnected";
    ClientData *c = getClientData(socket);
    c->setUser(nullptr);
    m_clients.removeAll(c);
    delete c;
    emit newClients();
}

ClientData *MessageHandler::getClientData(QTcpSocket* socket)
{
    for (QObject *oc: m_clients) {
        ClientData *c = (ClientData *) oc;
        if (c->getSocket() == socket) {
            return c;
        }
    }
}
