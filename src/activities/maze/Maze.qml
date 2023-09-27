/* GCompris - maze.qml
*
* SPDX-FileCopyrightText: 2014 Stephane Mankowski <stephane@mankowski.fr>
*
* Authors:
*   Bastiaan Verhoef <b.f.verhoef@student.utwente.nl> (GTK+ version)
*   Stephane Mankowski <stephane@mankowski.fr> (Qt Quick port)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12
import GCompris 1.0

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
        source: Activity.url + "maze_bg.svg"
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
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias mazeRows: maze.rows
            property alias mazeColumns: maze.columns
            property alias mazeRepeater: mazeRepeater.model
            property GCSfx audioEffects: activity.audioEffects
            property alias message: message
            property int playerx: 0
            property int playery: 0
            property int playerr: 270
            property int doory: 0
            property int cellSize: Math.min((parent.height - bar.height * 1.2 - 40) / mazeRows,
                                            (parent.width - 40) / mazeColumns)
            property int wallSize: Math.max(2, cellSize / 10)
            property bool wallVisible: true
            property bool fastMode: false
        }

        onStart: {
            Activity.start(items, relativeMode, invisibleMode)
        }
        onStop: {
            timeAutoMove.stop()
            Activity.stop()
        }

        Rectangle {
            color: "#E3DEDB"
            anchors.fill: maze
        }

        Grid {
            id: maze
            anchors.top: parent.top
            anchors.topMargin: 40
            anchors.horizontalCenter: parent.horizontalCenter
            columns: 1
            rows: 1
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
                        radius: height / 2
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.topMargin: -items.wallSize / 2
                        anchors.leftMargin: -items.wallSize / 2
                        color: "#B38B56"
                        visible: modelData & 1 ? items.wallVisible : false
                        z: 1
                    }

                    Rectangle {
                        id: south
                        width: items.cellSize + items.wallSize
                        height: items.wallSize
                        radius: height / 2
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.bottomMargin: -items.wallSize / 2
                        anchors.leftMargin: -items.wallSize / 2
                        color: "#B38B56"
                        visible: modelData & 4 ? items.wallVisible : false
                        z: 1
                    }

                    Rectangle {
                        id: east
                        width: items.wallSize
                        height: items.cellSize + items.wallSize
                        radius: width / 2
                        anchors.bottom: parent.bottom
                        anchors.right: parent.right
                        anchors.bottomMargin: -items.wallSize / 2
                        anchors.rightMargin: -items.wallSize / 2
                        color: "#B38B56"
                        visible: modelData & 8 ? items.wallVisible : false
                        z: 1
                    }

                    Rectangle {
                        id: west
                        width: items.wallSize
                        height: items.cellSize + items.wallSize
                        radius: width / 2
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.bottomMargin: -items.wallSize / 2
                        anchors.leftMargin: -items.wallSize / 2
                        color: "#B38B56"
                        visible: modelData & 2 ? items.wallVisible : false
                        z: 1
                    }
                }
            }
        }

        MultiPointTouchArea {
            anchors.fill: parent
            touchPoints: [ TouchPoint { id: point1 } ]
            property real startX
            property real startY
            // Workaround to avoid having 2 times the onReleased event
            property bool started

            onPressed: {
                startX = point1.x
                startY = point1.y
                started = true
            }

            onReleased: {
                if(!started)
                    return false
                var moveX = point1.x - startX
                var moveY = point1.y - startY
                // Find the direction with the most move
                if(Math.abs(moveX) * ApplicationInfo.ratio > 10 &&
                   Math.abs(moveX) > Math.abs(moveY)) {
                    if(moveX > 10 * ApplicationInfo.ratio)
                        Activity.clickRight()
                    else if(moveX < -10 * ApplicationInfo.ratio)
                        Activity.clickLeft()
                } else if(Math.abs(moveY) * ApplicationInfo.ratio > 10 &&
                          Math.abs(moveX) < Math.abs(moveY)) {
                    if(moveY > 10 * ApplicationInfo.ratio)
                        Activity.clickDown()
                    else if(moveY < -10 * ApplicationInfo.ratio)
                        Activity.clickUp()
                } else {
                    // No move, just a tap or mouse click
                    if(point1.x > player.x + player.width)
                        Activity.clickRight()
                    else if(point1.x < player.x)
                        Activity.clickLeft()
                    else if(point1.y < player.y)
                        Activity.clickUp()
                    else if(point1.y > player.y + player.height)
                        Activity.clickDown()

                }

                started = false
            }
        }

        // Show an hint to show that can move by swiping anywhere
        Image {
            anchors {
                right: parent.right
                bottom: parent.bottom
                margins: 12
            }
            source: "qrc:/gcompris/src/core/resource/arrows_move.svg"
            sourceSize.width: 140
            opacity: bar.level == 1 && ApplicationInfo.isMobile ? 1 : 0
        }

        Image {
            id: player
            source: Activity.url + "tux_top_south.svg"
            sourceSize.width: items.cellSize * 0.8
            x: maze.x + items.cellSize * 0.05 + items.wallSize / 2 + items.playerx * items.cellSize
            y: maze.y + items.cellSize * 0.20 + items.wallSize / 2 + items.playery * items.cellSize
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

            Image {
                id: shoes
                source: Activity.url + "tux_shoes_top_south.svg"
                sourceSize.width: items.cellSize * 0.8
                anchors.centerIn: parent
                visible: items.fastMode
            }
        }

        Image {
            id: door
            source: Activity.url + "door.svg"
            width: items.cellSize * 0.6
            height: items.cellSize * 0.8
            y: maze.y + items.cellSize * 0.05 + items.wallSize / 2 + items.doory * items.cellSize
            z: 1
            anchors.right: maze.right
            anchors.rightMargin: items.cellSize * 0.15 + items.wallSize / 2
        }

        BarButton {
            id: fastmode
            source: Activity.url + "fast-mode-button.svg"
            sourceSize.width: 66 * bar.barZoom
            visible: !message.visible
            x: 10 * ApplicationInfo.ratio
            y: 10 * ApplicationInfo.ratio
            onClicked: items.fastMode = !items.fastMode
        }

        BarButton {
            id: switchMaze
            source: Activity.url + "maze-2d-bubble.svg"
            anchors {
                right: parent.right
                top: parent.top
                margins: 10
            }
            sourceSize.width: 66 * bar.barZoom
            visible: invisibleMode
            onClicked: {
                items.wallVisible = !items.wallVisible
                message.visible = items.wallVisible
            }
        }

        GCText {
            id: message
            anchors {
                left: parent.left
                right: switchMaze.left
                top: parent.top
                margins: 10
            }
            width: background.width - x - 20
            fontSize: regularSize
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
            level: items.currentLevel + 1
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
