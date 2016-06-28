/* GCompris - guesscount.qml
 *
 * Copyright (C) 2016 RAHUL YADAV <rahulyadav170923@gmail.com>
 *
 * Authors:
 *   <PASCAL GEORGES> (V13.11)
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
import QtQuick 2.1

import "../../core"
import "guesscount-summer.js" as Activity

Item {
    id: root
    property string type
    MouseArea {
        id: mouseArea
        property alias reparent: root
        property alias tile: tile
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        drag.target: tile
        onReleased:{
            parent = tile.Drag.target !== null ? tile.Drag.target : root
            tile.Drag.drop()
        }
        Rectangle {
            id: tile
            width: parent.width; height: parent.height
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            property var datavalue: modelData
            radius: 20
            opacity: 0.7
            color: root.type == "operators" ? "red" : "green"
            Drag.keys: [ type ]
            Drag.active: mouseArea.drag.active
            Drag.hotSpot.x: parent.width/2
            Drag.hotSpot.y: parent.height/2
            GCText{
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                text: modelData
                fontSize: mediumSize
            }
            states: [
                State {
                    when: mouseArea.drag.active
                    ParentChange { target: tile; parent: root }
                    AnchorChanges { target: tile; anchors.verticalCenter: undefined; anchors.horizontalCenter: undefined }
                }
            ]
        }
    }
}
