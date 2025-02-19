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
import QtQuick
import core 1.0

import "../analog_electricity.js" as Activity

Image {
    id: terminalPoint

    property ElectricalComponent component
    property double posX
    property double posY
    property double size: component ? component.terminalSize : 1
    property bool selected: false
    property int value: 0
    property var wires: []
    property int colorIndex: -1
    property int initialIndex: 0
    property int netlistIndex: 0
    property string terminalType: "noPolarity"

    width: component ? size * Math.max(component.paintedHeight, component.paintedWidth) : 1
    height: width
    source: Activity.urlDigital + "tPoint.svg"
    sourceSize.width: width
    sourceSize.height: width
    antialiasing: true

    x: component ? (component.width - component.paintedWidth) * 0.5 + posX * component.paintedWidth - width * 0.5 : 1
    y: component ? (component.height - component.paintedHeight) * 0.5 + posY * component.paintedHeight - height * 0.5 : 1

    property double xCenter: component ? terminalPoint.component.x + terminalPoint.x + width * 0.5 : 1
    property double yCenter: component ? terminalPoint.component.y + terminalPoint.y + height * 0.5 : 1
    property double xCenterFromComponent: component ? terminalPoint.x + width * 0.5 - terminalPoint.component.width * 0.5 : 1
    property double yCenterFromComponent: component ? terminalPoint.y + height * 0.5 - terminalPoint.component.height * 0.5 : 1

    function updateNetlistIndex(netlistIndex_: int, colorIndex_: int) {
        if(initialIndex === 0) {
            initialIndex = netlistIndex_;
        }
        terminalPoint.netlistIndex = netlistIndex_;
        component.externalNetlistIndex[index] = netlistIndex_;
        if(colorIndex_ !== undefined) {
            colorIndex = colorIndex_;
        }
        propagateNetlistIndex(netlistIndex_, colorIndex);
    }

    function propagateNetlistIndex(netlistIndex_: int, colorIndex_: int) {
        for(var i = 0; i < wires.length; ++i) {
            if(wires[i].node1.netlistIndex !== netlistIndex_)
                wires[i].node1.updateNetlistIndex(netlistIndex_, colorIndex_);
            if(wires[i].node2.netlistIndex !== netlistIndex_)
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
        visible: terminalPoint.selected
        radius: width / 2
        color: "#08D050"
        z: -1
    }

    MouseArea {
        id: mouseArea
        anchors.fill: terminalPoint
        onPressed: {
            terminalPoint.selected = true;
            Activity.terminalPointSelected(terminalPoint);
        }
    }
}
