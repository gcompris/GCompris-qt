/* GCompris - Adjacent_numbers.qml
 *
 * SPDX-FileCopyrightText: 2023 Alexandre Laurent <littlewhite.dev@gmail.com>
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQml.Models 2.12

import core 1.0
import "../../core"
import "adjacent_numbers.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: activityBackground
        source: "qrc:/gcompris/src/activities/chess/resource/background-wood.svg"
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        sourceSize.height: height
        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        QtObject {
            id: items
            property Item main: activity.main
            // UI elements
            property alias activityBackground: activityBackground
            property alias instruction: instructionPanel.textItem
            property alias bar: bar
            property alias bonus: bonus
            property alias score: score
            property alias questionTilesModel: questionTilesModel
            property alias questionTilesFlow: questionTilesFlow
            property alias proposedTilesModel: proposedTilesModel
            property alias goodAnswerSound: goodAnswerSound
            property alias badAnswerSound: badAnswerSound

            // Activity options
            property bool randomSubLevels: true // not presented to the user
            property bool immediateAnswer: true

            // Updated by JS
            property bool answerCompleted: false
            property bool buttonsEnabled: true

            readonly property var levels: activity.datasets.length !== 0 ? activity.datasets : null
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        GCSoundEffect {
            id: goodAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/win.wav"
        }

        GCSoundEffect {
            id: badAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/crash.wav"
        }

        GCTextPanel {
            id: instructionPanel
            panelWidth: parent.width - 2 * GCStyle.baseMargins
            panelHeight: Math.min(50 * ApplicationInfo.ratio, activityBackground.height * 0.2)
            fixedHeight: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: GCStyle.baseMargins
        }

        Item {
            id: layoutArea
            anchors.top: instructionPanel.bottom
            anchors.bottom: okButton.top
            anchors.left: activityBackground.left
            anchors.right: activityBackground.right
            anchors.margins: GCStyle.baseMargins
        }

        Item {
            id: questionArea
            z: 100
            anchors.top: layoutArea.top
            anchors.topMargin: GCStyle.baseMargins
            anchors.horizontalCenter: parent.horizontalCenter
            width: layoutArea.width - GCStyle.baseMargins * 2
            height: (layoutArea.height - GCStyle.baseMargins * 3) * 0.5
            property int tileSize: Math.min(questionArea.width / questionTilesModel.count - GCStyle.baseMargins, height - 2 * GCStyle.baseMargins)

            Rectangle {
                anchors.centerIn: parent
                width: questionTilesFlow.childrenRect.width + 2 * GCStyle.baseMargins
                height: questionTilesFlow.childrenRect.height + 2 * GCStyle.baseMargins
                color: "#80FFFFFF"
                radius: height * 0.1
            }

            Item {
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: GCStyle.halfMargins
                width: (parent.tileSize + GCStyle.baseMargins) * questionTilesModel.count
                height: parent.tileSize
                DelegateModel {
                    id: questionTilesDelegateModel
                    model: ListModel {
                        id: questionTilesModel
                    }
                    delegate: DroppableTile {
                        width: Math.max(1, questionArea.tileSize)
                        onTileChanged: (newValue) => {
                            Activity.updatePupilAnswer(index, newValue)
                        }
                    }
                }

                Flow {
                    id: questionTilesFlow
                    width: questionArea.width
                    height: questionArea.height
                    spacing: GCStyle.baseMargins

                    Repeater {
                        model: questionTilesDelegateModel
                    }
                }
            }
        }

        Item {
            id: proposedTilesArea
            z: 200
            anchors.bottom: layoutArea.bottom
            anchors.bottomMargin: GCStyle.baseMargins
            anchors.horizontalCenter: layoutArea.horizontalCenter
            height: questionArea.height
            width: questionArea.width

            property int tileSize: Core.fitItems(proposedTilesArea.width, proposedTilesArea.height, proposedTilesModel.count) - GCStyle.baseMargins

            Item {
                anchors.centerIn: parent
                width: proposedTilesFlow.childrenRect.width
                height: proposedTilesFlow.childrenRect.height
                DelegateModel {
                    id: proposedTilesDelegateModel
                    model: ListModel {
                        id: proposedTilesModel
                    }
                    delegate: DraggableTile {
                        width: Math.max(1, proposedTilesArea.tileSize)
                    }
                }

                Flow {
                    id: proposedTilesFlow
                    width: proposedTilesArea.width
                    height: proposedTilesArea.height
                    spacing: GCStyle.baseMargins

                    Repeater {
                        model: proposedTilesDelegateModel
                    }
                }
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Score {
            id: score
            anchors.top: undefined
            anchors.bottom: activityBackground.bottom
            anchors.bottomMargin: bar.height * 1.5
            anchors.right: activityBackground.right
            anchors.rightMargin: GCStyle.baseMargins
            currentSubLevel: 0
            numberOfSubLevels: 10
            onStop: {
                Activity.nextSubLevel();
            }
        }

        BarButton {
            id: okButton
            anchors.right: score.left
            anchors.rightMargin: GCStyle.baseMargins
            anchors.verticalCenter: score.verticalCenter
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: GCStyle.bigButtonHeight
            onClicked: validateKey();
            enabled: visible && items.buttonsEnabled
            visible: !items.immediateAnswer && items.answerCompleted
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

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo

            onClose: home()

            onLoadData: {
                if(activityData && activityData["answerMode"]) {
                    items.immediateAnswer = activityData["answerMode"] == 1
                }
            }

            onSaveData: {
                levelFolder = dialogActivityConfig.chosenLevels
                currentActivity.currentLevels = dialogActivityConfig.chosenLevels
                ApplicationSettings.setCurrentLevels(currentActivity.name, dialogActivityConfig.chosenLevels)
            }

            onStartActivity: {
                activityBackground.stop()
                activityBackground.start()
            }
        }

        Keys.onReturnPressed: validateKey();

        Keys.onEnterPressed: validateKey();

        function validateKey() {
            if(okButton.enabled) {
                Activity.checkAnswer();
            }
        }

        SequentialAnimation {
            id: okButtonAnimation
            running: false
            NumberAnimation { target: okButton; property: "scale"; to: 0.9; duration: 70 }
            NumberAnimation { target: okButton; property: "scale"; to: 1; duration: 70 }
        }
    }
}
