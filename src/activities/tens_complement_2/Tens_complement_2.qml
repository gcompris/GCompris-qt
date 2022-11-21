/* GCompris - tens_complement_2.qml
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQml.Models 2.12
import QtQuick.Controls 2.12

import GCompris 1.0
import "../../core"
import "tens_complement_2.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: "white"
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
            property alias equations: equations
            readonly property var levels: activity.datasetLoader.data
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Item {
            id: layoutArea
            anchors.top: parent.top
            anchors.bottom: bar.top
            anchors.bottomMargin: bar.height * 0.2
            anchors.left: parent.left
            anchors.right: parent.right

            ListModel {
                id: equations
            }

            Rectangle {
                id: containerHolder
                height: layoutArea.height * 0.7
                width: layoutArea.width * 0.6
                color: "white"
                radius: 20
                anchors.centerIn: parent
                Column {
                    Repeater {
                        model: items.equations
                        delegate: CardContainer {
                            height: containerHolder.height / (items.equations.count + 1)
                            width: containerHolder.width
                        }
                    }
                }
            }

            Score {
                id: score
                color: "black"
            }

            BarButton {
                id: okButton
                height: containerHolder.height * 0.2
                width: containerHolder.height * 0.2
                z: 2
                source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
                anchors {
                    horizontalCenter: layoutArea.horizontalCenter
                    bottom: parent.bottom
                }
                enabled: !bonus.isPlaying
                onClicked: Activity.checkAnswer()
            }

        }

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
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
