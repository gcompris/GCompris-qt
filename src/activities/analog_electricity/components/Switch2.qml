/* GCompris - Switch2.qml
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
    id: switch2 // two resistors
    terminalSize: 0.2
    noOfConnectionPoints: 3
    information: qsTr("A three points switch can toggle a circuit between two connection points.")
    source: Activity.url + "switch2_off.png"

    property double componentVoltage: 0
    property double current: 0
    property string resistanceValueOn: "0.001"
    property string resistanceValueOff: "100000000"
    property string resistanceTop: resistanceValueOn
    property string resistanceBottom: resistanceValueOff
    property alias connectionPoints: connectionPoints
    property var connectionPointPosX: [0, 1, 1]
    property var connectionPointPosY: [0.5, 0, 1]
    property string componentName: "Switch2"
    property var externalNetlistIndex: [0, 0, 0]
    property var netlistModel:
    [
        "r",
        [
        ],
        {
            "name": "-top",
            "r": resistanceValueOff,
            "_json_": 0
        },
        [
            0,
            0
        ]
    ]

    Item {
        id: switch2Bottom
        property int jsonNumber: 0
        property double current: 0
        property var netlistModel:
        [
            "r",
            [
            ],
            {
                "name": "-bottom",
                "r": switch2.resistanceValueOn,
                "_json_": 0
            },
            [
                0,
                0
            ]
        ]
    }

    Repeater {
        id: connectionPoints
        model: 3
        delegate: connectionPoint
        Component {
            id: connectionPoint
            TerminalPoint {
                posX: connectionPointPosX[index]
                posY: connectionPointPosY[index]
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
                if(switch2.source == Activity.url + "switch2_off.png") {
                    switch2.source = Activity.url + "switch2_on.png";
                    switch2.netlistModel[2].r = resistanceValueOn;
                    switch2Bottom.netlistModel[2].r = resistanceValueOff;
                } else {
                    switch2.source = Activity.url + "switch2_off.png";
                    switch2.netlistModel[2].r = resistanceValueOff;
                    switch2Bottom.netlistModel[2].r = resistanceValueOn;

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
        switch2.externalNetlistIndex[0] = ++connectionIndex;
        connectionPoints.itemAt(0).updateNetlistIndex(connectionIndex);
        switch2.externalNetlistIndex[1] = ++connectionIndex;
        connectionPoints.itemAt(1).updateNetlistIndex(connectionIndex);
        switch2.externalNetlistIndex[2] = ++connectionIndex;
        connectionPoints.itemAt(2).updateNetlistIndex(connectionIndex);
        Activity.connectionCount = connectionIndex;
    }

    function addToNetlist() {
        var netlistItem = switch2.netlistModel;
        Activity.netlistComponents.push(switch2);
        netlistItem[2].name = componentName + "-top";
        netlistItem[2]._json = Activity.netlist.length;
        netlistItem[3][0] = switch2.externalNetlistIndex[0];
        netlistItem[3][1] = switch2.externalNetlistIndex[1];
        Activity.netlist.push(netlistItem);

        netlistItem = switch2Bottom.netlistModel;
        Activity.netlistComponents.push(switch2Bottom);
        netlistItem[2].name = componentName + "-bottom";
        netlistItem[2]._json = Activity.netlist.length;
        netlistItem[3][0] = switch2.externalNetlistIndex[0];
        netlistItem[3][1] = switch2.externalNetlistIndex[2];
        Activity.netlist.push(netlistItem);

    }
}
