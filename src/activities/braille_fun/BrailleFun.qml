/* GCompris - braille_fun.qml
 *
 * SPDX-FileCopyrightText: 2014 Arkit Vora <arkitvora123@gmail.com>
 *
 * Authors:
 *   Srishti Sethi (GTK+ version)
 *   Arkit Vora <arkitvora123@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
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
        sourceSize.width: width
        sourceSize.height: height
        source: Activity.url + "hillside.svg"
        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        Keys.onPressed: {
            if(event.key === Qt.Key_Space)
                brailleMap.clicked();
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property GCSfx audioEffects: activity.audioEffects
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias questionItem: questionItem
            property alias score: score
            property alias cardRepeater: cardRepeater
            property alias animateX: animateX
            property alias charBg: charBg
            property string question
            property int baseMargins: 10 * ApplicationInfo.ratio
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Item {
            id: layoutArea
            anchors.top: planeText.bottom
            anchors.bottom: background.bottom
            anchors.left: background.left
            anchors.right: background.right
            anchors.bottomMargin: bar.height * 1.3
        }

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

        Item {
            id: charBg
            anchors {
                top: layoutArea.top
                bottom: score.top
                left: layoutArea.left
                right: layoutArea.right
                margins: items.baseMargins
            }

            property int charWidth: Math.min(120 * ApplicationInfo.ratio, width * 0.3)

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
                spacing: items.baseMargins
                anchors.centerIn: parent

                Repeater {
                    id: cardRepeater

                    Item {
                        id: inner
                        height: charBg.height - 2 * items.baseMargins
                        width: charBg.charWidth
                        property string brailleChar: ins.brailleChar
                        property alias ins: ins

                        Rectangle {
                            id: rect1
                            width:  parent.width
                            height: ins.height
                            anchors.horizontalCenter: inner.horizontalCenter
                            anchors.top: parent.top
                            border.width: ins.found ? 0 : 2 * ApplicationInfo.ratio
                            border.color: "#fff"
                            radius: items.baseMargins
                            color: ins.found ? '#85d8f6' : "#dfe1e8"

                            BrailleChar {
                                id: ins
                                clickable: true
                                anchors.centerIn: rect1
                                width: parent.width * 0.5
                                isLetter: true
                                onBrailleCharChanged: {
                                    inner.brailleChar = ins.brailleChar
                                    var answerString = "" ;
                                    if(brailleChar == "") {
                                        // fix TypeError on level change
                                        return
                                    }
                                    for(var i = 0 ; i < items.currentLevel + 1 ; i++ ) {
                                        answerString = answerString + cardRepeater.itemAt(i).brailleChar;
                                    }
                                    if(answerString === items.question) {
                                        charBg.clickable(false)
                                        Activity.goodAnswer()
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
            anchors.bottom: layoutArea.bottom
            anchors.right: layoutArea.right
            anchors.rightMargin: items.baseMargins
            anchors.top: undefined
            anchors.left: undefined
            onStop: Activity.nextQuestion()
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
            level: items.currentLevel + 1
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
            source: "qrc:/gcompris/src/activities/braille_alphabets/resource/braille_button.svg"
            anchors {
                right: background.right
                top: background.top
                margins: items.baseMargins
            }
            sourceSize.width: 60 * ApplicationInfo.ratio
            onClicked: {
                dialogMap.visible = true
                displayDialog(dialogMap)
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: {
                win.connect(Activity.nextLevel)
            }
        }
    }

}
