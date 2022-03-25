/* GCompris - Bulb.qml
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
    id: redLed //to form an LED, connecting diode, resistor of 19 ohm and voltage source of 1.84v in series
    terminalSize: 0.2
    noOfConnectionPoints: 2
    information: qsTr("Red LED converts electrical energy into red light energy. It can glow only if the current flow is in the direction of the arrow. Electrical energy more than a certain limit can break it.")
    source: Activity.url + "red_led_off.svg"

    property var nodeVoltages: [0, 0]
    property double componentVoltage: 0
    property double power: 0
    property double powerThreshold: 0.01 //in W
    property double powerMax: 0.08
    property alias connectionPoints: connectionPoints
    property bool isBroken: false
    property var connectionPointPosX: [0.1, 0.9]
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
                "r": "19",
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
                posY: 0.85
            }
        }
    }

    Image {
        id: ledLight
        source: Activity.url + "red_led_on.svg"
        anchors.fill: parent
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectFit
        opacity: 0
    }

    Image {
        id: ledArrow
        source: isBroken ? Activity.url + "red_led_arrowBroken.svg" : Activity.url + "red_led_arrow.svg"
        anchors.fill: parent
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectFit
        opacity: 1
    }

    function repairComponent() {
        redLed.source = Activity.url + "red_led_off.svg";
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
            redLed.source = Activity.url + "red_led_broken.svg";
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
        if(!isBroken) {
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

    function checkComponentAnswer() {
        if(ledLight.opacity === 1) {
            return "redLedGlows";
        } else if(terminalConnected >= 2 && isBroken) {
            return "redLedBroken";
        } else if(terminalConnected >= 2)
            return "redLedIn";
        else
            return "";
    }
}
