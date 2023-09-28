/* GCompris - Battery.qml
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
    id: battery
    terminalSize: 0.2
    noOfConnectionPoints: 2
    information: qsTr("Battery is used for powering up electrical devices. It can supply voltage in a closed circuit. Which means there should be a path for the current to flow from one terminal of the battery to the other.") + " " + qsTr("If the current in a circuit is too high then the battery can be damaged.")
    //: 1st V for Voltage, 2nd V for Volt
    labelText1: qsTr("V = %1V").arg(componentVoltage)
    //: I for current intensity, A for Ampere
    labelText2: qsTr("I = %1A").arg(current)
    source: Activity.url + "battery.svg"

    property double componentVoltage: 0
    property var nodeVoltages: [0, 0]
    property double current: 0
    property alias connectionPoints: connectionPoints
    property var connectionPointPosY: [0.1, 0.9]
    property var connectionPointType: ["positive", "negative"]
    property string componentName: "Voltage"
    property var externalNetlistIndex: [0, 0]
    property var netlistModel:
    [
        "v",
        [
        ],
        {
            "name": componentName,
            "value": "dc(10)",
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
                posX: 0.5
                posY: connectionPointPosY[index]
                terminalType: connectionPointType[index]
            }
        }
    }

    function checkConnections() {
        terminalConnected = 0;
        for(var i = 0; i < noOfConnectionPoints; i++) {
            if(connectionPoints.itemAt(i).wires.length > 0)
                terminalConnected += 1;
        }

        // show label only from level 6 or in free mode
        if(terminalConnected >= 2 && (!Activity.items.isTutorialMode || Activity.items.currentLevel >= 5)) {
            battery.showLabel = true;
        } else {
            battery.showLabel = false;
        }
    }

    function updateValues() {
        componentVoltage = (Math.abs(nodeVoltages[1] - nodeVoltages[0])).toFixed(2);
        current = (Math.abs(current)).toFixed(3);
        // short circuit case
        if(Math.abs(current) > 1) {
            battery.source = Activity.url + "battery_dead.svg";
        } else {
            battery.source = Activity.url + "battery.svg";
        }
    }

    function initConnections() {
        var connectionIndex = Activity.connectionCount;
        battery.externalNetlistIndex[0] = ++connectionIndex;
        connectionPoints.itemAt(0).updateNetlistIndex(connectionIndex);
        battery.externalNetlistIndex[1] = ++connectionIndex;
        connectionPoints.itemAt(1).updateNetlistIndex(connectionIndex);
        Activity.connectionCount = connectionIndex;
    }

    function addToNetlist() {
        var netlistItem = battery.netlistModel;
        Activity.netlistComponents.push(battery);
        Activity.vSourcesList.push(battery);
        netlistItem[2].name = componentName;
        netlistItem[2]._json = Activity.netlist.length;
        netlistItem[3][0] = battery.externalNetlistIndex[0];
        netlistItem[3][1] = battery.externalNetlistIndex[1];
        Activity.netlist.push(netlistItem);
    }

    function checkComponentAnswer() {
        if(terminalConnected >= 2)
            return "batteryIn";
        else
            return "";
    }
}
