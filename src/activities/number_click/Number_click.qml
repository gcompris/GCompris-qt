/* GCompris - number_click.qml
 *
 * Copyright (C) 2018 YOUR NAME <xx@yy.org>
 *
 * Authors:
 *   <THE GTK VERSION AUTHOR> (GTK+ version)
 *   YOUR NAME <YOUR EMAIL> (Qt Quick port)
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
import GCompris 1.0

import "../../core"
import "number_click.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        source: Activity.url + "background.svg"

        fillMode: Image.PreserveAspectCrop
        sourceSize.width: Math.max(parent.width, parent.height)

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
            property alias bar: bar
            property alias bonus: bonus
            property alias tux: tux
            property alias numberInLetters: numberInLetters
            property alias numericNumber: numericNumber
            property alias errorpanel: errorpanel
            property alias correctAnswer: correctAnswer
            property alias wrongAnswer: wrongAnswer
            property alias firstbar: firstbar
            property alias secondbar: secondbar
            property alias thirdbar: thirdbar
            property alias fourthbar: fourthbar
            property alias fifthbar: fifthbar
            property alias sixthbar: sixthbar
            property alias seventhbar: seventhbar
            property alias eighthbar: eighthbar
            property alias ninthbar: ninthbar
            property alias tenthbar: tenthbar
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        /*Set the main workspace*/
        Rectangle {
            id: mainworkspace

            visible : true

            height: parent.height * 0.6
            width: parent.width * 0.3

            color: "#ABCDEF"
            border.width: 4
            border.color: "grey"
            radius : 30

            anchors.horizontalCenter: parent.horizontalCenter
            //anchors.horizontalCenterOffset: 100 * parent.width/1080
            anchors.verticalCenter: parent.verticalCenter

            /*Display the number in letters*/
            Text {
                id: numberInLetters

                color: "white"
                style: Text.Outline
                styleColor: "black"

                font.pointSize: 42 * background.height / 1080

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: parent.height * 0.05
            }

            /*Display the number in numeric*/
            Text {
                id: numericNumber

                color: numberInLetters.color
                style: numberInLetters.style
                styleColor: numberInLetters.styleColor

                font.pointSize: numberInLetters.font.pointSize
                font.bold: true

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: numberInLetters.bottom
                anchors.topMargin: numberInLetters.height * 0.1
            }

            /*Button where the player has to click to answer*/
            Image {
                id: tux
                source: Activity.url + "tux.svg"

                height: parent.height * 0.4
                fillMode: Image.PreserveAspectFit

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: numericNumber.bottom
                anchors.topMargin: parent.height * 0.05

                MouseArea {
                    id: tuxArea

                    anchors.fill: parent
                    hoverEnabled: true

                    onEntered: {
                        parent.rotation = -3
                        parent.height = mainworkspace.height * 0.41
                    }

                    onExited: {
                        parent.rotation = 0
                        parent.height = mainworkspace.height * 0.40
                    }

                    onPressed: {
                        parent.source = Activity.url + "tux_clicked.svg"
                        activity.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/smudge.wav")
                        Activity.clickCount++
                    }
                    onReleased: { parent.source = Activity.url + "tux.svg" }


                }
            }

            /*Button where the player has to click to check his answer*/
            Rectangle {
                id: buttonBox

                height: parent.height * 0.12
                width: parent.width * 0.7

                color: "#00A31B"
                border.width: 2
                border.color: "grey"
                radius: 60

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: parent.height * 0.05

                Image {
                    id: buttonTick
                    source: Activity.url + "tick.svg"

                    height: parent.height * 0.6
                    fillMode: Image.PreserveAspectFit

                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                }

                MouseArea {
                    id: buttonArea

                    anchors.fill: parent
                    hoverEnabled: true

                    onEntered: { parent.color = "#00D022" }
                    onExited: { parent.color = "#00A31B" }
                    onPressed: {
                        buttonTick.height = parent.height * 0.7
                        activity.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/bleep.wav")
                        Activity.checkAnswer()
                    }
                    onReleased: { buttonTick.height = parent.height * 0.6 }
                }
            }
        }

        /* Set the error panel */
        Rectangle {
            id: errorpanel

            visible: false

            height: parent.height * 0.6
            width : parent.width * 0.6

            color: "white"
            border.width: 4
            border.color: "black"
            radius: 30

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            MouseArea {
                id: errorpanelArea

                anchors.fill: parent
                hoverEnabled: true

                onEntered: {  }
                onExited: {  }
                onPressed: {
                    activity.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/bleep.wav")
                    errorpanel.visible = false
                }
                onReleased: {  }
            }

            Rectangle {
                id: correctAnswer

                height: tenthbar.height * 1.05
                width: firstbar.width * 1.25

                anchors.verticalCenter: parent.verticalCenter
                //anchors.horizontalCenter: firstbar.horizontalCenter

                border.color: "green"
                border.width: 7
                radius: 10
            }

            Rectangle {
                id: wrongAnswer

                height: tenthbar.height * 1.05
                width: firstbar.width * 1.25

                anchors.verticalCenter: parent.verticalCenter
                //anchors.horizontalCenter: tenthbar.horizontalCenter

                border.color: "red"
                border.width: 7
                radius: 10
            }

            Rectangle {
                id: firstbar

                height: parent.height * 0.09 //0.09 * 1
                width: parent.width * 0.07

                color: "grey"
                border.width: 2
                border.color: "black"
                radius : 10

                anchors.left: parent.left
                anchors.leftMargin: parent.width * 0.05
                anchors.bottom: parent.bottom
                anchors.bottomMargin: parent.height * 0.05

                Text {
                    id: firstbar_text

                    text: "1"
                    color: "white"
                    style: Text.Outline
                    styleColor: "black"

                    font.pointSize: 24 * background.height / 1080

                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height * 0.05
                }
            }
            Rectangle {
                id: secondbar

                height: parent.height * 0.18 //0.09 * 2
                width: parent.width * 0.07

                color: "red"
                border.width: 2
                border.color: "black"
                radius : 10

                anchors.left: firstbar.left
                anchors.leftMargin: parent.width * 0.091
                anchors.bottom: parent.bottom
                anchors.bottomMargin: parent.height * 0.05

                Text {
                    id: secondbar_text

                    text: "2"
                    color: "white"
                    style: Text.Outline
                    styleColor: "black"

                    font.pointSize: 24 * background.height / 1080

                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height * 0.05
                }
            }
            Rectangle {
                id: thirdbar

                height: parent.height * 0.27 // 0.09 * 3
                width: parent.width * 0.07

                color: "darkorange"
                border.width: 2
                border.color: "black"
                radius : 10

                anchors.left: secondbar.left
                anchors.leftMargin: parent.width * 0.091
                anchors.bottom: parent.bottom
                anchors.bottomMargin: parent.height * 0.05

                Text {
                    id: thirdbar_text

                    text: "3"
                    color: "white"
                    style: Text.Outline
                    styleColor: "black"

                    font.pointSize: 24 * background.height / 1080

                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height * 0.05
                }
            }
            Rectangle {
                id: fourthbar

                height: parent.height * 0.36 // 0.09 * 4
                width: parent.width * 0.07

                color: "green"
                border.width: 2
                border.color: "black"
                radius : 10

                anchors.left: thirdbar.left
                anchors.leftMargin: parent.width * 0.091
                anchors.bottom: parent.bottom
                anchors.bottomMargin: parent.height * 0.05

                Text {
                    id: fourthbar_text

                    text: "4"
                    color: "white"
                    style: Text.Outline
                    styleColor: "black"

                    font.pointSize: 24 * background.height / 1080

                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height * 0.05
                }
            }
            Rectangle {
                id: fifthbar

                height: parent.height * 0.45 // 0.09 * 5
                width: parent.width * 0.07

                color: "purple"
                border.width: 2
                border.color: "black"
                radius : 10

                anchors.left: fourthbar.left
                anchors.leftMargin: parent.width * 0.091
                anchors.bottom: parent.bottom
                anchors.bottomMargin: parent.height * 0.05

                Text {
                    id: fifthbar_text

                    text: "5"
                    color: "white"
                    style: Text.Outline
                    styleColor: "black"

                    font.pointSize: 24 * background.height / 1080

                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height * 0.05
                }
            }
            Rectangle {
                id: sixthbar

                height: parent.height * 0.54 // 0.09 * 6
                width: parent.width * 0.07

                color: "cyan"
                border.width: 2
                border.color: "black"
                radius : 10

                anchors.left: fifthbar.left
                anchors.leftMargin: parent.width * 0.091
                anchors.bottom: parent.bottom
                anchors.bottomMargin: parent.height * 0.05

                Text {
                    id: sixthbar_text

                    text: "6"
                    color: "white"
                    style: Text.Outline
                    styleColor: "black"

                    font.pointSize: 24 * background.height / 1080

                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height * 0.05
                }
            }
            Rectangle {
                id: seventhbar

                height: parent.height * 0.63 // 0.09 * 7
                width: parent.width * 0.07

                color: "deeppink"
                border.width: 2
                border.color: "black"
                radius : 10

                anchors.left: sixthbar.left
                anchors.leftMargin: parent.width * 0.091
                anchors.bottom: parent.bottom
                anchors.bottomMargin: parent.height * 0.05

                Text {
                    id: seventhbar_text

                    text: "7"
                    color: "white"
                    style: Text.Outline
                    styleColor: "black"

                    font.pointSize: 24 * background.height / 1080

                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height * 0.05
                }
            }
            Rectangle {
                id: eighthbar

                height: parent.height * 0.72 // 0.09 * 8
                width: parent.width * 0.07

                color: "salmon"
                border.width: 2
                border.color: "black"
                radius : 10

                anchors.left: seventhbar.left
                anchors.leftMargin: parent.width * 0.091
                anchors.bottom: parent.bottom
                anchors.bottomMargin: parent.height * 0.05

                Text {
                    id: eighthbar_text

                    text: "8"
                    color: "white"
                    style: Text.Outline
                    styleColor: "black"

                    font.pointSize: 24 * background.height / 1080

                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height * 0.05
                }
            }
            Rectangle {
                id: ninthbar

                height: parent.height * 0.81 // 0.09 * 9
                width: parent.width * 0.07

                color: "gold"
                border.width: 2
                border.color: "black"
                radius : 10

                anchors.left: eighthbar.left
                anchors.leftMargin: parent.width * 0.091
                anchors.bottom: parent.bottom
                anchors.bottomMargin: parent.height * 0.05

                Text {
                    id: ninthbar_text

                    text: "9"
                    color: "white"
                    style: Text.Outline
                    styleColor: "black"

                    font.pointSize: 24 * background.height / 1080

                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height * 0.05
                }
            }
            Rectangle {
                id: tenthbar

                height: parent.height * 0.9 // 0.09 * 10
                width: parent.width * 0.07

                color: "blue"
                border.width: 2
                border.color: "black"
                radius : 10

                anchors.left: ninthbar.left
                anchors.leftMargin: parent.width * 0.091
                anchors.bottom: parent.bottom
                anchors.bottomMargin: parent.height * 0.05

                Text {
                    id: tenthbar_text

                    text: "10"
                    color: "white"
                    style: Text.Outline
                    styleColor: "black"

                    font.pointSize: 24 * background.height / 1080

                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height * 0.05
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
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }
}
