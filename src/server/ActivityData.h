/* GCompris - ActivityData.h
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
#ifndef ACTIVITYDATA_H
#define ACTIVITYDATA_H

#include <QObject>
#include <QDateTime>
#include <QVariantMap>

struct ActivityRawData;
/**
 * @class ActivityData_d
 * @short contains specific data of an activity
 */

class ActivityData_d:public QObject
{
public:
    ActivityData_d(const QDateTime& date, const QVariantMap& data);
    ~ActivityData_d();
    QDateTime getDate();
    QVariantMap getData();
private:
    QDateTime m_date;
    QVariantMap m_data;

};


/**
 * @class ActivityData
 * @short maintains list of ActivityData_d class
 */
class ActivityData : public QObject {
    Q_OBJECT
public:
    ActivityData();
    ActivityData(const ActivityData& act);
    ~ActivityData();

    void push_back(const ActivityRawData& rawData);

    const QList<ActivityData_d*> returnData();
private:
    QList<ActivityData_d*> m_dataList;
};

Q_DECLARE_METATYPE(ActivityData)
#endif
