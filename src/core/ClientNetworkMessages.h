/* GCompris - ClientNetworkMessages.h
 *
 * SPDX-FileCopyrightText: 2021 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
#ifndef CLIENTNETWORKMESSAGES_H
#define CLIENTNETWORKMESSAGES_H

#include <QObject>
#include <QtQml>
#include "netconst.h"

class QTcpSocket;
class QUdpSocket;

class ClientNetworkMessages : public QObject
{
    Q_OBJECT
    //    Q_PROPERTY(bool connected MEMBER _connected NOTIFY connectionStatus)
    Q_PROPERTY(netconst::ConnectionStatus status MEMBER status NOTIFY statusChanged)
    Q_PROPERTY(QString host READ host WRITE setHost NOTIFY hostChanged)
    Q_PROPERTY(int port READ port WRITE setPort NOTIFY portChanged)

public:
    ClientNetworkMessages();

Q_SIGNALS:
    void newServers();
    void statusChanged();
    void hostChanged();
    void portChanged();
    //    void connectionStatus();
    void loginListReceived(const QStringList &logins);
    void loginConfirmationReceived(const QString &login, bool logOk);
    void requestConnection(const QString &requestDeviceId, const QString &serverIp);
    void passwordRejected();

public:
    virtual ~ClientNetworkMessages();
    Q_INVOKABLE void connectToServer(const QString &serverName);
    Q_INVOKABLE void sendLoginMessage(const QString &login, const QString &newPassword);
    Q_INVOKABLE void sendActivityData(const QString &activity, const QJsonObject &data);
    Q_INVOKABLE int connectionStatus();

    QString host() const
    {
        return _host;
    }

    void setHost(const QString &newHost)
    {
        _host = newHost;
        Q_EMIT hostChanged();
    }

    int port() const
    {
        return _port;
    }

    void setPort(const int &newPort)
    {
        _port = newPort;
        Q_EMIT portChanged();
    }

private Q_SLOTS:
    void readFromSocket();
    void udpRead();
    void connected();
    void onErrorOccurred(QAbstractSocket::SocketError socketError);
    void serverDisconnected();
    void ping();

private:
    void disconnectFromServer();
    void forgetUser();
    QByteArray prepareMessage(QJsonObject &obj);
    void sendMessage(QByteArray message);
    void sendNextMessage();
    bool sendStoredData();

    int userId;

    QString _host;
    int _port;
    bool _connected;
    bool _wait4pong;

    QTcpSocket *tcpSocket;
    QUdpSocket *udpSocket;
    QByteArray tcpBuffer;
    QByteArray udpBuffer;
    netconst::ConnectionStatus status;
    // polling and reconnection
    QTimer pingTimer;
    QString login;
    QString password;
    QString ipServer;
    QList<QByteArray> messageQueue;
};

#endif
