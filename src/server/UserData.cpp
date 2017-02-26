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
#include <QVariant>
#include <QDebug>

#include "Messages.h"
#include "UserData.h"
#include "GroupData.h"
#include "ActivityData.h"


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
QList<QObject*> UserData::getGroups()
{
    return m_groups;
}

void UserData::setAvatar(const QString &avatar)
{
    m_avatar = avatar;
    emit newAvatar();
}
void UserData::addGroup(GroupData *group)
{
    if(!m_groups.contains((QObject*)group))
        m_groups << (QObject*)group;
}
const QString &UserData::getName() const
{
    return m_name;
}

void UserData::addData(const ActivityRawData &rawData)
{
    ActivityData* act = m_activityData.value(rawData.activityName , NULL);
    if(!act){
        act = new ActivityData();
        m_activityData.insert(rawData.activityName, act);
        qDebug() << act;
    }
    act->push_back(rawData);
}

const QVariantMap UserData::getActivityData(const QString &activity)
{
    qDebug() << activity << " "<< this->m_name;
    QMap<QString, QVariant> result;
    QList<QVariant> dataList;
    QVariant var;
    ActivityData*  act = m_activityData.value(activity);
    if(act){
        const QList<ActivityData_d*> &data = act->returnData();
        for(auto it = data.begin(); it!= data.end(); it++) {
            var = result.value((*it)->getDate().toString("dd/MM/yyyy"),QVariant());
            dataList = var.value<QList<QVariant>>();
            dataList.push_back((*it)->getData());
            var.setValue(dataList);
            result.insert((*it)->getDate().toString("dd/MM/yyyy"),var);
        }
    }

    return result;
}
