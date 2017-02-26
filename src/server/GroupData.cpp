/* GCompris - GroupData.cpp
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

#include <QStringList>
#include <QDebug>
#include "UserData.h"
#include "GroupData.h"
#include "MessageHandler.h" // not good having it here?

GroupData::GroupData()
{
}

GroupData::GroupData(const GroupData &group)
{
        m_users = group.m_users;
        m_name = group.m_name;
}

GroupData::~GroupData()
{
}

const QList<QObject *> &GroupData::getUsers() const
{
    return m_users;
}
void GroupData::addUser(UserData *user)
{
    if(!m_users.contains(user))
        m_users << user;
    emit newUsers();
}

void GroupData::removeUser(UserData *user)
{
    m_users.removeAll(user);
    emit newUsers();
}

void GroupData::removeAllUsers()
{
    m_users.clear();
    emit newUsers();
}

bool GroupData::hasUser(const QString &userName)
{
    UserData *user = MessageHandler::getInstance()->getUser(userName);
    return m_users.contains(user);
}

const QString &GroupData::getName() const
{
    return m_name;
}

void GroupData::setDescription(const QString &description)
{
    m_description = description;
}

void GroupData::setName(const QString &name)
{
    m_name = name;
    emit newName();
}
