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

    pageComponent: Item {
        id: rootWindow
        signal start
        signal stop
        anchors.fill: parent

        Image {
            id: backgroundImage
            source: Activity.url + "school_bg" + Activity.level + ".svg"
            sourceSize.height: rootWindow.height
            sourceSize.width: rootWindow.width
            anchors.fill: rootWindow
        }

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property Item boxModel: boxModel
            property Item rootWindow: rootWindow
            property alias tuxRect: tuxRect
            property alias tux: tux
            property alias blueBalls: blueBalls
            property alias greenBalls: greenBalls
            property alias tuxArea: tuxArea
            property alias boxes: boxes
            property alias masks: masks
            property alias numberOfBalls: numberOfBalls
            property alias backgroundImage: backgroundImage
            property alias answerBallsPlacement: answerBallsPlacement
            property alias answerBalls: answerBalls
            property alias bar: bar
            property alias bonus: bonus
        }

        onStart: {
            Activity.start(items)
            Activity.calculateWinPlaces();
        }
        onStop: { Activity.stop() }

        // Tux image
        Rectangle {
            id: tuxRect
            color: 'transparent'
            height: rootWindow.height / 3.8
            width: rootWindow.width / 8
            y: rootWindow.height - rootWindow.height / 1.8
            x: rootWindow.width - rootWindow.width / 1.05
            radius: 10

            Image {
                id: tux
                source: Activity.url + "tux" + Activity.level + ".svg"
                height: parent.height
                width: parent.width
                anchors.centerIn: tuxRect.Center
                MouseArea {
                    id: tuxArea
                    hoverEnabled: true
                    enabled: true
                    anchors.fill: parent
                    onClicked: {
                        tuxArea.hoverEnabled = false;
                        tuxArea.enabled = false;
                        tuxRect.color = 'white';
                        Activity.machinePlay();
                    }
                    onEntered: tuxRect.color = '#80FF0000';
                    onExited: tuxRect.color = 'transparent';
                }
            }
        }

        // Upper blue balls sample
        Grid {
            id: blueBalls
            columns: 4
            rows: 1
            x: rootWindow.width / 5
            y: rootWindow.height / 1.7
            Repeater {
                model: blueBalls.columns
                Image {
                    id: blueBall
                    source: Activity.url + "blue_ball.svg"
                    height: rootWindow.height / (8 + Activity.ballSizeFactor[Activity.sublevel - 1])
                    width: rootWindow.width / (15 + Activity.ballSizeFactor[Activity.sublevel - 1])
                }
            }
        }

        // Lower green balls sample
        Grid {
            id: greenBalls
            x: rootWindow.width / 5
            y: rootWindow.height / 1.2
            rows: 1
            columns: 4
            Repeater {
                model: greenBalls.columns
                Image {
                    id: greenBall
                    source: Activity.url + "green_ball.svg"
                    height: rootWindow.height / (8 + Activity.ballSizeFactor[Activity.sublevel - 1])
                    width: rootWindow.width / (15 + Activity.ballSizeFactor[Activity.sublevel - 1])
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
                columns: 15
                x: 0
                y: rootWindow.height / 1.4
                Repeater {
                    id: startCase
                    model: boxes.columns
                    Image {
                        id: greenCase
                        source: Activity.url + ((index == boxes.columns - 1) ? "case_last.svg" : "case.svg")
                        height: rootWindow.height / (9 + (Activity.sublevel - 1) * Activity.elementSizeFactor[Activity.sublevel - 1])
                        width: rootWindow.width / (15 + (Activity.sublevel - 1) * Activity.elementSizeFactor[Activity.sublevel - 1])
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
                    x: rootWindow.width / 2000
                    y: rootWindow.height / 1.4
                    columns: 15
                    rows: 1
                    Repeater {
                        model: answerBallsPlacement.columns
                        Image {
                            id: greenBall
                            source: Activity.url + "green_ball.svg"
                            height: rootWindow.height / (9 + (Activity.sublevel - 1) * Activity.elementSizeFactor[Activity.sublevel - 1])
                            width: rootWindow.width / (15 + (Activity.sublevel - 1) * Activity.elementSizeFactor[Activity.sublevel - 1])
                            opacity: 0.0
                        }
                    }
                }
            }

            // Masks
            Grid {
                id: masks
                x: rootWindow.width / 2000
                y: rootWindow.height / 1.4
                rows: 1
                columns: 15
                Repeater {
                    id: startMask
                    model: masks.columns
                    Image {
                        id: greenMask
                        source: Activity.url + ((index == boxes.columns - 1) ? "mask_last.svg" : "mask.svg")
                        height: rootWindow.height / (9 + (Activity.sublevel - 1) * Activity.elementSizeFactor[Activity.sublevel - 1])
                        width: rootWindow.width / (15 + (Activity.sublevel - 1) * Activity.elementSizeFactor[Activity.sublevel - 1])
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
            source: Activity.url + "ok.svg"
            MouseArea {
                id: okArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    tuxArea.hoverEnabled = false;
                    tuxArea.enabled = false;
                    var value = numberOfBalls.text
                    numberOfBalls.text = Activity.numberBalls[Activity.sublevel - 1][0];
                    Activity.play(true, value);
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

            GCText {
                text: qsTr("OK")
                fontSizeMode: smallSize
                color: 'white'
                anchors.centerIn: playLabel
            }
        }

        // Number of balls to be placed
        Image {
            id: ballNumberPlate
            x: rootWindow.width / 1.3
            y: rootWindow.height / 1.2
            source: Activity.url + "enumerate_answer.svg"
            width: rootWindow.width / 7
            height: rootWindow.height / 8
            MouseArea {
                id: numberPlateArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    parent.source = Activity.url + "enumerate_answer_focus.svg";
                    Activity.noOfBalls ++;
                    if (Activity.noOfBalls > Activity.numberBalls[Activity.sublevel - 1 ][1]) {
                        Activity.noOfBalls = Activity.numberBalls[Activity.sublevel - 1 ][0];
                    }
                    numberOfBalls.text = Activity.noOfBalls;
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
                id: numberOfBalls
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

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: {
                win.connect(Activity.reSetup)
                loose.connect(Activity.reSetup)
            }
        }
    }
}
