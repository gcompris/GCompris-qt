/* GCompris - braille_fun.qml
 *
 * Copyright (C) 2014 Arkit Vora <arkitvora123@gmail.com>
 *
 * Authors:
 *   Srishti Sethi (GTK+ version)
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
import GCompris 1.0

import "../../core"
import "../braille_alphabets"
import "braille_fun.js" as Activity



ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        sourceSize.width: Math.max(parent.width, parent.height)
        source: Activity.url + "hillside.svg"
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
            property alias questionItem: questionItem
            property alias score: score
            property alias cardRepeater: cardRepeater
            property alias animateX: animateX
            property alias charBg: charBg
            property string question
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Item {
            id: planeText
            width: plane.width
            height: plane.height
            x: - width
            anchors.top: parent.top
            anchors.topMargin: 20 * ApplicationInfo.ratio

            Image {
                id: plane
                anchors.centerIn: planeText
                anchors.top: parent.top
                source: Activity.url + "plane.svg"
                sourceSize.height: 90 * ApplicationInfo.ratio
            }

            GCText {
                id: questionItem
                anchors.right: planeText.right
                anchors.rightMargin: plane.width / 2
                anchors.verticalCenter: planeText.verticalCenter
                fontSize: hugeSize
                font.weight: Font.DemiBold
                color: "#2a2a2a"
                text: items.question
            }

            PropertyAnimation {
                id: animateX
                target: planeText
                properties: "x"
                from: - planeText.width
                to: background.width
                duration: 11000
                easing.type: Easing.OutInCirc
                loops: Animation.Infinite
            }
        }

        Rectangle {
            id: charBg
            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
                rightMargin: 20 * ApplicationInfo.ratio
            }
            width: charWidth * cardRepeater.model
            height: charWidth * 1.5
            color: "#AAFFFFFF"
            border.width: 0
            radius: 5

            property int charWidth: Math.min(150 * ApplicationInfo.ratio,
                            parent.width * 0.3)

            function clickable(status) {
                for(var i=0 ; i < cardRepeater.model ; i++) {
                    cardRepeater.itemAt(i).ins.clickable = status
                }
            }

            function clearAllLetters() {
                for(var i=0 ; i < cardRepeater.model ; i++) {
                    cardRepeater.itemAt(i).ins.clearLetter()
                }
            }

            Row {
                id: row
                spacing: 5 * ApplicationInfo.ratio
                anchors.centerIn: parent

                Repeater {
                    id: cardRepeater

                    Item {
                        id: inner
                        height: charBg.height * 0.9
                        width: charBg.charWidth
                        property string brailleChar: ins.brailleChar
                        property alias ins: ins

                        Rectangle {
                            id: rect1
                            width:  charBg.charWidth * 0.6
                            height: ins.height
                            anchors.horizontalCenter: inner.horizontalCenter
                            border.width: 0
                            color: ins.found ? '#FFa3f9a3' : "#ffef6949"

                            BrailleChar {
                                id: ins
                                clickable: true
                                anchors.centerIn: rect1
                                width: parent.width * 0.9
                                isLetter: true
                                onBrailleCharChanged: {
                                    inner.brailleChar = ins.brailleChar
                                    var answerString = "" ;
                                    for(var i = 0 ; i < Activity.currentLevel + 1 ; i++ ) {
                                        answerString = answerString + cardRepeater.itemAt(i).brailleChar;
                                    }
                                    if(answerString === items.question) {
                                        charBg.clickable(false)
                                        bonus.good("tux")
                                        score.currentSubLevel ++;
                                    }
                                }
                                property string question: items.question[modelData] ? items.question[modelData] : ""
                                property bool found: question === brailleChar
                            }
                        }

                        GCText {
                            text: brailleChar
                            font.weight: Font.DemiBold
                            color: "#2a2a2a"
                            fontSize: hugeSize
                            anchors {
                                top: rect1.bottom
                                topMargin: 4 * ApplicationInfo.ratio
                                horizontalCenter: rect1.horizontalCenter
                            }
                        }
                    }

                }
            }
        }

        Score {
            id: score
            // @FIXME We have no way to get the real bar width, that would make this
            // calculation formal
            anchors.bottom: parent.width - bar.width * 6 > width ? parent.bottom : bar.top
            anchors.bottomMargin: 10 * ApplicationInfo.ratio
            anchors.rightMargin: 10 * ApplicationInfo.ratio
            anchors.right: parent.right
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
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        BarButton {
            id: brailleMap
            source: Activity.url + "target.svg"
            anchors {
                right: score.left
                bottom: score.bottom
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
            Component.onCompleted: {
                win.connect(Activity.nextQuestion)
                loose.connect(Activity.initQuestion)
            }
        }
    }

}
