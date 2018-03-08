/* GCompris - OperandRow.qml
 *
 * Copyright (C) 2016 RAHUL YADAV <rahulyadav170923@gmail.com>
 *
 * Authors:
 *   Pascal Georges <pascal.georges1@free.fr> (GTK+ version)
 *   RAHUL YADAV <rahulyadav170923@gmail.com> (Qt Quick port)
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */

import QtQuick 2.6
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
