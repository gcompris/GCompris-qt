/* GCompris - GroupData.h
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
#ifndef GROUPDATA_H
#define GROUPDATA_H

#include <QObject>
#include <QStringList>

class UserData;

/**
 * @class GroupData
 * @short Contains all the data relative to a group
 *
 * A group is composed of a list of users and has a name identifier.
 *
 * @sa UserData
 */
class GroupData : public QObject {
    Q_OBJECT

    Q_PROPERTY(QList<QObject *> users MEMBER m_users NOTIFY newUsers)
    Q_PROPERTY(QString name MEMBER m_name NOTIFY newName)

public:
    GroupData();
    GroupData(const GroupData &group);
    ~GroupData();

    const QList<QObject *> &getUsers() const;
    void addUser(UserData *user);
    void removeUser(UserData *user);
    void removeAllUsers();
    Q_INVOKABLE bool hasUser(const QString &user);

    const QString &getName() const;
    void setName(const QString &newName);

 private:
    // UserData*
    QList<QObject *> m_users;
    QString m_name;

signals:
    void newUsers();
    void newName();
};

Q_DECLARE_METATYPE(GroupData)

#endif
