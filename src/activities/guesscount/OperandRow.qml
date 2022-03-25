/* GCompris - OperandRow.qml
 *
 * SPDX-FileCopyrightText: 2016 RAHUL YADAV <rahulyadav170923@gmail.com>
 *
 * Authors:
 *   Pascal Georges <pascal.georges1@free.fr> (GTK+ version)
 *   RAHUL YADAV <rahulyadav170923@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import "../../core"

Row {
    id: operandRow
    property alias repeater: repeater
    property int rowSum
    spacing: 20
    Rectangle {
        id: operands
        width: parent.width*0.328
        height: parent.height
        radius: 10
        color: "#75D21B"  //green
        Rectangle {
            id: insideFill
            width: parent.width - anchors.margins
            height: parent.height - anchors.margins
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: parent.height/4
            radius: 10
            color: "#E8E8E8" //paper white
        }
        GCText {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            fontSize: mediumSize
            text: qsTr("Numbers")
        }
    }
    Repeater {
        id: repeater
        delegate: DragTile {
            id: root
            type: "operands"
            width: operandRow.width*0.1
            height: operandRow.height
        }
    }
}
