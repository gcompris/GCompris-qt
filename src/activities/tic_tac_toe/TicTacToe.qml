/* GCompris - TicTacToe.qml
 *
 * SPDX-FileCopyrightText: 2014 Pulkit Gupta <pulkitgenius@gmail.com>
 *
 * Authors:
 *   Pulkit Gupta <pulkitgenius@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

import "../../core"
import "tic_tac_toe.js" as Activity

import GCompris 1.0

ActivityBase {
    id: activity

    property bool twoPlayer: false
    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: Activity.url + "background.svg"
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop
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

            property alias player1score: player1score
            property alias player2score: player2score

            property alias pieces: pieces
            property alias createPiece: createPiece
            property alias repeater: repeater
            property alias columns: grid.columns
            property alias rows: grid.rows
            property alias magnify: magnify
            property alias demagnify: demagnify
            property bool gameDone
            property int counter
            property int playSecond
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
        }

        onStart: Activity.start(items, twoPlayer)
        onStop: Activity.stop()

        Image {
            id: board
            source: Activity.url + "board.svg"
            sourceSize.width: 4 * Math.min(background.width / 4, background.height / 6)
            anchors {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
            }

            ListModel {
                id: pieces
            }

            Grid {
                id: grid
                rows: 3
                columns: 3
                anchors {
                fill: parent
                left: parent.left
                leftMargin: parent.width/18
                top: parent.top
                topMargin: board.width/20
                }
                spacing: board.width/16
                Repeater {
                    id: repeater
                    model: pieces
                    delegate: blueSquare
                    Component {
                        id: blueSquare
                        Rectangle {
                            width: (grid.height/4)*1.1
                            height: (grid.height/4)*1.1
                            border.color: "transparent"
                            border.width: 5
                            radius: 10
                            state: "INITIAL"
                            color: "#c7ecfb"
                            Piece {
                                anchors.fill: parent
                                state: stateTemp
                            }
                            states: [
                                State {
                                    name: "INITIAL"
                                    PropertyChanges {
                                        target: area
                                        visible: true
                                    }
                                },
                                State {
                                    name: "DONE"
                                    PropertyChanges {
                                        target: area;
                                        visible: false;
                                    }
                                }
                            ]
                            MouseArea {
                                id: area
                                enabled: !magnify.running && !items.gameDone
                                hoverEnabled: enabled
                                width: parent.width
                                height: parent.height
                                onEntered: { border.color = "#62db53" }
                                onExited: { border.color = "transparent" }
                                onClicked: { Activity.handleCreate(parent) }
                            }
                        }
                    }
                }
                Piece {
                    id: createPiece
                    state: (items.counter + items.playSecond) % 2 ? "2": "1"
                    width: (grid.height/4)*1.1
                    height: (grid.height/4)*1.1
                    opacity: 0
                }
            }
        }

        PropertyAnimation {
            id: demagnify
            target: createPiece
            properties: "scale"
            from: 1.0
            to: 0.0
            duration: 1
        }
        PropertyAnimation {
            id: magnify
            target: createPiece
            properties: "scale"
            from: 0.0
            to: 1.0
            duration: 1000
            onStarted: activity.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/smudge.wav')
            onStopped: { Activity.continueGame() }
        }

        ScoreItem {
            id: player1score
            player: 1
            height: Math.min(background.height/7, Math.min(background.width/7, bar.height * 1.05))
            width: height*11/8
            anchors {
                top: background.top
                topMargin: 5
                left: background.left
                leftMargin: 5
            }
            playerImageSource: "qrc:/gcompris/src/core/resource/player_1.svg"
            backgroundImageSource: Activity.url + "score_1.svg"
            playerItem.source: Activity.url + "cross.svg"
            playerItem.height: playerItem.parent.height * 0.4
            playerItem.anchors.leftMargin: playerItem.parent.height * 0.15
            playerItem.anchors.bottomMargin: playerItem.parent.height * 0.05
        }

        ScoreItem {
            id: player2score
            player: 2
            height: Math.min(background.height/7, Math.min(background.width/7, bar.height * 1.05))
            width: height*11/8
            anchors {
                top: background.top
                topMargin: 5
                right: background.right
                rightMargin: 5
            }
            playerImageSource: "qrc:/gcompris/src/core/resource/player_2.svg"
            backgroundImageSource: Activity.url + "score_2.svg"
            playerScaleOriginX: player2score.width
            playerItem.source: Activity.url + "circle.svg"
            playerItem.height: playerItem.parent.height * 0.4
            playerItem.anchors.leftMargin: playerItem.parent.height * 0.15
            playerItem.anchors.bottomMargin: playerItem.parent.height * 0.15
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: (twoPlayer ? (help | home | reload) : (help | home | level | reload))}
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onReloadClicked: {
                Activity.reset()
            }
        }

        Bonus {
            id: bonus
        }
    }
}
