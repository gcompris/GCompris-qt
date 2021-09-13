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

#include "UserData.h"

UserData::UserData(const QString &name, const QString &dateOfBirth, const QString &password) : m_name(name), m_dateOfBirth(dateOfBirth), m_password(password)
{
}

UserData::UserData(const UserData &user)
{
    m_name = user.m_name;
    m_dateOfBirth = user.m_dateOfBirth;
    m_password = user.m_password;
}

UserData::~UserData()
{
}

void UserData::setName(const QString &name)
{
    m_name = name;
    emit newName();
}

void UserData::setDateOfBirth(const QString &dateOfBirth)
{
    m_dateOfBirth = dateOfBirth;
    emit newDateOfBirth();
}

void UserData::setPassword(const QString &password)
{
    m_password = password;
    emit newPassword();
}

const QString &UserData::getName() const
{
    return m_name;
}

const QString &UserData::getDateOfBirth() const
{
    return m_dateOfBirth;
}

const QString &UserData::getPassword() const
{
    return m_password;
}
