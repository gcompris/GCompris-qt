/* GCompris - ClientData.h
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
#ifndef CLIENTDATA_H
#define CLIENTDATA_H

#include <QObject>
#include "ActivityData.h"

class QTcpSocket;

class ClientData : public QObject {
    Q_OBJECT

    Q_PROPERTY(QString login MEMBER m_login NOTIFY newLogin)
    Q_PROPERTY(QVariantMap activityData MEMBER m_variantData NOTIFY newActivityData)

public:
    ClientData();
    ClientData(const ClientData &clientData);
    ~ClientData();

    const QTcpSocket *getSocket() const;
    void setSocket(const QTcpSocket *socket);
    void setLogin(const QString &newLogin);

    void addData(const ActivityRawData &rawData);

    Q_INVOKABLE const QList<QObject*> getActivityData(const QString &activity);

private:
    const QTcpSocket *m_socket;
    QString m_login;

    QMap<QString /*activity*/, ActivityData> m_activityData;
    QVariantMap m_variantData;

signals:
    void newLogin();
    void newActivityData();
};

#endif
