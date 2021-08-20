/* GCompris - ClientNetworkMessages.cpp
 *
 * SPDX-FileCopyrightText: 2021 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
#include <QString>
#include <QTcpSocket>
#include <QUdpSocket>
#include "ApplicationSettings.h"
#include "ClientNetworkMessages.h"
#include "gcompris.pb.h"

ClientNetworkMessages::ClientNetworkMessages(): QObject(),
                                                tcpSocket(new QTcpSocket(this)),
                                                udpSocket(new QUdpSocket(this)),
                                                _connected(false)
{
    if(!udpSocket->bind(5678, QUdpSocket::ShareAddress))
         qDebug() <<"could not bind to UdpSocket";
     else
         qDebug() << "Connected to UdpSocket";

    connect(udpSocket, &QUdpSocket::readyRead, this, &ClientNetworkMessages::udpRead);
    connect(tcpSocket, &QTcpSocket::connected, this, &ClientNetworkMessages::connected);
    connect(tcpSocket, &QTcpSocket::disconnected, this, &ClientNetworkMessages::serverDisconnected);
    connect(tcpSocket, &QAbstractSocket::readyRead, this, &ClientNetworkMessages::readFromSocket);
}

ClientNetworkMessages::~ClientNetworkMessages()
{
}

void ClientNetworkMessages::connectToServer(const QString& serverName)
{
    QString ip = serverName;
    int port = 5678;

    //if we are already connected to some server, disconnect from it first and then make a connection with new server
    if(_connected) { // and newServer != currentServer
        disconnectFromServer();
    }
    qDebug()<< "connect to " << ip << ":" << port;
    if(tcpSocket->state() != QAbstractSocket::ConnectedState) {
        tcpSocket->connectToHost(ip, port);
    }

    //ApplicationSettings::getInstance()->setCurrentServer(serverName);
}

void ClientNetworkMessages::disconnectFromServer()
{
    tcpSocket->disconnectFromHost();
    //ApplicationSettings::getInstance()->setCurrentServer("");
}

void ClientNetworkMessages::connected()
{
    QTcpSocket* socket = qobject_cast<QTcpSocket*>(sender());
    _connected = true;
    emit connectionStatus();
    emit hostChanged();
}

void ClientNetworkMessages::serverDisconnected() {
    _host = "";
    _connected = false;
    emit connectionStatus();
    emit hostChanged();
}

void ClientNetworkMessages::udpRead() {
    QByteArray data;
    QHostAddress address;
    quint16 port;
    data.resize(udpSocket->pendingDatagramSize());
    udpSocket->readDatagram(data.data(), data.size(), &address, &port);

    udpBuffer += data;
    while(udpBuffer.size() > 0) {
        if(udpBuffer.size() < sizeof(qint32)) {
            qDebug() << "not enough data to read";
            return;
        }
        QDataStream ds(udpBuffer);
        qint32 messageSize;
        ds >> messageSize; // It is already bigEndian
        qDebug() << "Message Received of size" << messageSize << "from" << address << data.size();

        data.resize(udpSocket->pendingDatagramSize());
        udpSocket->readDatagram(data.data(), data.size(), &address, &port);
        udpBuffer += data;

        if(udpBuffer.size() < messageSize + sizeof(qint32)) {
            qDebug() << "Message is not fully received. Expected:" << messageSize << ", received:" << data.size();
            return;
        }
        network::Container container;
        container.ParseFromArray(data.constData(), messageSize);
        qDebug() << container.type();
        switch(container.type()) {
        case network::Type::SCAN_CLIENTS:
            network::ScanClients client;
            container.data().UnpackTo(&client);
            qDebug() << "Scan deviceId" << client.deviceid().c_str() << address.toString();
            QString requestDeviceId = client.deviceid().c_str();
            if(!_connected && (requestDeviceId.isEmpty() || ApplicationSettings::getInstance()->deviceId() == requestDeviceId)) {
                emit requestConnection(requestDeviceId, address.toString());
            }
            break;
        }
        udpBuffer = udpBuffer.mid(messageSize + sizeof(qint32)); // Message handled, remove it from the queue
    }
}

template <class T>
qint32 encodeMessage(const network::Type &messageType, T &message, std::string &encodedContainer)
{
    network::Container container;
    container.set_type(messageType);
    container.mutable_data()->PackFrom(message);
    encodedContainer = container.SerializeAsString();
    return qToBigEndian(qint32(encodedContainer.size()));
}

void ClientNetworkMessages::sendLoginMessage(const QString &newLogin, const QString& password)
{
    // store the username in config
    //ApplicationSettings::getInstance()->setUserName(newLogin);

    // Send Login message
    network::LoginRequest request;
    request.set_login(newLogin.toStdString());
    request.set_password(password.toStdString());
    std::string encodedContainer;

    qint32 encodedContainerSize = encodeMessage(network::Type::LOGIN_REQUEST, request, encodedContainer);
    tcpSocket->write(reinterpret_cast<const char *>(&encodedContainerSize), sizeof(qint32));
    tcpSocket->write(encodedContainer.c_str(), encodedContainer.size());
}

void ClientNetworkMessages::sendActivityData(const QString &activity,
                                             const QVariantMap &data)
{
    if(tcpSocket->state() != QAbstractSocket::ConnectedState)
        return;
    /*const QString &username = ApplicationSettings::getInstance()->userName();
    ActivityRawData activityData { activity, username, QDateTime::currentDateTime(), data };*/

    network::ActivityRawData activityData;
    activityData.set_activity(activity.toStdString());
    activityData.set_timestamp(QDateTime::currentMSecsSinceEpoch());

    QByteArray jsonData = QJsonDocument::fromVariant(data).toJson(QJsonDocument::Compact);
    qDebug() << "Activity:" << activity << "- date:" << QDateTime::currentSecsSinceEpoch() << "- data:" << jsonData;
    activityData.set_data(jsonData.toStdString());
    std::string encodedContainer;

    qint32 encodedContainerSize = encodeMessage(network::Type::ACTIVITY_RAW_DATA, activityData, encodedContainer);
    tcpSocket->write(reinterpret_cast<const char *>(&encodedContainerSize), sizeof(qint32));
    tcpSocket->write(encodedContainer.c_str(), encodedContainer.size());
}

