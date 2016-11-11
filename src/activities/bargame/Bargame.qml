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
            property int mode: 1
            property int player1Score: 0
            property int player2Score: 0
            property string player1: "Human"
            property string player2: "CPU"
            property int gameMode: 1
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
                onClicked: {
                    tuxArea.hoverEnabled = false;
                    tuxArea.enabled = false;
                    var value = Activity.numberOfBalls
                    numberLabel.text = Activity.numberOfBalls = Activity.numberBalls[items.mode - 1][0];
                    Activity.play(1, value);
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

        Score {
            id: score
            message: ((items.gameMode == 1) ? "Human" : "Player1") + ": " + items.player1Score + " - " + ((items.gameMode == 1) ? "CPU" : "Player2") + ": " + items.player2Score
            anchors.top: parent.top
            anchors.topMargin: 10 * ApplicationInfo.ratio
            anchors.right: parent.right
            anchors.rightMargin: 10 * ApplicationInfo.ratio
            anchors.bottom: undefined
        }
    }
}
