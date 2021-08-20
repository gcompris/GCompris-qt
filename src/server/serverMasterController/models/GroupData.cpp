/* GCompris - GroupData.cpp
 *
 * SPDX-FileCopyrightText: 2021 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
#include <QStringList>
#include <QDebug>
//#include "UserData.h"
#include "GroupData.h"
//#include "MessageHandler.h" // not good having it here?

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
    // if(!m_users.contains(user))
    //     m_users << user;
    emit newUsers();
}

void GroupData::removeUser(UserData *user)
{
    // m_users.removeAll(user);
    emit newUsers();
}

void GroupData::removeAllUsers()
{
    m_users.clear();
    emit newUsers();
}

bool GroupData::hasUser(const QString &userName)
{
    //UserData *user = MessageHandler::getInstance()->getUser(userName);
    //return m_users.contains(user);
    return true;
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
