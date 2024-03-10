/* GCompris - tens_complement_swap.qml
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-FileCopyrightText: 2022 Timothée Giet <animtim@gmail.com>
 * SPDX-FileCopyrightText: 2024 Harsh Kumar <hadron43@yahoo.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQml.Models 2.12

import GCompris 1.0
import "../../core"
import "tens_complement_swap.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    // Mode : swap | input
    property string mode: "swap"

    pageComponent: Image {
        id: background
        source: "qrc:/gcompris/src/activities/chess/resource/background-wood.svg"
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        sourceSize.height: height
        signal start
        signal stop

        property int layoutMargins: 10 * ApplicationInfo.ratio

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property GCSfx audioEffects: activity.audioEffects
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias equations: equations
            readonly property var levels: activity.datasets
            property bool isHorizontal: background.width >= background.height
            property alias numPad: numPad
            property var previousSelectedCard: undefined
            readonly property string mode: activity.mode
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Keys.enabled: okButton.enabled
        Keys.onPressed: (event) => {
            if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                okButton.clicked();
            } else if(activity.mode === "input" && !bonus.isPlaying) {
                numPad.updateAnswer(event.key, true);
            }
        }

        Keys.onReleased: (event) => {
            if(activity.mode === "input" && !bonus.isPlaying)
                numPad.updateAnswer(event.key, false);
        }

        Item {
            id: layoutArea
            anchors.top: parent.top
            anchors.bottom: bar.top
            anchors.bottomMargin: bar.height * 0.2
            anchors.horizontalCenter: parent.horizontalCenter
            width: numPad.visible ? (parent.width - 2 * numPad.columnWidth) : parent.width

            ListModel {
                id: equations
            }

            Item {
                id: containerHolder
                height: layoutArea.height - okButton.height * 2 - background.layoutMargins
                width: layoutArea.width - (background.layoutMargins * 2)
                anchors.top: parent.top
                anchors.topMargin: background.layoutMargins
                anchors.horizontalCenter: parent.horizontalCenter
                Column {
                    Repeater {
                        model: items.equations
                        delegate: CardContainer {
                            height: Math.min(containerHolder.height / items.equations.count,
                                             okButton.height * 2)
                            width: items.isHorizontal ? containerHolder.width - height :
                                                            containerHolder.width
                        }
                    }
                }
            }

            Item {
                id: okButtonArea
                anchors.top: containerHolder.bottom
                anchors.bottom: layoutArea.bottom
                anchors.left: layoutArea.left
                anchors.right: layoutArea.right
            }

            BarButton {
                id: okButton
                sourceSize.width: 60 * ApplicationInfo.ratio
                source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
                anchors {
                    horizontalCenter: okButtonArea.horizontalCenter
                    verticalCenter: okButtonArea.verticalCenter
                }
                enabled: !bonus.isPlaying
                onClicked: Activity.checkAnswer()
            }

        }

        NumPad {
            id: numPad
            maxDigit: 2
            widthRatio: 12
            visible: activity.mode === "input" && ApplicationSettings.isVirtualKeyboard
            enableInput: (items.previousSelectedCard && items.previousSelectedCard.type === "inputCard") ? true : false
            onAnswerChanged: {
                if(items.previousSelectedCard && items.previousSelectedCard.type === "inputCard") {
                    items.equations.get(items.previousSelectedCard.rowNumber).listmodel.get(items.previousSelectedCard.columnNumber).value = answer;
                }
            }
        }

        MouseArea {
            id: clickMask
            anchors.fill: layoutArea
            enabled: bonus.isPlaying
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
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
