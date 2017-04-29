/* GCompris - OperatorRow.qml
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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */


import QtQuick 2.6
import "../../core"
import "guesscount.js" as Activity

Row {
    id: operatorRow
    spacing: 20
    property string mode
    property var operators
    property int level
    property alias repeater: repeater
    Rectangle {
        id: operator
        width: parent.width*0.328
        height: parent.height
        radius: 20.0;
        color: "#E16F6F"  //red
        Rectangle {
            id: insideFill
            width: parent.width - anchors.margins
            height: parent.height - anchors.margins
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: parent.height/4
            radius: 10
            color: "#E8E8E8"
        }
        GCText {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            fontSize: mediumSize
            text: qsTr("Operators")
        }
    }
    Repeater {
        id: repeater
        model: mode == "builtin" ? Activity.defaultOperators[level] : operators[level]
        delegate: DragTile {
            id: root
            type: "operators"
            width: operatorRow.width * 0.1
            height: operatorRow.height
        }
    }
}
