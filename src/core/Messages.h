/* GCompris - Messages.h
 *
 * Copyright (C) 2016 Emmanuel Charruau <echarruau@gmail.com>, Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
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
#ifndef MESSAGES_H
#define MESSAGES_H

#include <QList>
#include <QString>
#include <QStringList>
#include <QDateTime>
#include <QVariantMap>

enum MessageIdentifier : int {
    LOGIN = 0,
    REQUEST_CONTROL,
    LOGINS_LIST,
    REQUEST_USERNAME,
    DISPLAYED_ACTIVITIES,
    ACTIVITY_DATA,
    ACTIVITY_CONFIGURATION
};

struct Identifier {
    MessageIdentifier _id;
};

struct Login {
    QString _name;
};

struct AvailableLogins {
    QStringList _logins;
};

struct DisplayedActivities {
    QStringList activitiesToDisplay;
};

struct ActivityRawData {
    QString activityName;
    QString username;
    QDateTime date;
    QVariantMap data;
};

struct ActivityConfiguration {
    QString activityName;
    QVariantMap data;
};

struct ConfigurationData {
    QList<ActivityConfiguration*> activities;
};

#endif
