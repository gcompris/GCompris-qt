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
import GCompris 1.0

import "../digital_electricity.js" as Activity

Image {
    id: terminalPoint

    property double posX
    property double posY
    property double size: parent.terminalSize
    property bool selected: false
    property string type
    property int value: 0
    property var wires: []

    width: size * parent.paintedHeight
    height: width
    source: Activity.url + "tPoint.svg"
    sourceSize.width: width
    sourceSize.height: width
    antialiasing: true

    x: (parent.width - parent.paintedWidth) / 2 + posX * parent.paintedWidth - width / 2
    y: (parent.height - parent.paintedHeight) / 2 + posY * parent.paintedHeight - height / 2

    property double xCenter: terminalPoint.parent.x + terminalPoint.x + width/2
    property double yCenter: terminalPoint.parent.y + terminalPoint.y + height/2
    property double xCenterFromComponent: terminalPoint.x + width/2 - terminalPoint.parent.width / 2
    property double yCenterFromComponent: terminalPoint.y + height/2 - terminalPoint.parent.height / 2

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
