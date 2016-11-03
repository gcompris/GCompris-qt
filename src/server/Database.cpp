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

#define CREATE_TABLE_USERS						\
  "CREATE TABLE users (user_id INT UNIQUE, login TEXT, avatar TEXT); "
#define CREATE_TABLE_GROUPS						\
  "CREATE TABLE groups (group_id INT UNIQUE, name TEXT, description TEXT, userId INT); "

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

bool Database::addUser(const QString &name, const QString &avatar)
{
    QSqlDatabase dbConnection = QSqlDatabase::database();

    // Don't add twice the same login
    QSqlQuery alreadyExistingUser(dbConnection);
    alreadyExistingUser.prepare("SELECT * FROM users WHERE login=:name");
    alreadyExistingUser.bindValue(":name", name);
    alreadyExistingUser.exec();
    if(alreadyExistingUser.next()) {
        qDebug() << "User " << name << " already exists";
        return false;
    }

    // Add the user in the database
    QSqlQuery query(dbConnection);
    query.prepare("INSERT INTO users (login, avatar) VALUES (:name, :avatar)");
    query.bindValue(":name", name);
    query.bindValue(":avatar", avatar);
    bool returnValue = query.exec();
    if(!returnValue)
        qDebug() << query.lastError();
    return returnValue;
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
    query.exec(CREATE_TABLE_USERS);
    query.exec(CREATE_TABLE_GROUPS);
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
