/* GCompris - OperatorRow.qml
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
import "guesscount.js" as Activity

Row {
    id: operatorRow
    spacing: 20
    property string mode
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
        delegate: DragTile {
            id: root
            type: "operators"
            width: operatorRow.width * 0.1
            height: operatorRow.height
        }
    }
}
