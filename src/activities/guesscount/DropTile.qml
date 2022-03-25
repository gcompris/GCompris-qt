/* GCompris - DropTile.qml
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

DropArea {
    id: dragTarget
    property string type
    property var droppedItem
    keys: [ type ]
    Rectangle {
        id: dropRectangle
        width: parent.width
        height: parent.height
        anchors.fill: parent
        color: type == "operators" ? "#80F16F6F" : "#8075D21B" // red or green
        border.width: 5
        border.color: type == "operators" ? "#FFF16F6F" : "#FF75D21B" // red or green
        radius: 10
        states: [
            State {
                when: dragTarget.containsDrag
                PropertyChanges {
                    target: dropRectangle
                    color: "transparent"
                    border.color: "#80FFFFFF"
                }
            }
        ]
    }
}
