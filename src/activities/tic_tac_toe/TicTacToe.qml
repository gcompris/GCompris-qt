/* GCompris - TicTacToe.qml
 *
 * SPDX-FileCopyrightText: 2014 Pulkit Gupta <pulkitgenius@gmail.com>
 *
 * Authors:
 *   Pulkit Gupta <pulkitgenius@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
pragma ComponentBehavior: Bound

import QtQuick

import "../../core"
import "tic_tac_toe.js" as Activity

import core 1.0

ActivityBase {
    id: activity

    property bool twoPlayer: false
    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: activityBackground
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
            property alias activityBackground: activityBackground

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

        onStart: Activity.start(items, activity.twoPlayer)
        onStop: Activity.stop()

        GCSoundEffect {
            id: smudgeSound
            source: "qrc:/gcompris/src/core/resource/sounds/smudge.wav"
        }

        Item {
            id: layoutArea
            anchors.fill: parent
            anchors.margins: GCStyle.baseMargins
            anchors.bottomMargin: bar.height * 1.5
            anchors.topMargin: GCStyle.baseMargins * 2 + player1score.height * 1.4
        }

        Image {
            id: board
            source: Activity.url + "board.svg"
            width: Math.min(layoutArea.width, layoutArea.height)
            height: width
            sourceSize.width: width
            anchors.centerIn: layoutArea
            property real cellSize: grid.height / 3
            property real squareSize: cellSize * 0.90625
            property real pieceSize: cellSize * 0.8125
            property real marginSize: (cellSize - pieceSize) * 0.5

            ListModel {
                id: pieces
            }

            Grid {
                id: grid
                rows: 3
                columns: 3
                anchors {
                    fill: parent
                }
                spacing: 0
                Repeater {
                    id: repeater
                    model: pieces
                    delegate: blueSquare
                    Component {
                        id: blueSquare
                        Item {
                            id: blueSquareItem
                            width: board.cellSize
                            height: board.cellSize
                            state: "INITIAL"
                            property alias border: pieceBg.border
                            property alias color: pieceBg.color
                            required property string stateTemp
                            Rectangle {
                                id: pieceBg
                                anchors.centerIn: parent
                                width: board.squareSize
                                height: board.squareSize
                                border.color: "transparent"
                                border.width: GCStyle.midBorder
                                color: "#c7ecfb"
                            }
                            Piece {
                                anchors.centerIn: parent
                                width: board.pieceSize
                                height: board.pieceSize
                                state: blueSquareItem.stateTemp
                            }
                            states: [
                                State {
                                    name: "INITIAL"
                                    PropertyChanges {
                                        area {
                                            visible: true
                                        }
                                    }
                                },
                                State {
                                    name: "DONE"
                                    PropertyChanges {
                                        area {
                                            visible: false
                                        }
                                    }
                                }
                            ]
                            MouseArea {
                                id: area
                                enabled: !magnify.running && !items.gameDone
                                hoverEnabled: enabled
                                width: parent.width
                                height: parent.height
                                onEntered: { blueSquareItem.border.color = "#62db53" }
                                onExited: { blueSquareItem.border.color = "transparent" }
                                onClicked: { Activity.handleCreate(parent) }
                            }
                        }
                    }
                }
            }
            Piece {
                id: createPiece
                property real pieceX: 0
                property real pieceY: 0
                x: pieceX + board.marginSize
                y: pieceY + board.marginSize
                state: (items.counter + items.playSecond) % 2 ? "2": "1"
                width: board.pieceSize
                height: board.pieceSize
                opacity: 0
            }
        }

        PropertyAnimation {
            id: demagnify
            target: createPiece
            properties: "scale"
            from: 1.0
            to: 0.0
            duration: 0
        }
        PropertyAnimation {
            id: magnify
            target: createPiece
            properties: "scale"
            from: 0.0
            to: 1.0
            duration: 1000
            onStarted: smudgeSound.play()
            onFinished: { Activity.continueGame() }
        }

        ScoreItem {
            id: player1score
            player: 1
            height: Math.min(activityBackground.height/7, activityBackground.width/7, bar.height * 1.05)
            width: height*11/8
            anchors {
                top: activityBackground.top
                left: activityBackground.left
                margins: GCStyle.baseMargins
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
            height: player1score.height
            width: player1score.width
            anchors {
                top: activityBackground.top
                right: activityBackground.right
                margins: GCStyle.baseMargins
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
            onClose: activity.home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: (activity.twoPlayer ? (help | home | reload) : (help | home | level | reload))}
            onHelpClicked: {
                activity.displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onReloadClicked: {
                bonus.haltBonus()
                Activity.reset()
            }
        }

        Bonus {
            id: bonus
        }
    }
}
