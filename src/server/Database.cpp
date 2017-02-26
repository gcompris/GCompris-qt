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

#define CREATE_TABLE_GROUPS \
    "CREATE TABLE groups (group_name TEXT PRIMARY KEY NOT NULL, description TEXT); "

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
    if(query.next()){
        qDebug()<< "group "<< groupName << " already exists";
        return false;
    }
    // since the group does not exist ,create the new group and add description and users to it
    query.prepare("INSERT INTO groups (group_name, description) VALUES (:groupName,:description)");
    query.bindValue(":groupName", groupName);
    query.bindValue(":description",description);
    groupAdded = query.exec();
    if(groupAdded){
        //add users to the group
    }
    else{

        qDebug()<<"group could not be added " <<  query.lastError();
    }
    return groupAdded;
}
bool Database::deleteGroup(const QString &groupName)
{
    bool groupDeleted = false;
    QSqlDatabase dbConnection = QSqlDatabase::database();
    QSqlQuery query(dbConnection);
    query.prepare("DELETE FROM groups WHERE group_name=:gname");
    query.bindValue(":gname",groupName);
    if(query.exec()){
        groupDeleted = true;   
        // query.prepare("DELETE FROM group_users WHERE group_name=:gname");
        // query.bindValue(":gname",groupName);
        // if(query.exec())
        //     groupDeleted = true;
    }
    return groupDeleted;

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


void Database::retrieveAllExistingUsers(QList <UserData *> &allUsers)
{
    QSqlDatabase dbConnection = QSqlDatabase::database();

    // Don't add twice the same login
    QSqlQuery query(dbConnection);
    query.prepare("SELECT * FROM users");
    query.exec();
    const int nameIndex = query.record().indexOf("login");
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
    if(query.exec(CREATE_TABLE_GROUPS))
        qDebug()<< "created table groups";
    else{
        qDebug() <<"failed";
        qDebug() << query.lastError();
    }
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
