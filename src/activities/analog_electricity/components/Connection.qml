/* GCompris - Connection.qml
 *
 * SPDX-FileCopyrightText: 2020 Aiswarya Kaitheri Kandoth <aiswaryakk29@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Aiswarya Kaitheri Kandoth <aiswaryakk29@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0
import "../analog_electricity.js" as Activity

ElectricalComponent {
    id: connection
    terminalSize: 0.2
    noOfConnectionPoints: 1
    information: qsTr("A simple connection point to connect several wires in an electrical circuit.")
    source: Activity.url + "connection.svg"

    property alias connectionPoints: connectionPoints
    property string componentName: "Connection"
    property var externalNetlistIndex: [0]

    Repeater {
        id: connectionPoints
        model: 1
        delegate: connectionPoint
        Component {
            id: connectionPoint
            TerminalPoint {
                posX: 0.5
                posY: 0.5
            }
        }
    }

    function checkConnections() {
        return;
    }

    function updateValues() {
        return;
    }

    function initConnections() {
        var connectionIndex = Activity.connectionCount;
        connection.externalNetlistIndex[0] = ++connectionIndex;
        connectionPoints.itemAt(0).updateNetlistIndex(connectionIndex);
        Activity.connectionCount = connectionIndex;
    }

    function addToNetlist() {
        return;
    }
}
