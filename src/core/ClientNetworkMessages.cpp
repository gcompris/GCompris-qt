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
#include "ActivityInfoTree.h"
#include "ClientNetworkMessages.h"

ClientNetworkMessages::ClientNetworkMessages() :
    QObject(),
    _connected(false),
    _missedPongs(0),
    tcpSocket(new QTcpSocket(this)),
    udpSocket(new QUdpSocket(this)),
    status(netconst::NOT_CONNECTED),
    pingTimer(this)
{
    userId = -1;
    pingTimer.setInterval(netconst::PING_DELAY);

    ApplicationSettings *applicationSettings = ApplicationSettings::getInstance();
    quint32 port = applicationSettings->teacherPort().toUInt();
    if (!udpSocket->bind(port, QUdpSocket::ShareAddress))
        qDebug() << "could not bind to UdpSocket on port" << port;
    else
        qDebug() << "Connected to UdpSocket on port" << port;

    tcpSocket->setSocketOption(QAbstractSocket::LowDelayOption, 1);
    tcpSocket->setSocketOption(QAbstractSocket::KeepAliveOption, 1);

    connect(udpSocket, &QUdpSocket::readyRead, this, &ClientNetworkMessages::udpRead);
    connect(tcpSocket, &QTcpSocket::connected, this, &ClientNetworkMessages::connected);
    connect(tcpSocket, &QTcpSocket::disconnected, this, &ClientNetworkMessages::serverDisconnected);
    connect(tcpSocket, &QAbstractSocket::errorOccurred, this, &ClientNetworkMessages::onErrorOccurred);
    connect(tcpSocket, &QAbstractSocket::readyRead, this, &ClientNetworkMessages::readFromSocket);

    connect(&pingTimer, &QTimer::timeout, this, &ClientNetworkMessages::ping);
    connect(applicationSettings, &ApplicationSettings::teacherPortChanged, this, &ClientNetworkMessages::teacherPortChanged);
}

void ClientNetworkMessages::teacherPortChanged()
{
    disconnectFromServer();
    forgetUser();
    ApplicationSettings *applicationSettings = ApplicationSettings::getInstance();
    quint32 port = applicationSettings->teacherPort().toUInt();
    udpSocket->close();
    if (!udpSocket->bind(port, QUdpSocket::ShareAddress))
        qDebug() << "could not bind to UdpSocket on port" << port;
    else
        qDebug() << "Connected to UdpSocket on port" << port;
}

void ClientNetworkMessages::connectToServer(const QString &serverName)
{
    ipServer = serverName;
    ApplicationSettings *applicationSettings = ApplicationSettings::getInstance();
    quint32 port = applicationSettings->teacherPort().toUInt();

    // if we are already connected to some server, disconnect from it first and then make a connection with new server
    if (_connected) { // and newServer != currentServer
        disconnectFromServer();
    }
    //    qWarning()<< "Try to connect to " << ipServer << ":" << port;
    if (tcpSocket->state() != QAbstractSocket::ConnectedState) {
        tcpSocket->connectToHost(ipServer, port);
        status = netconst::NOT_LOGGED;
        Q_EMIT statusChanged();
        pingTimer.start();
    }

    // ApplicationSettings::getInstance()->setCurrentServer(serverName);
}

void ClientNetworkMessages::forgetUser()
{
    status = netconst::NOT_CONNECTED;
    Q_EMIT statusChanged();
    setLogin("");
    password = "";
    // ApplicationSettings::getInstance()->setCurrentServer("");
}

void ClientNetworkMessages::disconnectFromServer()
{
    qDebug() << "disconnectFromServer";
    tcpSocket->disconnectFromHost();
    _connected = false;
    pingTimer.stop();
}

void ClientNetworkMessages::connected()
{
    _connected = true;
    if (m_login != "") {
        sendLoginMessage(m_login, password);
    }
    pingTimer.setInterval(netconst::PING_DELAY);
    Q_EMIT hostChanged();
}

void ClientNetworkMessages::serverDisconnected()
{
    qDebug() << "serverDisconnected";
    _host = "";
    _connected = false;
    //    Q_EMIT connectionStatus();
    Q_EMIT hostChanged();
}

void ClientNetworkMessages::onErrorOccurred(QAbstractSocket::SocketError socketError)
{
    qDebug() << "Error occurred:" << socketError << tcpSocket->errorString();
    disconnectFromServer();
    forgetUser();
}

void ClientNetworkMessages::udpRead()
{
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
        if (ApplicationSettings::getInstance()->teacherId() == requestDeviceId) {
            Q_EMIT requestConnection(requestDeviceId, address.toString()); // Run connectToServer if answer is yes
        }
    }
}

void ClientNetworkMessages::sendLoginMessage(const QString &newLogin, const QString &newPassword)
{
    setLogin(newLogin);
    password = newPassword;
    QJsonObject obj { { "aType", netconst::LOGIN_REPLY } };
    QJsonObject content { { "login", newLogin }, { "password", newPassword } };
    obj.insert("content", content);
    sendMessage(prepareMessage(obj));
    // store the username in config
    //    ApplicationSettings::getInstance()->setUserName(newLogin);      // Should be done after LOGIN_ACCEPT
}

