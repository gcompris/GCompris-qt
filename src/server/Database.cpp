/* GCompris - Database.cpp
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
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QDir>
#include <QFileInfo>
#include <QDebug>
#include "UserData.h"
#include "Database.h"
#include "GroupData.h"


#define CREATE_TABLE_USERS \
    "CREATE TABLE users (user_name TEXT PRIMARY KEY NOT NULL, avatar TEXT); "
#define CREATE_TABLE_GROUPS \
    "CREATE TABLE groups (group_name TEXT PRIMARY KEY NOT NULL, description TEXT); "
#define CREATE_TABLE_USERGROUP \
    "CREATE TABLE group_users(user_name TEXT NOT NULL, group_name TEXT NOT NULL)"

Database* Database::_instance = 0;

Database::Database()
{
}

Database::~Database()
{
}

Database* Database::getInstance()
{
    if (!_instance)
        _instance = new Database;
    return _instance;
}

bool Database::addGroup(const QString &groupName, const QString& description,
                        const QStringList& users)
{

    bool groupAdded = false;
    QSqlDatabase dbConnection = QSqlDatabase::database();
    QSqlQuery query(dbConnection);
    // add group to db only if it has not been added before
    query.prepare("SELECT group_name FROM groups WHERE group_name=:groupName");
    query.bindValue(":groupName", groupName);
    query.exec();
    if(query.next()) {
        qDebug()<< "group "<< groupName << " already exists";
        return false;
    }
    // since the group does not exist ,create the new group and add description and users to it
    query.prepare("INSERT INTO groups (group_name, description) VALUES (:groupName,:description)");
    query.bindValue(":groupName", groupName);
    query.bindValue(":description",description);
    groupAdded = query.exec();
    if(groupAdded) {
        //add users to the group
        for(const auto &user: users) {
            addUserToGroup(groupName, user);
        }
    }
    else
        qDebug()<<"group could not be added " <<  query.lastError();

    return groupAdded;
}

bool Database::deleteGroup(const QString &groupName)
{
    bool groupDeleted = false;
    QSqlDatabase dbConnection = QSqlDatabase::database();
    QSqlQuery query(dbConnection);
    query.prepare("DELETE FROM groups WHERE group_name=:gname");
    query.bindValue(":gname",groupName);
    if(query.exec()) {
        query.prepare("DELETE FROM group_users WHERE group_name=:gname");
        query.bindValue(":gname",groupName);
        if(query.exec())
            groupDeleted = true;
    }
    return groupDeleted;

}

bool Database::addUserToGroup(const QString& group, const QString& user)
{
    // insert in table group_users
    // add (user, group) to db only if they don't exist
    bool userAdded = false;
    QSqlDatabase dbConnection = QSqlDatabase::database();
    QSqlQuery query(dbConnection);
    query.prepare("SELECT * FROM group_users WHERE user_name=:user and group_name=:group");
    query.bindValue(":user",user);
    query.bindValue(":group",group);
    query.exec();
    if(query.next()) {
        qDebug() << "user " << user << "already exists in group " << group;
        return false;
    }
    query.prepare("INSERT INTO group_users (user_name, group_name) values(:user,:group)");
    query.bindValue(":user",user);
    query.bindValue(":group",group);
    userAdded = query.exec();
    if(!userAdded) {
        qDebug() << "user could not be added "<< query.lastError();
    }
    return userAdded;

}


bool Database::addUser(const QString& name, const QString &avatar, const QStringList& groups)
{
    // check whether user already exists before adding to database
    bool userAdded = false;
    QSqlDatabase dbConnection = QSqlDatabase::database();
    QSqlQuery query(dbConnection);
    query.prepare("SELECT user_name FROM users WHERE user_name=:name");
    query.bindValue(":name", name);
    query.exec();
    if(query.next()) {
        qDebug() << "user " << name << "already exists";
        return false;
    }
    query.prepare("INSERT INTO users (user_name, avatar) VALUES(:name,:avatar)");
    query.bindValue(":name", name);
    query.bindValue(":avatar", avatar);
    userAdded = query.exec();
    if(userAdded) {
        for (const auto &group:groups) {
            addUserToGroup(group, name);
        }
    }
    else
        qDebug()<< query.lastError();

    return userAdded;
}


void Database::retrieveAllExistingGroups(QList<GroupData *> &allGroups)
{
    QSqlDatabase dbConnection = QSqlDatabase::database();

    // Don't add twice the same login
    QSqlQuery query(dbConnection);
    query.prepare("SELECT * FROM groups");
    query.exec();
    const int nameIndex = query.record().indexOf("group_name");
    const int descriptionIndex = query.record().indexOf("description");
    while(query.next()) {
        GroupData *g = new GroupData();
        g->setName(query.value(nameIndex).toString());
        g->setDescription(query.value(descriptionIndex).toString());
        allGroups.push_back(g);
    }
}

QMultiMap<QString,QString> Database::retrieveGroupUsers()
{
    QSqlDatabase dbConnection = QSqlDatabase::database();
    QSqlQuery query(dbConnection);
    query.prepare("SELECT * FROM group_users");
    query.exec();
    int userIndex = query.record().indexOf("user_name");
    int groupIndex = query.record().indexOf("group_name");
    QMultiMap<QString,QString> groupUsers;
    while(query.next()) {
        groupUsers.insert(query.value(groupIndex).toString(),query.value(userIndex).toString());
    }
    return groupUsers;

}

void Database::retrieveAllExistingUsers(QList <UserData *> &allUsers)
{
    QSqlDatabase dbConnection = QSqlDatabase::database();
    QSqlQuery query(dbConnection);
    query.prepare("SELECT * FROM users");
    query.exec();
    const int nameIndex = query.record().indexOf("user_name");
    const int avatarIndex = query.record().indexOf("avatar");
    while(query.next()) {
        UserData *u = new UserData();
        u->setName(query.value(nameIndex).toString());
        u->setAvatar(query.value(avatarIndex).toString());
        allUsers.push_back(u);
    }
}

void createDatabase(const QString &path)
{
    QSqlDatabase dbConnection = QSqlDatabase::database();
    QSqlQuery query(dbConnection);

    if(query.exec(CREATE_TABLE_USERS))
        qDebug()<< "created table users";
    else
        qDebug() << query.lastError();


    if(query.exec(CREATE_TABLE_GROUPS))
        qDebug()<< "created table groups";
    else
        qDebug() << query.lastError();

    if(query.exec(CREATE_TABLE_USERGROUP))
        qDebug()<< "created table group_users";
    else
        qDebug() << query.lastError();


}

void Database::init()
{
    QDir databasePath;
    QString path = databasePath.currentPath()+"/gcompris-qt.db"; // todo set cache/data path instead of current folder

    QSqlDatabase dbConnection = QSqlDatabase::addDatabase("QSQLITE");
    dbConnection.setDatabaseName(path);

    QFileInfo fileInfo(path);
    if(!fileInfo.exists()) {
        if (!dbConnection.open()) {
            qDebug() << "Error: connection with database fail";
        }
        createDatabase(path);
    }

    if (!dbConnection.open()) {
        qDebug() << "Error: connection with database fail";
    }
}
