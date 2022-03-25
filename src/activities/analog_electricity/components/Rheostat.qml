/* GCompris - Rheostat.qml
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
    id: rheostat // Two resistors with ammeters on each connection point
    terminalSize: 0.2
    noOfConnectionPoints: 3
    information: qsTr("Rheostat is used to vary resistance in an electrical circuit.")
    //: 1st V for Voltage, 2nd V for Volt
    labelText1: qsTr("V = %1V").arg(componentVoltage)
    //: I for current intensity, A for Ampere
    labelText2: qsTr("I = %1A").arg(current)
    source: Activity.url + "rheostat.svg"

    property var nodeVoltages: [0, 0, 0]
    property double componentVoltage: 0
    property double current: 0
    property double bottomCurrent: 0
    property double wiperPosition: 0
    property double topResistance: 1000 * wiperPosition
    property double bottomResistance: 1000 - topResistance
    property string topResistanceTxt: topResistance.toString()
    property string bottomResistanceTxt: bottomResistance.toString()
    onBottomResistanceTxtChanged: Activity.restartTimer();
    property string componentName: "Rheostat"
    property alias connectionPoints: connectionPoints
    property var connectionPointPosX: [0.335, 0.83, 0.335]
    property var connectionPointPosY: [0.1, 0.5, 0.9]
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
        property double current: 0
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
        width: parent.width * 0.5
        height: parent.height * 0.4
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: width * -0.33
        property double wiperLimit: wiperArea.height * 0.8
        //update wiper on zoom or window size changes
        onWiperLimitChanged: {
            wiper.y = wiperArea.wiperLimit * wiperPosition;
        }
        Rectangle {
            id: internalWire
            height: wiper.height * 0.4
            radius: height * 0.5
            color: "#535353"
            transformOrigin: Item.Left

            property double wiperXCenter: wiper.x + wiper.width * 0.5
            property double wiperYCenter: wiper.y + wiper.height * 0.5
            property double pointXCenter: wiperXCenter + wiperArea.width
            property double pointYCenter: wiperArea.height * 0.5
            property double rectangleWidth: pointXCenter - wiperXCenter
            property double rectangleHeight: pointYCenter - wiperYCenter

            x: wiperXCenter
            y: wiperYCenter - radius
            width: Math.sqrt(Math.pow(rectangleWidth, 2) + Math.pow(Math.abs(rectangleHeight), 2))
            rotation: rectangleHeight >= 0 ? 90 - (Math.atan(rectangleWidth / rectangleHeight) * 57.3) :
                                             (Math.atan(rectangleWidth / rectangleHeight) * -57.3) - 90
        }
        Rectangle {
            id: wiper
            width: parent.width * 1.1
            height: wiperArea.height * 0.2
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#535353"
            border.width: height * 0.2
            border.color: "#373737"
            radius: height * 0.2
            y: 0
            MouseArea {
                width: parent.width
                height: parent.height * 2
                anchors.centerIn: parent
                drag.target: wiper
                onPositionChanged: {
                    if(wiper.y < 0)
                        wiper.y = 0;
                    if(wiper.y > wiperArea.wiperLimit)
                        wiper.y = wiperArea.wiperLimit;
                    wiperPosition = wiper.y / wiperArea.wiperLimit;
                }
            }
        }
        Rectangle {
            height: internalWire.height * 1.5
            width: height
            radius: height * 0.5
            anchors.centerIn: wiper
            color: "#888888"
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
            componentVoltage = (Math.abs(nodeVoltages[2] - nodeVoltages[0])).toFixed(2);
            current = (Math.abs(aMeter1.current)).toFixed(3);
        } else if(connectionPoints.itemAt(0).wires.length > 0 && connectionPoints.itemAt(1).wires.length > 0) {
            componentVoltage = (Math.abs(nodeVoltages[1] - nodeVoltages[0])).toFixed(2);
            current = (Math.abs(aMeter2.current)).toFixed(3);
        } else {
            componentVoltage = (Math.abs(nodeVoltages[2] - nodeVoltages[1])).toFixed(2);
            current = (Math.abs(bottomCurrent)).toFixed(3);
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
        if(netlistItem[2].r === "0") {
            Activity.vSourcesList.push(rheostat);
        }
        netlistItem[2].name = componentName;
        netlistItem[2]._json = Activity.netlist.length;
        netlistItem[3][0] = rheostat.internalNetlistIndex[0];
        netlistItem[3][1] = rheostat.internalNetlistIndex[1];
        Activity.netlist.push(netlistItem);

        netlistItem = bottomResistor.netlistModel;
        Activity.netlistComponents.push(bottomResistor);
        if(netlistItem[2].r === "0") {
            Activity.vSourcesList.push(bottomResistor);
        }
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

    function checkComponentAnswer() {
        if(connectionPoints.itemAt(0).wires.length > 0 && connectionPoints.itemAt(2).wires.length > 0 && current === 0.005) {
            return "rheostatConst";
        } else if(terminalConnected >= 2 && current > 0) {
            return "rheostatIn";
        } else
            return "";
    }
}
