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
#include <QDateTime>
#include <QString>
#include <QTcpSocket>
#include <QUdpSocket>
#include "Messages.h"
#include "DataStreamConverter.h"
#include "ApplicationSettings.h"
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

void ClientNetworkMessages::connectToServer(const QString& serverName)
{
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

    ApplicationSettings::getInstance()->setCurrentServer(serverName);
}

void ClientNetworkMessages::disconnectFromServer()
{
    tcpSocket->disconnectFromHost();
    ApplicationSettings::getInstance()->setCurrentServer("");
}

void ClientNetworkMessages::connected()
{
    QTcpSocket* socket = qobject_cast<QTcpSocket*>(sender());
    _host = serverMap.key(socket->peerAddress());
    _connected = true;
    emit connectionStatus();
    emit hostChanged();
    // if we have saved data for this server, we send it
    sendStoredData();
}

void ClientNetworkMessages::sendLoginMessage(const QString &newLogin)
{
    // Send Login message
    QByteArray bytes;
    QDataStream out(&bytes, QIODevice::WriteOnly);
    Login login { newLogin };
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
    qDebug() << "Receiving data";
    // to get the address we need to read the datagram sent by server .Is there a way to get server's address without
    // reading the datagram ?
    QByteArray datagram;
    QHostAddress address;
    quint16 port;
    datagram.resize(udpSocket->pendingDatagramSize());
    udpSocket->readDatagram(datagram.data(), datagram.size(), &address, &port);
    // since our server keeps on sending the broadcast message udpread() will be called everytime it receives the broadcast message
    // add the server's address to list only if it was not added before;

    QDataStream in(&datagram, QIODevice::ReadOnly);
    in.setVersion(QDataStream::Qt_4_0);
    Identifier messageId;
    in >> messageId;
    switch(messageId._id) {
    case MessageIdentifier::REQUEST_CONTROL:
        {
            QString serverName;
            in >> serverName;
            qDebug() << "control requested by " << serverName;
            // todo use the real server name and a real message with QDataStream
            if(!_connected)
                emit requestConnection(serverName);

            if(!serversAvailable.contains(serverName)) {
                serversAvailable.append(serverName);
                serverMap.insert(serverName, address);
                emit newServers();
            }
        }
        break;
    default:
        qDebug() << messageId._id << " received but not handled";
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

void ClientNetworkMessages::sendActivityData(const QString &activity,
                                             const QVariantMap &data)
{
    qDebug() << "Activity: " << activity << ", date: " << QDateTime::currentDateTime() << ", data:" << data;
    QString username = QString("-%1-").arg(QHostInfo::localHostName());
    ActivityRawData activityData { activity, username, QDateTime::currentDateTime(), data };

    QByteArray bytes;
    QDataStream out(&bytes, QIODevice::WriteOnly);
    out.setVersion(QDataStream::Qt_4_0);
    out << MessageIdentifier::ACTIVITY_DATA << activityData;

    if(!sendMessage(bytes) && !ApplicationSettings::getInstance()->currentServer().isEmpty()) {
        // store only if the user did not explicitly disconnect from the server
        QFile file(QStandardPaths::writableLocation(QStandardPaths::CacheLocation) +
                   ApplicationSettings::getInstance()->currentServer() + ".dat");
        file.open(QIODevice::WriteOnly | QIODevice::Append);

        QDataStream outFile(&file);
        outFile.setVersion(QDataStream::Qt_4_0);
        outFile << MessageIdentifier::ACTIVITY_DATA << activityData;

        file.close();
    }
}

bool ClientNetworkMessages::sendStoredData()
{
    QFile file(QStandardPaths::writableLocation(QStandardPaths::CacheLocation) +
               ApplicationSettings::getInstance()->currentServer() + ".dat");
    if(file.exists()) {
        file.open(QIODevice::ReadOnly);
        QDataStream in(&file);
        in.setVersion(QDataStream::Qt_4_0);
        QByteArray bytes;
        QDataStream out(&bytes, QIODevice::WriteOnly);
        out.setVersion(QDataStream::Qt_4_0);

        while(!in.atEnd()) {
            Identifier messageId;
            ActivityRawData act;
            in >> messageId >> act;
            out << messageId << act;
        }

        if(tcpSocket->state() == QAbstractSocket::ConnectedState) {
            int size = tcpSocket->write(bytes);
            qDebug() << "size sent: " << size << "/" << bytes.size() << endl;
        }
        file.close();
        file.remove();
    }
}

bool ClientNetworkMessages::sendMessage(const QByteArray &message)
{
    int size = 0;
    if(tcpSocket->state() == QAbstractSocket::ConnectedState) {
        size = tcpSocket->write(message);
    }
    return size != 0;
}

void ClientNetworkMessages::readFromSocket()
{
    QByteArray data = tcpSocket->readAll();
    QDataStream in(&data, QIODevice::ReadOnly);
    in.setVersion(QDataStream::Qt_4_0);

    Identifier messageId;
    in >> messageId;
    switch(messageId._id) {
    case MessageIdentifier::DISPLAYED_ACTIVITIES:
        {
            DisplayedActivities activities;
            in >> activities;
            qDebug() << "--" << activities.activitiesToDisplay;
            ApplicationSettings::getInstance()->setActivitiesToDisplay(activities.activitiesToDisplay);
            break;
        }
    case MessageIdentifier::ACTIVITY_CONFIGURATION:
        {
            ActivityConfiguration config;
            in >> config;
            qDebug() << "Configuration received for: " << config.activityName <<
                        ", data: " << config.data;
            ApplicationSettings::getInstance()->storeActivityConfiguration(config.activityName, config.data);
            break;
        }
    case MessageIdentifier::LOGINS_LIST:
        {
            AvailableLogins logins;
            in >> logins;
            qDebug() << "logins received: " << logins._logins;
            // todo
            emit loginListReceived(logins._logins);
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
