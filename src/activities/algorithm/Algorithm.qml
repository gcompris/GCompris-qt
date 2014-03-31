/* GCompris - algorithm.qml
 *
 * Copyright (C) 2014 Bharath M S
 *
 * Authors:
 *   Christof Petig and Ingo Konrad (GTK+ version)
 *   Bharath M S <brat.197@gmail.com> (Qt Quick port)
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
import QtQuick 2.2
import QtMultimedia 5.0
import GCompris 1.0
import "qrc:/gcompris/src/core"
import "algorithm.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: "qrc:/gcompris/src/activities/algorithm/resource/scenery5_background.png"
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
            property alias questionTray: questionTray
            property alias answerTray: answerTray
            property alias choiceTray: choiceTray
            property alias question: question
            property alias answer: answer
            property alias choice: choice
            property alias audio: audio
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Rectangle {
            id: questionTray
            height: parent.height / 8
            width: parent.width - parent.width / 3
            x: parent.width / 6
            y: parent.height / 15
            color: "#55333333"
            border.color: "black"
            border.width: 2
            radius: 5
            Row {
                anchors.leftMargin: parent.width/70
                anchors.fill: parent
                anchors.rightMargin: parent.width/70
                spacing: parent.width/70
                Repeater {
                    id: question
                    Image {
                        source: Activity.url + modelData + '.svgz'
                        visible: true
                        height: questionTray.height
                        width: questionTray.width/9
                    }
                }
            }
        }

        Rectangle {
            id: answerTray
            height: parent.height/8
            width: parent.width - parent.width/3
            x: parent.width/6
            y: parent.height/4 + 8
            color: "#55333333"
            border.color: "black"
            border.width: 2
            radius: 5
            Row {
                anchors.topMargin: 10
                anchors.bottomMargin: 10
                anchors.leftMargin: parent.width/70
                anchors.fill: parent
                anchors.rightMargin: parent.width/70
                spacing: parent.width/70
                Repeater {
                    id: answer
                    Image {
                        source: "qrc:/gcompris/src/activities/algorithm/resource/" +
                                modelData + '.svgz'
                        visible: true
                        height: answerTray.height
                        width: answerTray.width/9
                    }
                }
            }
        }

        Rectangle {
            id: choiceTray
            height: parent.height/8
            width: parent.width - parent.width/3
            x: parent.width/6
            y: 3*parent.height/4 - 10
            color: "#55333333"
            border.color: "black"
            border.width: 2
            radius: 5
            Row {
                anchors.leftMargin: parent.width/70
                anchors.fill: parent
                anchors.rightMargin: parent.width/70
                spacing: parent.width/70
                Repeater {
                    id: choice
                    model: Activity.images
                    Image {
                        id: img
                        source: Activity.url + modelData + '.svgz'
                        visible: true
                        height: choiceTray.height
                        width: choiceTray.width/9
                        state: "notclicked"
                        signal clicked
                        MouseArea {
                            id: mouseArea
                            hoverEnabled: true
                            anchors.fill: parent
                            onClicked: {
                                if(Activity.clickHandler(modelData)) {
                                    particle.emitter.burst(20)
                                }
                            }
                        }
                        states: [
                            State {
                                name: "notclicked"
                                PropertyChanges {
                                    target: img
                                    scale: 1.0
                                }
                            },
                            State {
                                name: "clicked"
                                when: mouseArea.pressed
                                PropertyChanges {
                                    target: img
                                    scale: 0.9
                                }
                            },
                            State {
                                name: "hover"
                                when: mouseArea.containsMouse
                                PropertyChanges {
                                    target: img
                                    scale: 1.1
                                }
                            }
                        ]

                        Behavior on scale { NumberAnimation { duration: 70 } }

                        ParticleSystemStar {
                            id: particle
                            clip: false
                        }
                    }
                }
            }
        }

        Audio {
            id: audio
            onError: console.log("play error: " + errorString)
        }

        DialogHelp {
            id: dialogHelp
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

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }
}
