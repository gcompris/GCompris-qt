/* GCompris - Connection.qml
 *
 * Copyright (C) 2020 Aiswarya Kaitheri Kandoth <aiswaryakk29@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Aiswarya Kaitheri Kandoth <aiswaryakk29@gmail.com> (Qt Quick port)
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
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
