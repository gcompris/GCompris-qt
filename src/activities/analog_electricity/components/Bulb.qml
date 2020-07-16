/* GCompris - Bulb.qml
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
    id: bulb // Ammeter on both sides of a resistor
    terminalSize: 0.2
    noOfConnectionPoints: 2
    information: qsTr("Bulb glows when it has enough power. Its intensity is proportional to the supplied voltage. It will be broken if there is a power greater than a certain limit.")
    //: 1st V for Voltage, 2nd V for Volt
    labelText1: qsTr("V = %1V").arg(componentVoltage)
    //: I for current intensity, A for Ampere
    labelText2: qsTr("I = %1A").arg(bulbCurrent)
    source: Activity.url + "bulb1.png"

    property var nodeVoltages: [0, 0]
    property double componentVoltage: 0
    property double power: 0
    property double maxPower: 0.11
    property double bulbCurrent: 0
    property string resistanceValue: "1000"
    property alias connectionPoints: connectionPoints
    property bool isBroken: false
    property var connectionPointPosX: [0.2, 0.8]
    property string componentName: "Bulb"
    property var internalNetlistIndex: [0, 0]
    property var externalNetlistIndex: [0, 0]
    property var netlistModel:
    [
        "r",
        [
        ],
        {
            "name": componentName,
            "r": bulb.resistanceValue,
            "_json_": 0
        },
        [
            0,
            0
        ]
    ]

    Item {
        id: aMeter1 // Ammeters are to measure current and voltage
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
        id: lightBulb
        source: Activity.url + "bulb_max.png"
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        opacity: power < maxPower ? power * 10 : 0
    }

    function repairComponent() {
        bulb.source = Activity.url + "bulb1.png";
        resistanceValue = "1000";
        isBroken = false;
    }

    function checkConnections() {
        terminalConnected = 0;
        for(var i = 0; i < noOfConnectionPoints; i++) {
            if(connectionPoints.itemAt(i).wires.length > 0)
                terminalConnected += 1;
        }
        if(terminalConnected >= 2) {
            bulb.showLabel = true;
        } else {
            bulb.showLabel = false;
        }
    }

    function updateValues() {
        bulbCurrent = (Math.abs(aMeter1.current)).toFixed(3);
        componentVoltage = (Math.abs(nodeVoltages[1] - nodeVoltages[0])).toFixed(2);
        power = componentVoltage * bulbCurrent;
        if(power < maxPower)
            lightBulb.opacity  = power * 10;
        else {
            lightBulb.opacity = 0;
            // if the bulb is blown, change the resistanceValue and recalculate
            bulb.source = Activity.url + "bulb_blown.png";
            resistanceValue = "100000000";
            isBroken = true;
            Activity.restartTimer();
        }
    }

    function initConnections() {
        var connectionIndex = Activity.connectionCount;
        bulb.externalNetlistIndex[0] = ++connectionIndex;
        connectionPoints.itemAt(0).updateNetlistIndex(connectionIndex);
        bulb.internalNetlistIndex[0] = ++connectionIndex;
        bulb.internalNetlistIndex[1] = ++connectionIndex;
        bulb.externalNetlistIndex[1] = ++connectionIndex;
        connectionPoints.itemAt(1).updateNetlistIndex(connectionIndex);
        Activity.connectionCount = connectionIndex;
    }

    function addToNetlist() {
        var netlistItem = aMeter1.netlistModel;
        Activity.netlistComponents.push(aMeter1);
        Activity.vSourcesList.push(aMeter1);
        netlistItem[2].name = "aMeter1-" + componentName;
        netlistItem[2]._json = Activity.netlist.length;
        netlistItem[3][0] = bulb.externalNetlistIndex[0];
        netlistItem[3][1] = bulb.internalNetlistIndex[0];
        Activity.netlist.push(netlistItem);

        netlistItem = bulb.netlistModel;
        Activity.netlistComponents.push(bulb);
        netlistItem[2].name = componentName;
        netlistItem[2]._json = Activity.netlist.length;
        netlistItem[3][0] = bulb.internalNetlistIndex[0];
        netlistItem[3][1] = bulb.internalNetlistIndex[1];
        Activity.netlist.push(netlistItem);

        netlistItem = aMeter2.netlistModel;
        Activity.netlistComponents.push(aMeter2);
        Activity.vSourcesList.push(aMeter2);
        netlistItem[2].name = "aMeter2-" + componentName;
        netlistItem[2]._json = Activity.netlist.length;
        netlistItem[3][0] = bulb.internalNetlistIndex[1];
        netlistItem[3][1] = bulb.externalNetlistIndex[1];
        Activity.netlist.push(netlistItem);
    }
}

