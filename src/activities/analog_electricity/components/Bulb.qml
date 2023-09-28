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
    id: bulb // Ammeter on both sides of a resistor
    terminalSize: 0.2
    noOfConnectionPoints: 2
    information: qsTr("Bulb glows when it has enough power. Its intensity is proportional to the supplied voltage. It will be broken if there is a power greater than a certain limit.")
    //: 1st V for Voltage, 2nd V for Volt
    labelText1: qsTr("V = %1V").arg(componentVoltage)
    //: I for current intensity, A for Ampere
    labelText2: qsTr("I = %1A").arg(bulbCurrent)
    source: Activity.url + "bulb.svg"

    property var nodeVoltages: [0, 0]
    property double componentVoltage: 0
    property double power: 0
    property double maxPower: 0.11
    property double bulbCurrent: 0
    property alias connectionPoints: connectionPoints
    property alias lightBulb: lightBulb
    property bool isBroken: false
    property var connectionPointPosX: [0.1, 0.9]
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
            "r": "1000",
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
                posY: 0.9
            }
        }
    }

    Image {
        id: lightFilament
        source: Activity.url + "bulb_light.svg"
        anchors.fill: parent
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectFit
        opacity: lightBulb.opacity > 0 ? 1 : 0
    }

    Image {
        id: lightBulb
        source: Activity.url + "bulb_max.svg"
        anchors.fill: parent
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectFit
        opacity: power < maxPower ? power * 10 : 0
    }

    function repairComponent() {
        bulb.source = Activity.url + "bulb.svg";
        isBroken = false;
    }

    function checkConnections() {
        terminalConnected = 0;
        for(var i = 0; i < noOfConnectionPoints; i++) {
            if(connectionPoints.itemAt(i).wires.length > 0)
                terminalConnected += 1;
        }

        // show label only from level 6 or in free mode, and when it's connected and not broken
        if((terminalConnected >=2 && !isBroken && !Activity.items.isTutorialMode) ||
            (terminalConnected >= 2 && !isBroken && Activity.items.isTutorialMode &&
            Activity.items.currentLevel >= 5)) {
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
            // if the bulb is blown, set its current to 0, hide its label and don't push it to the netlist
            bulb.showLabel = false;
            bulbCurrent = 0;
            bulb.source = Activity.url + "bulb_blown.svg";
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
        if(!isBroken) {
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

    function checkComponentAnswer() {
        // special case for level 8
        if(Activity.items.currentLevel === 7 && componentVoltage > 0 && !isBroken)
            return "bulbIn";

        if(componentVoltage === 10) {
            return "bulbGlows";
        } else if(terminalConnected >= 2 && componentVoltage < 10 && bulbCurrent > 0) {
            return "bulbGlowsLess"
        } else if(terminalConnected >= 2 && isBroken) {
            return "bulbBroken";
        } else
            return "";
    }
}

