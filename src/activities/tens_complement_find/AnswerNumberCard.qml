/* GCompris - AnswerNumberCard.qml
 *
 * SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

import GCompris 1.0
import "../../core"
import "tens_complement_find.js" as Activity

Rectangle {
    id: placeHolder
    height: parent.height
    width: Math.min(placeHolder.height, parent.width / 4)
    anchors.verticalCenter: parent.verticalCenter
    border.width: 2
    border.color: "black"
    color: clickable ? "yellow" : "orange"
    radius: parent.radius

    property bool clickable
    property string text
    property int index
    signal clicked

    GCText {
        anchors.fill: parent
        text: placeHolder.text
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    MouseArea {
        anchors.fill: parent
        enabled: placeHolder.clickable && !items.bonus.isPlaying
        onClicked: {
            Activity.click(index, rowIndex);
        }
    }
}
