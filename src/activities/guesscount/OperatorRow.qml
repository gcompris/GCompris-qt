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

Row {
    id: operatorRow
    spacing: background.baseMargins
    property string mode
    property alias repeater: repeater
    Rectangle {
        id: operator
        width: parent.width * 0.3
        height: parent.height
        radius: background.baseMargins
        color: "#E8E8E8"
        border.color: "#E16F6F"  //red
        border.width: background.tileBorder

        GCText {
            anchors.fill: parent
            anchors.margins: 2 * background.tileBorder
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            fontSize: mediumSize
            fontSizeMode: Text.Fit
            text: qsTr("Operators")
        }
    }

    Repeater {
        id: repeater
        delegate: DragTile {
            id: root
            type: "operators"
            width: Math.min(70 * ApplicationInfo.ratio,
                            (operatorRow.width - operator.width) * 0.25 - background.baseMargins)
            height: operatorRow.height
        }
    }
}
