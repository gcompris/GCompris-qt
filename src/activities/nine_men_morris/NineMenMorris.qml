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
        id: activityBackground
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
        Keys.forwardTo: [tutorialSection]

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
            property bool playSecond: false
            property bool firstPhase
            property bool pieceBeingMoved

            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias instructionTxt: instructionPanel.textItem
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

        Item {
            id: layoutArea1 // used for horizontal layout
            anchors.top: instructionPanel.bottom
            anchors.left: player1score.right
            anchors.right: player2score.left
            anchors.bottom: parent.bottom
            anchors.margins: player1score.width * 0.4
            anchors.topMargin: 0
            anchors.bottomMargin: bar.height * 1.3
        }

        Item {
            id: layoutArea2 // used for vertical layout
            anchors.top: firstInitial.bottom
            anchors.left: player1score.left
            anchors.right: player2score.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: bar.height * 1.3
        }

        Image {
            id: board
            source: Activity.url + "board.svg"
            height: width
            sourceSize.width: width

            states: [
                State {
                    name: "horizontalLayout"
                    when: layoutArea1.width >= layoutArea2.height
                    PropertyChanges {
                        board {
                            width: Math.min(layoutArea1.width, layoutArea1.height) * 0.9
                            anchors.centerIn: layoutArea1
                        }
                    }
                },
                State {
                    name: "verticalLayout"
                    when: layoutArea2.height > layoutArea1.width
                    PropertyChanges {
                        board {
                            width: Math.min(layoutArea2.width, layoutArea2.height) * 0.9
                            anchors.centerIn: layoutArea2
                        }
                    }
                }
            ]

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
            radius: GCStyle.halfMargins
            border.width: GCStyle.thinnestBorder
            border.color: GCStyle.whiteBorder
            color: GCStyle.darkBg

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
                        width: firstPieceNumber.width
                        x: GCStyle.halfMargins
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
                    rightMargin: GCStyle.halfMargins
                }
                width: (firstInitial.width - 2 * GCStyle.halfMargins) * 0.5
                height: firstInitial.height - GCStyle.baseMargins
                fontSize: mediumSize
                fontSizeMode: Text.Fit
                color: GCStyle.whiteText
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
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
            radius: GCStyle.halfMargins
            border.width: GCStyle.thinnestBorder
            border.color: GCStyle.whiteBorder
            color: GCStyle.darkBg

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
                        width: firstPieceNumber.width
                        x: GCStyle.halfMargins
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
                    rightMargin: GCStyle.halfMargins
                }
                width: firstPieceNumber.width
                height: firstPieceNumber.height
                fontSize: mediumSize
                fontSizeMode: Text.Fit
                color: GCStyle.whiteText
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                property int count: 9
                text: "×%1".arg(count)
            }
        }

        ListModel {
            id: secondPlayerPiecesModel
        }

        GCTextPanel {
            id: instructionPanel
            panelWidth: parent.width - 2.8 * player1score.width - 4 * GCStyle.halfMargins
            panelHeight: player1score.height
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: GCStyle.halfMargins
        }

        // Player scores section start
        ScoreItem {
            id: player2score
            player: 2
            height: Math.min(activityBackground.height / 9, Math.min(activityBackground.width / 9, bar.height * 1.2))
            width: height * 11 / 8
            anchors {
                top: activityBackground.top
                right: activityBackground.right
                margins: GCStyle.halfMargins
            }
            playerImageSource: "qrc:/gcompris/src/core/resource/player_2.svg"
            backgroundImageSource: Activity.url + "score_1.svg"
            playerScaleOriginX: player2score.width
            playerItem.source: items.playSecond ? Activity.url + "white_piece.svg" : Activity.url + "black_piece.svg"
            playerItem.height: playerItem.parent.height * 0.35
            playerItem.anchors.leftMargin: playerItem.parent.height * 0.10
            playerItem.anchors.bottomMargin: playerItem.parent.height * 0.10
        }

        ScoreItem {
            id: player1score
            player: 1
            height: Math.min(activityBackground.height / 9, Math.min(activityBackground.width / 9, bar.height * 1.2))
            width: height * 11 / 8
            anchors {
                top: activityBackground.top
                left: activityBackground.left
                margins: GCStyle.halfMargins
            }
            playerImageSource: "qrc:/gcompris/src/core/resource/player_1.svg"
            backgroundImageSource: Activity.url + "score_2.svg"
            playerItem.source: items.playSecond ? Activity.url + "black_piece.svg" : Activity.url + "white_piece.svg"
            playerItem.height: playerItem.parent.height * 0.35
            playerItem.anchors.leftMargin: playerItem.parent.height * 0.15
            playerItem.anchors.bottomMargin: playerItem.parent.height * 0.10
        }
        // Player scores section ends

        // Tutorial section starts
        Image {
            id: tutorialImage
            source: activityBackground.source
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