void ClientNetworkMessages::sendMessage(const QByteArray &message)
{
    // prepare the block
    QByteArray block;
    QDataStream out(&block, QIODevice::WriteOnly);
    out.setVersion(QDataStream::Qt_6_5);
    // write message size to at the beginning of the block
    out << (quint32)message.size();
    block.append(message);
    tcpSocket->write(block);
}

void ClientNetworkMessages::sendNextMessage()
{ // Send next message in queue
    if (tcpSocket->state() != QAbstractSocket::ConnectedState)
        return;
    sendMessage(messageQueue.takeFirst());
    _missedPongs = 0;
}

QByteArray ClientNetworkMessages::prepareMessage(QJsonObject &obj)
{
    QJsonDocument jsonDoc;
    jsonDoc.setObject(obj);
    QByteArray message = jsonDoc.toJson(QJsonDocument::Compact);
    return message;
}

void ClientNetworkMessages::ping()
{
    if (status == netconst::CONNECTION_LOST) {
        _missedPongs = 0;
        if (m_login != "") {
            qDebug() << "Attempting to reconnect...";
            connectToServer(ipServer); // Try to reconnect
        }
        else {
            disconnectFromServer();
        }
        return;
    }
    if (_missedPongs >= 5) {
        status = netconst::CONNECTION_LOST;
        Q_EMIT statusChanged();
        _missedPongs = 0;
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
    }
    else {
        QJsonObject obj { { "aType", netconst::PING } };
        sendMessage(prepareMessage(obj));
        _missedPongs++;
        // qWarning() << "Ping";
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

int ClientNetworkMessages::connectionStatus()
{
    return static_cast<netconst::ConnectionStatus>(status);
}

void ClientNetworkMessages::readFromSocket()
{
    QTcpSocket *clientConnection = qobject_cast<QTcpSocket *>(sender());
    tcpBuffer.append(clientConnection->readAll());
    // loop as long as the data is longer than 4 octets
    while (tcpBuffer.size() >= (int)sizeof(quint32)) {
        QDataStream in(tcpBuffer);
        in.setVersion(QDataStream::Qt_6_5);

        quint32 blockSize;
        in >> blockSize;

        // warning if message length read more than 10 MiB
        if (blockSize > 10 * 1024 * 1024) {
            qWarning() << "Message too big! Disconnecting for security.";
            disconnectFromServer();
            return;
        }
        // if message is not terminated wait for next read signal
        if ((quint32)tcpBuffer.size() < (sizeof(quint32) + blockSize)) {
            break;
        }
        else {
            // message is correct, read json
            QByteArray jsonData = tcpBuffer.mid(sizeof(quint32), blockSize);
            // remove message length then extract buffer
            tcpBuffer.remove(0, sizeof(quint32) + blockSize);
            // Parsing JSON
            QJsonParseError parseError;
            QJsonDocument jsonDoc = QJsonDocument::fromJson(jsonData, &parseError);
            if (parseError.error != QJsonParseError::NoError) {
                qWarning() << "JSON parse error:" << parseError.errorString();
                continue;
            }

            QJsonObject obj = jsonDoc.object();
            if (obj.contains("aType")) {
                switch (obj["aType"].toInt()) {
                case netconst::LOGIN_LIST:
                     if (const QJsonValue v = obj["content"]; v.isArray()) {
                        const QJsonArray content = v.toArray();
                        QStringList logins;
                        for (int i = 0; i < content.size(); i++) {
                            logins << content[i].toString();
                        }
                        Q_EMIT loginListReceived(logins);
                    }
                    break;
                case netconst::LOGIN_ACCEPT:
                    if (const QJsonValue v = obj["content"]; v.isObject()) {
                        const QJsonObject content = v.toObject();
                        bool accepted = content["accepted"].toBool();
                        userId = content["user_id"].toInt();
                        qDebug() << "Login accepted:" << accepted << ", user ID:" << userId;
                        if (!accepted) {
                            setLogin("");
                            password = "";
                            Q_EMIT passwordRejected();
                            status = netconst::BAD_PASSWORD_INPUT;
                        }
                        else {
                            status = netconst::CONNECTED;
                        }
                        Q_EMIT statusChanged();
                    }
                    break;
                case netconst::DISCONNECT:
                    disconnectFromServer();
                    forgetUser();
                    break;
                case netconst::DATASET_CREATION:
                    ActivityInfoTree::getInstance()->createDataset(obj["content"].toObject());
                    break;
                case netconst::DATASET_REMOVE:
                    ActivityInfoTree::getInstance()->removeDataset(obj["content"].toObject());
                    break;
                case netconst::DATASET_REMOVE_ALL:
                    ActivityInfoTree::getInstance()->removeAllLocalDatasets();
                    break;
                case netconst::PONG:
                    _missedPongs = 0;
                    break;
                default:
                    qDebug() << "Received unknown message" << obj["aType"].toInt();
                }
            }
        }
    }
}
