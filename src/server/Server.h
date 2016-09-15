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
struct ActivityData;
struct ClientData;

#include <QQmlEngine>
#include <QJSEngine>
#include <QDialog>

class Server : public QDialog
{
    Q_OBJECT

private:
    explicit Server(QWidget *parent = Q_NULLPTR);
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
    Q_INVOKABLE void sendConfiguration(QObject *client/*, const ConfigurationData &config*/);
    Q_INVOKABLE void sendActivities();

private slots:
    void sessionOpened();
    void newTcpConnection();
    void slotReadyRead();
    void sendAll();
    void disconnected();

private:
    QTcpServer *tcpServer;
    QNetworkSession *networkSession;
    QList<QTcpSocket*> list;
    QUdpSocket *udpSocket;
    int messageNo;
    
signals:
    void newClientReceived(const ClientData &client);
    void clientDisconnected(const ClientData &client);
    void loginReceived(const Login &log);
    void activityDataReceived(const ActivityData &data);
};

#endif
