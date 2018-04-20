/* GCompris - MagicHat.qml
 *
 * Copyright (C) 2014 Thibaut ROMAIN <thibrom@gmail.com>
 *
 * Authors:
 *   <Bruno Coudoin> (GTK+ version)
 *   Thibaut ROMAIN <thibrom@gmail.com> (Qt Quick port)
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
import "magic-hat.js" as Activity
import "."

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property string mode: "minus"

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: Activity.url + "background.svg"
        sourceSize.width: Math.max(parent.width, parent.height)
        fillMode: Image.PreserveAspectCrop
        property int starSize: Math.min(rightLayout.width / 12,
                                        background.height / 16)
        signal start
        signal stop

        property var starColors : ["1", "2", "3"]
        
        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        onStart: Activity.start(items, mode)
        onStop: Activity.stop()

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property GCSfx audioEffects: activity.audioEffects
            property alias bar: bar
            property alias bonus: bonus
            property alias hat: theHat
            property alias introductionText: introText
            property var repeatersList:
                [repeaterFirstRow, repeaterSecondRow, repeaterAnswerRow]
        }

        Item {
            id: mainlayout
            anchors.left: background.left
            width: background.width * 0.4
            height: background.height
            z: 11
            Hat {
                id: theHat
                starsSize: background.starSize
                audioEffects: activity.audioEffects
            }

            GCText {
                id: introText
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    topMargin: 20 * ApplicationInfo.ratio
                }
                width: parent.width - 5 * ApplicationInfo.ratio
                fontSize: regularSize
                font.bold: true
                style: Text.Outline
                styleColor: "black"
                color: "white"
                wrapMode: TextEdit.WordWrap
                horizontalAlignment: TextEdit.AlignHCenter
                text: qsTr("Click on the hat to begin the game")
            }

            GCText {
                //: The math operation
                text: mode == "minus" ? qsTr("−") : qsTr("+")
                anchors.right: mainlayout.right
                anchors.rightMargin: 10
                y: secondRow.y
                fontSize: 66
                color: "white"
                style: Text.Outline
                styleColor: "black"
            }
        }

        Grid {
            id: rightLayout
            anchors {
                left: mainlayout.right
                right: background.right
                rightMargin: 10
                verticalCenter: background.verticalCenter
                verticalCenterOffset: background.height/8
            }
            height: background.height
            columns: 1
            Column {
                id: firstRow
                height: background.starSize * 4
                spacing: 5
                z: 10
                Repeater {
                    id: repeaterFirstRow
                    model: 3
                    StarsBar {
                        barGroupIndex: 0
                        barIndex: index
                        width: rightLayout.width
                        backgroundColor: "grey"
                        starsColor: starColors[index]
                        theHat: items.hat
                        starsSize: background.starSize
                        opacity: 0
                    }
                }
            }
            Column {
                id: secondRow
                height: background.starSize * 4
                spacing: 5
                z: 9
                Repeater {
                    id: repeaterSecondRow
                    model: 3
                    StarsBar {
                        barGroupIndex: 1
                        barIndex: index
                        width: rightLayout.width
                        backgroundColor: "grey"
                        starsColor: starColors[index]
                        theHat: items.hat
                        starsSize: background.starSize
                        opacity: 0
                    }
                }
            }

            Rectangle {
                width: (background.starSize + 5) * 10 - 5
                height: 5 * ApplicationInfo.ratio
                color: "white"
            }

            Rectangle {
                width: (background.starSize + 5) * 10 - 5
                height: 10 * ApplicationInfo.ratio
                opacity: 0
            }

            Column {
                id: answerRow
                height: background.starSize * 4
                spacing: 5
                Repeater {
                    id: repeaterAnswerRow
                    model: 3
                    StarsBar {
                        barGroupIndex: 2
                        barIndex: index
                        width: rightLayout.width
                        backgroundColor: "#53b9c9"
                        starsColor: starColors[index]
                        authorizeClick: false
                        theHat: items.hat
                        starsSize: background.starSize
                        opacity: 0
                    }
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

        BarButton {
            id: okButton
            anchors {
                bottom: bar.top
                right: parent.right
                rightMargin: 10 * ApplicationInfo.ratio
                bottomMargin: 10 * ApplicationInfo.ratio
            }
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            sourceSize.width: 60 * ApplicationInfo.ratio

            onClicked: Activity.verifyAnswer()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
