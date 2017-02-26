/* GCompris - ActivityData.cpp
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

#include "Messages.h"
#include "ActivityData.h"
#include <QDebug>
ActivityData::ActivityData()
{

}
ActivityData::ActivityData(const ActivityData &act)
{
}

ActivityData::~ActivityData()
{
}

const QList<ActivityData_d*> ActivityData::returnData()
{
    return m_dataList;
}

void ActivityData::push_back(const ActivityRawData& rawData)
{
    // create a new activity_d object
    ActivityData_d* actData_d = new ActivityData_d(rawData.date, rawData.data);
    this->m_dataList.push_back(actData_d);

}

ActivityData_d::ActivityData_d(const QDateTime &date, const QVariantMap &data):
    m_date(date),
    m_data(data)
{

}
ActivityData_d::~ActivityData_d()
{

}
QDateTime ActivityData_d::getDate()
{
    qDebug() << m_date;
    return m_date;
}
QVariantMap ActivityData_d::getData()
{
    qDebug() << m_data;
    return m_data;
}

