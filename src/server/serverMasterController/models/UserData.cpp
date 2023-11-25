/* GCompris - UserData.cpp
 *
 * SPDX-FileCopyrightText: 2021 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
#include <QStringList>
#include <QVariant>
#include <QDebug>

#include "GroupData.h"
#include "UserData.h"

UserData::UserData(const QString &name, const QString &password) :
    m_name(name), m_password(password), m_status(ConnectionStatus::NOT_CONNECTED)
{
}

UserData::UserData(const UserData &user)
{
    m_name = user.m_name;
    m_password = user.m_password;
    m_status = user.m_status;
}

UserData &UserData::operator=(const UserData &user)
{
    m_name = user.m_name;
    m_password = user.m_password;
    m_status = user.m_status;
    return *this;
}

UserData::~UserData()
{
}

void UserData::setName(const QString &name)
{
    m_name = name;
    Q_EMIT newName();
}

void UserData::setPassword(const QString &password)
{
    m_password = password;
    Q_EMIT newPassword();
}

void UserData::setConnectionStatus(const ConnectionStatus::Value status)
{
    m_status = status;
    Q_EMIT newConnectionStatus();
}

const QString &UserData::getName() const
{
    return m_name;
}

const QString &UserData::getPassword() const
{
    return m_password;
}

const ConnectionStatus::Value UserData::getConnectionStatus() const
{
    return m_status;
}

bool UserData::hasGroup(GroupData *g)
{
    return m_groups.indexOf(g) >= 0;
}

void UserData::addGroup(GroupData *g)
{
    m_groups << g;
    Q_EMIT newGroups();
}

void UserData::removeGroup(GroupData *g)
{
    m_groups.removeOne(g);
    Q_EMIT newGroups();
}

void UserData::removeAllGroups()
{
    m_groups.clear();
    Q_EMIT newGroups();
}

const QList<GroupData *> UserData::getGroups() const
{
    return m_groups;
}

QString UserData::getGroupsAsString() const
{
    if (!m_groups.empty()) {
        QString ss;
        auto it = m_groups.cbegin();
        while (true) {
            ss += (*it)->getName();
            it++;
            if (it != m_groups.cend()) {
                ss += ", ";
            }
            else {
                return ss;
            }
        }
    }
    return "";
}
