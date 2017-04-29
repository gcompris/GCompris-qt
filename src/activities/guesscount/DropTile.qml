/* GCompris - DropTile.qml
 *
 * Copyright (C) 2016 RAHUL YADAV <rahulyadav170923@gmail.com>
 *
 * Authors:
 *   Pascal Georges <pascal.georges1@free.fr> (GTK+ version)
 *   RAHUL YADAV <rahulyadav170923@gmail.com> (Qt Quick port)
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.6

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
