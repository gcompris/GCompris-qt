/* GCompris - Database.h
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
#ifndef DATABASE_H
#define DATABASE_H

#include <QQmlEngine>
#include <QJSEngine>
#include <QMultiMap>
#include <QByteArray>

class UserData;
class GroupData;
class QSqlError;
struct ActivityRawData;

class Database : public QObject {
    Q_OBJECT

private:
    Database();
    static Database* _instance;  // singleton instance

public:
    /**
     * Registers Database singleton in the QML engine.
     */
    static void init();
    static QObject *systeminfoProvider(QQmlEngine *engine,
            QJSEngine *scriptEngine);
    static Database* getInstance();

    ~Database();

    bool addGroup(const QString &groupName, const QString& description = QString(),
                  const QStringList& users=QStringList());
    bool deleteGroup(const QString& groupName);
    void retrieveAllExistingUsers(QList <UserData *> &allUsers);
    void retrieveAllExistingGroups(QList<GroupData* > &allGroups);

    bool addUser(const QString &name, const QString &avatar = "", const QStringList& groups=QStringList());
    bool addUserToGroup(const QString& group, const QString& user);

    QMultiMap<QString,QString> retrieveGroupUsers();
    bool addDataToDatabase(const ActivityRawData &rawData);
    void retrieveActivityData(UserData* user);

};

#endif
