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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
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
            property GCSfx audioEffects: activity.audioEffects
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property int nbSubLevel: 3
            property int currentSubLevel: 0
            property bool blockClicks: false
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        property bool keyNavigationVisible: false

        Keys.enabled: !items.blockClicks
        Keys.onPressed: {
            keyNavigationVisible = true
            if(event.key === Qt.Key_Left)
                choiceGridView.moveCurrentIndexLeft()
            if(event.key === Qt.Key_Right)
                choiceGridView.moveCurrentIndexRight()
            if(event.key === Qt.Key_Space || event.key === Qt.Key_Enter || event.key === Qt.Key_Return)
                choiceGridView.currentItem.clicked()
        }

        Column {
            id: column
            spacing: 10
            y: parent.height * 0.05
            width: itemWidth * Activity.images.length
            anchors.horizontalCenter: parent.horizontalCenter

            property int itemWidth: Math.min(background.width * 0.75 / Activity.images.length, background.height * 0.19)

            Rectangle {
                id: questionTray
                height: column.itemWidth
                width: parent.width
                color: "#55333333"
                radius: 5

                Row {
                    anchors.topMargin: 4
                    anchors.bottomMargin: 4
                    anchors.leftMargin: 5
                    anchors.fill: parent
                    spacing: 5.7 * ApplicationInfo.ratio
                    Repeater {
                        id: question
                        // workaround for https://bugreports.qt.io/browse/QTBUG-72643 (qml binding with global variable in Repeater do not work)
                        property alias itemWidth: column.itemWidth
                        Image {
                            source: Activity.url + modelData + '.svg'
                            sourceSize.height: height
                            sourceSize.width: width
                            width: question.itemWidth - 6 * ApplicationInfo.ratio
                            height: width
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                }
            }

            Rectangle {
                id: answerTray
                height: column.itemWidth
                width: parent.width
                color: "#55333333"
                radius: 5
                Row {
                    anchors.topMargin: 4
                    anchors.bottomMargin: 4
                    anchors.leftMargin: 5
                    anchors.fill: parent
                    spacing: 5.7 * ApplicationInfo.ratio
                    Repeater {
                        id: answer
                        Image {
                            source: "qrc:/gcompris/src/activities/algorithm/resource/" +
                                    modelData + '.svg'
                            sourceSize.height: height
                            sourceSize.width: width
                            width: question.itemWidth - 6 * ApplicationInfo.ratio
                            height: width
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                }
            }

            // A spacer
            Item {
                height: column.itemWidth / 2
                width: parent.width
            }

            Rectangle {
                id: choiceTray
                height: column.itemWidth + 3 * ApplicationInfo.ratio
                width: parent.width
                color: "#55333333"
                radius: 5

                GridView {
                    id: choiceGridView
                    anchors.fill: parent
                    model: Activity.images
                    cellWidth: column.itemWidth
                    cellHeight: cellWidth
                    interactive: false
                    keyNavigationWraps: true
                    highlightFollowsCurrentItem: true
                    highlight: Rectangle {
                        width: parent.cellWidth
                        height: parent.cellHeight
                        color:  "#AAFFFFFF"
                        border.width: 2
                        border.color: "white"
                        visible: background.keyNavigationVisible
                        Behavior on x { SpringAnimation { spring: 2; damping: 0.2 } }
                        Behavior on y { SpringAnimation { spring: 2; damping: 0.2 } }
                    }

                    delegate: Item {
                        id: cellItem
                        width: choiceGridView.cellWidth
                        height: choiceTray.height

                        signal clicked
                        onClicked: {
                            if(Activity.clickHandler(modelData)) {
                                particle.burst(20)
                            }
                        }

                        Image {
                            id: img
                            source: Activity.url + modelData + '.svg'
                            width: question.itemWidth - 6 * ApplicationInfo.ratio
                            height: width
                            sourceSize.width: width
                            sourceSize.height: height
                            anchors.centerIn: parent
                            fillMode: Image.PreserveAspectFit
                            state: "notclicked"

                            MouseArea {
                                id: mouseArea
                                hoverEnabled: enabled
                                enabled: !items.blockClicks
                                anchors.fill: parent
                                onClicked: cellItem.clicked()
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
            onStop: items.blockClicks = false
            Component.onCompleted: win.connect(Activity.nextSubLevel)
        }

        Score {
            anchors {
                bottom: bar.top
                bottomMargin: 10 * ApplicationInfo.ratio
                right: parent.right
                rightMargin: 5 * ApplicationInfo.ratio
                top: undefined
                left: undefined
            }
            numberOfSubLevels: items.nbSubLevel
            currentSubLevel: items.currentSubLevel + 1
        }
    }
}
