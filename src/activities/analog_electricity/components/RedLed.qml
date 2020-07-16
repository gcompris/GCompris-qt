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
    id: redLed //to form a LED, connecting diode, resistor of 19 ohm and voltage source of 1.84v in series
    terminalSize: 0.2
    noOfConnectionPoints: 2
    information: qsTr("Red LED converts electrical energy into red light energy. It can glow only if the current flow is in the direction of the arrow. Electrical energy more than a certain limit can break it.")
    source: Activity.url + "red_led_off.png"

    property var nodeVoltages: [0, 0]
    property double componentVoltage: 0
    property double power: 0
    property double powerThreshold: 0.01 //in W
    property double powerMax: 0.08
    property string resistanceValue: "19" //in Ohm
    property alias connectionPoints: connectionPoints
    property bool isBroken: false
    property var connectionPointPosX: [0.2, 0.8]
    property string componentName: "RedLed"
    property var internalNetlistIndex: [0, 0]
    property var externalNetlistIndex: [0, 0]
    property var netlistModel:
    [
        "d",
        [
        ],
        {
            "name": componentName,
            "area": "1",
            "_json_": 0
        },
        [
            0,
            0
        ]
    ]

    Item {
        id: resistor
        property int jsonNumber: 0
        property double current: 0
        property var netlistModel:
        [
            "r",
            [
            ],
            {
                "name": "resistor-",
                "r": redLed.resistanceValue,
                "_json_": 0
            },
            [
                0,
                0
            ]
        ]
    }

    Item {
        id: vSource //Forward bias voltage of Red LED is 1.84v
        property int jsonNumber: 0
        property double current: 0
        property var netlistModel:
        [
            "v",
            [
            ],
            {
                "name": "vSource-",
                "value": "dc(1.84)",
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
        id: ledLight
        source: Activity.url + "red_led_on.png";
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        opacity: 0
    }

    function repairComponent() {
        redLed.source = Activity.url + "red_led_off.png";
        resistanceValue = "19";
        isBroken = false;
    }

    function checkConnections() {
        terminalConnected = 0;
        for(var i = 0; i < noOfConnectionPoints; i++) {
            if(connectionPoints.itemAt(i).wires.length > 0)
                terminalConnected += 1;
        }
    }

    function updateValues() {
        power = 1.84 * (vSource.current);
        if(power >= powerThreshold && power < powerMax) {
            ledLight.opacity = 1;
        } else if(power < powerThreshold) {
            ledLight.opacity = 0;
        } else if(power >= powerMax) {
            ledLight.opacity = 0;
            redLed.source = Activity.url + "red_led_broken.png";
            redLed.resistanceValue = "100000000";
            isBroken = true;
            Activity.restartTimer();
        }
    }

    function initConnections() {
        var connectionIndex = Activity.connectionCount;
        redLed.externalNetlistIndex[0] = ++connectionIndex;
        connectionPoints.itemAt(0).updateNetlistIndex(connectionIndex);
        redLed.internalNetlistIndex[0] = ++connectionIndex;
        redLed.internalNetlistIndex[1] = ++connectionIndex;
        redLed.externalNetlistIndex[1] = ++connectionIndex;
        connectionPoints.itemAt(1).updateNetlistIndex(connectionIndex);
        Activity.connectionCount = connectionIndex;
    }

    function addToNetlist() {
        var netlistItem = redLed.netlistModel;
        Activity.netlistComponents.push(redLed);
        netlistItem[2].name = componentName;
        netlistItem[2]._json = Activity.netlist.length;
        netlistItem[3][0] = redLed.externalNetlistIndex[0];
        netlistItem[3][1] = redLed.internalNetlistIndex[0];
        Activity.netlist.push(netlistItem);

        netlistItem = resistor.netlistModel;
        Activity.netlistComponents.push(resistor);
        netlistItem[2].name = "resistor-" + componentName;
        netlistItem[2]._json = Activity.netlist.length;
        netlistItem[3][0] = redLed.internalNetlistIndex[0];
        netlistItem[3][1] = redLed.internalNetlistIndex[1];
        Activity.netlist.push(netlistItem);

        netlistItem = vSource.netlistModel;
        Activity.netlistComponents.push(vSource);
        Activity.vSourcesList.push(vSource);
        netlistItem[2].name = "vSource-" + componentName;
        netlistItem[2]._json = Activity.netlist.length;
        netlistItem[3][0] = redLed.internalNetlistIndex[1]; //positive terminal to the resistor
        netlistItem[3][1] = redLed.externalNetlistIndex[1];
        Activity.netlist.push(netlistItem);
    }
}
