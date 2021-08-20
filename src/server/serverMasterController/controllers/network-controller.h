/* GCompris - network-controller.h
 *
 * SPDX-FileCopyrightText: 2021 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
#ifndef NETWORKCONTROLLER_H
#define NETWORKCONTROLLER_H

class QTcpServer;
class QTcpSocket;
class QUdpSocket;

#include "gcompris.pb.h"

#include <unordered_map>
#include <QQmlEngine>
#include <QJSEngine>

namespace controllers {
/**
     * @class NetworkController
     * @short Receive and send messages to the gcompris client instances
     *
     * Contains the tcp socket that sends and receives the different messages to
     * the clients.
     * Sends the following messages:
     * * LoginList: list of all the logins the client can choose
     * * DisplayedActivities: activities to display on the target client
     * * ActivityConfiguration: for one activity, send a specific configuration (dataset)
     *
     * Receives the following ones:
     * * Login: allows to identify a client with a name
     * * ActivityData: contains the data for one result activity send by a client
     *
     * @sa MessageHandler
     */
class NetworkController : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QStringList allInterfaces READ getAllInterfaces CONSTANT)

public:
    explicit NetworkController(QObject *parent = nullptr);

    Q_INVOKABLE void broadcastDatagram(const QString &broadcastIp, const QString &deviceId);
    Q_INVOKABLE void sendLoginList(const QStringList &selectedUsers);
    Q_INVOKABLE void disconnectSession(const QStringList &selectedUsers = QStringList());

   Q_INVOKABLE QStringList getAllInterfaces() const;

   void setMasterController(MasterController *masterController);

private slots:
    void newTcpConnection();
    void slotReadyRead();
    void disconnected();

private:
    QTcpServer *tcpServer;
    std::unordered_map<QTcpSocket *, UserData*> usersMap;
    QUdpSocket *udpSocket;

    MasterController *m_masterController;
    std::map<QTcpSocket *, QByteArray> buffers;

    void replyLoginStatus(QTcpSocket *sock, const std::string &login, const network::LoginStatus &status);
signals:
    void newClientReceived(QTcpSocket *socket);
    void clientDisconnected(QTcpSocket *socket);
};
}

#endif
