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
    spacing: baseMargins
    property int level
    readonly property int baseMargins: 10 * ApplicationInfo.ratio
    Rectangle {
        id: operator
        width: parent.width * 0.23
        height: parent.height
        radius: admin.baseMargins
        color: "#E6E6E6"
        GCText {
            anchors.fill: parent
            anchors.margins: admin.baseMargins
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
            width: (parent.width - operator.width - admin.baseMargins) * 0.2 - admin.baseMargins
            height: parent.height
            radius: admin.baseMargins
            border.color: "#E6E6E6"
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
                anchors.margins: admin.baseMargins
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
                            border.width: 3 * ApplicationInfo.ratio
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
