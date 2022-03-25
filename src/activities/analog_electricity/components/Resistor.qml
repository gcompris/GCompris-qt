/* GCompris - Resistor.qml
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
    id: resistor // Ammeters to measure current and voltage
    terminalSize: 0.2
    noOfConnectionPoints: 2
    information: qsTr("Resistors are used to reduce the current flow in an electrical circuit.")
    //: 1st V for Voltage, 2nd V for Volt
    labelText1: qsTr("V = %1V").arg(componentVoltage)
    //: I for current intensity, A for Ampere
    labelText2: qsTr("I = %1A").arg(resistorCurrent)
    source: Activity.url + "resistor.svg"

    property var nodeVoltages: [0, 0]
    property double componentVoltage: 0
    property double resistorCurrent: 0
    property alias connectionPoints: connectionPoints
    property var connectionPointPosX: [0.1, 0.9]
    property var connectionPointPosY: [0.5, 0.5]
    property string componentName: "Resistor"
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

    Repeater {
        id: connectionPoints
        model: 2
        delegate: connectionPoint
        Component {
            id: connectionPoint
            TerminalPoint {
                posX: connectionPointPosX[index]
                posY: connectionPointPosY[index]
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
            resistor.showLabel = true;
        } else {
            resistor.showLabel = false;
        }
    }

    function updateValues() {
        resistorCurrent = (Math.abs(aMeter1.current)).toFixed(3);
        componentVoltage = (Math.abs(nodeVoltages[1] - nodeVoltages[0])).toFixed(2);
    }

    function initConnections() {
        var connectionIndex = Activity.connectionCount;
        resistor.externalNetlistIndex[0] = ++connectionIndex;
        connectionPoints.itemAt(0).updateNetlistIndex(connectionIndex);
        resistor.internalNetlistIndex[0] = ++connectionIndex;
        resistor.internalNetlistIndex[1] = ++connectionIndex;
        resistor.externalNetlistIndex[1] = ++connectionIndex;
        connectionPoints.itemAt(1).updateNetlistIndex(connectionIndex);
        Activity.connectionCount = connectionIndex;
    }

    function addToNetlist() {
        var netlistItem = aMeter1.netlistModel;
        Activity.netlistComponents.push(aMeter1);
        Activity.vSourcesList.push(aMeter1);
        netlistItem[2].name = "aMeter1-" + componentName;
        netlistItem[2]._json = Activity.netlist.length;
        netlistItem[3][0] = resistor.externalNetlistIndex[0];
        netlistItem[3][1] = resistor.internalNetlistIndex[0];
        Activity.netlist.push(netlistItem);

        netlistItem = resistor.netlistModel;
        Activity.netlistComponents.push(resistor);
        netlistItem[2].name = componentName;
        netlistItem[2]._json = Activity.netlist.length;
        netlistItem[3][0] = resistor.internalNetlistIndex[0];
        netlistItem[3][1] = resistor.internalNetlistIndex[1];
        Activity.netlist.push(netlistItem);

        netlistItem = aMeter2.netlistModel;
        Activity.netlistComponents.push(aMeter2);
        Activity.vSourcesList.push(aMeter2);
        netlistItem[2].name = "aMeter2-" + componentName;
        netlistItem[2]._json = Activity.netlist.length;
        netlistItem[3][0] = resistor.internalNetlistIndex[1];
        netlistItem[3][1] = resistor.externalNetlistIndex[1];
        Activity.netlist.push(netlistItem);
    }

    function checkComponentAnswer() {
        if(resistorCurrent > 0 && terminalConnected >= 2)
            return "resistorIn";
        else
            return "";
    }
}

