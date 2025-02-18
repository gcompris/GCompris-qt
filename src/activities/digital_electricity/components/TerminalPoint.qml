/* GCompris - TerminalPoint.qml
 *
 * SPDX-FileCopyrightText: 2016 Pulkit Gupta <pulkitnsit@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitnsit@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0

import "../digital_electricity.js" as Activity

Image {
    id: terminalPoint

    property double posX
    property double posY
    property double size: parent ? parent.terminalSize : 1
    property bool selected: false
    property string type
    property int value: 0
    property var wires: []

    width: parent ? size * parent.paintedHeight : 1
    height: width
    source: Activity.url + "tPoint.svg"
    sourceSize.width: width
    sourceSize.height: width
    antialiasing: true

    x: parent ? (parent.width - parent.paintedWidth) * 0.5 + posX * parent.paintedWidth - width * 0.5 : 1
    y: parent ? (parent.height - parent.paintedHeight) * 0.5 + posY * parent.paintedHeight - height * 0.5 : 1

    property double xCenter: parent ? terminalPoint.parent.x + terminalPoint.x + width * 0.5 : 1
    property double yCenter: parent ? terminalPoint.parent.y + terminalPoint.y + height * 0.5 : 1
    property double xCenterFromComponent: parent ? terminalPoint.x + width * 0.5 - terminalPoint.parent.width * 0.5 : 1
    property double yCenterFromComponent: parent ? terminalPoint.y + height * 0.5 - terminalPoint.parent.height * 0.5 : 1

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
            selected = true
            Activity.terminalPointSelected(terminalPoint)
        }
    }
}