void ClientNetworkMessages::readFromSocket()
{
    QTcpSocket *clientConnection = qobject_cast<QTcpSocket *>(sender());

    tcpBuffer += clientConnection->readAll();

    while (tcpBuffer.size() > 0) {
        if (tcpBuffer.size() < sizeof(qint32)) {
            qDebug() << "not enough data to read";
            return;
        }
        QDataStream ds(tcpBuffer);
        qint32 messageSize;
        ds >> messageSize; // already bigendian
        qDebug() << "Message Received of size" << messageSize << tcpBuffer;
        if (tcpBuffer.size() < messageSize + sizeof(qint32)) {
            qDebug() << "Message is not fully sent";
            return;
        }
        network::Container container;
        container.ParseFromArray(tcpBuffer.constData() + sizeof(qint32), messageSize);
        qDebug() << container.type();
        switch (container.type()) {
        case network::Type::LOGIN_LIST: {
            network::LoginList loginList;
            container.data().UnpackTo(&loginList);
            QStringList logins;
            for (const std::string &name: loginList.login()) {
                qDebug() << "available login:" << name.c_str();
                logins << name.c_str();
            }
            emit loginListReceived(logins);
            break;
        }
        case network::Type::DISCONNECT: {
            network::Disconnect disconnect;
            container.data().UnpackTo(&disconnect);
            // TODO do we want to display a message onscreen (you have been disconnected)?
            disconnectFromServer();
            break;
        }
        case network::Type::LOGIN_REPLY: {
            network::LoginReply loginReply;
            container.data().UnpackTo(&loginReply);
            bool logOk = (loginReply.status() == network::LOGIN_OK);
            // TODO store in conf (if we want to have it persistent for some reason, schoolwork at home(?), or locally if we want a temporary session) and prevent new login list to be displayed in main.qml
            emit loginConfirmationReceived(loginReply.login().c_str(), logOk);
            break;
        }
        default:
            qWarning() << "Received message not handled:" << container.type();
        }
        tcpBuffer = tcpBuffer.mid(messageSize + sizeof(qint32)); // Message handled, remove it from the queue
    }
    qDebug() << "All messages processed";
}
