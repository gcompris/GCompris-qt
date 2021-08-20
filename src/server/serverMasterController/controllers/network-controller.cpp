/* GCompris - network-controller.cpp
 *
 * SPDX-FileCopyrightText: 2021 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
#include <QtNetwork>
#include <QtEndian>

#include <QNetworkInterface>

#include "master-controller.h"
#include "network-controller.h"
#include "gcompris.pb.h"

namespace controllers {

NetworkController::NetworkController(QObject *parent) :
    QObject(parent), tcpServer(Q_NULLPTR)
{
    udpSocket = new QUdpSocket(this);
    tcpServer = new QTcpServer(this);
    connect(tcpServer, &QTcpServer::newConnection, this, &NetworkController::newTcpConnection);

    if (!tcpServer->listen(QHostAddress::Any, 5678)) {
        qDebug() << tr("Unable to start the server: %1.").arg(tcpServer->errorString());
    }
}

void NetworkController::newTcpConnection()
{
    QTcpSocket *clientConnection = tcpServer->nextPendingConnection();

    connect(clientConnection, &QAbstractSocket::disconnected,
            this, &NetworkController::disconnected);

    connect(clientConnection, &QAbstractSocket::readyRead,
            this, &NetworkController::slotReadyRead);

    usersMap[clientConnection] = nullptr;
    qDebug() << "New tcp connection" << clientConnection->peerAddress().toString();
    emit newClientReceived(clientConnection);
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

void NetworkController::broadcastDatagram(const QString &broadcastIp, const QString &deviceId)
{
    network::ScanClients sendClients;
    sendClients.set_deviceid(deviceId.toStdString());
    std::string encodedContainer;

    qDebug() << "Sending broadcast to" << broadcastIp << "for deviceId:" << deviceId;
    qint32 encodedContainerSize = encodeMessage(network::Type::SCAN_CLIENTS, sendClients, encodedContainer);
    udpSocket->writeDatagram(reinterpret_cast<const char *>(&encodedContainerSize), sizeof(qint32), QHostAddress(broadcastIp), 5678);
    qint64 data = udpSocket->writeDatagram(encodedContainer.c_str(), encodedContainer.size(), QHostAddress(broadcastIp), 5678);
}

void NetworkController::slotReadyRead()
{
    QTcpSocket *clientConnection = qobject_cast<QTcpSocket *>(sender());
    QByteArray &data = buffers[clientConnection];
    data += clientConnection->readAll();

    while (data.size() > 0) {
        if (data.size() < sizeof(qint32)) {
            qDebug() << "not enough data to read";
            return;
        }
        QDataStream ds(data);
        qint32 messageSize;
        ds >> messageSize;
        qDebug() << "Message Received of size" << messageSize << data;
        if (data.size() < messageSize) {
            qDebug() << "Message is not fully sent. Buffer size:" << data.size() << ", message size:" << messageSize;
            return;
        }
        network::Container container;
        container.ParseFromArray(data.constData() + sizeof(qint32), messageSize);
        switch (container.type()) {
        case network::Type::CLIENT_ACCEPTED: {
            network::ClientAccepted client;
            container.data().UnpackTo(&client);
            //emit newClient();
            break;
        }
        case network::Type::LOGIN_REQUEST: {
            network::LoginRequest login;
            container.data().UnpackTo(&login);
            qDebug() << "Request from" << login.login().c_str() << "with password" << login.password().c_str();
            // Checks if user not already used and password correct
            bool isUserOk = m_masterController->checkPassword(QString::fromStdString(login.login()), QString::fromStdString(login.password()));
            UserData *user = m_masterController->getUserByName(QString::fromStdString(login.login()));
            if(!isUserOk) {
                // todo Ask again for user/password
                user->setConnectionStatus(ConnectionStatus::Value::BAD_PASSWORD_INPUTTED);
                qDebug() << "Bad password for" << login.login().c_str();
                replyLoginStatus(clientConnection, login.login(), network::LOGIN_KO);
            }
            else {
                usersMap[clientConnection] = user;
                if(user->getConnectionStatus() == ConnectionStatus::Value::CONNECTED) {
                    // todo user already connected
                    qDebug() << login.login().c_str() << "is already connected";
                    user->setConnectionStatus(ConnectionStatus::Value::ALREADY_CONNECTED);
                    replyLoginStatus(clientConnection, login.login(), network::LOGIN_KO);
                }
                else {
                    user->setConnectionStatus(ConnectionStatus::Value::CONNECTED);
                    qDebug() << login.login().c_str() << "is now connected";
                    replyLoginStatus(clientConnection, login.login(), network::LOGIN_OK);
                }
            }
            break;
        }
        case network::Type::ACTIVITY_RAW_DATA: {
            network::ActivityRawData rawData;
            container.data().UnpackTo(&rawData);
            qDebug() << rawData.activity().c_str() << rawData.timestamp();
            m_masterController->addActivityDataForUser(*usersMap[clientConnection], QString(rawData.activity().c_str()), rawData.timestamp(), QString(rawData.data().c_str()));
            break;
        }
            default:
                qWarning() << "Message:" << container.type() << "not handled";
        }
        data = data.mid(messageSize + sizeof(qint32)); // Message handled, remove it from the queue
    }
    qDebug() << "All messages processed";
}

void NetworkController::disconnected()
{
    QTcpSocket *clientConnection = qobject_cast<QTcpSocket *>(sender());
    if (!clientConnection)
        return;
    qDebug() << "Removing " << clientConnection;
    UserData *user = usersMap[clientConnection];
    if(user) {
        user->setConnectionStatus(ConnectionStatus::Value::DISCONNECTED);
    }
    usersMap.erase(clientConnection);
    emit clientDisconnected(clientConnection);
    clientConnection->deleteLater();
}

void NetworkController::sendLoginList(const QStringList &selectedUsers)
{
    network::LoginList loginList;
    for (const QString &name: selectedUsers) {
        std::string *login = loginList.add_login();
        *login = name.toStdString();
    }
    std::string encodedContainer;

    qint32 encodedContainerSize = encodeMessage(network::Type::LOGIN_LIST, loginList, encodedContainer);

    // todo we should only send to those not connected
    // Get all the clients
    // For each client, if it does not have a name yet, send the message
    for (auto &user: usersMap) {
        QTcpSocket *sock = user.first;
        qDebug() << "Sending " << encodedContainer.c_str() << " to " << sock;
        sock->write(reinterpret_cast<const char *>(&encodedContainerSize), sizeof(qint32));
        sock->write(encodedContainer.c_str(), encodedContainer.size());
    }
    // remove the sockets not the names
    //    QStringList usedLogins;
    //    for(const QObject* oClient: MessageHandler::getInstance()->returnClients()) {
    //        ClientData* c = (ClientData*)(oClient);
    //        if(c->getUserData()){
    //            usedLogins << c->getUserData()->getName();
    //        }
    //    }

    // AvailableLogins act;
    // for(const QObject *oC: MessageHandler::getInstance()->returnUsers()) {
    //         act._logins << ((const UserData*)oC)->getName();
    //         act._passwords << ((const UserData*)oC)->getPassword();
    // }
}

void NetworkController::replyLoginStatus(QTcpSocket *sock, const std::string &login, const network::LoginStatus &status)
{
    qDebug() << "Reply login status: ";
    network::LoginReply loginReply;
    std::string encodedContainer;
    loginReply.set_status(status);
    loginReply.set_login(login);

    qint32 encodedContainerSize = encodeMessage(network::Type::LOGIN_REPLY, loginReply, encodedContainer);

    qDebug() << "Sending " << encodedContainer.c_str() << " to " << sock;
    sock->write(reinterpret_cast<const char *>(&encodedContainerSize), sizeof(qint32));
    sock->write(encodedContainer.c_str(), encodedContainer.size());
}

void NetworkController::disconnectSession(const QStringList &selectedUsers)
{
    qDebug() << "Disconnecting: " << selectedUsers;
    network::Disconnect disconnectMessage;
    std::string encodedContainer;

    qint32 encodedContainerSize = encodeMessage(network::Type::DISCONNECT, disconnectMessage, encodedContainer);

    for (auto &user: usersMap) {
        if (selectedUsers.contains(user.second->getName())) {
                QTcpSocket *sock = user.first;
                qDebug() << "Sending " << encodedContainer.c_str() << " to " << sock;
                sock->write(reinterpret_cast<const char *>(&encodedContainerSize), sizeof(qint32));
                sock->write(encodedContainer.c_str(), encodedContainer.size());
        }
    }
}

QStringList NetworkController::getAllInterfaces() const
{
    QStringList possibleMatches;
    QList<QHostAddress> addresses = QNetworkInterface::allAddresses();

    if (!addresses.isEmpty()) {
        for (int i = 0; i < addresses.size(); i++) {
            // Ignore local host
            if (addresses[i] == QHostAddress::LocalHost)
                continue;

            // Ignore non-ipv4 addresses
            if (!addresses[i].toIPv4Address())
                continue;

            QString ip = addresses[i].toString();
            if (ip.isEmpty())
                continue;
            ip.replace(ip.lastIndexOf('.'), 5, ".255");

            bool foundMatch = false;
            for (int j = 0; j < possibleMatches.size(); j++) {
                if (ip == possibleMatches[j]) {
                    foundMatch = true;
                    break;
                }
            }
            if (!foundMatch) {
                possibleMatches.push_back(ip);
            }
        }
    }
    return possibleMatches;
}

void NetworkController::setMasterController(MasterController *masterController)
{
    m_masterController = masterController;
}

}
