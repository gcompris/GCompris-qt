/* GCompris - GridPath.qml
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0

import "../../core"
import "path.js" as Activity

ActivityBase {
    id: activity
    // mode : encode | decode
    property string mode

    // movement : absolute | relative
    property string movement

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: activityBackground
        color: "#42993E"
        anchors.fill: parent
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
            property alias goodAnswerSound: goodAnswerSound
            property alias badAnswerSound: badAnswerSound
            readonly property string resourceUrl: activity.resourceUrl
            readonly property string mode: activity.mode
            readonly property string movement: activity.movement
            property int rows: 1
            property int cols: 1
            property int errorsCount
            readonly property var levels: activity.datasets
            property alias mapView: mapView
            property alias tux: tux
            property alias movesGridView: moveBar.movesGridView
            property alias mapListModel: mapListModel
            property alias movesListModel: movesListModel
            property alias activityBackground: activityBackground
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
        }

        onWidthChanged: {
            sizeChangedTimer.restart()
        }

        onHeightChanged: {
            sizeChangedTimer.restart()
        }

        GCSoundEffect {
            id: goodAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/completetask.wav"
        }

        GCSoundEffect {
            id: badAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/crash.wav"
        }

        Timer {
            id: sizeChangedTimer
            interval: 100
            onTriggered: {
                mapView.init()

                tux.animationEnabled = false
                Activity.moveTuxToBlock()
                tux.animationEnabled = true
            }
        }

        onStart: { Activity.start(items) }
        onStop: {
            sizeChangedTimer.stop()
            Activity.stop()
        }

        ListModel {
            id: mapListModel
        }

        Item {
            id: layoutArea
            anchors.fill: parent
            anchors.margins: GCStyle.baseMargins
            anchors.bottomMargin: bar.height * 1.3
        }

        MapView {
            id: mapView
            touchEnabled: mode === 'decode'
            rows: items.rows
            cols: items.cols
            anchors.verticalCenterOffset: (-errorsArea.height - GCStyle.halfMargins) * 0.5
        }

        Rectangle {
            id: errorsArea
            anchors.top: mapView.bottom
            anchors.left: mapView.left
            anchors.topMargin: GCStyle.halfMargins
            width: errorsText.contentWidth + 2 * GCStyle.baseMargins
            height: errorsText.contentHeight + GCStyle.baseMargins
            radius: height * 0.5
            color: GCStyle.lightBg
            border.color: GCStyle.badAnswer
            border.width: GCStyle.thinBorder
        }

        GCText {
            id: errorsText
            fontSize: tinySize
            color: GCStyle.darkText
            text: qsTr("Errors: %1").arg(items.errorsCount.toString())
            anchors.centerIn: errorsArea
        }

        ListModel {
            id: movesListModel
        }

        Column {
            id: controlsColumn
            anchors.right: layoutArea.right
            spacing: GCStyle.halfMargins

            MoveButtons {
                id: moveButtons
                visible: items.mode === 'encode'
                width: parent.width
                height: visible ? moveBar.height : 0
            }

            MoveBar {
                id: moveBar
                width: parent.width
                height: moveButtons.visible ? parent.height * 0.5 - GCStyle.halfMargins : parent.height
            }
        }



        Tux {
            id: tux
            width: mapView.cellSize
        }

        states: [
            State {
                id: horizontalLayout
                when: layoutArea.width >= layoutArea.height
                PropertyChanges {
                    mapView {
                        maxHeight: layoutArea.height - errorsArea.height - errorsArea.anchors.topMargin
                        maxWidth: layoutArea.width * 0.5 - GCStyle.baseMargins
                    }
                    controlsColumn {
                        width: layoutArea.width - mapView.width - GCStyle.baseMargins
                        height: layoutArea.height
                        anchors.topMargin: 0
                    }
                }
                AnchorChanges {
                    target: mapView
                    anchors.verticalCenter: layoutArea.verticalCenter
                    anchors.horizontalCenter: undefined
                    anchors.top: undefined
                    anchors.left: layoutArea.left
                }
                AnchorChanges {
                    target: controlsColumn
                    anchors.top: layoutArea.top
                }
            },
            State {
                id: verticalLayout
                when: layoutArea.width < layoutArea.height
                PropertyChanges {
                    mapView {
                        maxHeight: (layoutArea.height * 0.7) - errorsArea.height - errorsArea.anchors.topMargin
                        maxWidth: layoutArea.width
                    }
                    controlsColumn {
                        width: layoutArea.width
                        height: layoutArea.height - mapView.height - errorsArea.height - GCStyle.halfMargins - GCStyle.baseMargins
                        anchors.topMargin: GCStyle.baseMargins
                    }
                }
                AnchorChanges {
                    target: mapView
                    anchors.verticalCenter: undefined
                    anchors.horizontalCenter: layoutArea.horizontalCenter
                    anchors.left: undefined
                    anchors.top: layoutArea.top
                }
                AnchorChanges {
                    target: controlsColumn
                    anchors.top: errorsArea.bottom
                }
            }
        ]

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo

            onSaveData: {
                levelFolder = dialogActivityConfig.chosenLevels
                currentActivity.currentLevels = dialogActivityConfig.chosenLevels
                ApplicationSettings.setCurrentLevels(currentActivity.name, dialogActivityConfig.chosenLevels)
                // restart activity on saving
                activityBackground.start()
            }
            onClose: {
                home()
            }
            onStartActivity: {
                activityBackground.start()
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level | activityConfig }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig)
            }
        }

        Bonus {
            id: bonus
            winSound: "qrc:/gcompris/src/activities/ballcatch/resource/tuxok.wav"
            Component.onCompleted: win.connect(Activity.nextLevel)
        }

        Keys.onLeftPressed: (items.mode === 'encode') ? Activity.moveTowards(Activity.Directions.LEFT) : null
        Keys.onRightPressed: (items.mode === 'encode') ? Activity.moveTowards(Activity.Directions.RIGHT) : null
        Keys.onUpPressed: (items.mode === 'encode') ? Activity.moveTowards(Activity.Directions.UP) : null
        Keys.onDownPressed: (items.mode === 'encode') ? Activity.moveTowards(Activity.Directions.DOWN) : null
    }
}
