/* GCompris - OperandRow.qml
 *
 * Copyright (C) 2016 RAHUL YADAV <rahulyadav170923@gmail.com>
 *
 * Authors:
 *   <Pascal Georges> (GTK+ version)
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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.1
import "../../core"

Row {
    id: operandRow
    property alias repeater: repeater
    property int rowSum
    spacing: 20
    Rectangle {
        id: operands
        width: parent.width*0.328;
        height: parent.height
        radius: 20.0;
        color: "green"
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
