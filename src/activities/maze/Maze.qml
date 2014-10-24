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

import "../../core"
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
        sourceSize.width: parent.width
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
            property GCAudio audioEffects: activity.audioEffects
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
            anchors.topMargin: (parent.height - height) / 2
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

        MouseArea {
            id: clickUp
            x: maze.x + items.playerx * items.cellSize
            y: maze.y + items.playery * items.cellSize - height
            height: items.cellSize
            width: items.cellSize
            onClicked: Activity.clickUp()
        }

        MouseArea {
            id: clickDown
            x: maze.x + items.playerx * items.cellSize
            y: maze.y + items.playery * items.cellSize + player.height
            height: items.cellSize
            width: items.cellSize
            onClicked: Activity.clickDown()
        }

        MouseArea {
            id: clickRight
            x: maze.x + items.playerx * items.cellSize + player.width
            y: maze.y + items.playery * items.cellSize
            height: items.cellSize
            width: items.cellSize
            onClicked: Activity.clickRight()
        }

        MouseArea {
            id: clickLeft
            x: maze.x + items.playerx * items.cellSize - width
            y: maze.y + items.playery * items.cellSize
            height: items.cellSize
            width: items.cellSize
            onClicked: Activity.clickLeft()
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

        BarButton {
            id: switchMaze
            source: Activity.url + "maze-2d-bubble.svg"
            anchors {
                right: bar.left
                bottom: bar.bottom
                bottomMargin: 10
            }
            sourceSize.width: 66 * bar.barZoom
            visible: invisibleMode
            onClicked: {
                items.wallVisible = !items.wallVisible
                message.visible = items.wallVisible
            }
        }

        BarButton {
            id: fastmode
            source: Activity.url + "fast-mode-button.svgz"
            sourceSize.width: 66 * bar.barZoom
            visible: true
            x: 10 * ApplicationInfo.ratio
            y: 10 * ApplicationInfo.ratio
            onClicked: items.fastMode = !items.fastMode
        }

        BarButton {
            id: buttonright
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20 * ApplicationInfo.ratio
            anchors.right: parent.right
            anchors.rightMargin: 20 * ApplicationInfo.ratio
            visible: ApplicationInfo.isMobile && !message.visible
            source: relativeMode ? Activity.url + "button_rotate_right.svg" : "qrc:/gcompris/src/core/resource/bar_next.svgz"
            sourceSize.width: 45 * ApplicationInfo.ratio
            onClicked: Activity.clickRight()
        }

        BarButton {
            id: buttonbottom
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20 * ApplicationInfo.ratio
            anchors.right: buttonright.left
            anchors.rightMargin: 20 * ApplicationInfo.ratio
            visible: ApplicationInfo.isMobile && !message.visible
            source: Activity.url + "button_down.svgz"
            sourceSize.height: 45 * ApplicationInfo.ratio
            onClicked: Activity.clickDown()
        }

        BarButton {
            id: buttontop
            anchors.bottom: buttonbottom.top
            anchors.bottomMargin: 20 * ApplicationInfo.ratio
            anchors.right: buttonright.left
            anchors.rightMargin: 20 * ApplicationInfo.ratio
            visible: ApplicationInfo.isMobile && !message.visible
            source: Activity.url + "button_up.svgz"
            sourceSize.height: 45 * ApplicationInfo.ratio
            onClicked: Activity.clickUp()
        }
        BarButton {
            id: buttonleft
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20 * ApplicationInfo.ratio
            anchors.right: buttonbottom.left
            anchors.rightMargin: 20 * ApplicationInfo.ratio
            visible: ApplicationInfo.isMobile && !message.visible
            source: relativeMode ? Activity.url + "button_rotate_left.svg" : "qrc:/gcompris/src/core/resource/bar_previous.svgz"
            sourceSize.width: 45 * ApplicationInfo.ratio
            onClicked: Activity.clickLeft()
        }

        GCText {
            id: message
            anchors {
                left: parent.left
                bottom: parent.bottom
                margins: 20
            }
            width: activity.width - x - 20
            font.pointSize: 18
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            visible: false
            wrapMode: Text.Wrap
            text: qsTr("Look at your position, then switch back to invisible mode to continue your moves")
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent {
                value: help | home | level
            }
            onHelpClicked: displayDialog(dialogHelp)
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
