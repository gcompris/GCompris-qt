/* GCompris - Admin.qml
 *
 * SPDX-FileCopyrightText: 2016 RAHUL YADAV <rahulyadav170923@gmail.com>
 *
 * Authors:
 *   Pascal Georges <pascal.georges1@free.fr> (GTK+ version)
 *   RAHUL YADAV <rahulyadav170923@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.9
import "../../core"

Row {
    id: admin
    spacing: 20
    property int level
    Rectangle {
        id: operator
        width: parent.width*0.23
        height: parent.height
        radius: 10.0;
        color: "red"
        state: "selected"
        GCText {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            fontSize: smallSize
            text: qsTr("Level %1").arg(level+1)
        }
    }
    Repeater {
        id: tileRepeater
        model: ['+','-','*','/']
        delegate: Rectangle {
            id: tile
            width: parent.width*0.1
            height: parent.height
            radius: 20
            opacity: 0.7
            state: activityConfiguration.adminLevelArr[level].indexOf(modelData) != -1 ? "selected" : "notselected"

            function refreshTile() {
                if(activityConfiguration.adminLevelArr[level].indexOf(modelData) != -1) {
                    state = "selected"
                  }
                else {
                    state = "notselected"
                }
            }
            GCText {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                text: modelData
                fontSize: smallSize
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(tile.state == "selected") {
                        if(activityConfiguration.adminLevelArr[level].length > 1) {
                            tile.state = "notselected"
                            activityConfiguration.adminLevelArr[level].splice(activityConfiguration.adminLevelArr[level].indexOf(modelData), 1)
                        }
                    }
                    else {
                        tile.state = "selected"
                        activityConfiguration.adminLevelArr[level].push(modelData)
                    }
                }
            }
            states: [
                State {
                    name: "selected"
                    PropertyChanges { target: tile; color: "green" }
                },
                State {
                    name: "notselected"
                    PropertyChanges { target: tile; color: "red" }
                }
            ]
        }
    }
    function refreshAllTiles() {
       for(var i = 0; i < tileRepeater.count; i++) {
           tileRepeater.itemAt(i).refreshTile()
       }
    }
}
