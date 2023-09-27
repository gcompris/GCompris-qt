/* GCompris - bargame.qml
 *
 * SPDX-FileCopyrightText: 2016 UTKARSH TIWARI <iamutkarshtiwari@kde.org>
 *
 * Authors:
 *   Yves Combe (GTK+ version)
 *   UTKARSH TIWARI <iamutkarshtiwari@kde.org> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "bargame.js" as Activity

ActivityBase {
    id: activity
    property int gameMode: 1

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: rootWindow
        source: Activity.url + "background.svg"
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop
        signal start
        signal stop
        property bool horizontalLayout: background.width >= background.height

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property int numberOfBalls: 1
            property alias answerBallsPlacement: answerBallsPlacement
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias okArea: okArea

            property alias trigTuxMove: trigTuxMove

            property alias player1score: player1score
            property alias player2score: player2score

            property int mode: 1
            property int gridSize: (horizontalLayout ? rootWindow.width : (rootWindow.height - bar.height * 1.2)) / Activity.levelsProperties[items.mode - 1].boardSize
            property bool isPlayer1Beginning: true
            property bool isPlayer1Turn: true
        }

        onStart: {
            Activity.start(items, gameMode);
            Activity.calculateWinPlaces();
        }
        onStop: { Activity.stop() }

        // Tux move delay
        Timer {
            id: trigTuxMove
            repeat: false
            interval: 1500
            onTriggered: Activity.machinePlay()
        }

        // Tux image
        Image {
            id: tux
            visible: gameMode == 1
            source: "qrc:/gcompris/src/activities/ballcatch/resource/tux.svg"
            height: rootWindow.height * 0.2
            width: tux.height
            y: rootWindow.height * 0.4
            anchors {
                right: rootWindow.right
                rightMargin: 23 * ApplicationInfo.ratio

            }
            MouseArea {
                id: tuxArea
                hoverEnabled: enabled
                enabled: gameMode == 1 && !answerBallsPlacement.children[0].visible
                anchors.fill: parent
                onClicked: {
                    items.isPlayer1Turn = false;
                    Activity.machinePlay();
                }
            }
            states: State {
                name: "tuxHover"
                when: tuxArea.containsMouse
                PropertyChanges {
                    target: tux
                    scale: 1.1
                }
            }
        }

        // Box row
        Item {
            id: boxModel

            states: [
                State {
                    name: "horizontalBar"
                    when: horizontalLayout
                    PropertyChanges { target: boxModel; x: 0; y: rootWindow.height - bar.height * 2}
                },
                State {
                    name: "verticalBar"
                    when: !horizontalLayout
                    PropertyChanges { target: boxModel; x: rootWindow.width * 0.5; y: 0}
                }
            ]

            transform: Rotation {
                origin.x: 0;
                origin.y: 0;
                angle: horizontalLayout ? 0 : 90
            }

            // The empty boxes grid
            Grid {
                id: boxes
                rows: 1
                columns: Activity.levelsProperties[items.mode - 1].boardSize
                anchors.centerIn: boxModel.Center
                Repeater {
                    id: startCase
                    model: boxes.columns
                    Image {
                        id: greenCase
                        source: Activity.url + ((index == boxes.columns - 1) ? "case_last.svg" : "case.svg")
                        sourceSize.width: items.gridSize
                        width: sourceSize.width
                        height: sourceSize.width
                        visible: true
                    }
                }
            }

            // Hidden Answer Balls
            Grid {
                // All green balls placement
                id: answerBallsPlacement
                anchors.centerIn: boxModel.Center
                columns: Activity.levelsProperties[items.mode - 1].boardSize
                rows: 1
                Repeater {
                    model: answerBallsPlacement.columns
                    Image {
                        source: Activity.url + "ball_1.svg"
                        sourceSize.width: items.gridSize
                        width: sourceSize.width
                        height: sourceSize.width
                        visible: false
                    }
                }
            }

            // Masks
            Grid {
                id: masks
                anchors.centerIn: boxModel.Center
                rows: 1
                columns: Activity.levelsProperties[items.mode - 1].boardSize
                Repeater {
                    id: startMask
                    model: masks.columns
                    Image {
                        id: greenMask
                        source: Activity.url + ((index == boxes.columns - 1) ? "mask_last.svg" : "mask.svg")
                        sourceSize.width: items.gridSize
                        width: sourceSize.width
                        height: sourceSize.width
                        // Numbering label
                        Rectangle {
                            id: bgNbTxt
                            visible: ((index + 1) % 5 == 0 && index > 0) ? true : false
                            color: "#42FFFFFF"
                            height: numberText.height * 1.2
                            width: height
                            radius: height / 2
                            anchors {
                                horizontalCenter: parent.horizontalCenter
                                bottom: parent.top
                                bottomMargin: (horizontalLayout ? 4 * ApplicationInfo.ratio : -16 * ApplicationInfo.ratio)
                            }
                            GCText {
                                id: numberText
                                text: index + 1
                                color: "#373737"
                                fontSize: smallSize
                                font.bold: true
                                visible: ((index + 1) % 5 == 0 && index > 0) ? true : false
                                anchors {
                                    horizontalCenter: bgNbTxt.horizontalCenter
                                    verticalCenter: bgNbTxt.verticalCenter
                                }
                            }
                            transform: Rotation {
                                angle: horizontalLayout ? 0 : -90
                            }
                        }
                    }
                }
            }
        }

        // ok button
        Image {
            id: playLabel
            width: ballNumberPlate.height
            height: width
            sourceSize.width: width
            sourceSize.height: width
            source: Activity.url + "bar_ok.svg"
            anchors {
                left: ballNumberPlate.right
                verticalCenter: ballNumberPlate.verticalCenter
                leftMargin: width / 4
            }

            MouseArea {
                id: okArea
                anchors.fill: parent
                hoverEnabled: enabled
                enabled: true
                onClicked: {
                    var value = items.numberOfBalls
                    if (gameMode == 1 || items.isPlayer1Turn) {
                        Activity.play(1, value);
                    } else {
                        Activity.play(2, value);
                    }
                    // reset next action
                    items.numberOfBalls = Activity.levelsProperties[items.mode - 1].minNumberOfBalls
                }
            }
            states: State {
                name: "mouseHover"
                when: okArea.containsMouse
                PropertyChanges {
                    target: playLabel
                    scale: 1.2
                }
            }
        }

        // Number of balls to be placed
        Image {
            id: ballNumberPlate
            y: rootWindow.height * 0.32
            source: items.isPlayer1Turn ? Activity.url + "score_1.svg" :
                                          Activity.url + "score_2.svg"
            width: bar.height
            height: bar.height * 0.7
            sourceSize.width: width
            sourceSize.height: height

            anchors {
                left: rootWindow.left
                leftMargin: 16 * ApplicationInfo.ratio
            }

            MouseArea {
                id: numberPlateArea
                anchors.fill: parent
                hoverEnabled: enabled
                enabled: (gameMode == 1 && items.isPlayer1Turn == false) ? false : true
                onClicked: {
                    items.numberOfBalls ++;
                    var max = Activity.levelsProperties[items.mode - 1].maxNumberOfBalls
                    if (items.numberOfBalls > max) {
                        items.numberOfBalls = Activity.levelsProperties[items.mode - 1].minNumberOfBalls;
                    }
                }
            }
            states: State {
                name: "numberHover"
                when: numberPlateArea.containsMouse
                PropertyChanges {
                    target: ballNumberPlate
                    scale: 1.1
                }
            }

            // Ball Icon
            Image {
                id: ballIcon
                source: items.isPlayer1Turn ? Activity.url + "ball_1b.svg" :
                                              Activity.url + "ball_2b.svg"
                sourceSize.width: parent.height * 0.8
                width: sourceSize.width
                height: sourceSize.width
                anchors {
                    verticalCenter: ballNumberPlate.verticalCenter
                    left: ballNumberPlate.left
                    leftMargin: 10
                }
            }
            // Number label
            GCText {
                id: numberLabel
                text: items.numberOfBalls
                color: "#C04040"
                font.bold: true
                fontSize: smallSize
                anchors {
                    right: ballNumberPlate.right
                    rightMargin: 10
                    verticalCenter: ballNumberPlate.verticalCenter
                }
            }
        }

        ScoreItem {
            id: player1score
            player: 1
            height: Math.min(rootWindow.height/7, Math.min(rootWindow.width/7, bar.height * 1.05))
            width: height*11/8
            anchors {
                top: rootWindow.top
                topMargin: 5
                left: rootWindow.left
                leftMargin: 5
            }
            playerImageSource: "qrc:/gcompris/src/core/resource/player_1.svg"
            backgroundImageSource: Activity.url + "score_1.svg"
            playerItem.source: Activity.url + "ball_1b.svg"
            playerItem.height: playerItem.parent.height * 0.3
            playerItem.anchors.leftMargin: playerItem.parent.height * 0.05
            playerItem.anchors.bottomMargin: playerItem.parent.height * 0.05
        }

        ScoreItem {
            id: player2score
            player: 2
            height: Math.min(rootWindow.height/7, Math.min(rootWindow.width/7, bar.height * 1.05))
            width: height*11/8
            anchors {
                top: rootWindow.top
                topMargin: 5
                right: rootWindow.right
                rightMargin: 5
            }
            playerImageSource: "qrc:/gcompris/src/core/resource/player_2.svg"
            backgroundImageSource: Activity.url + "score_2.svg"
            playerScaleOriginX: player2score.width
            playerItem.source: Activity.url + "ball_2b.svg"
            playerItem.height: playerItem.parent.height * 0.3
            playerItem.anchors.leftMargin: playerItem.parent.height * 0.05
            playerItem.anchors.bottomMargin: playerItem.parent.height * 0.10
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo

            onClose: home()

            onLoadData: {
                if(activityData && activityData["mode"]) {
                    items.mode = activityData["mode"];
                }
            }
            onStartActivity: {
                rootWindow.stop()
                rootWindow.start()
            }
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level | reload | activityConfig }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig)
            }
            onReloadClicked: Activity.restartLevel()
        }

        Bonus {
            id: bonus
        }
    }
}
