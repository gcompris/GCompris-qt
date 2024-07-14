/* GCompris - ClientNetworkMessages.cpp
 *
 * SPDX-FileCopyrightText: 2021 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
#include <QString>
#include <QTcpSocket>
#include <QUdpSocket>
#include "ApplicationSettings.h"
#include "ClientNetworkMessages.h"

ClientNetworkMessages::ClientNetworkMessages():
    QObject(),
    tcpSocket(new QTcpSocket(this)),
    udpSocket(new QUdpSocket(this)),
    _connected(false),
    _wait4pong(false),
    status(netconst::NOT_CONNECTED),
    pingTimer(this)
{
    userId = -1;
    pingTimer.setInterval(netconst::PING_DELAY);

    if(!udpSocket->bind(5678, QUdpSocket::ShareAddress))
         qDebug() <<"could not bind to UdpSocket";
     else
         qDebug() << "Connected to UdpSocket";

    tcpSocket->setSocketOption(QAbstractSocket::LowDelayOption, 1);
    tcpSocket->setSocketOption(QAbstractSocket::KeepAliveOption, 1);

    connect(udpSocket, &QUdpSocket::readyRead, this, &ClientNetworkMessages::udpRead);
    connect(tcpSocket, &QTcpSocket::connected, this, &ClientNetworkMessages::connected);
    connect(tcpSocket, &QTcpSocket::disconnected, this, &ClientNetworkMessages::serverDisconnected);
    connect(tcpSocket, &QAbstractSocket::readyRead, this, &ClientNetworkMessages::readFromSocket);

    connect(&pingTimer, SIGNAL(timeout()), this, SLOT(ping()));
}

ClientNetworkMessages::~ClientNetworkMessages()
{
}

void ClientNetworkMessages::connectToServer(const QString& serverName)
{
    ipServer = serverName;
    int port = 5678;

    //if we are already connected to some server, disconnect from it first and then make a connection with new server
    if (_connected) { // and newServer != currentServer
        disconnectFromServer();
    }
//    qWarning()<< "Try to connect to " << ipServer << ":" << port;
    if(tcpSocket->state() != QAbstractSocket::ConnectedState) {
        tcpSocket->connectToHost(ipServer, port);
        status = netconst::NOT_LOGGED;
        Q_EMIT statusChanged();
        pingTimer.start();
    }

    //ApplicationSettings::getInstance()->setCurrentServer(serverName);
}

void ClientNetworkMessages::forgetUser()
{
    status = netconst::NOT_CONNECTED;
    Q_EMIT statusChanged();
    login = "";
    password = "";
    //ApplicationSettings::getInstance()->setCurrentServer("");
}

void ClientNetworkMessages::disconnectFromServer()
{
    tcpSocket->disconnectFromHost();
    _connected = false;
    pingTimer.stop();
}

void ClientNetworkMessages::connected()
{
    QTcpSocket* socket = qobject_cast<QTcpSocket*>(sender());
    _connected = true;
    if (login != "") {
        sendLoginMessage(login, password);
    }
    pingTimer.setInterval(netconst::PING_DELAY);
    Q_EMIT hostChanged();
}

void ClientNetworkMessages::serverDisconnected() {
    _host = "";
    _connected = false;
//    Q_EMIT connectionStatus();
    Q_EMIT hostChanged();
}

void ClientNetworkMessages::udpRead() {
    QByteArray data;
    QHostAddress address;
    quint16 port;
    data.resize(udpSocket->pendingDatagramSize());
    udpSocket->readDatagram(data.data(), data.size(), &address, &port);
    qWarning() << "Udp received:" << data.data();

    QJsonDocument jsonDoc = QJsonDocument::fromJson(data.data());
    QJsonObject obj = jsonDoc.object();
    if (obj.contains("deviceId")) {
        QString requestDeviceId = obj.value("deviceId").toString();
        if (ApplicationSettings::getInstance()->deviceId() == requestDeviceId) {
            Q_EMIT requestConnection(requestDeviceId, address.toString());      // Run connectToServer if answer is yes
        }
    }
}

void ClientNetworkMessages::sendLoginMessage(const QString &newLogin, const QString& newPassword)
{
    login = newLogin;
    password = newPassword;
    QJsonObject obj { { "aType", netconst::LOGIN_REPLY } };
    QJsonObject content { {"login", newLogin},{"password", newPassword} };
    obj.insert("content", content);
    sendMessage(prepareMessage(obj));
    // store the username in config
//    ApplicationSettings::getInstance()->setUserName(newLogin);      // Should be done after LOGIN_ACCEPT
}

void ClientNetworkMessages::sendMessage(QByteArray message) {
    qint64 messageSize = message.size();
    tcpSocket->write(message.constData(), messageSize);
//    qWarning() << message;
}

void ClientNetworkMessages::sendNextMessage() {     // Send next message in queue
    if(tcpSocket->state() != QAbstractSocket::ConnectedState)
        return;
    sendMessage(messageQueue.takeFirst());
    _wait4pong = false;
}

QByteArray ClientNetworkMessages::prepareMessage(QJsonObject &obj) {
    QJsonDocument  jsonDoc;
    jsonDoc.setObject(obj);
    QByteArray message = jsonDoc.toJson(QJsonDocument::Compact);
    return message;
}

void ClientNetworkMessages::ping()
{
    if (status == netconst::CONNECTION_LOST) {
        _wait4pong = false;
        if (login != "")
            connectToServer(ipServer);      // Try to reconnect
        else {
            disconnectFromServer();
        }
        return;
    }
    if (_wait4pong) {
        status = netconst::CONNECTION_LOST;
        Q_EMIT statusChanged();
        _wait4pong = false;
        pingTimer.setInterval(netconst::WAIT_DELAY);
//        qWarning() << "Connection lost, client side";
        return;
    }
    if ((!messageQueue.isEmpty()) && (status == netconst::CONNECTED)) {
        sendNextMessage();
        if (messageQueue.isEmpty())
            pingTimer.setInterval(netconst::PING_DELAY);
        else
            pingTimer.setInterval(netconst::PURGE_DELAY);
    } else {
        QJsonObject obj { { "aType", netconst::PING } };
        sendMessage(prepareMessage(obj));
        _wait4pong = true;
//        qWarning() << "Ping";
    }
}

void ClientNetworkMessages::sendActivityData(const QString &activity,
                                             const QJsonObject &data)
{
    QJsonObject obj { { "aType", netconst::ACTIVITY_DATA } };
    obj.insert("activity", activity);
    obj.insert("content", data);
    messageQueue.append(prepareMessage(obj));
}

int ClientNetworkMessages::connectionStatus() {
    return static_cast<netconst::ConnectionStatus>(status);
}

void ClientNetworkMessages::readFromSocket()
{
    QTcpSocket *clientConnection = qobject_cast<QTcpSocket *>(sender());
    QByteArray message = clientConnection->readAll();
    qWarning() << message;
    QJsonDocument jsonDoc = QJsonDocument::fromJson(message);
    QJsonObject obj = jsonDoc.object();
    if (obj.contains("aType")) {
        switch (obj["aType"].toInt()) {
        case netconst::LOGIN_LIST:
            if (obj["content"].isArray()) {
                QStringList logins;
                for (int i = 0; i < obj["content"].toArray().size(); i++) {
                    logins << obj["content"].toArray()[i].toString();
                }
                Q_EMIT loginListReceived(logins);
            }
            break;
        case netconst::LOGIN_ACCEPT:
            if (obj["content"].isObject()) {
                bool accepted = obj["content"].toObject()["accepted"].toBool();
                userId = obj["content"].toObject()["user_id"].toInt();
                qWarning() << "Login accepted:" << accepted << ", user ID:" << userId;
                if (!accepted) {
                    login = "";
                    password = "";
                    Q_EMIT passwordRejected();
                    status = netconst::BAD_PASSWORD_INPUT;
                } else {
                    status = netconst::CONNECTED;
                }
                Q_EMIT statusChanged();
            }
            break;
        case netconst::DISCONNECT:
            disconnectFromServer();
            forgetUser();
            break;
        case netconst::PONG:
            _wait4pong = false;
            break;
        }
    }
}
