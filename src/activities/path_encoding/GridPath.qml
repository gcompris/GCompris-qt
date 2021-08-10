/* GCompris - GridPath.qml
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9
import GCompris 1.0
import QtQml.Models 2.1

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
        id: background
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
            property GCSfx audioEffects: activity.audioEffects
            readonly property string resourceUrl: activity.resourceUrl
            readonly property string mode: activity.mode
            readonly property string movement: activity.movement
            property int rows
            property int cols
            property int errorsCount
            property var levels: activity.datasetLoader.data
            property alias mapView: mapView
            property alias tux: tux
            property alias movesGridView: moveBar.movesGridView
            property alias mapListModel: mapListModel
            property alias movesListModel: movesListModel
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
        }

        onWidthChanged: {
            sizeChangedTimer.restart()
        }

        onHeightChanged: {
            sizeChangedTimer.restart()
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
        onStop: { Activity.stop() }

        ListModel {
            id: mapListModel
        }

        Item {
            id: layoutArea
            anchors.top: parent.top
            anchors.bottom: bar.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottomMargin: Math.max(bar.height * 0.5, errorsText.height)
            anchors.topMargin: anchors.bottomMargin
            anchors.leftMargin: anchors.bottomMargin
            anchors.rightMargin: anchors.bottomMargin
        }

        MapView {
            id: mapView

            touchEnabled: mode === 'decode'

            rows: items.rows
            cols: items.cols
        }

        GCText {
            id: errorsText
            fontSize: tinySize
            color: 'red'
            text: qsTr("Errors %1").arg(items.errorsCount.toString())

            anchors {
                bottom: mapView.top
                left: mapView.left
            }
        }

        ListModel {
            id: movesListModel
        }

        MoveBar {
            id: moveBar
        }

        MoveButtons {
            id: moveButtons
            visible: items.mode === 'encode'
        }

        Tux {
            id: tux
            width: mapView.cellSize
            height: mapView.cellSize
        }

        property double maxAllowedHeight: layoutArea.height
        property double maxAllowedWidth: (layoutArea.width - layoutArea.anchors.bottomMargin) / 2
        property double size: Math.min(maxAllowedHeight / items.rows, maxAllowedWidth / items.cols)

        states: [
            State {
                id: horizontalLayout
                when: layoutArea.width >= layoutArea.height
                PropertyChanges {
                    target: mapView
                    cellSize: size
                }
                PropertyChanges {
                    target: moveBar
                    width: layoutArea.width - mapView.width - layoutArea.anchors.bottomMargin
                    height: layoutArea.height / 2
                    anchors.topMargin: 0
                }
                PropertyChanges {
                    target: moveButtons
                    width: moveBar.width
                    height: layoutArea.height / 2
                }
                AnchorChanges {
                    target: mapView
                    anchors.verticalCenter: layoutArea.verticalCenter
                    anchors.horizontalCenter: undefined
                    anchors.top: undefined
                    anchors.left: layoutArea.left
                }
                AnchorChanges {
                    target: moveBar
                    anchors.right: layoutArea.right
                    anchors.top: layoutArea.top
                }
                AnchorChanges {
                    target: moveButtons
                    anchors.right: layoutArea.right
                    anchors.top: moveBar.bottom
                }
            },
            State {
                id: verticalLayout
                when: layoutArea.width < layoutArea.height
                PropertyChanges {
                    target: mapView
                    cellSize: Math.min((layoutArea.height / 2) / items.rows, layoutArea.width / items.cols)
                }
                PropertyChanges {
                    target: moveBar
                    width: layoutArea.width
                    height: (layoutArea.height - mapView.height - moveButtons.height - layoutArea.anchors.bottomMargin)
                    anchors.topMargin: layoutArea.anchors.bottomMargin
                }
                PropertyChanges {
                    target: moveButtons
                    width: moveBar.width
                    height: (moveButtons.visible) ? (layoutArea.height - mapView.height - layoutArea.anchors.bottomMargin) / 2 : 0
                }
                AnchorChanges {
                    target: mapView
                    anchors.verticalCenter: undefined
                    anchors.horizontalCenter: layoutArea.horizontalCenter
                    anchors.left: undefined
                    anchors.top: layoutArea.top
                }
                AnchorChanges {
                    target: moveBar
                    anchors.right: layoutArea.right
                    anchors.top: mapView.bottom
                }
                AnchorChanges {
                    target: moveButtons
                    anchors.right: layoutArea.right
                    anchors.top: moveBar.bottom
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
                background.start()
            }
            onClose: {
                home()
            }
            onStartActivity: {
                background.start()
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
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
