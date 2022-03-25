/* GCompris - Switch1.qml
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
    id: switch1 // A resistor
    terminalSize: 0.2
    noOfConnectionPoints: 2
    information: qsTr("Switch can connect or disconnect the conducting path in an electrical circuit.")
    source: Activity.url + "switch_off.svg"

    property double componentVoltage: 0
    property double current: 0
    property bool switchOn: false
    property alias connectionPoints: connectionPoints
    property var connectionPointPosX: [0.1, 0.9]
    property string componentName: "Switch1"
    property var externalNetlistIndex: [0, 0]
    property var netlistModel:
    [
        "r",
        [
        ],
        {
            "name": componentName,
            "r": "0",
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
                posY: 0.75
            }
        }
    }

    MouseArea {
        id: clickArea
        height: parent.height * 0.5
        width: parent.width * 0.25
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        onClicked: {
            if(switch1.source == Activity.url + "switch_off.svg") {
                switch1.source = Activity.url + "switch_on.svg";
                switchOn = true;
            } else {
                switch1.source = Activity.url + "switch_off.svg";
                switchOn = false;
            }
            Activity.restartTimer();
        }
    }

    function checkConnections() {
        terminalConnected = 0;
        for(var i = 0; i < noOfConnectionPoints; i++) {
            if(connectionPoints.itemAt(i).wires.length > 0)
                terminalConnected += 1;
        }
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
        if(switchOn) {
            var netlistItem = switch1.netlistModel;
            Activity.netlistComponents.push(switch1);
            Activity.vSourcesList.push(switch1);
            netlistItem[2].name = componentName;
            netlistItem[2]._json = Activity.netlist.length;
            netlistItem[3][0] = switch1.externalNetlistIndex[0];
            netlistItem[3][1] = switch1.externalNetlistIndex[1];
            Activity.netlist.push(netlistItem);
        }
    }

    function checkComponentAnswer() {
        if(switch1.source == Activity.url + "switch_off.svg" && terminalConnected >= 2) {
            switch1.source = Activity.url + "switch_on.svg";
            switchOn = true;
            Activity.createNetlist();

            if(current != 0)
                return "switch1In";
        } else if(switch1.source == Activity.url + "switch_on.svg" && terminalConnected >= 2 && current != 0) {
            return "switch1In";
        } else
            return "";
    }
}

