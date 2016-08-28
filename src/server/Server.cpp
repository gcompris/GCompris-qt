/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include <QtWidgets>
#include <QtNetwork>

#include "Messages.h"
#include "DataStreamConverter.h"
#include "Server.h"

//
MyModel::MyModel(QObject *parent)
    :QAbstractTableModel(parent)
{
}

int MyModel::rowCount(const QModelIndex & /*parent*/) const
{
    return list->size();
}

int MyModel::columnCount(const QModelIndex & /*parent*/) const
{
    return 2;
}

bool MyModel::insertRows(int position, int rows, const QModelIndex &index)
{
    Q_UNUSED(index);
    beginInsertRows(QModelIndex(), position, position+rows-1);

    for (int row=0; row < rows; row++) {
        QPair<QString, QString> pair((*list)[0]->peerAddress().toString(), " ");
        //list.insert(position, pair);
    }

    endInsertRows();
    return true;
}

QVariant MyModel::data(const QModelIndex &index, int role) const
{
    if (role == Qt::DisplayRole)
    {
        switch(index.column()) {
        case 0:
            return QString("%1")
                .arg((*list)[index.row()]->peerAddress().toString());
        break;
        case 1:
            return QString("toto");
        }
    }
    return QVariant();
}
//

Server::Server(QWidget *parent)
    : QDialog(parent)
    , statusLabel(new QLabel)
    , tcpServer(Q_NULLPTR)
    , networkSession(0)
    , tableView(new QTableView)
    , model(parent)      
{
    statusLabel->setTextInteractionFlags(Qt::TextBrowserInteraction);

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

        statusLabel->setText(tr("Opening network session."));
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

    model.list = &list;
    tableView->setModel(&model);
    mainLayout->addWidget(tableView);
    mainLayout->addWidget(statusLabel);
    mainLayout->addLayout(buttonLayout);
    mainLayout->addLayout(buttonLayout2);

    setWindowTitle(QGuiApplication::applicationDisplayName());
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
        QMessageBox::critical(this, tr("Server"),
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

    statusLabel->setText(tr("The server is running on\n\nIP: %1\nport: %2\n\n"
                            "Run the client now.")
                         .arg(ipAddress).arg(tcpServer->serverPort()));
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
    model.insertRows(0, 1, QModelIndex());
}

void Server::broadcastDatagram()
{
    statusLabel->setText(tr("Now broadcasting datagram %1").arg(messageNo));  
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
    default:
        qDebug() << messageId._id << " received but not handled";
    };
}

void Server::disconnected()
{
    QTcpSocket* clientConnection = qobject_cast<QTcpSocket*>(sender());
    qDebug() << "Removing " << clientConnection;
    list.removeAll(clientConnection);
    clientConnection->deleteLater();
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
