/* GCompris - bargame.qml
 *
 * Copyright (C) 2016 UTKARSH TIWARI <iamutkarshtiwari@kde.org>
 *
 * Authors:
 *   Yves Combe (GTK+ version)
 *   UTKARSH TIWARI <iamutkarshtiwari@kde.org > (Qt Quick port)
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
import GCompris 1.0

import "../../core"
import "bargame.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: rootWindow
        source: Activity.url + "school_bg" + bar.level + ".svg"
        sourceSize.height: parent.height
        sourceSize.width: parent.width
        anchors.fill: parent
        signal start
        signal stop

        Component.onCompleted: {
            dialogActivityConfig.getInitialConfiguration()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property Item boxModel: boxModel
            property Item rootWindow: rootWindow
            property alias tux: tux
            property alias blueBalls: blueBalls
            property alias greenBalls: greenBalls
            property alias tuxArea: tuxArea
            property alias boxes: boxes
            property alias masks: masks
            property alias numberLabel: numberLabel
            property alias answerBallsPlacement: answerBallsPlacement
            property alias answerBalls: answerBalls
            property alias bar: bar
            property alias bonus: bonus
            property alias okArea: okArea

            property alias player1: player1
            property alias player1turn: player1turn
            property alias player1shrink: player1shrink
            property alias player1image: player1image
            property alias changeScalePlayer1: changeScalePlayer1
            property alias rotateKonqi: rotateKonqi

            property alias player2: player2
            property alias player2turn: player2turn
            property alias player2shrink: player2shrink
            property alias player2image: player2image
            property alias changeScalePlayer2: changeScalePlayer2
            property alias rotateTux: rotateTux

            property int mode: 1
            property int player1Score: 0
            property int player2Score: 0
            property int gameMode: 1
            property bool isPlayer1Beginning: true
            property bool isPlayer1Turn: true
        }

        onStart: {
            Activity.start(items)
            Activity.calculateWinPlaces();
        }
        onStop: { Activity.stop() }

        // Tux image
        Image {
            id: tux
            source: Activity.url + "tux" + bar.level + ".svg"
            height: rootWindow.height / 3.8
            width: rootWindow.width / 8
            y: rootWindow.height - rootWindow.height / 1.8
            x: rootWindow.width - rootWindow.width / Activity.tuxPositionFactor[items.mode - 1];
            MouseArea {
                id: tuxArea
                hoverEnabled: true
                enabled: true
                anchors.fill: parent
                onClicked: {
                    tuxArea.hoverEnabled = false;
                    tuxArea.enabled = false;
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

        Item {
            // Upper blue balls sample
            Grid {
                id: blueBalls
                columns: Activity.sampleBallsNumber[items.mode - 1]
                rows: 1
                x: rootWindow.width / 2.2
                y: rootWindow.height / 1.7
                Repeater {
                    model: blueBalls.columns
                    Image {
                        id: blueBall
                        source: Activity.url + "blue_ball.svg"
                        height: rootWindow.height / (8 + Activity.ballSizeFactor[items.mode - 1])
                        width: rootWindow.width / (15 + Activity.ballSizeFactor[items.mode - 1])
                    }
                }
            }

            // Lower green balls sample
            Grid {
                id: greenBalls
                x: rootWindow.width / 2.2
                y: rootWindow.height / 1.2
                rows: 1
                columns: Activity.sampleBallsNumber[items.mode - 1]
                Repeater {
                    model: greenBalls.columns
                    Image {
                        id: greenBall
                        source: Activity.url + "green_ball.svg"
                        height: rootWindow.height / (8 + Activity.ballSizeFactor[items.mode - 1])
                        width: rootWindow.width / (15 + Activity.ballSizeFactor[items.mode - 1])
                    }
                }
            }
        }

        // Box row
        Item {
            id: boxModel
            // The empty boxes grid
            Grid {
                id: boxes
                rows: 1
                columns: Activity.boardSize[items.mode - 1]
                x: 0
                y: rootWindow.height / 1.4
                Repeater {
                    id: startCase
                    model: boxes.columns
                    Image {
                        id: greenCase
                        source: Activity.url + ((index == boxes.columns - 1) ? "case_last.svg" : "case.svg")
                        height: rootWindow.height / (9 + (items.mode - 1) * Activity.elementSizeFactor[items.mode - 1])
                        width: rootWindow.width / (15 + (items.mode - 1) * Activity.elementSizeFactor[items.mode - 1])
                        visible: true
                        // Numbering label
                        GCText {
                            text: index + 1
                            fontSize: smallSize
                            font.bold: true
                            visible: ((index + 1) % 5 == 0 && index > 0) ? true : false
                            anchors {
                                horizontalCenter: parent.horizontalCenter
                                bottom: parent.top
                            }
                        }
                    }
                }
            }

            // Hidden Answer Balls
            Item {
                id: answerBalls
                // All green balls placement
                Grid {
                    id: answerBallsPlacement
                    x: boxes.x
                    y: boxes.y
                    columns: Activity.boardSize[items.mode - 1]
                    rows: 1
                    Repeater {
                        model: answerBallsPlacement.columns
                        Image {
                            source: Activity.url + "green_ball.svg"
                            height: rootWindow.height / (9 + (items.mode - 1) * Activity.elementSizeFactor[items.mode - 1])
                            width: rootWindow.width / (15 + (items.mode - 1) * Activity.elementSizeFactor[items.mode - 1])
                            opacity: 0.0
                        }
                    }
                }
            }

            // Masks
            Grid {
                id: masks
                x: boxes.x
                y: boxes.y
                rows: 1
                columns: Activity.boardSize[items.mode-1]
                Repeater {
                    id: startMask
                    model: masks.columns
                    Image {
                        id: greenMask
                        source: Activity.url + ((index == boxes.columns - 1) ? "mask_last.svg" : "mask.svg")
                        height: rootWindow.height / (9 + (items.mode - 1) * Activity.elementSizeFactor[items.mode - 1])
                        width: rootWindow.width / (15 + (items.mode - 1) * Activity.elementSizeFactor[items.mode - 1])
                    }
                }
            }
        }

        // OK BUTTON
        Image {
            id: playLabel
            x: rootWindow.width / 1.2
            y: rootWindow.height / 2.4
            width: rootWindow.width / 20
            height: width
            source: Activity.url + "bar_ok.svg"
            MouseArea {
                id: okArea
                anchors.fill: parent
                hoverEnabled: true
                enabled: true
                onClicked: {
                    tuxArea.hoverEnabled = false;
                    tuxArea.enabled = false;
                    var value = Activity.numberOfBalls
                    numberLabel.text = Activity.numberOfBalls = Activity.numberBalls[items.mode - 1][0];
                    if (items.gameMode == 1) {
                    Activity.play(1, value);
                    } else {
                        Activity.play(((items.isPlayer1Turn) ? 1 : 2), value);
                    }
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
            x: rootWindow.width / 1.2
            y: rootWindow.height / 1.2
            source: Activity.url + "enumerate_answer.svg"
            width: rootWindow.width / 7
            height: rootWindow.height / 8
            MouseArea {
                id: numberPlateArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    Activity.numberOfBalls ++;
                    if (Activity.numberOfBalls > Activity.numberBalls[items.mode - 1 ][1]) {
                        Activity.numberOfBalls = Activity.numberBalls[items.mode - 1 ][0];
                    }
                    numberLabel.text = Activity.numberOfBalls;
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
                source: Activity.url + "green_ball.svg"
                width: rootWindow.width / 16
                height: rootWindow.height / 10
                anchors {
                    verticalCenter: ballNumberPlate.verticalCenter
                    left: ballNumberPlate.left
                }
            }
            // Number label
            GCText {
                id: numberLabel
                text: "1"
                color: 'Red'
                font.bold: true
                fontSize: smallSize
                anchors {
                    centerIn: ballNumberPlate
                }
            }
        }

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

        Rectangle {
            id: player2
            height: Math.min(rootWindow.height/7,Math.min(rootWindow.width/7,bar.height * 1.05))
            width: height*11/8
            anchors {
                top: rootWindow.top
                topMargin: 5
                right: rootWindow.right
                rightMargin: 5
            }
            radius: 5
            state: "second"

            GCText {
                anchors {
                    top: player2.bottom;
                    horizontalCenter: player2.horizontalCenter
                }
                color: "#2a2a2a"
                fontSize: smallSize
                text: qsTr((items.gameMode == 2) ? "Player2" : "Tux")
            }

            Image {
                id: player2background
                source: Activity.url + "score_2.svg"
                sourceSize.height: parent.height*0.93
                anchors.centerIn: parent

                Image {
                    id: player2image
                    source: Activity.url + "TuxCircle.svg"
                    sourceSize.height: parent.height*0.8
                    x: parent.width*0.06
                    anchors.verticalCenter: parent.verticalCenter
                }

                GCText {
                    id: player2_score
                    anchors.verticalCenter: parent.verticalCenter
                    x: parent.width*0.65
                    color: "#2a2a2a"
                    fontSize: largeSize
                    text: items.player2Score
                }
            }

            states: [
                State {
                    name: "first"
                    PropertyChanges {
                        target: player2image
                        source: Activity.url + "TuxCircle.svg"
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
                        source: Activity.url + "TuxCircle.svg"
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
            height: Math.min(rootWindow.height/7,Math.min(rootWindow.width/7,bar.height * 1.05))
            width: height*11/8
            anchors {
                top: rootWindow.top
                topMargin: 5
                left: rootWindow.left
                leftMargin: 5
            }
            radius: 5
            state: "second"

            GCText {
                anchors {
                    top: player1.bottom;
                    horizontalCenter: player1.horizontalCenter
                }
                color: "#2a2a2a"
                fontSize: smallSize
                text: qsTr((items.gameMode == 2) ? "Player1" : "Human")
            }

            Image {
                id: player1background
                source: Activity.url + "score_1.svg"
                sourceSize.height: parent.height*0.93
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: 0.5

                Image {
                    id: player1image
                    source: Activity.url + "KonqiCross.svg"
                    sourceSize.height: parent.height*0.8
                    x: parent.width*0.06
                    anchors.verticalCenter: parent.verticalCenter
                }

                GCText {
                    id: player1_score
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#2a2a2a"
                    x: parent.width*0.65
                    fontSize: largeSize
                    text: items.player1Score
                }
            }

            states: [
                State {
                    name: "first"
                    PropertyChanges {
                        target: player1image
                        source: Activity.url + "KonqiCross.svg"
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
                        source: Activity.url + "KonqiCross.svg"
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

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        DialogActivityConfig {
            id: dialogActivityConfig
            currentActivity: activity
            content: Component {
                Item {
                    property alias modeBox: modeBox
                    property alias gameModeBox: gameModeBox

                    property var availableModes: [
                        { "text": qsTr("Easy"), "value": 1 },
                        { "text": qsTr("Medium"), "value": 2 },
                        { "text": qsTr("Difficult"), "value": 3 }
                    ]

                    property var availableGameModes: [
                        { "text": qsTr("1 Player"), "value": 1 },
                        { "text": qsTr("2 Player"), "value": 2 }
                    ]
                    Flow {
                        id: flow
                        spacing: 5
                        width: dialogActivityConfig.width
                        GCComboBox {
                            id: modeBox
                            model: availableModes
                            background: dialogActivityConfig
                            label: qsTr("Select your difficulty")
                        }
                        GCComboBox {
                            id: gameModeBox
                            model: availableGameModes
                            background: dialogActivityConfig
                            label: qsTr("Select your gameplay mode")
                        }
                    }
                }
            }

            onClose: {
                Activity.initLevel();
                home();
            }
            onLoadData: {
                if(dataToSave && dataToSave["mode"] && dataToSave["gameMode"]) {
                    items.mode = dataToSave["mode"];
                    items.gameMode = dataToSave["gameMode"];
                    Activity.initLevel();
                }
            }
            onSaveData: {
                var newMode = dialogActivityConfig.configItem.availableModes[dialogActivityConfig.configItem.modeBox.currentIndex].value;
                var newGameMode = dialogActivityConfig.configItem.availableGameModes[dialogActivityConfig.configItem.gameModeBox.currentIndex].value;
                if (newMode !== items.mode) {
                    items.mode = newMode;
                    dataToSave = {"mode": items.mode};
                }
                if (newGameMode !== items.gameMode) {
                    items.gameMode = newGameMode;
                    dataToSave = {"gameMode": items.gameMode};
                }
                items.player1Score = items.player2Score = 0;
            }
            function setDefaultValues() {
                for(var i = 0 ; i < dialogActivityConfig.configItem.availableModes.length ; i++) {
                    if(dialogActivityConfig.configItem.availableModes[i].value === items.mode) {
                        dialogActivityConfig.configItem.modeBox.currentIndex = i;
                        break;
                    }
                }
                for(var j = 0 ; j < dialogActivityConfig.configItem.availableGameModes.length ; j++) {
                    if(dialogActivityConfig.configItem.availableGameModes[j].value === items.gameMode) {
                        dialogActivityConfig.configItem.gameModeBox.currentIndex = j;
                        break;
                    }
                }
            }
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level | config }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onConfigClicked: {
                dialogActivityConfig.active = true
                // Set default values
                dialogActivityConfig.setDefaultValues();
                displayDialog(dialogActivityConfig)
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: {
                win.connect(Activity.initLevel)
                loose.connect(Activity.initLevel)
            }
        }
    }
}
