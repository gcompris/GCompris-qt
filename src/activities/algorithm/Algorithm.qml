/* GCompris - algorithm.qml
 *
 * SPDX-FileCopyrightText: 2014 Bharath M S <brat.197@gmail.com>
 *
 * Authors:
 *   Christof Petig and Ingo Konrad (GTK+ version)
 *   Bharath M S <brat.197@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
pragma ComponentBehavior: Bound

import QtQuick 2.12
import core 1.0
import "../../core"
import "algorithm.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: activityBackground
        anchors.fill: parent
        source: Activity.url + "desert_scene.svg"
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop
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
            property alias goodAnswerSound: goodAnswerSound
            property alias badAnswerSound: badAnswerSound
            property alias bleepSound: bleepSound
            property alias activityBackground: activityBackground
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias score: score
            property int nbSubLevel: 3
            property int currentSubLevel: 0
            property bool blockClicks: false
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        readonly property bool isHorizontal: width >= height
        property bool keyNavigationVisible: false

        Keys.enabled: !items.blockClicks
        Keys.onPressed: (event) => {
            keyNavigationVisible = true
            if(event.key === Qt.Key_Left)
                choiceGridView.moveCurrentIndexLeft()
            if(event.key === Qt.Key_Right)
                choiceGridView.moveCurrentIndexRight()
            if(event.key === Qt.Key_Space || event.key === Qt.Key_Enter || event.key === Qt.Key_Return)
                choiceGridView.currentItem.clicked()
        }

        GCSoundEffect {
            id: goodAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/completetask.wav"
        }

        GCSoundEffect {
            id: badAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/brick.wav"
        }

        GCSoundEffect {
            id: bleepSound
            source: "qrc:/gcompris/src/core/resource/sounds/bleep.wav"
        }

        Column {
            id: columnLayout
            spacing: GCStyle.baseMargins
            y: rowHeight
            width: rowHeight * Activity.images.length
            anchors.horizontalCenter: parent.horizontalCenter

            property int rowHeight: activityBackground.isHorizontal ?
                Math.min(activityBackground.width * 0.75 / Activity.images.length, (activityBackground.height - bar.height - GCStyle.baseMargins) / 6) :
                Math.min((activityBackground.width - 2 * GCStyle.baseMargins) / Activity.images.length, (activityBackground.height - bar.height - GCStyle.baseMargins) / 6)

            property int itemSize: (width - 2 * GCStyle.tinyMargins - GCStyle.halfMargins * (Activity.images.length - 1)) / Activity.images.length

            Rectangle {
                id: questionTray
                height: columnLayout.rowHeight
                width: parent.width
                color: "#55333333"
                radius: GCStyle.tinyMargins

                Row {
                    anchors.fill: parent
                    anchors.margins: GCStyle.tinyMargins
                    spacing: GCStyle.halfMargins
                    Repeater {
                        id: question
                        Image {
                            required property string modelData
                            source: Activity.url + modelData + '.svg'
                            sourceSize.height: height
                            sourceSize.width: width
                            width: columnLayout.itemSize
                            height: columnLayout.itemSize
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                }
            }

            Rectangle {
                id: answerTray
                height: columnLayout.rowHeight
                width: parent.width
                color: questionTray.color
                radius: questionTray.radius
                Row {
                    anchors.fill: parent
                    anchors.margins: GCStyle.tinyMargins
                    spacing: GCStyle.halfMargins
                    Repeater {
                        id: answer
                        Image {
                            required property string modelData
                            source: "qrc:/gcompris/src/activities/algorithm/resource/" +
                                    modelData + '.svg'
                            sourceSize.height: height
                            sourceSize.width: width
                            width: columnLayout.itemSize
                            height: columnLayout.itemSize
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                }
            }

            // A spacer
            Item {
                height: columnLayout.rowHeight * 0.5
                width: parent.width
            }

            Rectangle {
                id: choiceTray
                height:columnLayout.rowHeight
                width: parent.width
                color: questionTray.color
                radius: questionTray.radius

                GridView {
                    id: choiceGridView
                    anchors.fill: parent
                    model: Activity.images
                    cellWidth: columnLayout.rowHeight
                    cellHeight: columnLayout.rowHeight
                    interactive: false
                    keyNavigationWraps: true
                    highlightFollowsCurrentItem: true
                    highlight: Rectangle {
                        width: choiceGridView.cellWidth
                        height: choiceGridView.cellHeight
                        color:  GCStyle.lightTransparentBg
                        border.width: GCStyle.thinnestBorder
                        border.color: GCStyle.whiteBorder
                        visible: activityBackground.keyNavigationVisible
                        Behavior on x { SpringAnimation { spring: 2; damping: 0.2 } }
                        Behavior on y { SpringAnimation { spring: 2; damping: 0.2 } }
                    }

                    delegate: Item {
                        id: cellItem
                        width: columnLayout.rowHeight
                        height: columnLayout.rowHeight

                        required property string modelData

                        signal clicked
                        onClicked: {
                            if(Activity.clickHandler(modelData)) {
                                particle.burst(20)
                            }
                        }

                        MouseArea {
                            id: mouseArea
                            hoverEnabled: enabled
                            enabled: !items.blockClicks
                            anchors.fill: parent
                            onClicked: cellItem.clicked()
                        }

                        Image {
                            id: img
                            source: Activity.url + cellItem.modelData + '.svg'
                            width: columnLayout.itemSize
                            height: columnLayout.itemSize
                            sourceSize.width: width
                            sourceSize.height: height
                            anchors.centerIn: parent
                            fillMode: Image.PreserveAspectFit
                            state: "notclicked"

                            states: [
                                State {
                                    name: "notclicked"
                                    PropertyChanges {
                                        img {
                                            scale: 1.0
                                        }
                                    }
                                },
                                State {
                                    name: "clicked"
                                    when: mouseArea.pressed
                                    PropertyChanges {
                                        img {
                                            scale: 0.9
                                        }
                                    }
                                },
                                State {
                                    name: "hover"
                                    when: mouseArea.containsMouse
                                    PropertyChanges {
                                        img {
                                            scale: 1.1
                                        }
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
            onClose: activity.home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: {
                activity.displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }

        Score {
            id: score
            anchors {
                bottom: bar.top
                right: parent.right
                margins: GCStyle.baseMargins
                top: undefined
                left: undefined
            }
            numberOfSubLevels: items.nbSubLevel
            currentSubLevel: items.currentSubLevel
            onStop: Activity.nextSubLevel()
        }
    }
}
