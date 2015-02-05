/* GCompris - braille_fun.qml
 *
 * Copyright (C) 2014 Arkit Vora
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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.1
import QtQuick.Layouts 1.1
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
        sourceSize.width: parent.width
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
            property alias planeQuestion: planeQuestion
            property alias score: score
            property alias cardRepeater: cardRepeater
            property alias animateX: animateX
            property alias animateY: animateY
            property alias animateSadTux: animateSadTux
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }



        Item {

            id: planeText
            width: parent.width * 0.25
            height: parent.height * 0.25
            x: parent.width / 3


            Image {
                id: plane
                anchors.centerIn: planeText
                scale: planeText.width / 250
                anchors.top: parent.top
                anchors.topMargin: planeText.width / 10
                source: Activity.url + "plane.svg"
            }

            GCText {
                id: questionItem
                anchors.right: planeText.left
                anchors.rightMargin: planeText.width / 50
                anchors.verticalCenter: planeText.verticalCenter
                font.pixelSize: Math.max(parent.width * 0.2, 24)
                font.weight: Font.DemiBold
                color: "black"

                function initQuestion() {
                    text = Activity.getCurrentLetter()
                    animateX.start()
                    opacity = 1.0
                }

                onOpacityChanged: opacity == 0 ? initQuestion() : ""
                Behavior on opacity { PropertyAnimation { duration: 5 } }
                MouseArea {
                    anchors.fill: parent
                    onClicked: Activity.nextQuestion()
                }

            }

            PropertyAnimation {
                id: animateX
                target: planeText
                properties: "x"
                from: parent.width / 9
                to: parent.width
                duration: 11000
                onRunningChanged: {if(planeText.x == parent.width && animateX.running == false) {
                        animateSadTux.start()
                        for(var i=0 ; i < Activity.currentLevel+1 ; i++) {
                            cardRepeater.itemAt(i).ins.clickable = false
                        }
                    }
                }
            }
        }

        GCText {
            id: planeQuestion
            x: parent.width / 6
            y: 0
            font.pixelSize: Math.max(planeText.width * 0.2, 24)
            font.weight: Font.DemiBold
            style: Text.Outline
            styleColor: "white"
            color: "black"

            function initQuestion() {
                text = questionItem.text
                animateY.start()
                opacity = 1.0
            }

            onOpacityChanged: opacity == 0 ? initQuestion() : ""
            Behavior on opacity { PropertyAnimation { duration: 5 } }
            MouseArea {
                anchors.fill: parent
                onClicked: Activity.nextQuestion()
            }

            PropertyAnimation {
                id: animateY
                target: planeQuestion
                properties: "y"
                from: parent.height / 6
                to: parent.height
                duration: 12000
            }
            PropertyAnimation {
                id: animateColor
                target: planeQuestion
                properties: "color"
                from: "blue"
                to: "black"
                duration: 1000
                onRunningChanged: {
                    if(animateColor.running == false) {
                        score.currentSubLevel++;
                        Activity.nextQuestion();
                        for(var i=0 ; i < Activity.currentLevel+1 ; i++) {

                            cardRepeater.itemAt(i).ins.brailleChar = ""
                            cardRepeater.itemAt(i).clearDots();

                        }
                    }
                }
            }
        }

        Rectangle {
            id: charBg
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 20 * ApplicationInfo.ratio
            width: charWidth * cardRepeater.model
            height: charWidth * 1.2
            color: "#80CCCCCC"
            border.color: "#80666666"

            property int charWidth: Math.min(120 * ApplicationInfo.ratio,
                            parent.width * 0.3)
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

                        function clearDots() {
                            ins.updateDotsFromBrailleChar();
                        }


                        Rectangle {
                            id: rect1
                            width:  charBg.charWidth * 0.6
                            height: ins.height
                            anchors.horizontalCenter: inner.horizontalCenter
                            border.width: 3
                            border.color: "black"
                            color: "white"

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
                                        answerString = answerString + cardRepeater.itemAt(i).brailleChar + " ";
                                    }
                                    if(answerString === Activity.getCurrentLetter()) {
                                        particles.emitter.burst(40)
                                        sadTux.opacity = 0
                                        planeQuestion.color = "blue"
                                        animateColor.start();

                                    }
                                }
                            }
                        }

                        Text {
                            text: brailleChar
                            font.weight: Font.DemiBold
                            color: "black"
                            font.pixelSize: Math.max(parent.width * 0.25 , 15)
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

        Image {
            id: sadTux
            anchors.centerIn: parent
            scale: 0.5 * ApplicationInfo.ratio
            source: Activity.url + "tux_bad.svg"
            opacity: 0
            PropertyAnimation {
                id: animateSadTux
                target: sadTux
                properties: "opacity"
                from: 0
                to: 1
                duration: 1500
                onRunningChanged: if(animateSadTux.running == false) {
                                      sadTux.opacity = 0
                                      for(var i=0 ; i < Activity.currentLevel+1 ; i++) {
                                          cardRepeater.itemAt(i).ins.clickable = true
                                      }
                                      animateX.restart()
                                      animateY.restart()
                                  }
            }
        }


        Score {
            id: score
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10 * ApplicationInfo.ratio
            anchors.rightMargin: 10 * ApplicationInfo.ratio
            anchors.right: parent.right
        }


        ParticleSystemStar {
            id: particles
            clip: false
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        BrailleMap {
            id: dialogMap
            // Make is non visible or we get some rendering artefacts before
            // until it is created
            visible: true
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
