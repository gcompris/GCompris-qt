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
#include <QQmlComponent>

ActivityData::ActivityData()
{
}
ActivityData::ActivityData(const ActivityData &act)
{
}

ActivityData::~ActivityData()
{
}

void ActivityData::operator=(const ActivityData &act)
{
    m_data = act.m_data;
}

void ActivityData::push_back(const ActivityRawData &rawData)
{
    ActivityData_d *data = new ActivityData_d;
    data->setDate(rawData.date);
    data->setData(rawData.data);
    m_data.push_back(*data);
    m_qmlData.push_back(data);
}

ActivityData_d::ActivityData_d()
{
}

ActivityData_d::ActivityData_d(const ActivityData_d &d)
{
    setDate(d.m_date);
    setData(d.m_data);
}

ActivityData_d::~ActivityData_d()
{
}

void ActivityData_d::operator=(const ActivityData_d &d)
{
    setDate(d.m_date);
    setData(d.m_data);
}

void ActivityData_d::setDate(const QDateTime &date)
{
    m_date = date;
    emit newDate();
}

void ActivityData_d::setData(const QVariantMap &data)
{
    m_data = data;
    emit newData();
}
