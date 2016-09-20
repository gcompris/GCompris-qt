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
#include <QList>
#include <QVariantMap>
#include <QDateTime>

class QTcpSocket;
struct ActivityRawData;

class ActivityData_d : public QObject {
    Q_OBJECT

    Q_PROPERTY(QDateTime date MEMBER m_date NOTIFY newDate)
    Q_PROPERTY(QVariantMap data MEMBER m_data NOTIFY newData)

public:
    ActivityData_d();
    ActivityData_d(const ActivityData_d &d);
    ~ActivityData_d();
    void operator=(const ActivityData_d &d);

    void setDate(const QDateTime &date);
    void setData(const QVariantMap &data);

private:
    QDateTime m_date;
    QVariantMap m_data;

signals:
    void newDate();
    void newData();

};

class ActivityData : public QObject {
    Q_OBJECT

public:
    ActivityData();
    ActivityData(const ActivityData &activityData);
    ~ActivityData();

    void operator=(const ActivityData &);

    void push_back(const ActivityRawData &rawData);

    QList<QObject *> m_qmlData;
private:
    QList<ActivityData_d> m_data;
};

#endif
