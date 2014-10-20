/* GCompris - Screen.qml
 *
 * Copyright (C) 2014 <Arkit Vora>
 *
 * Authors:
 *   Srishti Sethi <srishakatux@gmail.com> (GTK+ version)
 *   Arkit Vora <arkitvora123@gmail.com> (Qt Quick port)
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
import QtQuick.Layouts 1.1
import GCompris 1.0
import "../../core"
import "braille_alphabets.js" as Activity
import "questions.js" as Dataset

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property var dataset

    pageComponent: Image {
        id: background
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        source: Activity.url + "background.svg"
        sourceSize.width: parent.width
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
            property alias containerModel: containerModel
            property alias questionItem: questionItem
            property string instructions
            property alias playableChar: playableChar
        }

        onStart: {
            first_screen.visible = true
            Activity.start(items, dataset)
        }
        onStop: { Activity.stop() }


        ListModel {
            id: containerModel
        }

        Image {
            id: charList
            y: 20 * ApplicationInfo.ratio
            anchors.horizontalCenter: parent.horizontalCenter
            source: Activity.url + "top_back.svg"
            sourceSize.width: parent.width * 0.94

            Row {
                id: row
                spacing: 10 * ApplicationInfo.ratio
                anchors.centerIn: charList
                anchors.horizontalCenterOffset: 5

                Repeater {
                    id: cardRepeater
                    model: containerModel

                    Item {
                        id: inner
                        height: charList.height * 0.9
                        width: (charList.width - containerModel.count * row.spacing)/ containerModel.count

                        Rectangle {
                            id: rect1
                            width:  charList.width / 13
                            height: width * 1.5
                            border.width: 3
                            border.color: "black"
                            color: "white"

                            BrailleChar {
                                id: ins
                                width: parent.width * 0.9
                                anchors.centerIn: parent
                                clickable: false
                                brailleChar: letter
                            }
                        }

                        Text {
                            text: letter
                            font.weight: Font.DemiBold
                            style: Text.Outline
                            styleColor: "black"
                            color: "white"
                            font.pointSize: Math.max(parent.width * 0.2, 12)
                            anchors {
                                top: rect1.bottom
                                topMargin: 6 * ApplicationInfo.ratio
                                horizontalCenter: rect1.horizontalCenter
                            }
                        }
                    }

                }
            }
        }

        Image {
            id: playableCharBg
            anchors {
                top: charList.bottom
                topMargin: 10 * ApplicationInfo.ratio
                bottom: bar.top
                bottomMargin: 40 * ApplicationInfo.ratio
            }
            verticalAlignment: Image.AlignTop
            x: 10 * ApplicationInfo.ratio
            source: Activity.url + "char_background.svg"
            sourceSize.width: Math.min(height * 0.8, parent.width / 2)
            fillMode: Image.PreserveAspectFit

            BrailleChar {
                id: playableChar
                clickable: true
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    topMargin: 20 * ApplicationInfo.ratio
                }
                width: parent.width * 0.5
                height: width * 1.5
                isLetter: items.isLetter
                onBrailleCharChanged: {
                    if(brailleChar === Activity.getCurrentLetter()) {
                        particles.emitter.burst(40)
                        Activity.nextQuestion()
                    }
                }
            }

            Text {
                id: playableCharDisplay
                font.pointSize: Math.max(parent.width * 0.2, 12)
                font.weight: Font.DemiBold
                style: Text.Outline
                styleColor: "black"
                color: "white"
                text: playableChar.brailleChar
                anchors {
                    top: playableChar.bottom
                    topMargin: 6 * ApplicationInfo.ratio
                    horizontalCenter: parent.horizontalCenter
                }
            }
        }

        Rectangle {
            id: instructionsArea
            height: questionItem.height * 1.1
            width: parent.width / 1.1
            anchors {
                top: charList.bottom
                topMargin: 10 * ApplicationInfo.ratio
                left: playableCharBg.right
                leftMargin: 10 * ApplicationInfo.ratio
                right: parent.right
                rightMargin: 10 * ApplicationInfo.ratio
            }
            color: "#55333333"
            border.color: "black"
            border.width: 2
            radius: 5

            Text {
                id: questionItem
                anchors.centerIn: parent
                font.pointSize: 14
                horizontalAlignment: Text.AlignHCenter
                font.weight: Font.DemiBold
                style: Text.Outline
                styleColor: "black"
                color: "white"
                width: parent.width * 0.94
                wrapMode: Text.WordWrap

                function initQuestion() {
                    playableChar.brailleChar = ""
                    playableChar.updateDotsFromBrailleChar()
                    text = Activity.getCurrentTextQuestion()
                    if(items.instructions)
                        text += "\n" + items.instructions
                    opacity = 1.0
                }

                onOpacityChanged: opacity == 0 ? initQuestion() : ""
                Behavior on opacity { PropertyAnimation { duration: 1000 } }
            }
        }

        ParticleSystemStar {
            id: particles
            clip: false
        }

        FirstScreen {
            id: first_screen
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        BrailleMap {
            id: dialogMap
            // Make is non visible or we get some rendering artefacts before
            // until it is created
            visible: false
            onClose: home()
        }

        Bar {
            id: bar
            anchors {
                right: parent.right
            }
            content: BarEnumContent { value: help | home | previous | next }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        BarButton {
            id: braille_map
            source: Activity.url + "target.svg"
            anchors {
                right: bar.left
                bottom: parent.bottom
            }
            sourceSize.width: 66 * bar.barZoom
            visible: true
            onClicked: {
                dialogMap.visible = true
                displayDialog(dialogMap)
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}

