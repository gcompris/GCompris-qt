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
#include <QtWidgets>
#include <QtNetwork>

#include "Messages.h"
#include "DataStreamConverter.h"
#include "ClientData.h"
#include "Server.h"

#include <QtQml>

Server* Server::_instance = 0;

Server::Server(QWidget *parent)
    : QDialog(parent)
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

    QPushButton *quitButton = new QPushButton(tr("Quit"));
    quitButton->setAutoDefault(false);
    connect(quitButton, &QAbstractButton::clicked, this, &QWidget::close);
    QPushButton *sendButton = new QPushButton(tr("Send All"));
    sendButton->setAutoDefault(false);
    connect(sendButton, &QAbstractButton::clicked, this, &Server::sendAll);

    QPushButton *sendActivitiesButton = new QPushButton(tr("Send activities"));
    sendActivitiesButton->setAutoDefault(false);
    connect(sendActivitiesButton, &QAbstractButton::clicked, this, &Server::sendActivities);

    QHBoxLayout *buttonLayout = new QHBoxLayout;
    buttonLayout->addStretch(1);
    buttonLayout->addWidget(sendButton);
    buttonLayout->addWidget(sendActivitiesButton);
    buttonLayout->addWidget(quitButton);
    buttonLayout->addStretch(1);

    QPushButton *broadcasting = new QPushButton("Broadcasting");
    connect(broadcasting, &QAbstractButton::clicked, this, &Server::broadcastDatagram);

    QHBoxLayout *buttonLayout2 = new QHBoxLayout;
    buttonLayout2->addStretch(1);
    buttonLayout2->addWidget(broadcasting);
    buttonLayout2->addStretch(1);

    QVBoxLayout *mainLayout = new QVBoxLayout(this);

    mainLayout->addLayout(buttonLayout);
    mainLayout->addLayout(buttonLayout2);

    setWindowTitle(QGuiApplication::applicationDisplayName());
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
        QMessageBox::critical(this, tr("GCompris Server"),
                              tr("Unable to start the server: %1.")
                              .arg(tcpServer->errorString()));
        close();
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
    // temporary...
    newClient.setLogin(clientConnection->peerAddress().toString());
    qDebug("New tcp connection");
    emit newClientReceived(newClient);
}

void Server::broadcastDatagram()
{
    qDebug()<< "is anyone out there";
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
    qDebug() << "Reading " << data << " from " << clientConnection;
    switch(messageId._id) {
    case MessageIdentifier::LOGIN:
        {
            Login log;
            in >> log;
            emit loginReceived(log);
            break;
        }
    case MessageIdentifier::ACTIVITY_DATA:
        {
            ActivityData act;
            in >> act;
            emit activityDataReceived(act);
            break;
        }
    default:
        qDebug() << messageId._id << " received but not handled";
    };
}

void Server::disconnected()
{
    QTcpSocket* clientConnection = qobject_cast<QTcpSocket*>(sender());
    if(!clientConnection)
        return;
    qDebug() << "Removing " << clientConnection;
    list.removeAll(clientConnection);
    clientConnection->deleteLater();
    ClientData newClient;
    newClient.setSocket(clientConnection);
    emit clientDisconnected(newClient);
}

void Server::sendActivities()
{
    DisplayedActivities activities;
    activities.activitiesToDisplay << "align4" << "erase" << "geography";
    
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

void Server::sendAll()
{
    DisplayedActivities activities;
    activities.activitiesToDisplay << "align4" << "erase" << "geography";
    
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
