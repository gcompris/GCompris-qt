/* GCompris - GroupData.h
 *
 * SPDX-FileCopyrightText: 2021 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
#ifndef GROUPDATA_H
#define GROUPDATA_H

#include <QObject>
#include <QStringList>
#include "DatabaseElement.h"

class UserData;

/**
 * @class GroupData
 * @short Contains all the data relative to a group
 *
 * A group is composed of a list of users and has a name identifier.
 *
 * @sa UserData
 */
class GroupData : public DatabaseElement
{
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
    void setDescription(const QString &description);

private:
    // UserData*
    QList<QObject *> m_users;
    QString m_name;
    QString m_description;

signals:
    void newUsers();
    void newName();
};

Q_DECLARE_METATYPE(GroupData)

#endif
