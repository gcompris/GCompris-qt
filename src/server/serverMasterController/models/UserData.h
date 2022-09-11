/* GCompris - UserData.h
 *
 * SPDX-FileCopyrightText: 2021 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
#ifndef USERDATA_H
#define USERDATA_H

#include <QObject>
#include <QString>
#include "DatabaseElement.h"

class GroupData;

class ConnectionStatus
{
    Q_GADGET
public:
    enum Value {
        NOT_CONNECTED,
        BAD_PASSWORD_INPUTTED,
        CONNECTED,
        ALREADY_CONNECTED,
        DISCONNECTED
    };
    Q_ENUM(Value);

private:
    explicit ConnectionStatus();
};

/**
 * @class UserData
 * @short Contains all the data relative to a user
 *
 * A user has a name and a password
 *
 */
class UserData : public DatabaseElement
{
    Q_OBJECT

    Q_PROPERTY(QString password MEMBER m_password NOTIFY newPassword)
    Q_PROPERTY(QString name MEMBER m_name NOTIFY newName)
    // todo check if there is a better way to display the list of pupils with
    // their group (directly from sqlModel?). Storing it there and updating a
    // group implies we need to update all the users when we add a grouo,
    // update a group name, remove a pupil from a group...
    Q_PROPERTY(QString groupsList READ getGroupsAsString NOTIFY newGroups)
    Q_PROPERTY(ConnectionStatus::Value status READ getConnectionStatus NOTIFY newConnectionStatus)

public:
    UserData(const QString &name = QString(), const QString &password = QString());
    UserData(const UserData &user);
    ~UserData();
    UserData &operator=(const UserData &user);

    void setName(const QString &name);
    void setPassword(const QString &password);
    void setConnectionStatus(const ConnectionStatus::Value status);

    const QString &getName() const;
    const QString &getPassword() const;
    const QList<GroupData *> getGroups() const;
    const ConnectionStatus::Value getConnectionStatus() const;
    QString getGroupsAsString() const;
    bool hasGroup(GroupData *g);
    void addGroup(GroupData *g);
    void removeGroup(GroupData *g);
    void removeAllGroups();

private:
    QString m_password;
    QString m_name;
    QList<GroupData *> m_groups;
    ConnectionStatus::Value m_status;

signals:
    void newName();
    void newPassword();
    void newGroups();
    void newConnectionStatus();
};

Q_DECLARE_METATYPE(UserData)

#endif
