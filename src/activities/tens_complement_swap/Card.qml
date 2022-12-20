/* GCompris - Card.qml
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import "../../core"
import "tens_complement_swap.js" as Activity

Item {
    Rectangle {
        color: type == "numberCard" ? "white" : "transparent"
        height: items.isHorizontal ? (selected ? parent.height : parent.height * 0.8) :
                                (selected || type == "symbolCard" ? parent.height : parent.height * 0.8)
        width: items.isHorizontal ? (selected ? parent.width : parent.width * 0.9) :
                                (selected || type == "symbolCard" ? parent.width : parent.width * 0.9)
        border.width: selected ? 12 : 3
        border.color: type == "numberCard" ? "#9FB8E3" : "transparent"
        radius: 15
        anchors.centerIn: parent

        GCText {
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
            color: "#373737"
            text: value
            wrapMode: Text.WordWrap
            fontSizeMode: Text.Fit
            font.pointSize: Math.max(1, parent.width) // QFont::setPointSizeF: must be greater than 0.
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
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

