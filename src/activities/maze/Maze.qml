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
import core 1.0

import "../../core"
import "maze.js" as Activity

ActivityBase {
    id: activity
    property bool relativeMode: false
    property bool invisibleMode: false

    onStart: focus = true
    onStop: {

    }

    Keys.onPressed: (event) => { Activity.processPressedKey(event) }

    pageComponent: Image {
        id: activityBackground
        source: Activity.url + "maze_bg.svg"
        sourceSize.width: parent.width
        anchors.fill: parent
        signal start
        signal stop

        readonly property bool horizontalLayout: layoutArea.width >= layoutArea.height

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias activityBackground: activityBackground
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias mazeRows: maze.rows
            property alias mazeColumns: maze.columns
            property alias mazeRepeater: mazeRepeater.model
            property alias brickSound: brickSound
            property alias message: message
            property int playerx: 0
            property int playery: 0
            property int playerr: 270
            property int doory: 0
            property int cellSize: Math.min(mazeArea.height / mazeRows,
                                            mazeArea.width / mazeColumns)
            property int wallSize: Math.max(2, cellSize * 0.1)
            property bool wallVisible: true
            property bool fastMode: false
            property bool win: false
        }

        onStart: {
            Activity.start(items, relativeMode, invisibleMode)
        }
        onStop: {
            timeAutoMove.stop()
            Activity.stop()
        }

        GCSoundEffect {
            id: brickSound
            source: "qrc:/gcompris/src/core/resource/sounds/brick.wav"
        }

        Item {
            id: layoutArea
            anchors.fill: parent
            anchors.bottomMargin: bar.height * 1.2
        }

        Item {
            id: mazeArea
            anchors.top: layoutArea.top
            anchors.left: layoutArea.left
            anchors.right: layoutArea.right
            anchors.topMargin: activityBackground.horizontalLayout ? 3 * GCStyle.baseMargins : fastmode.height + 2 * GCStyle.baseMargins
            anchors.leftMargin: activityBackground.horizontalLayout ? fastmode.width + 2 * GCStyle.baseMargins : GCStyle.baseMargins
            anchors.rightMargin: anchors.leftMargin
            anchors.bottom: parent.bottom
            anchors.bottomMargin: ApplicationSettings.isBarHidden && activityBackground.horizontalLayout ? 3 * GCStyle.baseMargins : bar.height * 1.2
        }

        Rectangle {
            color: "#E3DEDB"
            anchors.fill: maze
        }

        Grid {
            id: maze
            anchors.verticalCenter: mazeArea.verticalCenter
            anchors.horizontalCenter: mazeArea.horizontalCenter
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
                        radius: height * 0.5
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.topMargin: -items.wallSize * 0.5
                        anchors.leftMargin: -items.wallSize * 0.5
                        color: "#B38B56"
                        visible: modelData & 1 ? items.wallVisible : false
                        z: 1
                    }

                    Rectangle {
                        id: south
                        width: items.cellSize + items.wallSize
                        height: items.wallSize
                        radius: height * 0.5
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.bottomMargin: -items.wallSize * 0.5
                        anchors.leftMargin: -items.wallSize * 0.5
                        color: "#B38B56"
                        visible: modelData & 4 ? items.wallVisible : false
                        z: 1
                    }

                    Rectangle {
                        id: east
                        width: items.wallSize
                        height: items.cellSize + items.wallSize
                        radius: width * 0.5
                        anchors.bottom: parent.bottom
                        anchors.right: parent.right
                        anchors.bottomMargin: -items.wallSize * 0.5
                        anchors.rightMargin: -items.wallSize * 0.5
                        color: "#B38B56"
                        visible: modelData & 8 ? items.wallVisible : false
                        z: 1
                    }

                    Rectangle {
                        id: west
                        width: items.wallSize
                        height: items.cellSize + items.wallSize
                        radius: width * 0.5
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.bottomMargin: -items.wallSize * 0.5
                        anchors.leftMargin: -items.wallSize * 0.5
                        color: "#B38B56"
                        visible: modelData & 2 ? items.wallVisible : false
                        z: 1
                    }
                }
            }
        }

        MultiPointTouchArea {
            anchors.fill: parent
            enabled: !items.win
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
                    if(moveX > GCStyle.baseMargins)
                        Activity.clickRight()
                    else if(moveX < -GCStyle.baseMargins)
                        Activity.clickLeft()
                } else if(Math.abs(moveY) * ApplicationInfo.ratio > 10 &&
                          Math.abs(moveX) < Math.abs(moveY)) {
                    if(moveY > GCStyle.baseMargins)
                        Activity.clickDown()
                    else if(moveY < -GCStyle.baseMargins)
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

        Image {
            id: player
            source: Activity.url + "tux_top_south.svg"
            sourceSize.width: items.cellSize * 0.8
            x: maze.x + items.cellSize * 0.05 + items.wallSize * 0.5 + items.playerx * items.cellSize
            y: maze.y + items.cellSize * 0.20 + items.wallSize * 0.5 + items.playery * items.cellSize
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
            y: maze.y + items.cellSize * 0.05 + items.wallSize * 0.5 + items.doory * items.cellSize
            z: 1
            anchors.right: maze.right
            anchors.rightMargin: items.cellSize * 0.15 + items.wallSize * 0.5
        }

        BarButton {
            id: fastmode
            source: Activity.url + "fast-mode-button.svg"
            width: 66 * ApplicationInfo.ratio
            visible: !message.visible
            x: GCStyle.baseMargins
            y: GCStyle.baseMargins
            onClicked: items.fastMode = !items.fastMode
        }

        BarButton {
            id: switchMaze
            source: Activity.url + "maze-2d-bubble.svg"
            anchors {
                right: parent.right
                top: parent.top
                margins: GCStyle.baseMargins
            }
            width: fastmode.width
            visible: invisibleMode
            onClicked: {
                items.wallVisible = !items.wallVisible
                message.visible = items.wallVisible
            }
        }

        Rectangle {
            anchors.centerIn: message
            width: message.contentWidth + 2 * GCStyle.baseMargins
            height: message.contentHeight
            color: "#D0FFFFFF"
            border.width: 0
            visible: message.visible
        }

        GCText {
            id: message
            anchors {
                left: parent.left
                right: switchMaze.left
                top: parent.top
                leftMargin: GCStyle.baseMargins * 2
                rightMargin: GCStyle.baseMargins * 2
                topMargin: activityBackground.horizontalLayout ? 0 : GCStyle.baseMargins
            }
            height: activityBackground.horizontalLayout ? 3 * GCStyle.baseMargins: fastmode.height
            fontSize: regularSize
            fontSizeMode: Text.Fit
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            visible: false
            wrapMode: Text.Wrap
            text: qsTr("Look at your position, then switch back to invisible mode to continue your moves")
        }

        // A hint to show that you can move by swiping anywhere
        Image {
            anchors {
                right: parent.right
                bottom: parent.bottom
                rightMargin: GCStyle.baseMargins
                bottomMargin: ApplicationSettings.isBarHidden ? GCStyle.baseMargins : bar.height * 1.2
            }
            z: 10
            source: "qrc:/gcompris/src/core/resource/arrows_move.svg"
            sourceSize.width: 40 * ApplicationInfo.ratio
            opacity: bar.level == 1 && ApplicationInfo.isMobile ? 1 : 0
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
