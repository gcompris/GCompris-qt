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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
*/
import QtQuick 2.1

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

            property alias tutorialImage: tutorialImage.source
            property alias tutorialTxt: tutorialTxt.text
            property alias tutNum: tutorialTxt.tutNum
            property bool isTutorial

            property alias player1: player1
            property alias firstInitial: firstInitial
            property alias firstPlayerPieces: firstPlayerPieces
            property alias firstPlayerPiecesModel: firstPlayerPiecesModel
            property alias firstPieceNumberCount: firstPieceNumber.count
            property alias player1background: player1background.visible
            property alias player1_score: player1_score.text
            property alias player1turn: player1turn
            property alias player1shrink: player1shrink
            property alias player1image: player1image
            property alias changeScalePlayer1: changeScalePlayer1
            property alias rotateKonqi: rotateKonqi

            property alias player2: player2
            property alias secondInitial: secondInitial
            property alias secondPlayerPieces: secondPlayerPieces
            property alias secondPlayerPiecesModel: secondPlayerPiecesModel
            property alias secondPieceNumberCount: secondPieceNumber.count
            property alias player2background: player2background.visible
            property alias player2_score: player2_score.text
            property alias player2turn: player2turn
            property alias player2shrink: player2shrink
            property alias player2image: player2image
            property alias changeScalePlayer2: changeScalePlayer2
            property alias rotateTux: rotateTux

            property bool gameDone
            property int turn
            property bool playSecond
            property bool firstPhase
            property bool pieceBeingMoved

            property alias bar: bar
            property alias bonus: bonus
            property alias instructionTxt: instruction.text
        }

        onStart: Activity.start(items, twoPlayer)
        onStop: Activity.stop()

        Image {
            id: board
            source: Activity.url + "board.svg"
            sourceSize.width: Math.min(background.height - 1.4 * player1.height - 1.2 * bar.height,
                                       background.width - 2.2 * firstInitial.width)
            visible: !items.isTutorial
            anchors {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
                verticalCenterOffset : -0.25 * player1.height
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
                left: player1.left
                top: player1.bottom
                topMargin: player1.height * 0.5
            }
            width: player1.width * 1.2
            height: player1.height * 1.2
            visible: !items.isTutorial && items.firstPhase
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
                right: player2.right
                top: player2.bottom
                topMargin: player2.height * 0.5
            }
            width: firstInitial.width
            height: firstInitial.height
            visible: !items.isTutorial && items.firstPhase
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
            visible: !items.isTutorial
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
            visible: !items.isTutorial
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#000" }
                GradientStop { position: 0.9; color: "#666" }
                GradientStop { position: 1.0; color: "#AAA" }
            }
        }
        // Instruction section ends

        // Player scores section start
        Rectangle {
            id: player2
            height: Math.min(background.height / 10, Math.min(background.width / 9, bar.height * 0.9))
            width: height * 11 / 8
            anchors {
                top: background.top
                topMargin: 5
                right: background.right
                rightMargin: 5
            }
            radius: 5
            state: "second"
            visible: !items.isTutorial

            Image {
                id: player2background
                source: Activity.url + "score_2.svg"
                sourceSize.height: parent.height * 0.93
                anchors.centerIn: parent

                Image {
                    id: player2image
                    source: Activity.url + "TuxBlack.svg"
                    sourceSize.height: parent.height * 0.8
                    x: parent.width * 0.05
                    anchors.verticalCenter: parent.verticalCenter
                }

                GCText {
                    id: player2_score
                    anchors.verticalCenter: parent.verticalCenter
                    x: parent.width * 0.65
                    color: "#2a2a2a"
                    fontSize: mediumSize
                }
            }

            states: [
                State {
                    name: "first"
                    PropertyChanges {
                        target: player2image
                        source: Activity.url + "TuxBlack.svg"
                    }
                    PropertyChanges {
                        target: player2
                        color: "#49bbf0"
                    }
                },
                State {
                    name: "second"
                    PropertyChanges {
                        target: player2
                        color: "transparent"
                    }
                    PropertyChanges {
                        target: player2image
                        source: Activity.url + "TuxBlack.svg"
                    }
                },
                State {
                    name: "win"
                    PropertyChanges {
                        target: player2image
                        source: Activity.url + "win.svg"
                    }
                    PropertyChanges {
                        target: player2
                        color: "#f7ec5d"
                    }
                }
            ]

            transform: Scale {
                id: changeScalePlayer2
                property real scale: 1
                origin.x: player2.width
                origin.y: 0
                xScale: scale
                yScale: scale
            }
        }

        Rectangle {
            id: player1
            height: Math.min(background.height / 10, Math.min(background.width / 9, bar.height * 0.9))
            width: height * 11 / 8
            anchors {
                top: background.top
                topMargin: 5
                left: background.left
                leftMargin: 5
            }
            radius: 5
            state: "second"
            visible: !items.isTutorial

            Image {
                id: player1background
                source: Activity.url + "score_1.svg"
                sourceSize.height: parent.height * 0.93
                anchors.centerIn: parent

                Image {
                    id: player1image
                    source: Activity.url + "KonqiWhite.svg"
                    sourceSize.height: parent.height * 0.8
                    x: parent.width * 0.05
                    anchors.verticalCenter: parent.verticalCenter
                }

                GCText {
                    id: player1_score
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#2a2a2a"
                    x: parent.width * 0.65
                    fontSize: mediumSize
                }
            }

            states: [
                State {
                    name: "first"
                    PropertyChanges {
                        target: player1image
                        source: Activity.url + "KonqiWhite.svg"
                    }
                    PropertyChanges {
                        target: player1
                        color: "#f07c49"
                    }
                },
                State {
                    name: "second"
                    PropertyChanges {
                        target: player1
                        color: "transparent"
                    }
                    PropertyChanges {
                            target: player1image
                            source: Activity.url + "KonqiWhite.svg"
                    }
                },
                State {
                    name: "win"
                    PropertyChanges {
                        target: player1image
                        source: Activity.url + "win.svg"
                    }
                    PropertyChanges {
                        target: player1
                        color: "#f7ec5d"
                    }
                }
            ]

            transform: Scale {
                id: changeScalePlayer1
                property real scale: 1
                xScale: scale
                yScale: scale
            }
        }
        // Player scores section ends

        // Animation section start
        PropertyAnimation {
            id: player1turn
            target: changeScalePlayer1
            properties: "scale"
            from: 1.0
            to: 1.4
            duration: 500
            onStarted:{
                player1.state = "first"
                player2.state = "second"
                rotateTux.stop()
                player2image.rotation = 0
                rotateKonqi.start()
                player2shrink.start()
            }
            onStopped: {Activity.shouldComputerPlay()}
        }

        PropertyAnimation {
            id: player1shrink
            target: changeScalePlayer1
            properties: "scale"
            from: 1.4
            to: 1.0
            duration: 500
        }

        PropertyAnimation {
            id: player2turn
            target: changeScalePlayer2
            properties: "scale"
            from: 1.0
            to: 1.4
            duration: 500
            onStarted:{
                player1.state = "second"
                player2.state = "first"
                rotateKonqi.stop()
                player1image.rotation = 0
                rotateTux.start()
                player1shrink.start()
            }
            onStopped: {Activity.shouldComputerPlay()}
        }

        PropertyAnimation {
            id: player2shrink
            target: changeScalePlayer2
            properties: "scale"
            from: 1.4
            to: 1.0
            duration: 500
        }

        SequentialAnimation {
            id: rotateKonqi
            loops: Animation.Infinite
            NumberAnimation {
                target: player1image
                property: "rotation"
                from: -30; to: 30
                duration: 750
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: player1image
                property: "rotation"
                from: 30; to: -30
                duration: 750
                easing.type: Easing.InOutQuad
            }
        }

        SequentialAnimation {
            id: rotateTux
            loops: Animation.Infinite
            NumberAnimation {
                target: player2image
                property: "rotation"
                from: -30; to: 30
                duration: 750
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: player2image
                property: "rotation"
                from: 30; to: -30
                duration: 750
                easing.type: Easing.InOutQuad
            }
        }
        // Animation section ends

        // Tutorial section starts
        Image {
            id: previousTutorial
            source: "qrc:/gcompris/src/core/resource/bar_previous.svg"
            sourceSize.height: skipTutorial.height * 1.1
            visible: items.isTutorial && tutorialTxt.tutNum != 1
            anchors {
                top: parent.top
                topMargin: 5
                right: skipTutorialContainer.left
                rightMargin: 5
            }

            MouseArea {
                id: previousArea
                width: parent.width
                height: parent.height
                onClicked: {Activity.tutorialPrevious()}
            }
        }

        Image {
            id: nextTutorial
            source: "qrc:/gcompris/src/core/resource/bar_next.svg"
            sourceSize.height: skipTutorial.height * 1.1
            visible: items.isTutorial && tutorialTxt.tutNum != 5
            anchors {
                top: parent.top
                topMargin: 5
                left: skipTutorialContainer.right
                leftMargin: 5
            }

            MouseArea {
                id: nextArea
                width: parent.width
                height: parent.height
                onClicked: {Activity.tutorialNext()}
            }
        }

        GCText {
            id: skipTutorial
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
            horizontalAlignment: Text.AlignHCenter
            width: Math.min(implicitWidth, 0.8 * parent.width )
            height: implicitHeight
            visible: items.isTutorial
            text: qsTr("Skip Tutorial")
            z: 2
        }

        Rectangle {
            id: skipTutorialContainer
            anchors.top: skipTutorial.top
            anchors.horizontalCenter: skipTutorial.horizontalCenter
            width: skipTutorial.width + 10
            height: skipTutorial.height + 2
            opacity: 0.8
            radius: 10
            border.width: 2
            border.color: "black"
            visible: items.isTutorial
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#000" }
                GradientStop { position: 0.9; color: "#666" }
                GradientStop { position: 1.0; color: "#AAA" }
            }
            MouseArea {
                id: skipArea
                hoverEnabled: true
                width: parent.width
                height: parent.height
                onEntered: {skipTutorialContainer.border.color = "#62db53"}
                onExited: {skipTutorialContainer.border.color = "black"}
                onClicked: {Activity.tutorialSkip()}
            }
        }

        GCText {
            id: tutorialTxt
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: skipTutorial.bottom
                topMargin: skipTutorial.height * 0.5
            }
            fontSizeMode: Text.Fit
            minimumPixelSize: 10
            color: "white"
            style: Text.Outline
            styleColor: "black"
            horizontalAlignment: Text.AlignHLeft
            width: Math.min(implicitWidth, 0.8 * parent.width )
            height: Math.min(implicitHeight, 0.25 * parent.height )
            wrapMode: TextEdit.WordWrap
            visible: items.isTutorial
            z: 2
            property int tutNum: 1
        }

        Rectangle {
            id: tutorialTxtContainer
            anchors.top: tutorialTxt.top
            anchors.horizontalCenter: tutorialTxt.horizontalCenter
            width: tutorialTxt.width + 20
            height: tutorialTxt.height + 2
            opacity: 0.8
            radius: 10
            border.width: 2
            border.color: "black"
            visible: items.isTutorial
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#000" }
                GradientStop { position: 0.9; color: "#666" }
                GradientStop { position: 1.0; color: "#AAA" }
            }
        }

        Image {
            id: tutorialImage
            source: Activity.url + "tutorial" + tutorialTxt.tutNum + ".svg"
            property int heightNeed: background.height - tutorialTxtContainer.height - bar.height -
                                     2 * skipTutorialContainer.height
            width: (sourceSize.width/sourceSize.height) > (0.9 * background.width / heightNeed) ?
                   0.9 * background.width : (sourceSize.width * heightNeed) / sourceSize.height
            fillMode: Image.PreserveAspectFit
            visible: items.isTutorial
            anchors {
                top: tutorialTxt.bottom
                topMargin: 10
                horizontalCenter: parent.horizontalCenter
            }
        }
        // Tutorial section ends

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: twoPlayer ? (help | home | reload) : items.isTutorial ?
                                             (help | home) : (help | home | level | reload)}
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
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
