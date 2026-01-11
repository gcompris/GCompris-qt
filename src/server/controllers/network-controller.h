/* GCompris - network-controller.h
 *
 * SPDX-FileCopyrightText: 2021 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
#ifndef NETWORKCONTROLLER_H
#define NETWORKCONTROLLER_H

class QTcpServer;
class QTcpSocket;
class QUdpSocket;

#include <QTimer>
#include <QDateTime>
#include <QJsonObject>
#include "netconst.h"

namespace controllers {

    class UserData : public QObject
    {
        Q_OBJECT

    public:
        explicit UserData(QTcpSocket *aSocket);

        void setUserId(int id) { userId = id; }
        int getUserId() { return userId; }
        void setUserName(const QString &name) { userName = name; }
        const QString &getUserName() { return userName; }
        QTcpSocket *getSocket() { return socket; }
        void recordTimeStamp() { lastTimeStamp = QDateTime::currentMSecsSinceEpoch(); }
        qint64 delaySinceTimeStamp() { return QDateTime::currentMSecsSinceEpoch() - lastTimeStamp; }

    Q_SIGNALS:
        void timeout();

    private Q_SLOTS:
        void sendTimeout();

    private:
        int userId;
        QString userName;
        QTcpSocket *socket;
        qint64 lastTimeStamp;
    };

    inline UserData::UserData(QTcpSocket *aSocket) :
        QObject(), userId(-1), userName("")
    {
        socket = aSocket;
        recordTimeStamp();
    }

    inline void UserData::sendTimeout() { Q_EMIT timeout(); }

    /**
     * @class NetworkController
     * @short Receive and send messages to the gcompris client instances
     *
     * Contains the tcp socket that sends and receives the different messages to
     * the clients.
     * Sends the following messages:
     * * LoginList: list of all the logins the client can choose
     * * DisplayedActivities: activities to display on the target client
     * * ActivityConfiguration: for one activity, send a specific configuration (dataset)
     *
     * Receives the following ones:
     * * Login: allows to identify a client with a name
     * * ActivityData: contains the data for one result activity send by a client
     *
     * @sa MessageHandler
     */
    class NetworkController : public QObject
    {
        Q_OBJECT

    public:
        explicit NetworkController(QObject *parent = nullptr);

        Q_PROPERTY(int socketCount READ socketCount NOTIFY socketCountChanged)
        Q_PROPERTY(int loggedCount READ loggedCount NOTIFY loggedCountChanged)
        Q_PROPERTY(int dataCount READ dataCount NOTIFY dataCountChanged)

        Q_INVOKABLE void broadcastDatagram(const QStringList &broadcastIpList, const QString &deviceId);
        Q_INVOKABLE void sendLoginList(const QStringList &selectedUsers);
        Q_INVOKABLE void disconnectSession(const int userId);
        Q_INVOKABLE void acceptPassword(const int userId, const QString &userName);

        Q_INVOKABLE void sendDatasetToUsers(const QJsonValue &dataset_content, const QList<int> &selectedUsersId);
        Q_INVOKABLE void removeDatasetToUsers(const QJsonValue &dataset_content, const QList<int> &selectedUsersId);
        Q_INVOKABLE void removeAllDatasetsToUsers(const QList<int> &selectedUsersId);

        Q_INVOKABLE void disconnectPendingSockets();

        Q_INVOKABLE QJsonObject getHostInformations();
        Q_INVOKABLE QStringList getAllInterfaces() const;
        Q_INVOKABLE bool isRunning();

        int socketCount() { return socketCount_; }
        int loggedCount() { return loggedCount_; }
        int dataCount() { return dataCount_; }

    Q_SIGNALS:
        void socketCountChanged();
        void loggedCountChanged();
        void dataCountChanged();
        void netLog(QString message);
        void checkUserPassword(QString login, QString password);
        void addDataToUser(int userId, QString activityName, QString rawData);
        void statusChanged(int userId, int newStatus);

    private Q_SLOTS:
        void newTcpConnection();
        void slotReadyRead();
        void clientDisconnected();
        void checkTimeout();

    private:
        void sendJson(QTcpSocket *tcpSocket, QJsonObject &obj);
        void sendNetLog(const QString &);
        void pong(QTcpSocket *);

        QTcpServer *tcpServer;
        QHash<QTcpSocket *, UserData *> usersMap;
        QHash<QTcpSocket *, QByteArray> socketBuffers;
        QUdpSocket *udpSocket;

        int socketCount_;
        int loggedCount_;
        qint64 dataCount_;
        QTimer pongTimer;
        bool running_;
    };
}

#endif
