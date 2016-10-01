/* GCompris - ClientNetworkMessages.h
 *
 * Copyright (C) 2016 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 * This file was originally created from Digia example code under BSD license
 * and heavily modified since then.
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
#ifndef CLIENTNETWORKMESSAGES_H
#define CLIENTNETWORKMESSAGES_H

#include <QObject>
#include <QtQml>

class QTcpSocket;
class QUdpSocket;
class QNetworkSession;

class ClientNetworkMessages : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList serversAvailable MEMBER serversAvailable NOTIFY newServers)
    Q_PROPERTY(bool connected MEMBER _connected NOTIFY connectionStatus)
    Q_PROPERTY(QString host READ host WRITE setHost NOTIFY hostChanged)
    Q_PROPERTY(int port READ port WRITE setPort NOTIFY portChanged)

signals:
    void newServers();
    void hostChanged();
    void portChanged();
    void connectionStatus();

    void loginListReceived(const QStringList& logins);
    void requestConnection(const QString& serverName);

private:
    ClientNetworkMessages();  // prohibit external creation, we are a singleton!
    static ClientNetworkMessages* _instance;  // singleton instance

    QString _host;
    int _port;
    bool _connected;
    
public:
    /**
     * Registers ClientNetworkMessages singleton in the QML engine.
     */
    static void init();
    static QObject *systeminfoProvider(QQmlEngine *engine,
            QJSEngine *scriptEngine);
    static ClientNetworkMessages* getInstance();

    Q_INVOKABLE void sendActivityData(const QString &activity, const QVariantMap &data);
    bool sendMessage(const QByteArray &message);

    virtual ~ClientNetworkMessages();
    Q_INVOKABLE void connectToServer(const QString& serverName);
    Q_INVOKABLE void disconnectFromServer();
    Q_INVOKABLE void sendLoginMessage(const QString &newLogin);
    QStringList serversAvailable;

    QString host() const{
        return _host;
    }

    void setHost(const QString &newHost) {
        _host = newHost;
        emit hostChanged();
    }

    int port() const{
        return _port;
    }

    void setPort(const int &newPort) {
        _port = newPort;
        emit portChanged();
    }

private slots:
    void readFromSocket();
//    void displayError(QAbstractSocket::SocketError socketError);
    void sessionOpened();
    void udpRead();
    void connected();
    void serverDisconnected();
    
private:
    bool sendStoredData();

    QTcpSocket *tcpSocket;
    QUdpSocket* udpSocket;
    QNetworkSession *networkSession;
    QMap<QString,QHostAddress> serverMap;
};

#endif
