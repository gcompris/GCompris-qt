/* GCompris - Tile.qml
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

MouseArea {
    id: mouseArea
    property alias tile: tile
    property alias datavalue: tile.datavalue
    property var reparent: root
    width: parent.width
    height: parent.height
    anchors.centerIn: parent
    drag.target: tile
    enabled: !items.solved
    onReleased: {
        parent = tile.Drag.target != null ? tile.Drag.target : root
        tile.Drag.drop()
    }
    onParentChanged: {
        if(parent.children.length > 2 && root.type == "operators")
            mouseArea.destroy()
    }

    Rectangle {
        id: tile
        width: parent.width
        height: parent.height
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        property var datavalue: modelData
        radius: GCStyle.halfMargins
        color: GCStyle.paperWhite
        Drag.keys: [ type ]
        Drag.active: mouseArea.drag.active
        Drag.hotSpot.x: parent.width * 0.5
        Drag.hotSpot.y: parent.height * 0.5
        
        Rectangle {
            id: typeLine
            anchors.fill: parent
            anchors.margins: GCStyle.midBorder
            radius: parent.radius - anchors.margins
            color: root.type == "operators" ? "#E16F6F" : "#75D21B" // red or green
        }
        
        Rectangle {
            id: insideFill
            anchors.fill: parent
            anchors.margins: typeLine.anchors.margins * 2
            radius: 0
            color: GCStyle.paperWhite
        }
        
        
        GCText {
            anchors.fill: insideFill
            text: modelData
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            fontSize: mediumSize
            fontSizeMode: Text.Fit
        }
        states: [
            State {
                when: mouseArea.drag.active
                ParentChange { target: tile; parent: root }
                AnchorChanges { target: tile; anchors.verticalCenter: undefined; anchors.horizontalCenter: undefined }
            },
            State {
                when: items.warningDialog.visible
                PropertyChanges {
                    mouseArea {
                        enabled: false
                    }
                }
            }
        ]
    }
}
