/* GCompris - ClientNetworkMessages.cpp
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
#include <QString>
#include <QTcpSocket>
#include <QUdpSocket>
#include "Messages.h"
#include "DataStreamConverter.h"
#include "ClientNetworkMessages.h"

ClientNetworkMessages* ClientNetworkMessages::_instance = 0;

ClientNetworkMessages::ClientNetworkMessages(): QObject(),
                                                tcpSocket(new QTcpSocket(this)),
                                                udpSocket(new QUdpSocket(this)),
                                                networkSession(Q_NULLPTR),
                                                _connected(false)
{
    if(!udpSocket->bind(5678, QUdpSocket::ShareAddress))
         qDebug("could not bind");
     else
         qDebug("success");

    connect(udpSocket, &QUdpSocket::readyRead, this, &ClientNetworkMessages::udpRead);
    connect(tcpSocket, &QTcpSocket::connected, this, &ClientNetworkMessages::connected);
    connect(tcpSocket, &QTcpSocket::disconnected, this, &ClientNetworkMessages::serverDisconnected);
    connect(tcpSocket, &QAbstractSocket::readyRead, this, &ClientNetworkMessages::readFromSocket);

    QNetworkConfigurationManager manager;
    if (manager.capabilities() & QNetworkConfigurationManager::NetworkSessionRequired) {
        // Get saved network configuration
        QString id;
        {
            QSettings settings(QSettings::UserScope, QLatin1String("QtProject"));
            settings.beginGroup(QLatin1String("QtNetwork"));
            id = settings.value(QLatin1String("DefaultNetworkConfiguration")).toString();
            settings.endGroup();
        }
        // If the saved network configuration is not currently discovered use the system default
        QNetworkConfiguration config = manager.configurationFromIdentifier(id);
        if ((config.state() & QNetworkConfiguration::Discovered) !=
            QNetworkConfiguration::Discovered) {
            config = manager.defaultConfiguration();
        }

        networkSession = new QNetworkSession(config, this);
        connect(networkSession, &QNetworkSession::opened, this, &ClientNetworkMessages::sessionOpened);
        networkSession->open();
    }
}

ClientNetworkMessages::~ClientNetworkMessages()
{
    _instance = 0;
}

// It is not recommended to create a singleton of Qml Singleton registered
// object but we could not found a better way to let us access ClientNetworkMessages
// on the C++ side. All our test shows that it works.
// Using the singleton after the QmlEngine has been destroyed is forbidden!
ClientNetworkMessages* ClientNetworkMessages::getInstance()
{
    if (!_instance)
        _instance = new ClientNetworkMessages;
    return _instance;
}

QObject *ClientNetworkMessages::systeminfoProvider(QQmlEngine *engine,
        QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    return getInstance();
}

void ClientNetworkMessages::init()
{
    qmlRegisterSingletonType<ClientNetworkMessages>("GCompris", 1, 0,
            "ClientNetworkMessages",
            systeminfoProvider);
}

void ClientNetworkMessages::connectToServer(const QString& serverName) {
    QString ip = _host;
    int port = _port;

    //if we are already connected to some server, disconnect from it first and then make a connection with new server
    if(_connected) { // and newServer != currentServer
        disconnectFromServer();
    }
    if(serverMap.count(serverName) != 0) {
        ip = serverMap.value(serverName).toString();
        port = 5678;
    }
    qDebug()<< "connect to " << ip << ":" << port;
    if(tcpSocket->state() != QAbstractSocket::ConnectedState) {
        tcpSocket->connectToHost(ip, port);
    }
}

void ClientNetworkMessages::disconnectFromServer() {
    tcpSocket->disconnectFromHost();
}

void ClientNetworkMessages::connected() {
    QTcpSocket* socket = qobject_cast<QTcpSocket*>(sender());
    _host = serverMap.key(socket->peerAddress());
    _connected = true;
    emit connectionStatus();
    emit hostChanged();

    // Send Login message
    QByteArray bytes;
    QDataStream out(&bytes, QIODevice::WriteOnly);
    Login login {QString("-%1-").arg(QHostInfo::localHostName()) };
    out << MessageIdentifier::LOGIN << login;
    sendMessage(bytes);
}

void ClientNetworkMessages::serverDisconnected() {
    _host = "";
    _connected = false;
    emit connectionStatus();
    emit hostChanged();
}


void ClientNetworkMessages::udpRead() {
    // someone is out there whom I can connect with.Let's get it's address and store it in the list;

    // to get the address we need to read the datagram sent by server .Is there a way to get server's address without
    // reading the datagram ?
    QByteArray datagram;
    QHostAddress address;
    quint16 port;
    datagram.resize(udpSocket->pendingDatagramSize());
    udpSocket->readDatagram(datagram.data(), datagram.size(), &address, &port)
;
    // since our server keeps on sending the broadcast message udpread() will be called everytime it receives the broadcast message
    // add the server's address to list only if it was not added before;
//    qDebug()<< datagram.data();

    if(!serversAvailable.contains(datagram.data())) {
        serversAvailable.append(datagram.data());
        serverMap.insert(datagram.data(),address);
        emit newServers();
    }
}

void ClientNetworkMessages::sessionOpened()
{
    // Save the used configuration
    QNetworkConfiguration config = networkSession->configuration();
    QString id;
    if (config.type() == QNetworkConfiguration::UserChoice)
        id = networkSession->sessionProperty(QLatin1String("UserChoiceConfiguration")).toString();
    else
        id = config.identifier();
}

void ClientNetworkMessages::sendMessage(const QString &message)
{
    qDebug() << "Message:" << message;
    if(tcpSocket->state() == QAbstractSocket::ConnectedState) {
        // QByteArray bytes;
        // QDataStream out(&bytes, QIODevice::WriteOnly);
        // Login login {const_cast<char*>(QString("-%1-").arg(QHostInfo::localHostName()).toStdString().c_str()) };
        // out << MessageIdentifier::LOGIN << login;
        // tcpSocket->write(bytes);
    }
}

void ClientNetworkMessages::sendMessage(const QByteArray &message)
{
    qDebug() << "Message:" << message;
    if(tcpSocket->state() == QAbstractSocket::ConnectedState) {
        tcpSocket->write(message);
    }
}

void ClientNetworkMessages::readFromSocket()
{
    QByteArray data = tcpSocket->readAll();
    QDataStream in(&data, QIODevice::ReadOnly);
    in.setVersion(QDataStream::Qt_4_0);

    Identifier messageId;
    in >> messageId;
    qDebug() << "Reading " << data << " from " << tcpSocket;
    switch(messageId._id) {
    case MessageIdentifier::DISPLAYED_ACTIVITIES:
        {
            DisplayedActivities activities;
            in >> activities;
            qDebug() << "--" << activities.activitiesToDisplay;
            break;
        }
    default:
        qDebug() << messageId._id << " received but not handled";
    }
}

//void ClientNetworkMessages::displayError(QAbstractSocket::SocketError socketError)
//{
//    switch (socketError) {
//    case QAbstractSocket::RemoteHostClosedError:
//        break;
//    case QAbstractSocket::HostNotFoundError:
//        qDebug() << tr("The host was not found. Please check the "
//                  "host name and port settings.");
//        break;
//    case QAbstractSocket::ConnectionRefusedError:
//        qDebug() << tr("The connection was refused by the peer. "
//                                    "Make sure the server is running, "
//                                    "and check that the host name and port "
//                                    "settings are correct.");
//        break;
//    default:
//        qDebug() << tr("The following error occurred: %1.").arg(tcpSocket->errorString());
//    }
//}
