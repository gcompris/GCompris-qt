/* GCompris - Crane.qml
 *
 * SPDX-FileCopyrightText: 2016 Stefan Toncu <stefan.toncu29@gmail.com>
 * SPDX-FileCopyrightText: 2020 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   <Marc BRUN> (GTK+ version)
 *   Stefan Toncu <stefan.toncu29@gmail.com> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (layout refactoring)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import QtGraphicalEffects 1.0
import GCompris 1.0

import "../../core"
import "crane.js" as Activity

ActivityBase {
    id: activity

    // Overload this in your activity to change it
    // Put you default-<locale>.json files in it
    property string dataSetUrl: "qrc:/gcompris/src/activities/crane/resource/"

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        source: activity.dataSetUrl+"background.svg"
        fillMode: Image.PreserveAspectCrop
        anchors.fill: parent
        sourceSize.width: width
        sourceSize.height: height

        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            dialogActivityConfig.initialize()
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias board: board
            property alias grid: answerGrid
            property alias answerRepeater: answerRepeater
            property alias modelRepeater: modelRepeater
            property alias gridRepeater: gridRepeater
            property alias showGrid1: showGrid1
            property alias score: score
            property int selected
            property int columns
            property int rows
            property bool ok: true
            property int sensivity: 80
            property bool gameFinished: false
            property bool pieceIsMoving: false
            readonly property var levels: activity.datasetLoader.data
            property double gridBaseWidth: items.board.width / items.columns
            property double gridBaseHeight: items.board.height / items.rows
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        property bool portrait: height >= width ? true : false
        property bool inLine: true

        Keys.onPressed: {
            if (event.key === Qt.Key_Left){
                Activity.move("left")
                left.opacity = 0.6
            }
            else if (event.key === Qt.Key_Right){
                Activity.move("right")
                right.opacity = 0.6
            }
            else if (event.key === Qt.Key_Up){
                Activity.move("up")
                up.opacity = 0.6
            }
            else if (event.key === Qt.Key_Down){
                Activity.move("down")
                down.opacity = 0.6
            }
            else if (event.key === Qt.Key_Space ||
                     event.key === Qt.Key_Tab ||
                     event.key === Qt.Key_Enter ||
                     event.key === Qt.Key_Return)
                Activity.move("next")
        }

        Keys.onReleased: {
            up.opacity = 1
            down.opacity = 1
            left.opacity = 1
            right.opacity = 1
        }

        Item {
            id: layoutArea
            anchors.top: background.top
            anchors.bottom: bar.top
            anchors.left: background.left
            anchors.right: background.right
            anchors.bottomMargin: bar.height * 0.2
        }

        //implementation of Swipe effect
        MouseArea {
            anchors.fill: layoutArea
            property int startX;
            property int startY;

            onPressed: {
                startX = mouse.x;
                startY = mouse.y;
            }
            onReleased: Activity.gesture(mouse.x - startX, mouse.y - startY)
        }

        Rectangle {
            id: boardBg
            color: "#77c0d9"
            radius: width * 0.03
            border.color: "#77c0d9"
            border.width: width * 0.02
            z: 1
            clip: true

            anchors {
                top: crane_top.bottom
                bottom: crane_body.top
                right: crane_vertical.left
                margins: 5 * ApplicationInfo.ratio
            }

            width: background.portrait ? (layoutArea.width - crane_vertical.width) * 0.8 : ((layoutArea.width - anchors.margins * 2 - crane_vertical.width) * 0.5 ) * 0.9
        }

        Rectangle {
            id: board
            z: 1
            color: "#b9e2f0"
            anchors.centerIn: boardBg
            width: boardBg.width - boardBg.border.width * 2
            height: boardBg.height - boardBg.border.width * 2
        }

        Grid {
            id: showGrid1
            columns: items.columns
            rows: items.rows
            z: 1
            anchors.centerIn: board
            layer.enabled: ApplicationInfo.useOpenGL
            layer.effect: OpacityMask {
                maskSource: board
            }
            Repeater {
                id: gridRepeater

                Rectangle {
                    width: items.gridBaseWidth
                    height: items.gridBaseHeight
                    color: "transparent"
                    border.width: 2
                    border.color: "#77c0d9"
                }
            }
        }


        Grid {
            id: answerGrid
            columns: items.columns
            rows: items.rows
            z: 4
            anchors.centerIn: board

            Repeater {
                id: answerRepeater

                Image {
                    id: figure
                    sourceSize.height: height
                    sourceSize.width: width
                    width: items.gridBaseWidth
                    height: items.gridBaseHeight
                    fillMode: Image.PreserveAspectFit

                    property int initialIndex: -1

                    property alias anim: anim
                    property int distance
                    property int indexChange
                    property int startPoint
                    property string animationProperty
                    property int _index: index // make current index accessible from outside

                    SequentialAnimation {
                        id: anim
                        PropertyAction { target: items; property: "ok"; value: "false"}
                        NumberAnimation { target: figure; property: figure.animationProperty; from: figure.startPoint; to: figure.startPoint + distance; duration: 200 }
                        PropertyAction { target: figure; property: "opacity"; value: 0 }
                        NumberAnimation { target: figure; property: figure.animationProperty; from: figure.startPoint + distance; to: figure.startPoint; duration: 0; }
                        PropertyAction { target: figure; property: "opacity"; value: 1 }
                        PropertyAction { target: items.answerRepeater.itemAt(items.selected + indexChange); property: "source"; value: figure.source }
                        PropertyAction { target: items.answerRepeater.itemAt(items.selected + indexChange); property: "initialIndex"; value: figure.initialIndex }
                        PropertyAction { target: figure; property: "initialIndex"; value: -1 }
                        PropertyAction { target: figure; property: "source"; value: "" }
                        PropertyAction { target: items; property: "ok"; value: "true"}
                        PropertyAction { target: items; property: "pieceIsMoving"; value: "false"}
                        ScriptAction { script: Activity.checkAnswer() }
                    }

                    MouseArea {
                        anchors.fill: parent

                        // Swipe effect
                        property int startX;
                        property int startY;

                        onPressed: {
                            startX = mouse.x;
                            startY = mouse.y;
                        }

                        onReleased:
                            Activity.gesture(mouse.x - startX, mouse.y - startY)

                        // Select a figure with mouse/touch
                        onClicked: {
                            if (source != "" && !items.pieceIsMoving)
                                items.selected = index
                        }
                    }
                }
            }
        }

        Image {
            id: selected
            source: activity.dataSetUrl+"selected.svg"
            sourceSize.width: width
            sourceSize.height: height
            width: items.gridBaseWidth
            height: items.gridBaseHeight
            opacity: 1

            property var newCoord: answerRepeater.itemAt(items.selected)
            x: newCoord.x + board.x
            y: newCoord.y + board.y
            z: 100

            Behavior on x { NumberAnimation { duration: 200 } }
            Behavior on y { NumberAnimation { duration: 200 } }

        }

        Rectangle {
            id: modelBoardBg
            color: "#e294b7"
            radius: width * 0.03
            border.color: "#e294b7"
            border.width: width * 0.02
            z: 1

            anchors {
                left: background.portrait ? boardBg.left : crane_vertical.right
                top: background.portrait ? crane_body.bottom : background.inLine ? boardBg.top : parent.top
                topMargin: background.portrait ? boardBg.anchors.margins : background.inLine ? 0 : crane_top.height * 1.5
                leftMargin: background.portrait ? 0 : boardBg.anchors.margins * 1.2
                margins: boardBg.anchors.margins
            }

            width: boardBg.width
            height: boardBg.height
        }

        Rectangle {
            id: modelBoard
            z: 1
            color: "#f0b9d2"
            anchors.centerIn: modelBoardBg
            width: board.width
            height: board.height
        }

        Grid {
            id: modelGrid
            columns: items.columns
            rows: items.rows
            anchors.centerIn: modelBoard
            z: 4

            Repeater {
                id: modelRepeater

                Image {
                    id: modelFigure
                    sourceSize.height: height
                    sourceSize.width: width
                    width: items.gridBaseWidth
                    height: items.gridBaseHeight
                    fillMode: Image.PreserveAspectFit
                }
            }
        }

        Grid {
            id: showGrid2
            columns: items.columns
            rows: items.rows
            z: 1
            opacity: showGrid1.opacity
            anchors.centerIn: modelBoard
            layer.enabled: ApplicationInfo.useOpenGL
            layer.effect: OpacityMask {
                maskSource: modelBoard
            }
            Repeater {
                id: gridRepeater2
                model: gridRepeater.model

                Rectangle {
                    width: items.gridBaseWidth
                    height: items.gridBaseHeight
                    color: "transparent"
                    border.width: 2
                    border.color: showGrid1.opacity == 1 ? "#e294b7" : "transparent"
                }
            }
        }


        Image {
            id: crane_top
            source: activity.dataSetUrl+"crane_up.svg"
            sourceSize.width: width
            width: background.portrait ? layoutArea.width * 0.8: layoutArea.width * 0.5
            fillMode: Image.PreserveAspectFit
            z: 4
            anchors {
                top: layoutArea.top
                right: crane_vertical.right
                rightMargin: 0
                margins: boardBg.anchors.margins
            }
        }

        Image {
            id: crane_vertical
            source: activity.dataSetUrl+"crane_vertical.svg"
            sourceSize.height: height
            fillMode: Image.PreserveAspectFit
            anchors {
                top: crane_top.top
                bottom: crane_body.verticalCenter
                right: background.portrait ? layoutArea.right : layoutArea.horizontalCenter
                rightMargin: background.portrait ? width / 2 : - width / 2
                topMargin: boardBg.anchors.margins
            }
        }

        Image {
            id: crane_body
            source: activity.dataSetUrl+"crane_only.svg"
            z: 2
            height: bar.height
            sourceSize.height: height
            fillMode: Image.PreserveAspectFit
            mirror: background.portrait ? true : false
            anchors.verticalCenterOffset: crane_top.height * 0.5
        }

        Image {
            id: crane_command
            source: activity.dataSetUrl+"command.svg"
            sourceSize.height: height
            anchors.margins: 5 * ApplicationInfo.ratio
            fillMode: Image.PreserveAspectFit
            Controls {
                id: up
                source: activity.dataSetUrl+"arrow_up.svg"
                anchors {
                    right: parent.horizontalCenter
                    rightMargin: width * 1.15
                }
                command: "up"
            }

            Controls {
                id: down
                source: activity.dataSetUrl+"arrow_down.svg"
                anchors {
                    right: parent.horizontalCenter
                    rightMargin: width * 0.1
                }
                command: "down"
            }

            Controls {
                id: left
                source: activity.dataSetUrl+"arrow_left.svg"
                anchors {
                    left: parent.horizontalCenter
                    leftMargin: width * 0.1
                }
                command: "left"
            }

            Controls {
                id: right
                source: activity.dataSetUrl+"arrow_right.svg"
                anchors {
                    left: parent.horizontalCenter
                    leftMargin: width * 1.15
                }
                command: "right"
            }
        }

        Rectangle {
            id: cable
            color: "#373737"
            width: 5
            height: convert.y + board.y - crane_top.y
            x: convert.x + board.x + items.gridBaseWidth / 2
            z: 3
            anchors.top: crane_top.top
            anchors.topMargin: 10

            property var convert: answerRepeater.itemAt(items.selected)

            Behavior on x { NumberAnimation { duration: 200 } }
            Behavior on height { NumberAnimation { duration: 200 } }
        }

        states: [
            State {
                name: "horizontal"
                when: !background.portrait
                PropertyChanges{
                    target: crane_command
                    width: boardBg.width
                }
                AnchorChanges{
                    target: crane_body
                    anchors.left: crane_vertical.left
                    anchors.right: undefined
                    anchors.bottom: layoutArea.bottom
                    anchors.verticalCenter: undefined
                }
                AnchorChanges{
                    target: score
                    anchors.right: modelBoardBg.right
                    anchors.bottom: undefined
                    anchors.verticalCenter: crane_body.verticalCenter
                    anchors.left: undefined
                }
                AnchorChanges{
                    target:crane_command
                    anchors.top: boardBg.bottom
                    anchors.bottom: crane_body.bottom
                    anchors.right: undefined
                    anchors.left: undefined
                    anchors.horizontalCenter: boardBg.horizontalCenter
                }
            },
            State {
                name: "vertical"
                when: background.portrait
                PropertyChanges{
                    target: crane_command
                    width: undefined
                }
                AnchorChanges{
                    target: crane_body
                    anchors.left: undefined
                    anchors.right: crane_vertical.right
                    anchors.bottom: undefined
                    anchors.verticalCenter: layoutArea.verticalCenter
                }
                AnchorChanges{
                    target: score
                    anchors.right: undefined
                    anchors.bottom: undefined
                    anchors.verticalCenter: crane_body.verticalCenter
                    anchors.left: layoutArea.left
                }
                AnchorChanges{
                    target:crane_command
                    anchors.top: boardBg.bottom
                    anchors.bottom: modelBoardBg.top
                    anchors.right: crane_body.left
                    anchors.left: score.right
                    anchors.horizontalCenter: undefined
                }
            }
        ]


        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo
            onClose: {
                home()
            }

            onSaveData: {
                levelFolder = dialogActivityConfig.chosenLevels
                currentActivity.currentLevels = dialogActivityConfig.chosenLevels
                ApplicationSettings.setCurrentLevels(currentActivity.name, dialogActivityConfig.chosenLevels)
            }

            onStartActivity: {
                background.stop()
                background.start()
            }
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level | activityConfig}
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig)
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextSubLevel)
        }

        Score {
            id: score
            visible: true
            anchors.right: modelBoardBg.right
            anchors.margins: 5 * ApplicationInfo.ratio
        }
    }

}
