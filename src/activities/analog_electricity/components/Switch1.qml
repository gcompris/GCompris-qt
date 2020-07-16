/* GCompris - Switch1.qml
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
    id: switch1 // A resistor
    terminalSize: 0.2
    noOfConnectionPoints: 2
    information: qsTr("Switch can connect or disconnect the conducting path in an electrical circuit.")
    source: Activity.url + "switch1_off.png"

    property double componentVoltage: 0
    property double current: 0
    property string resistanceValueOn: "0.001"
    property string resistanceValueOff: "100000000"
    property alias connectionPoints: connectionPoints
    property var connectionPointPosX: [0, 1]
    property string componentName: "Switch1"
    property var externalNetlistIndex: [0, 0]
    property var netlistModel:
    [
        "r",
        [
        ],
        {
            "name": componentName,
            "r": resistanceValueOff,
            "_json_": 0
        },
        [
            0,
            0
        ]
    ]

    Repeater {
        id: connectionPoints
        model: 2
        delegate: connectionPoint
        Component {
            id: connectionPoint
            TerminalPoint {
                posX: connectionPointPosX[index]
                posY: 1
            }
        }
    }

    Image {
        id: switchButton
        source: Activity.url + "switchButton.png"
        height: parent.height * 0.5
        width: parent.width * 0.3
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(switch1.source == Activity.url + "switch1_off.png") {
                    switch1.source = Activity.url + "switch1_on.png";
                    switch1.netlistModel[2].r = resistanceValueOn;
                } else {
                    switch1.source = Activity.url + "switch1_off.png";
                    switch1.netlistModel[2].r = resistanceValueOff;
                }
                Activity.restartTimer();
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
        switch1.externalNetlistIndex[0] = ++connectionIndex;
        connectionPoints.itemAt(0).updateNetlistIndex(connectionIndex);
        switch1.externalNetlistIndex[1] = ++connectionIndex;
        connectionPoints.itemAt(1).updateNetlistIndex(connectionIndex);
        Activity.connectionCount = connectionIndex;
    }

    function addToNetlist() {
        var netlistItem = switch1.netlistModel;
        Activity.netlistComponents.push(switch1);
        netlistItem[2].name = componentName;
        netlistItem[2]._json = Activity.netlist.length;
        netlistItem[3][0] = switch1.externalNetlistIndex[0];
        netlistItem[3][1] = switch1.externalNetlistIndex[1];
        Activity.netlist.push(netlistItem);
    }
}

