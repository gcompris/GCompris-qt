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
#include "MessageHandler.h"

#include <QtQml>

Server* Server::_instance = 0;

Server::Server(QObject *parent)
    : QObject(parent)
    , tcpServer(Q_NULLPTR)
    , networkSession(0)
{
    udpSocket = new QUdpSocket(this);
    messageNo = 1;
    tcpServer = new QTcpServer(this);
    connect(tcpServer, &QTcpServer::newConnection, this, &Server::newTcpConnection);

    if (!tcpServer->listen(QHostAddress::Any, 5678)) {
        qDebug() << tr("Unable to start the server: %1.")
                              .arg(tcpServer->errorString());
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
    qDebug("New tcp connection");
    emit newClientReceived(clientConnection);
}

void Server::broadcastDatagram()
{
    qDebug()<< QHostInfo::localHostName();
    QByteArray datagram;
    // todo use a real message structure in Messages.h
    QDataStream out(&datagram, QIODevice::WriteOnly);
    out << MessageIdentifier::REQUEST_CONTROL << QHostInfo::localHostName();
    qint64 data = udpSocket->writeDatagram(datagram.data(),datagram.size(),QHostAddress::Broadcast, 5678);
    qDebug()<< " size of data :" << data;
}

void Server::slotReadyRead()
{
    QTcpSocket* clientConnection = qobject_cast<QTcpSocket*>(sender());
    QByteArray data = clientConnection->readAll();
    QDataStream in(&data, QIODevice::ReadOnly);
    in.setVersion(QDataStream::Qt_4_0);

    while(!in.atEnd()) {
        Identifier messageId;
        in >> messageId;

        switch(messageId._id) {
        case MessageIdentifier::LOGIN:
        {
            Login log;
            in >> log;
            emit loginReceived(clientConnection, log);
            break;
        }
        case MessageIdentifier::ACTIVITY_DATA:
        {
            ActivityRawData act;
            in >> act;
            emit activityDataReceived(clientConnection, act);
            break;
        }
        default:
            qDebug() << messageId._id << " received but not handled";
        }
    }
}

void Server::disconnected()
{
    QTcpSocket* clientConnection = qobject_cast<QTcpSocket*>(sender());
    if(!clientConnection)
        return;
    qDebug() << "Removing " << clientConnection;
    list.removeAll(clientConnection);
    emit clientDisconnected(clientConnection);
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

void Server::sendLoginList()
{
    // Get all the clients from MessageHandler
    // For each client, if it does not have a name yet, send the message
    QByteArray block;
    QDataStream out(&block, QIODevice::WriteOnly);
    out.setVersion(QDataStream::Qt_4_0);

    // remove the sockets not the names
//    QStringList usedLogins;
//    for(const QObject* oClient: MessageHandler::getInstance()->returnClients()) {
//        ClientData* c = (ClientData*)(oClient);
//        if(c->getUserData()){
//            usedLogins << c->getUserData()->getName();
//        }
//    }

    AvailableLogins act;
    for(const QObject *oC: MessageHandler::getInstance()->returnUsers()) {
            act._logins << ((const UserData*)oC)->getName();
    }


    out << LOGINS_LIST << act;
    for(auto sock: list)
    {
        qDebug() << "Sending " << block << " to " << sock;
        sock->write(block);
    }

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
