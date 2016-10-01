/* GCompris - Server.cpp
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
#include <QtNetwork>

#include "Messages.h"
#include "DataStreamConverter.h"
#include "ClientData.h"
#include "GroupData.h"
#include "Server.h"

#include <QtQml>

Server* Server::_instance = 0;

Server::Server(QObject *parent)
    : QObject(parent)
    , tcpServer(Q_NULLPTR)
    , networkSession(0)
{
    udpSocket = new QUdpSocket(this);
    messageNo = 1;

    QNetworkConfigurationManager manager;
    if (manager.capabilities() & QNetworkConfigurationManager::NetworkSessionRequired) {
        // Get saved network configuration
        QSettings settings(QSettings::UserScope, QLatin1String("QtProject"));
        settings.beginGroup(QLatin1String("QtNetwork"));
        const QString id = settings.value(QLatin1String("DefaultNetworkConfiguration")).toString();
        settings.endGroup();

        // If the saved network configuration is not currently discovered use the system default
        QNetworkConfiguration config = manager.configurationFromIdentifier(id);
        if ((config.state() & QNetworkConfiguration::Discovered) !=
            QNetworkConfiguration::Discovered) {
            config = manager.defaultConfiguration();
        }

        networkSession = new QNetworkSession(config, this);
        connect(networkSession, &QNetworkSession::opened, this, &Server::sessionOpened);

        networkSession->open();
    }
    else {
        sessionOpened();
    }
}

Server* Server::getInstance()
{
    if (!_instance)
        _instance = new Server;
    return _instance;
}

QObject *Server::systeminfoProvider(QQmlEngine *engine,
        QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    return getInstance();
}

void Server::init()
{
    qmlRegisterSingletonType<Server>("GCompris", 1, 0,
                                     "Server",
                                     systeminfoProvider);
}


void Server::sessionOpened()
{
    // Save the used configuration
    if (networkSession) {
        QNetworkConfiguration config = networkSession->configuration();
        QString id;
        if (config.type() == QNetworkConfiguration::UserChoice)
            id = networkSession->sessionProperty(QLatin1String("UserChoiceConfiguration")).toString();
        else
            id = config.identifier();

        QSettings settings(QSettings::UserScope, QLatin1String("QtProject"));
        settings.beginGroup(QLatin1String("QtNetwork"));
        settings.setValue(QLatin1String("DefaultNetworkConfiguration"), id);
        settings.endGroup();
    }

    tcpServer = new QTcpServer(this);
    connect(tcpServer, &QTcpServer::newConnection, this, &Server::newTcpConnection);

    if (!tcpServer->listen(QHostAddress::Any, 5678)) {
        qDebug() << tr("Unable to start the server: %1.")
                              .arg(tcpServer->errorString());
        return;
    }
    QString ipAddress;
    QList<QHostAddress> ipAddressesList = QNetworkInterface::allAddresses();
    // use the first non-localhost IPv4 address
    for (int i = 0; i < ipAddressesList.size(); ++i) {
        if (ipAddressesList.at(i) != QHostAddress::LocalHost &&
            ipAddressesList.at(i).toIPv4Address()) {
            ipAddress = ipAddressesList.at(i).toString();
            break;
        }
    }
    // if we did not find one, use IPv4 localhost
    if (ipAddress.isEmpty())
        ipAddress = QHostAddress(QHostAddress::LocalHost).toString();
}

void Server::newTcpConnection()
{
    QTcpSocket *clientConnection = tcpServer->nextPendingConnection();

    qDebug() << clientConnection;
    connect(clientConnection, &QAbstractSocket::disconnected,
            this, &Server::disconnected);

    connect(clientConnection, &QAbstractSocket::readyRead,
            this, &Server::slotReadyRead);

    list.push_back(clientConnection);
    qDebug() << clientConnection->peerAddress().toString();
    ClientData newClient;
    newClient.setSocket(clientConnection);
    qDebug("New tcp connection");
    emit newClientReceived(newClient);
}

void Server::broadcastDatagram()
{
    qDebug()<< QHostInfo::localHostName();
    QByteArray datagram;
    datagram.setNum(static_cast<qint32>(MessageIdentifier::REQUEST_CONTROL));
    datagram.append(QHostInfo::localHostName().toLatin1());
    qint64 data = udpSocket->writeDatagram(datagram.data(),datagram.size(),QHostAddress::Broadcast, 5678);
    qDebug()<< " size of data :" << data;
}

void Server::slotReadyRead()
{
    QTcpSocket* clientConnection = qobject_cast<QTcpSocket*>(sender());
    QByteArray data = clientConnection->readAll();
    QDataStream in(&data, QIODevice::ReadOnly);

    Identifier messageId;
    in >> messageId;

    ClientData client;
    client.setSocket(clientConnection);

    switch(messageId._id) {
    case MessageIdentifier::LOGIN:
        {
            Login log;
            in >> log;
            emit loginReceived(client, log);
            break;
        }
    case MessageIdentifier::ACTIVITY_DATA:
        {
            ActivityRawData act;
            in >> act;
            emit activityDataReceived(client, act);
            break;
        }
    default:
        qDebug() << messageId._id << " received but not handled";
    }
}

void Server::disconnected()
{
    QTcpSocket* clientConnection = qobject_cast<QTcpSocket*>(sender());
    if(!clientConnection)
        return;
    qDebug() << "Removing " << clientConnection;
    list.removeAll(clientConnection);
    ClientData newClient;
    newClient.setSocket(clientConnection);
    emit clientDisconnected(newClient);
    clientConnection->deleteLater();
}

void Server::sendActivities()
{
    DisplayedActivities activities;
    activities.activitiesToDisplay << "geography/Geography.qml" << "erase/Erase.qml" << "reversecount/Reversecount.qml";

    QByteArray block;
    QDataStream out(&block, QIODevice::WriteOnly);
    out.setVersion(QDataStream::Qt_4_0);
    out << DISPLAYED_ACTIVITIES << activities;

    for(auto sock: list)
    {
        qDebug() << "Sending " << block << " to " << sock;
        sock->write(block);
    }
}

void Server::sendLoginList(QObject *g)
{
    GroupData *group = (GroupData *) g;
    // Get all the clients from MessageHandler
    // For each client, if it does not have a name yet, send the message
    QByteArray block;
    QDataStream out(&block, QIODevice::WriteOnly);
    out.setVersion(QDataStream::Qt_4_0);

    AvailableLogins act;
    act._logins = group->m_members;

    // todo remove already used logins

    out << LOGINS_LIST << act;

    for(auto sock: list)
    {
        qDebug() << "Sending " << block << " to " << sock;
        sock->write(block);
    }

    //qDebug() << "Sending " << block << " to " << client->getSocket();
    //((QTcpSocket*)client->getSocket())->write(block);
}

void Server::sendConfiguration(/*QObject *c*//*, const ConfigurationData &config*/)
{
    //ClientData *client = (ClientData*)c;
    QByteArray block;
    QDataStream out(&block, QIODevice::WriteOnly);
    out.setVersion(QDataStream::Qt_4_0);

    ActivityConfiguration act;
    act.activityName = "reversecount/Reversecount.qml";
    act.data["dataset"] = "[{\"maxNumber\": 1, \"minNumber\": 1, \"numberOfFish\": 1},"
                      " {\"maxNumber\": 2, \"minNumber\": 2, \"numberOfFish\": 4}]";

    out << ACTIVITY_CONFIGURATION << act;

    for(auto sock: list)
    {
        qDebug() << "Sending " << block << " to " << sock;
        sock->write(block);
    }

    //qDebug() << "Sending " << block << " to " << client->getSocket();
    //((QTcpSocket*)client->getSocket())->write(block);
}
