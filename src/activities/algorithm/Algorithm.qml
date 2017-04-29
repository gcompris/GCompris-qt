/* GCompris - algorithm.qml
 *
 * Copyright (C) 2014 Bharath M S <brat.197@gmail.com>
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
import QtQuick 2.6
import GCompris 1.0
import "../../core"
import "algorithm.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: Activity.url + "desert_scene.svg"
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
            property alias questionTray: questionTray
            property alias answerTray: answerTray
            property alias choiceTray: choiceTray
            property alias question: question
            property alias answer: answer
            property alias choice: choice
            property GCAudio audioEffects: activity.audioEffects
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property int nbSubLevel: 3
            property int currentSubLevel: 0
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Column {
            id: column
            spacing: 10
            x: parent.width * 0.1
            y: parent.height * 0.1
            width: parent.width * 0.8

            property int itemWidth: width / Activity.images.length - 10
            property int itemHeight: itemWidth

            Rectangle {
                id: questionTray
                height: column.itemHeight + 10
                width: parent.width + 10
                color: "#55333333"
                border.color: "black"
                border.width: 0
                radius: 5

                Row {
                    anchors.topMargin: 4
                    anchors.bottomMargin: 4
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    anchors.fill: parent
                    spacing: 10
                    Repeater {
                        id: question
                        Image {
                            source: Activity.url + modelData + '.svg'
                            sourceSize.height: questionTray.height
                            width: column.itemWidth
                            height: column.itemHeight
                        }
                    }
                }
            }

            Rectangle {
                id: answerTray
                height: column.itemHeight + 10
                width: parent.width + 10
                color: "#55333333"
                border.color: "black"
                border.width: 0
                radius: 5
                Row {
                    anchors.topMargin: 4
                    anchors.bottomMargin: 4
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    anchors.fill: parent
                    spacing: 10
                    Repeater {
                        id: answer
                        Image {
                            source: "qrc:/gcompris/src/activities/algorithm/resource/" +
                                    modelData + '.svg'
                            sourceSize.height: answerTray.height
                            width: column.itemWidth
                            height: column.itemHeight
                        }
                    }
                }
            }

            // A spacer
            Item {
                height: column.itemHeight / 2
                width: parent.width
            }

            Rectangle {
                id: choiceTray
                height: column.itemHeight + 10
                width: parent.width + 10
                color: "#55333333"
                border.color: "black"
                border.width: 0
                radius: 5
                Row {
                    anchors.topMargin: 4
                    anchors.bottomMargin: 4
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    anchors.fill: parent
                    spacing: 10
                    Repeater {
                        id: choice
                        model: Activity.images
                        Image {
                            id: img
                            source: Activity.url + modelData + '.svg'
                            sourceSize.height: parent.height
                            width: column.itemWidth
                            height: column.itemHeight
                            state: "notclicked"
                            signal clicked
                            MouseArea {
                                id: mouseArea
                                hoverEnabled: true
                                anchors.fill: parent
                                onClicked: {
                                    if(Activity.clickHandler(modelData)) {
                                        particle.burst(20)
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

                            ParticleSystemStarLoader {
                                id: particle
                                clip: false
                            }
                        }
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

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextSubLevel)
        }

        Score {
            anchors {
                bottom: parent.bottom
                bottomMargin: 10 * ApplicationInfo.ratio
                right: parent.right
                rightMargin: 10 * ApplicationInfo.ratio
                top: undefined
                left: undefined
            }
            numberOfSubLevels: items.nbSubLevel
            currentSubLevel: items.currentSubLevel + 1
        }
    }
}
