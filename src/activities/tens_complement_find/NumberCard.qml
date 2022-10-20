/* GCompris - NumberCard.qml
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

import GCompris 1.0
import "../../core"
import "tens_complement_find.js" as Activity

Item {
    Rectangle {
        id: numberRectangle
        visible: visibility
        height: selected ? parent.height : parent.height * 0.9
        width: selected ? parent.width : parent.width * 0.9
        anchors.centerIn: parent
        color: "#FFFB9A"
        border.color: "black"
        border.width: 3
        radius: 15

        GCText {
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
            color: "black"
            text: value
            fontSizeMode: Text.Fit
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        MouseArea {
            anchors.fill: parent
            enabled: !items.bonus.isPlaying
            onClicked: {
                Activity.selectCard(index)
            }
        }
    }
}
