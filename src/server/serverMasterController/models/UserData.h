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

/**
 * @class UserData
 * @short Contains all the data relative to a user
 *
 * A user has a name, a date of birth, a password
 *
 */
class UserData : public DatabaseElement {
    Q_OBJECT

    Q_PROPERTY(QString password MEMBER m_password NOTIFY newPassword)
    Q_PROPERTY(QString dateOfBirth MEMBER m_dateOfBirth NOTIFY newDateOfBirth)
    Q_PROPERTY(QString name MEMBER m_name NOTIFY newName)
    // todo check if there is a better way to display the list of pupils with
    // their group (directly from sqlModel?). Storing it there and updating a
    // group implies we need to update all the users when we add a grouo,
    // update a group name, remove a pupil from a group...
    Q_PROPERTY(QString groupsList READ getGroupsAsString NOTIFY newGroups)

public:
    UserData(const QString &name = QString(), const QString &dateOfBirth = QString(), const QString &password = QString());
    UserData(const UserData &user);
    ~UserData();

    void setName(const QString &name);
    void setDateOfBirth(const QString &dateOfBirth);
    void setPassword(const QString &password);

    const QString &getName() const;
    const QString &getDateOfBirth() const;
    const QString &getPassword() const;
    const QList<GroupData *> getGroups() const;
    QString getGroupsAsString() const;
    bool hasGroup(GroupData *g);
    void addGroup(GroupData *g);
    void removeGroup(GroupData *g);
    void removeAllGroups();

private:
    QString m_password;
    QString m_dateOfBirth;
    QString m_name;
    QList<GroupData *> m_groups;

signals:
    void newName();
    void newDateOfBirth();
    void newPassword();
    void newGroups();
};

Q_DECLARE_METATYPE(UserData)

#endif
