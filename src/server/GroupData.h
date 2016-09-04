/* GCompris - GroupData.h
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
#ifndef GROUPDATA_H
#define GROUPDATA_H

#include <QObject>
#include <QStringList>

class GroupData : public QObject {
    Q_OBJECT

    Q_PROPERTY(QStringList members MEMBER m_members NOTIFY newMembers)
    Q_PROPERTY(QString name MEMBER m_name NOTIFY newName)

public:
    GroupData();
    ~GroupData();

    //private:
    QStringList m_members;
    QString m_name;

signals:
    void newMembers();
    void newName();
};

#endif
