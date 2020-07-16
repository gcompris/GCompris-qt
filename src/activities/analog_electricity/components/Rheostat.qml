/* GCompris - Rheostat.qml
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
    id: rheostat // Two resistors with ammeters on each connection point
    terminalSize: 0.2
    noOfConnectionPoints: 3
    information: qsTr("Rheostat is used to vary resistance in an electrical circuit.")
    //: 1st V for Voltage, 2nd V for Volt
    labelText1: qsTr("V = %1V").arg(componentVoltage)
    //: I for current intensity, A for Ampere
    labelText2: qsTr("I = %1A").arg(current)
    source: Activity.url + "resistor_track.png"

    property var nodeVoltages: [0, 0, 0]
    property double componentVoltage: 0
    property double current: 0
    property double bottomCurrent: 0
    property int wiperY: 0
    property double topResistance: Math.max(0.001, 1000 * (wiperY / wiperArea.height))
    property double bottomResistance: Math.max(0.001, 1000 - topResistance)
    property string topResistanceTxt: topResistance.toString()
    property string bottomResistanceTxt: bottomResistance.toString()
    onBottomResistanceTxtChanged: Activity.restartTimer();
    property string componentName: "Rheostat"
    property alias connectionPoints: connectionPoints
    property var connectionPointPosX: [0, 1, 0]
    property var connectionPointPosY: [0, 0.5, 1]
    property var internalNetlistIndex: [0, 0, 0]
    property var externalNetlistIndex: [0, 0, 0]
    property var netlistModel:
    [
        "r",
        [
        ],
        {
            "name": componentName,
            "r": topResistanceTxt,
            "_json_": 0
        },
        [
            0,
            0
        ]
    ]

    Item {
        id: bottomResistor
        property int jsonNumber: 0
        property var netlistModel:
        [
            "r",
            [
            ],
            {
                "name": "-bottom",
                "r": rheostat.bottomResistanceTxt,
                "_json_": 0
            },
            [
                0,
                0
            ]
        ]
    }

    Item {
        id: aMeter1
        property int jsonNumber: 0
        property double current: 0
        property var netlistModel:
        [
            "a",
            [
            ],
            {
                "name": "aMeter1-",
                "color": "magenta",
                "offset": "0",
                "_json_": aMeter1.jsonNumber
            },
            [
                0,
                0
            ]
        ]
    }

    Item {
        id: aMeter2
        property int jsonNumber: 0
        property double current: 0
        property var netlistModel:
        [
            "a",
            [
            ],
            {
                "name": "aMeter2-",
                "color": "magenta",
                "offset": "0",
                "_json_": aMeter2.jsonNumber
            },
            [
                0,
                0
            ]
        ]
    }

    Item {
        id: aMeter3
        property int jsonNumber: 0
        property double current: 0
        property var netlistModel:
        [
            "a",
            [
            ],
            {
                "name": "aMeter3-",
                "color": "magenta",
                "offset": "0",
                "_json_": aMeter3.jsonNumber
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

    Item {
        id: wiperArea
        width: parent.width
        height: parent.height * 0.6
        anchors.centerIn: parent
        Rectangle {
            id: wiper
            width: rheostat.paintedWidth * 1.1
            height: rheostat.paintedHeight * 0.1
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#373737"
            radius: height * 0.2
            y: 0
            MouseArea {
                anchors.fill: parent
                drag.target: wiper
                onPositionChanged: {
                    if(wiper.y < 0)
                        wiper.y = 0;
                    if(wiper.y > wiperArea.height)
                        wiper.y = wiperArea.height;
                    wiperY = wiper.y;
                }
            }
        }
    }

    function checkConnections() {
        terminalConnected = 0;
        for(var i = 0; i < noOfConnectionPoints; i++) {
            if(connectionPoints.itemAt(i).wires.length > 0)
                terminalConnected += 1;
        }
        if(terminalConnected >= 2) {
            rheostat.showLabel = true;
        } else {
            rheostat.showLabel = false;
        }
    }

    function updateValues() {
        bottomCurrent = aMeter3.current;
        if(connectionPoints.itemAt(0).wires.length > 0 && connectionPoints.itemAt(2).wires.length > 0) {
            componentVoltage = (Math.abs(nodeVoltages[2] - nodeVoltages[0])).toFixed(1);
            current = (Math.abs(aMeter1.current)).toFixed(2);
        } else if(connectionPoints.itemAt(0).wires.length > 0 && connectionPoints.itemAt(1).wires.length > 0) {
            componentVoltage = (Math.abs(nodeVoltages[1] - nodeVoltages[0])).toFixed(1);
            current = (Math.abs(aMeter2.current)).toFixed(2);
        } else {
            componentVoltage = (Math.abs(nodeVoltages[2] - nodeVoltages[1])).toFixed(1);
            current = (Math.abs(bottomCurrent)).toFixed(2);
        }
    }

    function initConnections() {
        var connectionIndex = Activity.connectionCount;
        rheostat.externalNetlistIndex[0] = ++connectionIndex;
        connectionPoints.itemAt(0).updateNetlistIndex(connectionIndex);
        rheostat.internalNetlistIndex[0] = ++connectionIndex;
        rheostat.internalNetlistIndex[1] = ++connectionIndex;
        rheostat.internalNetlistIndex[2] = ++connectionIndex;
        rheostat.externalNetlistIndex[1] = ++connectionIndex;
        connectionPoints.itemAt(1).updateNetlistIndex(connectionIndex);
        rheostat.externalNetlistIndex[2] = ++connectionIndex;
        connectionPoints.itemAt(2).updateNetlistIndex(connectionIndex);
        Activity.connectionCount = connectionIndex;
    }

    function addToNetlist() {
        var netlistItem = aMeter1.netlistModel;
        Activity.netlistComponents.push(aMeter1);
        Activity.vSourcesList.push(aMeter1);
        netlistItem[2].name = "aMeter1-" + componentName;
        netlistItem[2]._json = Activity.netlist.length;
        netlistItem[3][0] = rheostat.externalNetlistIndex[0];
        netlistItem[3][1] = rheostat.internalNetlistIndex[0];
        Activity.netlist.push(netlistItem);

        netlistItem = rheostat.netlistModel;
        Activity.netlistComponents.push(rheostat);
        netlistItem[2].name = componentName;
        netlistItem[2]._json = Activity.netlist.length;
        netlistItem[3][0] = rheostat.internalNetlistIndex[0];
        netlistItem[3][1] = rheostat.internalNetlistIndex[1];
        Activity.netlist.push(netlistItem);

        netlistItem = bottomResistor.netlistModel;
        Activity.netlistComponents.push(bottomResistor);
        netlistItem[2].name = componentName + "-bottom";
        netlistItem[2]._json = Activity.netlist.length;
        netlistItem[3][0] = rheostat.internalNetlistIndex[1];
        netlistItem[3][1] = rheostat.internalNetlistIndex[2];
        Activity.netlist.push(netlistItem);

        netlistItem = aMeter2.netlistModel;
        Activity.netlistComponents.push(aMeter2);
        Activity.vSourcesList.push(aMeter2);
        netlistItem[2].name = "aMeter2-" + componentName;
        netlistItem[2]._json = Activity.netlist.length;
        netlistItem[3][0] = rheostat.internalNetlistIndex[1];
        netlistItem[3][1] = rheostat.externalNetlistIndex[1];
        Activity.netlist.push(netlistItem);

        netlistItem = aMeter3.netlistModel;
        Activity.netlistComponents.push(aMeter3);
        Activity.vSourcesList.push(aMeter3);
        netlistItem[2].name = "aMeter3-" + componentName;
        netlistItem[2]._json = Activity.netlist.length;
        netlistItem[3][0] = rheostat.internalNetlistIndex[2];
        netlistItem[3][1] = rheostat.externalNetlistIndex[2];
        Activity.netlist.push(netlistItem);
    }
}
