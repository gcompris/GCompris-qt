/* GCompris - network-controller.cpp
 *
 * SPDX-FileCopyrightText: 2021 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
#include <limits>
#include <QtEndian>

#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QTcpServer>
#include <QTcpSocket>
#include <QUdpSocket>
#include <QNetworkInterface>
#include <QHostInfo>

#include "network-controller.h"

namespace controllers {

    NetworkController::NetworkController(QObject *parent) :
        QObject(parent), tcpServer(nullptr)
    {
        udpSocket = new QUdpSocket(this);
        tcpServer = new QTcpServer(this);
        socketCount_ = 0;
        loggedCount_ = 0;
        running_ = false;
        connect(tcpServer, &QTcpServer::newConnection, this, &NetworkController::newTcpConnection);
        pongTimer.setInterval(netconst::WAIT_DELAY);
        connect(&pongTimer, &QTimer::timeout, this, &NetworkController::checkTimeout);
        pongTimer.start();

        if (!tcpServer->listen(QHostAddress::Any, 5678)) {
            qWarning() << tr("Unable to start the server: %1.").arg(tcpServer->errorString());
        }
        else {
            running_ = true;
        }
    }

    bool NetworkController::isRunning()
    {
        return running_;
    }
    void NetworkController::newTcpConnection()
    {
        QTcpSocket *clientConnection = tcpServer->nextPendingConnection();

        connect(clientConnection, &QAbstractSocket::disconnected, this, &NetworkController::clientDisconnected);
        connect(clientConnection, &QAbstractSocket::readyRead, this, &NetworkController::slotReadyRead);

        usersMap.insert(clientConnection, new UserData(clientConnection));
        socketCount_++;
        Q_EMIT socketCountChanged();
    }

    void NetworkController::sendNetLog(const QString &message)
    {
        Q_EMIT netLog(message);
    }

    void NetworkController::checkTimeout()
    {
        QList<QTcpSocket *> sockets = usersMap.keys();
        for (int i = 0; i < sockets.size(); i++) { // Loop on sockets to check for connection lost
            if (usersMap.value(sockets.at(i))->delaySinceTimeStamp() > netconst::WAIT_DELAY) { // Time out, remove socket
                sendNetLog(QString("Connection lost with: %1").arg(usersMap.value(sockets.at(i))->getUserName()));
                Q_EMIT statusChanged(usersMap.value(sockets.at(i))->getUserId(), netconst::CONNECTION_LOST);
                loggedCount_--;
                Q_EMIT loggedCountChanged();
                usersMap.remove(sockets.at(i));
                sockets.at(i)->deleteLater();
                socketCount_--;
                Q_EMIT socketCountChanged();
            }
        }
    }

    void NetworkController::broadcastDatagram(const QStringList &broadcastIpList, const QString &deviceId)
    {
        QJsonDocument jsonDoc;
        QJsonObject obj { { "deviceId", deviceId } };
        jsonDoc.setObject(obj);
        QByteArray message = jsonDoc.toJson(QJsonDocument::Compact);
        qint64 messageSize = message.count();

        sendNetLog(QString("Sending broadcast to %1\n with deviceId: %2").arg(broadcastIpList.join(", ")).arg(deviceId));
        for (const QString &ip: broadcastIpList) {
            qWarning() << "Broadcasting on:" << ip;
            udpSocket->writeDatagram(reinterpret_cast<const char *>(&messageSize), sizeof(qint64), QHostAddress(ip), 5678);
            qint64 data = udpSocket->writeDatagram(message.constData(), messageSize, QHostAddress(ip), 5678);
            // check count here ?
        }
    }

    void NetworkController::sendJson(QTcpSocket *tcpSocket, QJsonObject &obj)
    {
        QJsonDocument jsonDoc;
        jsonDoc.setObject(obj);
        QByteArray message = jsonDoc.toJson(QJsonDocument::Compact);
        qint64 messageSize = message.count();
        //    qWarning() << message;
        tcpSocket->write(message.constData(), messageSize);
    }

    void NetworkController::slotReadyRead()
    {
        QTcpSocket *clientConnection = qobject_cast<QTcpSocket *>(sender());
        QByteArray message = clientConnection->readAll();
        //    qWarning() << message;
        QJsonDocument jsonDoc = QJsonDocument::fromJson(message);
        QJsonObject obj = jsonDoc.object();
        if (obj.contains("aType")) {
            switch (obj["aType"].toInt()) {
            case netconst::LOGIN_LIST:
                if (obj["content"].isArray()) {
                    QStringList logins;
                    const auto &jsonArray = obj["content"].toArray();
                    for (int i = 0; i < jsonArray.count(); i++) {
                        logins << jsonArray[i].toString();
                    }
                }
                break;
            case netconst::LOGIN_REPLY:
                if (obj["content"].isObject()) {
                    const auto &jsonObject = obj["content"].toObject();
                    QString login = jsonObject["login"].toString();
                    QString password = jsonObject["password"].toString();
                    Q_EMIT checkUserPassword(login, password);
                }
                break;
            case netconst::ACTIVITY_DATA:
                if (obj["activity"].isString() && obj["content"].isObject()) {
                    QString activityName = obj["activity"].toString();
                    QJsonDocument jsonDocData;
                    jsonDocData.setObject(obj["content"].toObject());
                    QString activityData = jsonDocData.toJson(QJsonDocument::Compact);
                    Q_EMIT addDataToUser(usersMap.value(clientConnection)->getUserId(), activityName, activityData);
                    dataCount_++;
                    Q_EMIT dataCountChanged();
                }
                break;
            case netconst::PING:
                pong(clientConnection);
                break;
            }
            usersMap.value(clientConnection)->recordTimeStamp();
        }
    }

    void NetworkController::pong(QTcpSocket *tcpSocket)
    {
        QJsonObject obj { { "aType", netconst::PONG } };
        sendJson(tcpSocket, obj);
        //    qWarning() << "Pong";
    }

    void NetworkController::clientDisconnected()
    {
        QTcpSocket *clientConnection = qobject_cast<QTcpSocket *>(sender());
        if (!clientConnection)
            return;
        qWarning() << "Removing" << clientConnection;
        UserData *user = usersMap.value(clientConnection);
        if (user) {
            sendNetLog(QString("Client disconnected: %1").arg(user->getUserName()));
            bool reconnected = false;
            QList<QTcpSocket *> sockets = usersMap.keys();
            for (int i = 0; i < sockets.size(); i++) {
                UserData *loopUser = usersMap.value(sockets.at(i));
                if ((user != loopUser) && (user->getUserId() == loopUser->getUserId())) {
                    reconnected = true;
                }
            }
            if (!reconnected) {
                Q_EMIT statusChanged(user->getUserId(), netconst::DISCONNECTED);
            }
            if (user->getUserId() != -1) {
                loggedCount_--;
                Q_EMIT loggedCountChanged();
            }
        }
        usersMap.remove(clientConnection);
        clientConnection->deleteLater();
        socketCount_--;
        Q_EMIT socketCountChanged();
    }

    void NetworkController::disconnectSession(const int userId)
    {
        QJsonObject obj { { "aType", netconst::DISCONNECT } };
        QList<QTcpSocket *> sockets = usersMap.keys();
        for (int i = 0; i < sockets.size(); i++) {
            UserData *loopUser = usersMap.value(sockets.at(i));
            if (loopUser->getUserId() == userId) {
                sendJson(sockets.at(i), obj);
                sendNetLog(QString("Disconnect sent to user %1").arg(loopUser->getUserName()));
            }
        }
        Q_EMIT socketCountChanged();
    }

    void NetworkController::disconnectPendingSockets()
    { // Opened sockets, but not logged
        QJsonObject obj { { "aType", netconst::DISCONNECT } };
        QList<QTcpSocket *> sockets = usersMap.keys();
        for (int i = 0; i < sockets.size(); i++) {
            sendJson(sockets.at(i), obj);
        }
        Q_EMIT socketCountChanged();
    }

    void NetworkController::sendLoginList(const QStringList &selectedUsers)
    {
        QJsonObject obj { { "aType", netconst::LOGIN_LIST } };
        obj.insert("content", QJsonArray::fromStringList(selectedUsers));
        int count = 0;

        QList<QTcpSocket *> sockets = usersMap.keys();
        for (int i = 0; i < sockets.size(); i++) {
            if (usersMap.value(sockets.at(i))->getUserId() == -1) { // Send to non connected users
                sendJson(sockets.at(i), obj);
                count++;
            }
        }
        sendNetLog(QString("Login list sended to %1 users").arg(count));
    }

    void NetworkController::acceptPassword(const int userId, const QString &userName)
    {

        QTcpSocket *clientConnection = qobject_cast<QTcpSocket *>(sender());
        QJsonObject obj { { "aType", netconst::LOGIN_ACCEPT } };
        QJsonObject content { { "accepted", (userId != -1) }, { "user_id", userId } };
        obj.insert("content", content);
        sendJson(clientConnection, obj);
        if (userId == -1) {
            sendNetLog(QString("Login rejected for: %1").arg(userName));
            return;
        }
        loggedCount_++;
        usersMap.value(clientConnection)->setUserId(userId);
        usersMap.value(clientConnection)->setUserName(userName);
        sendNetLog(QString("Login accepted for: %1").arg(userName));
        Q_EMIT loggedCountChanged();
        Q_EMIT statusChanged(userId, netconst::CONNECTED);
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

    // Modified from: https://stackoverflow.com/questions/13835989/get-local-ip-address-in-qt
    QJsonObject NetworkController::getHostInformations()
    {
        QString localhostname = QHostInfo::localHostName();
        QStringList localhostIPs;
        QStringList broadcastIPs;
        QStringList localMacAddresses;
        QStringList localNetmasks;
        QList<QHostAddress> hostList = QHostInfo::fromName(localhostname).addresses();
        for (int i = 0; i < hostList.count(); i++) {
            const QHostAddress &address = hostList[i];
            if (address.protocol() == QAbstractSocket::IPv4Protocol && address.isLoopback() == false) {
                localhostIPs << address.toString();
            }
        }
        QList<QNetworkInterface> all = QNetworkInterface::allInterfaces();
        for (int i = 0; i < all.count(); i++) {
            const QNetworkInterface &networkInterface = all[i];
            QList<QNetworkAddressEntry> allEntries = networkInterface.addressEntries();
            for (int j = 0; j < allEntries.count(); j++) {
                const QNetworkAddressEntry &entry = allEntries[j];
                if (localhostIPs.contains(entry.ip().toString())) {
                    localMacAddresses << networkInterface.hardwareAddress();
                    localNetmasks << entry.netmask().toString();
                    broadcastIPs << entry.broadcast().toString();
                    break;
                }
            }
        }

        broadcastIPs << "255.255.255.255";

        return QJsonObject {
            { "hostName", localhostname },
            { "ip", QJsonArray::fromStringList(localhostIPs) },
            { "broadcastIp", QJsonArray::fromStringList(broadcastIPs) },
            { "mac", QJsonArray::fromStringList(localMacAddresses) },
            { "netmask", QJsonArray::fromStringList(localNetmasks) }
        };
    }

}
