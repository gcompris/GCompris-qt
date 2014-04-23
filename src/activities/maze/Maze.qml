/* GCompris - maze.qml
*
* Copyright (C) 2014 Stephane Mankowski <stephane@mankowski.fr>
*
* Authors:
*   Bastiaan Verhoef <b.f.verhoef@student.utwente.nl> (GTK+ version)
*   Stephane Mankowski <stephane@mankowski.fr> (Qt Quick port)
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
import GCompris 1.0
import QtMultimedia 5.0

import "qrc:/gcompris/src/core"
import "maze.js" as Activity

ActivityBase {
    id: activity
    property bool relativeMode: false
    property bool invisibleMode: false

    onStart: focus = true
    onStop: {

    }

    Keys.onPressed: Activity.processPressedKey(event)

    pageComponent: Image {
        id: background
        source: Activity.url + "maze_bg.svgz"
        anchors.fill: parent
        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias mazeRows: maze.rows
            property alias mazeColumns: maze.columns
            property alias mazeRepeater: mazeRepeater.model
            property alias playBrick: playBrick
            property alias message: message
            property int playerx: 0
            property int playery: 0
            property int playerr: 270
            property int doory: 0
            property int cellSize: Math.min((parent.height - 200) / mazeRows,
                                            (parent.width - 40) / mazeColumns)
            property int wallSize: cellSize / 10
            property bool wallVisible: true
            property bool fastMode: false
        }

        onStart: {
            Activity.start(items, relativeMode, invisibleMode)
        }
        onStop: {
            Activity.stop()
        }

        Rectangle {
            color: "white"
            anchors.fill: maze
        }

        Grid {
            id: maze
            anchors.top: parent.top
            anchors.topMargin: 50
            anchors.horizontalCenter: parent.horizontalCenter
            columns: 0
            rows: 0
            spacing: 0

            Repeater {
                id: mazeRepeater
                Item {
                    width: items.cellSize
                    height: items.cellSize
                    Rectangle {
                        id: north
                        width: items.cellSize + items.wallSize
                        height: items.wallSize
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.topMargin: -items.wallSize / 2
                        anchors.leftMargin: -items.wallSize / 2
                        color: "black"
                        visible: modelData & 1 ? items.wallVisible : false
                        z: 1
                    }

                    Rectangle {
                        id: south
                        width: items.cellSize + items.wallSize
                        height: items.wallSize
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.bottomMargin: -items.wallSize / 2
                        anchors.leftMargin: -items.wallSize / 2
                        color: "black"
                        visible: modelData & 4 ? items.wallVisible : false
                        z: 1
                    }

                    Rectangle {
                        id: east
                        width: items.wallSize
                        height: items.cellSize + items.wallSize
                        anchors.bottom: parent.bottom
                        anchors.right: parent.right
                        anchors.bottomMargin: -items.wallSize / 2
                        anchors.rightMargin: -items.wallSize / 2
                        color: "black"
                        visible: modelData & 8 ? items.wallVisible : false
                        z: 1
                    }

                    Rectangle {
                        id: west
                        width: items.wallSize
                        height: items.cellSize + items.wallSize
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.bottomMargin: -items.wallSize / 2
                        anchors.leftMargin: -items.wallSize / 2
                        color: "black"
                        visible: modelData & 2 ? items.wallVisible : false
                        z: 1
                    }
                }
            }
        }

        Image {
            id: player
            source: Activity.url + "tux_top_south.svg"
            sourceSize.width: items.cellSize * 0.8
            x: maze.x + items.cellSize * 0.05 + items.wallSize / 2 + items.playerx * items.cellSize
            y: maze.y + items.cellSize * 0.05 + items.wallSize / 2 + items.playery * items.cellSize
            z: 2
            rotation: items.playerr
            Timer {
                id: timeAutoMove
                interval: 10
                running: false
                repeat: false
                onTriggered: Activity.autoMove()
            }

            Behavior on x {
                SequentialAnimation {
                    NumberAnimation {
                        duration: 100
                    }
                    ScriptAction {
                        script: timeAutoMove.running = true
                    }
                }
            }
            Behavior on y {
                SequentialAnimation {
                    NumberAnimation {
                        duration: 100
                    }
                    ScriptAction {
                        script: timeAutoMove.running = true
                    }
                }
            }
            Behavior on rotation {
                PropertyAnimation {
                    duration: 100
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    items.fastMode = !items.fastMode
                }
            }

            Image {
                id: shoes
                source: Activity.url + "tux_shoes_top_south.svgz"
                sourceSize.width: items.cellSize * 0.8
                anchors.centerIn: parent
                visible: items.fastMode
            }
        }

        Image {
            id: door
            source: Activity.url + "door.png"
            width: items.cellSize * 0.8
            height: items.cellSize * 0.8
            y: maze.y + items.cellSize * 0.05 + items.wallSize / 2 + items.doory * items.cellSize
            z: 1
            anchors.right: maze.right
            anchors.rightMargin: items.cellSize * 0.05 + items.wallSize / 2
        }

        Image {
            id: fastmode
            source: Activity.url + "fast-mode-button.svgz"
            sourceSize.width: 66 * ApplicationInfo.ratio
            x: 10
            y: 10
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    items.fastMode = !items.fastMode
                }
            }
        }

        Text {
            id: message
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: maze.bottom
            anchors.topMargin: 5
            font.pointSize: 18
            visible: false
        }

        Audio {
            id: playBrick
            source: "qrc:/gcompris/src/core/resource/sounds/brick.wav"
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent {
                value: help | home | previous | next
            }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }
}
