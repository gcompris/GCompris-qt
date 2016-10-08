/* GCompris - UserData.h
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
#ifndef USERDATA_H
#define USERDATA_H

#include <QObject>
#include <QStringList>
#include "ActivityData.h"

class UserData : public QObject {
    Q_OBJECT

    Q_PROPERTY(QString avatar MEMBER m_avatar NOTIFY newAvatar)
    Q_PROPERTY(QString name MEMBER m_name NOTIFY newName)

    Q_PROPERTY(QVariantMap activityData MEMBER m_variantData NOTIFY newActivityData)

public:
    UserData();
    UserData(const UserData &user);
    ~UserData();

    void setName(const QString &name);
    void setAvatar(const QString &avatar);

    const QString &getName() const;

    void addData(const ActivityRawData &rawData);

    Q_INVOKABLE const QList<QObject*> getActivityData(const QString &activity);

private:
    QString m_avatar;
    QString m_name;

    QMap<QString /*activity*/, ActivityData> m_activityData;
    QVariantMap m_variantData;

signals:
    void newAvatar();
    void newName();
    void newActivityData();
};

Q_DECLARE_METATYPE(UserData)

#endif
