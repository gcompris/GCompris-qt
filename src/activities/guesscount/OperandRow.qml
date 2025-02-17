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
    spacing: activityBackground.baseMargins
    Rectangle {
        id: operands
        width: parent.width * 0.3
        height: parent.height
        radius: activityBackground.baseMargins
        color: "#E8E8E8"
        border.color: "#75D21B"  //green
        border.width: activityBackground.tileBorder

        GCText {
            anchors.fill: parent
            anchors.margins: 2 * activityBackground.tileBorder
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            fontSize: mediumSize
            fontSizeMode: Text.Fit
            text: qsTr("Numbers")
        }
    }
    Repeater {
        id: repeater
        delegate: DragTile {
            id: root
            type: "operands"
            width: Math.min(70 * ApplicationInfo.ratio,
                            (operandRow.width - operands.width) * 0.2 - activityBackground.baseMargins)
            height: operandRow.height
        }
    }
}
