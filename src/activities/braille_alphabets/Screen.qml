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
        source: "qrc:/gcompris/src/activities/braille_alphabets/resource/mosaic.svgz"
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
            property alias instructions: instructions
            property alias ans: ans
            property alias circles: circles
        }

        onStart: { Activity.start(items, dataset) }
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

        Item {
            id: outer
            x: parent.width / 2
            y: parent.height / 15
            width : parent.width / 1.06
            height :  parent.height / 3.7
            anchors.horizontalCenter: parent.horizontalCenter

            Row {
                spacing: 17
                anchors.centerIn: outer

                Repeater {
                    id: cardRepeater
                    model: containerModel

                    Item {
                        id: inner
                        height: outer.height
                        width: outer.width / 12

                        Rectangle {
                            id: rect1
                            width:  outer.width / 13; height: outer.height / 1.5
                            border.width: 3
                            border.color: "black"
                            color: "white"


                            BrailleChar {
                                id: ins
                                wid: rect1.height / 3.4
                                hei: rect1.height / 3.4
                                anchors.centerIn: rect1
                                clickable: false

                            }
                        }

                        Text {
                            text: letter
                            scale:  2
                            y: parent.height / 1.3
                            x: parent.width / 2.2

                        }
                    }

                }
            }
        }

        Item {
            id: box
            height: parent.height / 3
            width: parent.width / 3
            x: parent.width / 9
            y: parent.height / 1.9

            BrailleChar {

                id: circles
                clickable: true
                anchors.centerIn: box.left
                wid: parent.height / 3
                hei: parent.height / 3
            }

        }

        Rectangle {
            id: instructionsArea
            height: parent.height / 16
            width: parent.width / 1.1
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: outer.bottom
            color: "#55333333"
            border.color: "black"
            border.width: 2
            radius: 5
            anchors.leftMargin: 10
            anchors.rightMargin: 10


            Text {
                id: questionItem
                anchors.leftMargin: 10
                x: parent.width / 2
                y: parent.height / 7
                anchors.centerIn: parent
                font.pointSize: instructionsArea.height / 3
                horizontalAlignment: Text.AlignHCenter
                font.weight: Font.DemiBold
                style: Text.Outline
                styleColor: "white"
                color: "black"
                width: parent.width
                wrapMode: Text.WordWrap

                function initQuestion() {
                    text = Activity.getCurrentTextQuestion()

                    opacity = 1.0
                }

                onOpacityChanged: opacity == 0 ? initQuestion() : ""
                Behavior on opacity { PropertyAnimation { duration: 500 } }
            }
        }

        Text {
            id: instructions
            anchors.top: instructionsArea.bottom
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
            wrapMode: Text.WordWrap
            color: "black"
            style: Text.Outline
            styleColor: "white"
            font.weight: Font.DemiBold
            font.pointSize: instructionsArea.height / 3
            text: ""
        }

        ParticleSystemStar {
            id: particles
            clip: false
        }


        Image {
            id: okbutton
            x: parent.width / 2
            y: parent.height / 1.5
            width: parent.height / 10
            height: parent.height / 10
            source: "qrc:/gcompris/src/core/resource/apply.svgz"

            MouseArea {
                id: mou

                function arraysEqual(a, b) {
                    if (a === b) return true;
                    if (a == null || b == null) return false;
                    if (a.length != b.length) return false;
                    for (var i = 0; i < a.length; ++i) {
                        if (a[i] !== b[i]) return false;
                    }
                    return true;
                }

                function correct() {

                    var arr = [];
                    for(var i  = 0; i <= 5; i++) {
                        if(circles.circles.itemAt(i).state == "on") {
                            arr.push((i+1));
                        }
                    }

                    var ya  = [];
                    ya  = Activity.getCurrentArr()
                    var t;
                    var answer  = [];
                    for( t  = 0;t<ya.length;t++) {
                        answer[t]  = ya[t].pos
                    }

                    if(arraysEqual(arr,answer )) {
                        particles.emitter.burst(100)
                        wrong.opacity  = 0
                        ans.opacity  = 1
                        circles.circles.itemAt(0).state  = "off"
                        circles.circles.itemAt(1).state  = "off"
                        circles.circles.itemAt(2).state  = "off"
                        circles.circles.itemAt(3).state  = "off"
                        circles.circles.itemAt(4).state  = "off"
                        circles.circles.itemAt(5).state  = "off"
                        ans.text  = Activity.getCurrentAlphabet()
                        Activity.nextQuestion()

                    }
                    else {
                        ans.opacity  = 0
                        wrong.opacity  = 1
                        wrong.visible  = true
                    }
                }

                anchors.fill: parent
                onClicked: correct()
                onPressed: okbutton.opacity  = 0.4
                onReleased: okbutton.opacity  = 1
            }
        }

        Image {
            id: wrong
            x: parent.width / 1.23
            y: parent.height / 1.70
            width: parent.height / 7
            height: parent.height / 7
            source: "qrc:/gcompris/src/core/resource/cancel.svgz"
            visible: false
        }

        Text {
            id: ans
            scale: 2
            x: parent.width / 1.20
            y: parent.height / 1.63
            font.pointSize: parent.height / 20
            font.weight: Font.DemiBold
            style: Text.Outline

            Behavior on opacity { PropertyAnimation { duration: 1000} }
            styleColor: "white"
            color: "black"
            text: ""
        }

        Image {
            id: first_screen
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            source: "qrc:/gcompris/src/activities/braille_alphabets/resource/braille_tux.svgz"
            sourceSize.width: parent.width

            Text {
                id: heading
                text: "Braille : Unlocking the Code"
                font.pointSize: parent.height / 24
                horizontalAlignment: Text.AlignHCenter
                font.weight: Font.DemiBold
                anchors.centerIn: parent.Center
                color: "black"
                width: parent.width
                wrapMode: Text.WordWrap

            }

            Text {
                id: body_text1
                text: "The Braille system is a method that is used by blind people to read and write.

Each Braille character, or cell, is made up of six dot positions, arranged in a rectangle containing two columns of three dots each. As seen on the left, each dot is referenced by a number from 1 to 6."
                font.pointSize:  parent.height / 40

                font.weight: Font.DemiBold
                x: parent.width / 2.7
                y: parent.height / 2.5
                color: "black"
                width: parent.width / 2
                wrapMode: Text.WordWrap

            }

            Text {
                id: bottom_text
                text: "When you are ready, click on
me and try reproducing Braille characters."
                font.pointSize:  parent.height / 45
                font.weight: Font.DemiBold
                x: parent.width / 2.7
                y: parent.height / 1.15
                color: "black"
                width: parent.width / 2
                wrapMode:  Text.WordWrap

            }

            Rectangle {
                id: tux_square
                anchors.bottom: parent.bottom
                radius: 10
                anchors.right: parent.right
                color: "transparent"
                width: parent.width / 3
                height: parent.width / 3


                MouseArea {
                    id: tux_click
                    anchors.fill: parent

                    function tux_onClicked() {
                        first_screen.visible  = false

                    }
                    function tux_onHover() {
                        tux_square.color  = "#E41B2D"
                        tux_square.opacity  = 0.3
                    }
                    function tux_onExit() {
                        tux_square.color  = "transparent"
                        tux_square.opacity  = 1
                    }
                    hoverEnabled: true
                    onClicked: tux_onClicked()
                    onEntered: tux_onHover()
                    onExited: tux_onExit()
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

