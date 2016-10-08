/* GCompris - UserData.cpp
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
#include "Messages.h"
#include "UserData.h"

UserData::UserData() : m_name(""), m_avatar("")
{
}

UserData::UserData(const UserData &user)
{
    m_name = user.m_name;
    m_avatar = user.m_avatar;
}

UserData::~UserData()
{
}

void UserData::setName(const QString &name)
{
    m_name = name;
    emit newName();
}

void UserData::setAvatar(const QString &avatar)
{
    m_avatar = avatar;
    emit newAvatar();
}

const QString &UserData::getName() const
{
    return m_name;
}

void UserData::addData(const ActivityRawData &rawData)
{
    ActivityData &act = m_activityData[rawData.activityName];
    act.push_back(rawData);

    ActivityData *act2 = m_variantData[rawData.activityName].value<ActivityData*>();
    if(!act2) act2 = new ActivityData;
    act2->push_back(rawData);
    m_variantData[rawData.activityName] = QVariant::fromValue(act2);
    emit newActivityData();
}

const QList<QObject*> UserData::getActivityData(const QString &activity)
{
    return m_activityData[activity].m_qmlData;
}
