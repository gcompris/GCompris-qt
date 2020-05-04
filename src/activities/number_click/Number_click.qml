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

        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        /*Set a workspace*/
        Rectangle {
            id: workspace

            height: parent.height * 0.6
            width: parent.width * 0.3

            color: "#ABCDEF"
            border.width: 4
            border.color: "grey"
            radius : 30

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            /*Display the number in letters*/
            Text {
                id: numberInLetters

                color: "white"

                font.pointSize: 36 * background.height / 1080

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: parent.height * 0.05
            }

            /*Display the number in numeric*/
            Text {
                id: numericNumber

                color: "white"
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

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: numericNumber.bottom
                anchors.topMargin: parent.height * 0.05

                MouseArea {
                    id: tuxArea

                    anchors.fill: parent

                    onPressed: {
                        parent.source = Activity.url + "tux_clicked.svg"
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
                        Activity.checkAnswer()
                    }
                    onReleased: { buttonTick.height = parent.height * 0.6 }
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
