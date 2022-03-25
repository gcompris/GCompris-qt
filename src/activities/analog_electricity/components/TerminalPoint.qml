/* GCompris - TerminalPoint.qml
 *
 * SPDX-FileCopyrightText: 2020 Aiswarya Kaitheri Kandoth <aiswaryakk29@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitnsit@gmail.com> (Qt Quick port)
 *   Aiswarya Kaitheri Kandoth <aiswaryakk29@gmail.com> (AnalogElectricity activity)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

import "../analog_electricity.js" as Activity

Image {
    id: terminalPoint

    property double posX
    property double posY
    property double size: parent.terminalSize
    property bool selected: false
    property int value: 0
    property var wires: []
    property int colorIndex: -1
    property int initialIndex: 0
    property int netlistIndex: 0
    property string terminalType: "noPolarity"

    width: size * Math.max(parent.paintedHeight, parent.paintedWidth)
    height: width
    source: Activity.urlDigital + "tPoint.svg"
    sourceSize.width: width
    sourceSize.height: width
    antialiasing: true

    x: (parent.width - parent.paintedWidth) / 2 + posX * parent.paintedWidth - width / 2
    y: (parent.height - parent.paintedHeight) / 2 + posY * parent.paintedHeight - height / 2

    property double xCenter: terminalPoint.parent.x + terminalPoint.x + width/2
    property double yCenter: terminalPoint.parent.y + terminalPoint.y + height/2
    property double xCenterFromComponent: terminalPoint.x + width/2 - terminalPoint.parent.width / 2
    property double yCenterFromComponent: terminalPoint.y + height/2 - terminalPoint.parent.height / 2

    function updateNetlistIndex(netlistIndex_, colorIndex_) {
        if(initialIndex === 0) {
            initialIndex = netlistIndex_;
        }
        terminalPoint.netlistIndex = netlistIndex_;
        parent.externalNetlistIndex[index] = netlistIndex_;
        if(colorIndex_ !== undefined) {
            colorIndex = colorIndex_;
        }
        propagateNetlistIndex(netlistIndex_, colorIndex);
    }

    function propagateNetlistIndex(netlistIndex_, colorIndex_) {
        for(var i = 0; i < wires.length; ++i) {
            if(wires[i].node1.netlistIndex != netlistIndex_)
                wires[i].node1.updateNetlistIndex(netlistIndex_, colorIndex_);
            if(wires[i].node2.netlistIndex != netlistIndex_)
                wires[i].node2.updateNetlistIndex(netlistIndex_, colorIndex_);
        }
    }

    function resetIndex() {
            updateNetlistIndex(initialIndex);
    }

    Rectangle {
        id: boundary
        anchors.centerIn: terminalPoint
        width: terminalPoint.width * 2
        height: width
        visible: selected
        radius: width / 2
        color: "#08D050"
        z: -1
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onPressed: {
            selected = true;
             Activity.terminalPointSelected(terminalPoint);
        }
    }
}
