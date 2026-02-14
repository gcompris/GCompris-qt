/* GCompris - netconst.h
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
#ifndef NETCONST_H
#define NETCONST_H

#include <QObject>

namespace netconst {
    Q_NAMESPACE

    static const int PING_DELAY = 500; // Timeout between pings. Check connection (client side)
    static const int WAIT_DELAY = 5000; // Timeout without message or ping received, before closing socket (server side)
    static const int PURGE_DELAY = 100; // Timeout between messages, while purging message queue after reconnection (client side)

    enum MessageType : int {
        LOGIN_LIST,
        LOGIN_REPLY,
        LOGIN_ACCEPT,
        DISCONNECT,
        ACTIVITY_DATA,
        DATASET_CREATION,
        DATASET_REMOVE,
        DATASET_REMOVE_ALL,
        PING,
        PONG,
        SEQUENCE_START
    };
    Q_ENUM_NS(MessageType)

    enum ConnectionStatus : int {
        NOT_CONNECTED,
        NOT_LOGGED,
        BAD_PASSWORD_INPUT,
        CONNECTED,
        CONNECTION_LOST,
        ALREADY_CONNECTED,
        DISCONNECTED
    };
    Q_ENUM_NS(ConnectionStatus)

}

#endif
