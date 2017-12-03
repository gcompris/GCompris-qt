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
#include <QMap>
#include <QVariantMap>

struct ActivityRawData;
class ActivityData;


/**
 * @class UserData
 * @short Contains all the data relative to a user
 *
 * A user has a name, a date of birth, a password and a map of all its results per activity
 *
 */
class UserData : public QObject {
    Q_OBJECT

    Q_PROPERTY(QString password MEMBER m_password NOTIFY newPassword)
    Q_PROPERTY(QString dateOfBirth MEMBER m_dateOfBirth NOTIFY newDateOfBirth)
    Q_PROPERTY(QString name MEMBER m_name NOTIFY newName)

public:
    UserData(const QString &name = QString(), const QString &dateOfBirth = QString(), const QString &password = QString());
    UserData(const UserData &user);
    ~UserData();

    void setName(const QString &name);
    void setDateOfBirth(const QString &dateOfBirth);
    void setPassword(const QString &password);

    void addData(const ActivityRawData &rawData);
    const QString &getName() const;
    const QString &getDateOfBirth() const;
    const QString &getPassword() const;
    Q_INVOKABLE const QVariantMap getActivityData(const QString &activity);

private:
    QString m_password;
    QString m_dateOfBirth;
    QString m_name;

    QMap<QString, ActivityData*> m_activityData;
    QVariantMap m_variantData;

signals:
    void newName();
    void newDateOfBirth();
    void newPassword();
    void newActivityData();
};

Q_DECLARE_METATYPE(UserData)

#endif
