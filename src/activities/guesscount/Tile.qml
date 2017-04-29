/* GCompris - Tile.qml
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
import "guesscount.js" as Activity
import "../../core"

MouseArea {
    id: mouseArea
    property alias tile: tile
    property alias datavalue: tile.datavalue
    property var reparent: root
    width: root.width
    height: root.height
    anchors.centerIn: parent
    drag.target: tile
    onReleased: {
        parent = tile.Drag.target != null ? tile.Drag.target : root
        tile.Drag.drop()
    }
    onParentChanged: {
        if(parent.children.length>2 && root.type == "operators")
            mouseArea.destroy()
    }

    onClicked: {
        if(Activity.items.warningDialog.visible)
            Activity.items.warningDialog.visible = false
    }
    Rectangle {
        id: tile
        width: parent.width
        height: parent.height
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        property var datavalue: modelData
        radius: 10
        //opacity: 0.7
        //color: root.type == "operators" ? "red" : "green"
        color: "#E8E8E8"
        Drag.keys: [ type ]
        Drag.active: mouseArea.drag.active
        Drag.hotSpot.x: parent.width/2
        Drag.hotSpot.y: parent.height/2
        
        Rectangle {
            id: typeLine
            width: parent.width - anchors.margins
            height: parent.height - anchors.margins
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: parent.height/8
            radius: 10
            color: root.type == "operators" ? "#E16F6F" : "#75D21B" // red or green
        }
        
        Rectangle {
            id: insideFill
            width: parent.width - anchors.margins
            height: parent.height - anchors.margins
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: parent.height/4
            radius: 10
            color: "#E8E8E8" //paper white
        }
        
        
        GCText {
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
            },
            State {
                when: Activity.items.warningDialog.visible
                PropertyChanges {
                    target: mouseArea
                    enabled: false
                }
            }
        ]
    }
}
