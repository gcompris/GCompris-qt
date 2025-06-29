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
import QtQuick
import "../../core"

DropArea {
    id: dragTarget
    property string type
    property var droppedItem
    keys: [ type ]
    Rectangle {
        id: dropRectangle
        anchors.fill: parent
        color: type == "operators" ? "#80F16F6F" : "#8075D21B" // red or green
        border.width: GCStyle.midBorder
        border.color: type == "operators" ? "#FFF16F6F" : "#FF75D21B" // red or green
        radius: GCStyle.halfMargins
        states: [
            State {
                when: dragTarget.containsDrag
                PropertyChanges {
                    dropRectangle {
                        color: "transparent"
                        border.color: "#80FFFFFF"
                    }
                }
            }
        ]
    }
}
