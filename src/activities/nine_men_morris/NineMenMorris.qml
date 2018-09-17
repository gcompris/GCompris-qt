/* GCompris - NineMenMorris.qml
 *
 * Copyright (C) 2016 Pulkit Gupta <pulkitnsit@gmail.com>
 *
 * Authors:
 *   Pulkit Gupta <pulkitnsit@gmail.com>
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
*/
import QtQuick 2.6

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
        source: Activity.url + "background.svg"
        sourceSize.width: Math.max(parent.width, parent.height)
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
            property alias dragPointsModel: dragPointsModel
            property alias dragPoints: dragPoints

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

            property alias bar: bar
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
            opacity: 0.8
            radius: 10
            border.width: 2
            border.color: "black"
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#6b4723" }
                GradientStop { position: 0.9; color: "#996633" }
                GradientStop { position: 1.0; color: "#AAA" }
            }

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
                style: Text.Outline
                styleColor: "black"
                horizontalAlignment: Text.AlignHCenter
                property int count: 9
                text: "X%1".arg(count)
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
            opacity: 0.8
            radius: 10
            border.width: 2
            border.color: "black"
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#6b4723" }
                GradientStop { position: 0.9; color: "#996633" }
                GradientStop { position: 1.0; color: "#AAA" }
            }
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
                style: Text.Outline
                styleColor: "black"
                horizontalAlignment: Text.AlignHCenter
                property int count: 9
                text: "X%1".arg(count)
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
            style: Text.Outline
            styleColor: "black"
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
            opacity: 0.8
            radius: 10
            border.width: 2
            border.color: "black"
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#000" }
                GradientStop { position: 0.9; color: "#666" }
                GradientStop { position: 1.0; color: "#AAA" }
            }
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
            playerImageSource: Activity.url + "TuxBlack.svg"
            backgroundImageSource: Activity.url + "score_2.svg"
            playerScaleOriginX: player2score.width
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
            playerImageSource: Activity.url + "KonqiWhite.svg"
            backgroundImageSource: Activity.url + "score_1.svg"
        }
        // Player scores section ends

        // Tutorial section starts
        Image {
            id: tutorialImage
            source: Activity.url + "background.svg"
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
            content: BarEnumContent { value: twoPlayer ? (help | home | reload)
                                                       : tutorialImage.visible ? (help | home)
                                                       : (help | home | level | reload) }
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
