/* GCompris - Card.qml
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-FileCopyrightText: 2024 Harsh Kumar <hadron43@yahoo.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import "../../core"
import "tens_complement_swap.js" as Activity

Item {
    Rectangle {
        color: ["numberCard", "inputCard"].indexOf(type) !== -1 ? "white" : "transparent"
        height: items.isHorizontal ? (selected ? parent.height : parent.height * 0.8) :
                                (selected || type === "symbolCard" ? parent.height : parent.height * 0.8)
        width: items.isHorizontal ? (selected ? parent.width : parent.width * 0.9) :
                                (selected || type === "symbolCard" ? parent.width : parent.width * 0.9)
        border.width: selected ? GCStyle.thickerBorder : GCStyle.thinBorder
        border.color: ["numberCard", "inputCard"].indexOf(type) !== -1 ? "#9FB8E3" : "transparent"
        radius: GCStyle.halfMargins
        anchors.centerIn: parent

        GCText {
            anchors.fill: parent
            anchors.margins: GCStyle.tinyMargins
            color: GCStyle.darkText
            text: value
            wrapMode: Text.WordWrap
            fontSize: largeSize
            fontSizeMode: Text.Fit
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }
    MouseArea {
        anchors.fill: parent
        enabled: selectable && !Activity.items.bonus.isPlaying
        onClicked: {
            selected = true;
            Activity.selectCard({ columnNumber: index, rowNumber: rowNumber, type: type });

            if(type === "inputCard")
                Activity.items.numPad.answer = value;
        }
    }
}
