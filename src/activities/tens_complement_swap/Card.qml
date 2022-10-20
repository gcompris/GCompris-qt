/* GCompris - Card.qml
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import "../../core"
import "tens_complement_swap.js" as Activity

Item {
    property color containerColor
    readonly property color numberCardColor: "#FFFB9A"
    readonly property color numberCardBorderColor: "black"
    Rectangle {
        color: type == "numberCard" || type == "resultCard" ? numberCardColor : containerColor
        height: selected ? parent.height : parent.height * 0.8
        width: selected ? parent.width : parent.width * 0.9
        border.width: 2
        border.color: (type == "numberCard" || type == "resultCard") ? numberCardBorderColor : containerColor
        radius: 20
        anchors.centerIn: parent

        GCText {
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
            color: "black"
            text: value
            wrapMode: Text.WordWrap
            fontSizeMode: Text.Fit
            font.pointSize: parent.width + 1 // QFont::setPointSizeF: must be greater than 0.
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        MouseArea {
            anchors.fill: parent
            enabled: selectable && !Activity.items.bonus.isPlaying
            onClicked: {
                selected = true;
                Activity.selectCard({ columnNumber: index, rowNumber: rowNumber })
            }
        }
    }
}

