/* GCompris - Server.h
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
#ifndef SERVER_H
#define SERVER_H

class QTcpServer;
class QTcpSocket;
class QNetworkSession;
class QUdpSocket;

struct Login;
struct ActivityRawData;
struct GroupData;
struct ClientData;

#include <QQmlEngine>
#include <QJSEngine>

/**
 * @class Server
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
class Server : public QObject
{
    Q_OBJECT

private:
    explicit Server(QObject *parent = Q_NULLPTR);
    static Server* _instance;  // singleton instance

public:
    /**
     * Registers Server singleton in the QML engine.
     */
    /// @cond INTERNAL_DOCS
    static void init();
    static QObject *systeminfoProvider(QQmlEngine *engine,
            QJSEngine *scriptEngine);
    static Server* getInstance();
    
    Q_INVOKABLE void broadcastDatagram();
    Q_INVOKABLE void sendConfiguration();
    Q_INVOKABLE void sendActivities();
    Q_INVOKABLE void sendLoginList(QObject *g);

private slots:
    void newTcpConnection();
    void slotReadyRead();
    void disconnected();

private:
    QTcpServer *tcpServer;
    QNetworkSession *networkSession;
    QList<QTcpSocket*> list;
    QUdpSocket *udpSocket;
    int messageNo;
    
signals:
    void newClientReceived(const ClientData &client);
    void activityDataReceived(const ClientData &who, const ActivityRawData &data);
    void clientDisconnected(QTcpSocket* socket);
    void loginReceived(QTcpSocket* socket, const Login &log);
};

#endif
