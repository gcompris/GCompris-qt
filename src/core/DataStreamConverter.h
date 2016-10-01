/* GCompris - DataStreamConverter.h
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
#ifndef DATASTREAM_CONVERTER_H
#define DATASTREAM_CONVERTER_H

#include "Messages.h"
#include <QDataStream>

QDataStream& operator<<(QDataStream &dataStream, const Identifier &id)
{
    dataStream << int(id._id);
    return dataStream;
};

QDataStream& operator>>(QDataStream &dataStream, Identifier &id)
{
    int identifier;
    dataStream >> identifier;
    id._id = (MessageIdentifier)identifier;
    return dataStream;
};

QDataStream& operator<<(QDataStream &dataStream, const Login &login)
{
    dataStream << login._name;
    return dataStream;
};

QDataStream& operator>>(QDataStream &dataStream, Login &login)
{
    dataStream >> login._name;
    return dataStream;
};

QDataStream& operator<<(QDataStream &dataStream, const AvailableLogins &logins)
{
    dataStream << logins._logins;
    return dataStream;
};

QDataStream& operator>>(QDataStream &dataStream, AvailableLogins &logins)
{
    dataStream >> logins._logins;
    return dataStream;
};

QDataStream& operator<<(QDataStream &dataStream, const DisplayedActivities &act)
{
    dataStream << act.activitiesToDisplay;
    return dataStream;
};

QDataStream& operator>>(QDataStream &dataStream, DisplayedActivities &act)
{
    dataStream >> act.activitiesToDisplay;
    return dataStream;
};

QDataStream& operator<<(QDataStream &dataStream, const ActivityRawData &act)
{
    dataStream << act.activityName << act.username << act.date << act.data;
    return dataStream;
};

QDataStream& operator>>(QDataStream &dataStream, ActivityRawData &act)
{
    dataStream >> act.activityName >> act.username >> act.date >> act.data;
    return dataStream;
};

QDataStream& operator<<(QDataStream &dataStream, const ActivityConfiguration &act)
{
    dataStream << act.activityName << act.data;
    return dataStream;
};

QDataStream& operator>>(QDataStream &dataStream, ActivityConfiguration &act)
{
    dataStream >> act.activityName >> act.data;
    return dataStream;
};


#endif
