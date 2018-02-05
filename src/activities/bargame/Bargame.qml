/* GCompris - bargame.qml
 *
 * Copyright (C) 2016 UTKARSH TIWARI <iamutkarshtiwari@kde.org>
 *
 * Authors:
 *   Yves Combe (GTK+ version)
 *   UTKARSH TIWARI <iamutkarshtiwari@kde.org> (Qt Quick port)
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
import QtQuick 2.6
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
        height: parent.height
        width: rootWindow.height * 1.75
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
            property int numberOfBalls: 1
            property alias answerBallsPlacement: answerBallsPlacement
            property alias bar: bar
            property alias bonus: bonus
            property alias okArea: okArea

            property alias trigTuxMove: trigTuxMove

            property alias player1score: player1score
            property alias player2score: player2score

            property int mode: 1
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
            source: Activity.url + "tux1.svg"
            height: rootWindow.height / 4
            width: tux.height
            y: rootWindow.height - rootWindow.height / 1.8
            anchors {
                right: rootWindow.right
                rightMargin: 16 * ApplicationInfo.ratio

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
            x: 0
            anchors.top: tux.bottom

            transform: Rotation {
                origin.x: 0;
                origin.y: 0;
                angle: (rootWindow.width > rootWindow.height) ? 0 : 90
                onAngleChanged: {
                    if (angle === 90) {
                        boxModel.anchors.top = undefined;
                        boxModel.y = 0;
                        boxModel.anchors.horizontalCenter = rootWindow.horizontalCenter;
                    } else {
                        boxModel.anchors.horizontalCenter = undefined;
                        boxModel.x = 0;
                        boxModel.anchors.top = tux.bottom;
                    }
                }
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
                        sourceSize.width: ((rootWindow.width > rootWindow.height) ? rootWindow.width : (rootWindow.height * 0.86)) / (15 + (items.mode - 1) * Activity.levelsProperties[items.mode - 1].elementSizeFactor)
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
                        sourceSize.width: ((rootWindow.width > rootWindow.height) ? rootWindow.width : (rootWindow.height * 0.86)) / (15 + (items.mode - 1) * Activity.levelsProperties[items.mode - 1].elementSizeFactor)
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
                        sourceSize.width: ((rootWindow.width > rootWindow.height) ? rootWindow.width : (rootWindow.height * 0.86)) / (15 + (items.mode - 1) * Activity.levelsProperties[items.mode - 1].elementSizeFactor)
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
                                bottomMargin: ((rootWindow.width > rootWindow.height) ? 4 * ApplicationInfo.ratio : -16 * ApplicationInfo.ratio)
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
                                angle: (rootWindow.width > rootWindow.height) ? 0 : -90
                            }
                        }
                    }
                }
            }
        }

        // ok button
        Image {
            id: playLabel
            width: rootWindow.height / 13
            height: width
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
            y: rootWindow.height / 3.1
            source: items.isPlayer1Turn ? Activity.url + "score_1.svg" :
                                          Activity.url + "score_2.svg"
            width: rootWindow.height / 7
            height: rootWindow.height / 9

            anchors {
                left: rootWindow.left
                leftMargin: 16 * ApplicationInfo.ratio
            }

            MouseArea {
                id: numberPlateArea
                anchors.fill: parent
                hoverEnabled: true
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
                sourceSize.width: rootWindow.height / 12
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
            playerImageSource: Activity.url + "player_1.svg"
            backgroundImageSource: Activity.url + "score_1.svg"
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
            playerImageSource: Activity.url + "player_2.svg"
            backgroundImageSource: Activity.url + "score_2.svg"
            playerScaleOriginX: player2score.width
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

                    property var availableModes: [
                        { "text": qsTr("Easy"), "value": 1 },
                        { "text": qsTr("Medium"), "value": 2 },
                        { "text": qsTr("Difficult"), "value": 3 }
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
                    }
                }
            }

            onClose: home()

            onLoadData: {
                if(dataToSave && dataToSave["mode"]) {
                    items.mode = dataToSave["mode"];
                }
            }
            onSaveData: {
                var newMode = dialogActivityConfig.configItem.availableModes[dialogActivityConfig.configItem.modeBox.currentIndex].value;
                if (newMode !== items.mode) {
                    items.mode = newMode;
                    dataToSave = {"mode": items.mode};
                }
                Activity.initLevel();
            }
            function setDefaultValues() {
                for(var i = 0 ; i < dialogActivityConfig.configItem.availableModes.length ; i++) {
                    if(dialogActivityConfig.configItem.availableModes[i].value === items.mode) {
                        dialogActivityConfig.configItem.modeBox.currentIndex = i;
                        break;
                    }
                }
            }
        }

        Bar {
            id: bar
            level: 1
            content: BarEnumContent { value: help | home | level | reload | config }
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
            onReloadClicked: Activity.restartLevel()
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
