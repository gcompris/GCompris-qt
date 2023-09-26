/* GCompris - NineMenMorris.qml
 *
 * SPDX-FileCopyrightText: 2016 Pulkit Gupta <pulkitnsit@gmail.com>
 *
 * Authors:
 *   Pulkit Gupta <pulkitnsit@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12

import "../../core"
import "nine_men_morris.js" as Activity
import "."

ActivityBase {
    id: activity

    property bool twoPlayer: false
    onStart: focus = true
    onStop: {}

    pageComponent: Image {
    id: background
        anchors.fill: parent
        source: "qrc:/gcompris/src/activities/tic_tac_toe/resource/background.svg"
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop
        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Needed to get keyboard focus on Tutorial
        Keys.forwardTo: tutorialSection

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias dragPointsModel: dragPointsModel
            property alias dragPoints: dragPoints
            property alias piecesLayout: piecesLayout

            property alias firstInitial: firstInitial
            property alias firstPlayerPieces: firstPlayerPieces
            property alias firstPlayerPiecesModel: firstPlayerPiecesModel
            property alias firstPieceNumberCount: firstPieceNumber.count
            property alias player1score: player1score

            property alias secondInitial: secondInitial
            property alias secondPlayerPieces: secondPlayerPieces
            property alias secondPlayerPiecesModel: secondPlayerPiecesModel
            property alias secondPieceNumberCount: secondPieceNumber.count
            property alias player2score: player2score

            property alias trigTuxMove: trigTuxMove

            property bool gameDone
            property int turn
            property bool playSecond
            property bool firstPhase
            property bool pieceBeingMoved

            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias instructionTxt: instruction.text
            property alias tutorialSection: tutorialSection
        }

        onStart: Activity.start(items, twoPlayer)
        onStop: Activity.stop()

        // Tux move delay
        Timer {
            id: trigTuxMove
            repeat: false
            interval: 1500
            onTriggered: {
                Activity.doMove()
                items.player2score.endTurn()
                items.player1score.beginTurn()
            }
        }

        Image {
            id: board
            source: Activity.url + "board.svg"
            sourceSize.width: Math.min(background.height - 1.4 * player1score.height - 1.2 * bar.height,
                                       background.width - 2.2 * firstInitial.width)
            anchors {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
                verticalCenterOffset : -0.25 * player1score.height
            }

            Repeater {
                id: dragPoints
                model: dragPointsModel
                delegate: point
                Component {
                    id: point
                    DragPoint {
                        id: dragPoint
                        x: posX * parent.width - width / 2
                        y: posY * parent.height - height / 2
                        index: myIndex
                        firstPhase: items.firstPhase
                        pieceBeingMoved: items.pieceBeingMoved
                    }
                }
            }

            Repeater {
                id: piecesLayout
                model: dragPointsModel
                delegate: piecePoint
                Component {
                    id: piecePoint
                    Item {
                        width: parent.width * 0.05
                        height: width
                        x: posX * parent.width - width * 0.5
                        y: posY * parent.height - height * 0.5
                    }
                }
            }
        }

        ListModel {
            id: dragPointsModel
        }

        Rectangle {
            id: firstInitial
            anchors {
                left: player1score.left
                top: player1score.bottom
                topMargin: player1score.height * 0.5
            }
            width: player1score.width * 1.2
            height: player1score.height * 1.2
            visible: items.firstPhase
            opacity: 1.0
            radius: 10
            border.width: 2
            border.color: "white"
            color: "#373737"

            Repeater {
                id: firstPlayerPieces
                model: firstPlayerPiecesModel
                delegate: firstPieceInitial
                Component {
                    id: firstPieceInitial
                    Piece {
                        id: firstPiece
                        state: "1"
                        firstPhase: items.firstPhase
                        sourceSize.height: Math.min(firstInitial.height * 0.8, firstInitial.width * 0.4)
                        x: firstInitial.width * 0.06
                        anchors.verticalCenter: firstInitial.verticalCenter
                        chance: items.turn % 2
                        playSecond: items.playSecond
                        gameDone: items.gameDone
                        pieceBeingMoved: items.pieceBeingMoved
                    }
                }
            }

            GCText {
                id: firstPieceNumber
                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: parent.width * 0.1
                }
                fontSize: mediumSize
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                property int count: 9
                text: "×%1".arg(count)
            }
        }

        ListModel {
            id: firstPlayerPiecesModel
        }

        Rectangle {
            id: secondInitial
            anchors {
                right: player2score.right
                top: player2score.bottom
                topMargin: player2score.height * 0.5
            }
            width: firstInitial.width
            height: firstInitial.height
            visible: items.firstPhase
            opacity: 1.0
            radius: 10
            border.width: 2
            border.color: "white"
            color: "#373737"

            Repeater {
                id: secondPlayerPieces
                model: secondPlayerPiecesModel
                delegate: secondPieceInitial
                Component {
                    id: secondPieceInitial
                    Piece {
                        id: secondPiece
                        state: "2"
                        firstPhase: items.firstPhase
                        sourceSize.height: Math.min(secondInitial.height * 0.8, secondInitial.width * 0.4)
                        x: secondInitial.width * 0.06
                        anchors.verticalCenter: secondInitial.verticalCenter
                        chance: items.turn % 2
                        playSecond: items.playSecond
                        gameDone: items.gameDone
                        pieceBeingMoved: items.pieceBeingMoved
                    }
                }
            }

            GCText {
                id: secondPieceNumber
                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: parent.width * 0.1
                }
                fontSize: mediumSize
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                property int count: 9
                text: "×%1".arg(count)
            }
        }

        ListModel {
            id: secondPlayerPiecesModel
        }

        // Instruction section starts
        GCText {
            id: instruction
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: 5
            }
            fontSizeMode: Text.Fit
            minimumPixelSize: 10
            color: "white"
            horizontalAlignment: Text.AlignHLeft
            width: implicitWidth
            height: implicitHeight
            z: 2
        }

        Rectangle {
            id: instructionContainer
            anchors.top: instruction.top
            anchors.horizontalCenter: parent.horizontalCenter
            width: instruction.width + 20
            height: instruction.height + 2
            opacity: 1.0
            radius: 10
            border.width: 2
            border.color: "white"
            color: "#373737"
        }
        // Instruction section ends

        // Player scores section start
        ScoreItem {
            id: player2score
            player: 2
            height: Math.min(background.height / 9, Math.min(background.width / 9, bar.height * 1.2))
            width: height * 11 / 8
            anchors {
                top: background.top
                topMargin: 5
                right: background.right
                rightMargin: 5
            }
            playerImageSource: "qrc:/gcompris/src/core/resource/player_2.svg"
            backgroundImageSource: Activity.url + "score_1.svg"
            playerScaleOriginX: player2score.width
            playerItem.source: Activity.url + "black_piece.svg"
            playerItem.height: playerItem.parent.height * 0.35
            playerItem.anchors.leftMargin: playerItem.parent.height * 0.10
            playerItem.anchors.bottomMargin: playerItem.parent.height * 0.10
        }

        ScoreItem {
            id: player1score
            player: 1
            height: Math.min(background.height / 9, Math.min(background.width / 9, bar.height * 1.2))
            width: height * 11 / 8
            anchors {
                top: background.top
                topMargin: 5
                left: background.left
                leftMargin: 5
            }
            playerImageSource: "qrc:/gcompris/src/core/resource/player_1.svg"
            backgroundImageSource: Activity.url + "score_2.svg"
            playerItem.source: Activity.url + "white_piece.svg"
            playerItem.height: playerItem.parent.height * 0.35
            playerItem.anchors.leftMargin: playerItem.parent.height * 0.15
            playerItem.anchors.bottomMargin: playerItem.parent.height * 0.10
        }
        // Player scores section ends

        // Tutorial section starts
        Image {
            id: tutorialImage
            source: background.source
            sourceSize.width: width
            sourceSize.height: height
            fillMode: Image.PreserveAspectCrop
            anchors.fill: parent
            z: 5
            visible: twoPlayer ? false : true
            Tutorial {
                id: tutorialSection
                tutorialDetails: Activity.tutorialInstructions
                onSkipPressed: {
	                Activity.initLevel()
                    tutorialImage.visible = false
                }
            }
        }
        // Tutorial section ends

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: twoPlayer ? (help | home | reload)
                                                       : tutorialImage.visible ? (help | home)
                                                       : (help | home | level | reload) }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: home()
            onReloadClicked: {
                Activity.reset()
            }
        }

        Bonus {
            id: bonus
        }
    }

}
