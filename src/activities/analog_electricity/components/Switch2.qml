/* GCompris - Switch2.qml
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
    id: switch2 // two resistors
    terminalSize: 0.2
    noOfConnectionPoints: 3
    information: qsTr("A three points switch can toggle a circuit between two connection points.")
    source: Activity.url + "switch2_off.svg"

    property double componentVoltage: 0
    property double current: 0
    property string resistanceValueOn: "0"
    property string resistanceValueOff: "100000000"
    property string resistanceTop: resistanceValueOn
    property string resistanceBottom: resistanceValueOff
    property alias connectionPoints: connectionPoints
    property var connectionPointPosX: [0.1, 0.9, 0.9]
    property var connectionPointPosY: [0.5, 0.165, 0.835]
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

    MouseArea {
        height: parent.height * 0.33
        width: parent.width * 0.25
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: width * -0.5
        anchors.top: parent.top
        onClicked: {
            if(switch2.source == Activity.url + "switch2_off.svg") {
                switch2.source = Activity.url + "switch2_on.svg";
                switch2.netlistModel[2].r = resistanceValueOn;
                switch2Bottom.netlistModel[2].r = resistanceValueOff;
            } else {
                switch2.source = Activity.url + "switch2_off.svg";
                switch2.netlistModel[2].r = resistanceValueOff;
                switch2Bottom.netlistModel[2].r = resistanceValueOn;
            }
            Activity.restartTimer();
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
        if(netlistItem[2].r === "0") {
            Activity.vSourcesList.push(switch2);
        }
        netlistItem[2].name = componentName + "-top";
        netlistItem[2]._json = Activity.netlist.length;
        netlistItem[3][0] = switch2.externalNetlistIndex[0];
        netlistItem[3][1] = switch2.externalNetlistIndex[1];
        Activity.netlist.push(netlistItem);

        netlistItem = switch2Bottom.netlistModel;
        Activity.netlistComponents.push(switch2Bottom);
        if(netlistItem[2].r === "0") {
            Activity.vSourcesList.push(switch2Bottom);
        }
        netlistItem[2].name = componentName + "-bottom";
        netlistItem[2]._json = Activity.netlist.length;
        netlistItem[3][0] = switch2.externalNetlistIndex[0];
        netlistItem[3][1] = switch2.externalNetlistIndex[2];
        Activity.netlist.push(netlistItem);

    }
}
