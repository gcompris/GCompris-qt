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
        source: "qrc:/gcompris/src/activities/braille_alphabets/resource/background.svg"
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
            property alias mapContainerModel: mapContainerModel
            property alias mapContainerModel2: mapContainerModel2
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

        ListModel {
            id: mapContainerModel
        }

        ListModel {
            id: mapContainerModel2
        }

        Image {
            id: charList
            x: parent.width / 2
            y: 20 * ApplicationInfo.ratio
            anchors.horizontalCenter: parent.horizontalCenter
            source: "qrc:/gcompris/src/activities/braille_alphabets/resource/top_back.svg"
            sourceSize.width: parent.width * 0.94
            sourceSize.height: parent.height * 0.33

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
                            height: charList.height / 1.5
                            border.width: 3
                            border.color: "black"
                            color: "white"

                            BrailleChar {
                                id: ins
                                dotWidth: rect1.height / 3.4
                                dotHeight: rect1.height / 3.4
                                anchors.centerIn: rect1
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

        Rectangle {
            id: instructionsArea
            height: questionItem.height * 1.1
            width: parent.width / 1.1
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: charList.bottom
            anchors.topMargin: 10 * ApplicationInfo.ratio
            color: "#55333333"
            border.color: "black"
            border.width: 2
            radius: 5
            anchors.leftMargin: 10
            anchors.rightMargin: 10

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
                    text = Activity.getCurrentTextQuestion()
                    if(items.instructions)
                        text += "\n" + items.instructions
                    opacity = 1.0
                }

                onOpacityChanged: opacity == 0 ? initQuestion() : ""
                Behavior on opacity { PropertyAnimation { duration: 500 } }
            }
        }

        Image {
            id: playableCharBg
            anchors {
                top: instructionsArea.bottom
                topMargin: 10 * ApplicationInfo.ratio
                bottom: bar.top
                bottomMargin: 40 * ApplicationInfo.ratio
            }
            x: 10 * ApplicationInfo.ratio
            source: "qrc:/gcompris/src/activities/braille_alphabets/resource/char_background.svg"
            sourceSize.width: height * 0.8
            fillMode: Image.PreserveAspectFit

            BrailleChar {
                id: playableChar
                clickable: true
                anchors.centerIn: parent
                anchors.verticalCenterOffset: - 20 * ApplicationInfo.ratio
                width: parent.width * 0.8
                height: width * 0.5
                isLetter: items.isLetter
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
                    horizontalCenter: playableChar.horizontalCenter
                }
                Behavior on opacity { PropertyAnimation { duration: 100} }
            }
        }

        ParticleSystemStar {
            id: particles
            clip: false
        }

        Image {
            id: first_screen
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            source: "qrc:/gcompris/src/activities/braille_alphabets/resource/intro_bg.svg"
            sourceSize.width: parent.width

            Text {
                id: heading
                text: "Braille : Unlocking the Code"
                font.pointSize: 24
                horizontalAlignment: Text.AlignHCenter
                font.weight: Font.DemiBold
                anchors.centerIn: parent.Center
                color: "white"
                width: parent.width
                wrapMode: Text.WordWrap
            }

            Image {
                id: introChar
                source: "qrc:/gcompris/src/activities/braille_alphabets/resource/intro_braille_char.svg"
                sourceSize.width: parent.width * 0.25
                fillMode: Image.PreserveAspectFit
                anchors {
                    top: heading.bottom
                    topMargin: 30 * ApplicationInfo.ratio
                    bottom: parent.bottom
                    bottomMargin: 60 * ApplicationInfo.ratio
                    left: parent.left
                    leftMargin:  30 * ApplicationInfo.ratio
                }
            }

            Text {
                id: body_text1
                text: qsTr('The Braille system is a method that is used by blind people to read and write.' +
                           'Each Braille character, or cell, is made up of six dot positions, arranged in ' +
                           'a rectangle containing two columns of three dots each. As seen on the left, each ' +
                           'dot is referenced by a number from 1 to 6.')
                font.pointSize:  14
                font.weight: Font.DemiBold
                horizontalAlignment: Text.AlignJustify
                anchors {
                    top: heading.bottom
                    topMargin: 30 * ApplicationInfo.ratio
                    right: parent.right
                    rightMargin: 30 * ApplicationInfo.ratio
                    left: introChar.right
                    leftMargin: 30 * ApplicationInfo.ratio
                }
                color: "white"
                width: parent.width / 2
                wrapMode: Text.WordWrap
            }

            Text {
                id: bottom_text
                text: qsTr("When you are ready, click on me and try reproducing Braille characters.")
                font.pointSize:  12
                font.weight: Font.DemiBold
                width: parent.width * 0.3
                color: "white"
                horizontalAlignment: Text.AlignJustify
                wrapMode:  Text.WordWrap
                anchors {
                    top: body_text1.bottom
                    topMargin: 30 * ApplicationInfo.ratio
                    left: introChar.right
                    leftMargin: 30 * ApplicationInfo.ratio
                }
            }

            Image {
                id: introTux
                source: "qrc:/gcompris/src/activities/braille_alphabets/resource/tux_braille.svg"
                fillMode: Image.PreserveAspectFit
                sourceSize.width: parent.width * 0.2
                anchors {
                    top: bottom_text.top
                    right: parent.right
                    rightMargin: 30 * ApplicationInfo.ratio
                    left: bottom_text.right
                    leftMargin: 30 * ApplicationInfo.ratio
                }
                Behavior on scale { PropertyAnimation { duration: 100} }

                MouseArea {
                    id: tux_click
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: first_screen.visible  = false
                    onEntered: introTux.scale = 1.1
                    onExited: introTux.scale = 1
                }
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        BrailleMap {
            id: dialogMap
            onClose: home()
        }

        Bar {
            id: bar
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
            source: "qrc:/gcompris/src/activities/braille_alphabets/resource/target.svg"
            anchors {
                left: bar.right
                bottom: parent.bottom

            }
            sourceSize.width: 66 * bar.barZoom
            visible: true
            onClicked: {
               displayDialog(dialogMap)
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}

