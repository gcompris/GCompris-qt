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

import QtQuick 2.12
import core 1.0

import "../../core"

Row {
    id: admin
    spacing: GCStyle.baseMargins
    property int level
    Rectangle {
        id: operator
        width: parent.width * 0.23
        height: parent.height
        radius: GCStyle.halfMargins
        color: GCStyle.paperWhite
        GCText {
            anchors.fill: parent
            anchors.margins: GCStyle.baseMargins
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            fontSize: mediumSize
            fontSizeMode: Text.Fit
            text: qsTr("Level %1").arg(level+1)
        }
    }
    Repeater {
        id: tileRepeater
        model: ['+','-','*','/']
        delegate: Rectangle {
            id: tile
            width: (parent.width - operator.width - GCStyle.baseMargins) * 0.2 - GCStyle.baseMargins
            height: parent.height
            radius: GCStyle.halfMargins
            border.color: GCStyle.paperWhite
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
                anchors.fill: parent
                anchors.margins: GCStyle.baseMargins
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                text: modelData
                fontSize: mediumSize
                fontSizeMode: Text.Fit
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
                    PropertyChanges {
                        tile {
                            color: "#5cc854"
                            border.width: GCStyle.midBorder
                        }
                    }
                },
                State {
                    name: "notselected"
                    PropertyChanges {
                        tile {
                            color: "#d94444"
                            border.width: 0
                        }
                    }
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
