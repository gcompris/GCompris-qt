/* GCompris - Adjacent_numbers.qml
 *
 * SPDX-FileCopyrightText: 2023 Alexandre Laurent <littlewhite.dev@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQml.Models 2.12

import GCompris 1.0
import "../../core"
import "adjacent_numbers.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: "#ABCDEF"
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
            property alias background: background
            property alias instruction: instruction
            property alias bar: bar
            property alias bonus: bonus
            property alias score: score
            property alias questionTilesModel: questionTilesModel
            property alias proposedTilesModel: proposedTilesModel
            property alias nextSubLevelTimer: nextSubLevelTimer
            property GCSfx audioEffects: activity.audioEffects

            // Activity options
            property bool randomSubLevels: true // not presented to the user
            property bool immediateAnswer: true

            // Updated by JS
            property bool answerCompleted: false
            property bool buttonsEnabled: true

            readonly property var levels: activity.datasetLoader.data.length !== 0 ? activity.datasetLoader.data : null
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Column {
            id: mainArea
            spacing: 10
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: bar.top
            bottomPadding: 10
            topPadding: 10

            Item {
                width: parent.width
                height: instructionArea.height

                Rectangle {
                    id: instructionArea
                    opacity: 1
                    radius: 10
                    color: "#373737"
                    width: instruction.contentWidth * 1.1
                    height: instruction.contentHeight * 1.1
                    anchors.horizontalCenter: parent.horizontalCenter

                    GCText {
                        id: instruction
                        z: 5
                        wrapMode: TextEdit.WordWrap
                        fontSize: tinySize
                        horizontalAlignment: Text.Center
                        width: mainArea.width * 0.9
                        color: 'white'
                        anchors.centerIn: instructionArea
                    }
                }
            }

            Item
            {
                id: layouting

                readonly property int screenPadding: 20 * ApplicationInfo.ratio
                readonly property int flowWidth: parent.width - (screenPadding * 2)

                readonly property int tileSpacing: 10
                readonly property int defaultTileSize: 80 * ApplicationInfo.ratio
                readonly property int nbQuestionTiles: questionTilesDelegateModel.count
                readonly property int cumulativeTileSpacing: tileSpacing * (nbQuestionTiles - 1)
                readonly property int widthAvailable: questionTilesFlow.width - cumulativeTileSpacing
                readonly property int tileWidth: Math.min(defaultTileSize, widthAvailable / nbQuestionTiles)

                // Proposed tiles
                readonly property int proposedLeftTilePadding: 60 * ApplicationInfo.ratio
                readonly property int okButtonWidth: items.immediateAnswer ? 0 : okButton.width
                readonly property int activityItemsWidth: score.width + okButtonWidth + 2 * 10 * ApplicationInfo.ratio // OK button and score are right to the proposed tiles
                readonly property int proposedFlowWidth: parent.width - proposedLeftTilePadding - activityItemsWidth
                readonly property int proposedTilesPerLine: 5
                readonly property int effectiveNbTilesOnLine: Math.min(proposedTilesModel.count, proposedTilesPerLine)
                readonly property int effectiveNbLines: (proposedTilesModel.count / proposedTilesPerLine) + 1
                readonly property int cumulativeProposedTileSpacing: tileSpacing * (proposedTilesPerLine - 1)
                readonly property int proposedWidthAvailable: proposedFlowWidth - cumulativeProposedTileSpacing
                readonly property int possibleProposedTileWidth: Math.min(defaultTileSize, proposedWidthAvailable / effectiveNbTilesOnLine)

                readonly property int availableHeight: bar.y - proposedTilesFlow.y - parent.bottomPadding - tileSpacing * 2
                // Proposed tiles never bigger than tiles from the question
                readonly property int proposedTileWidth: Math.min(tileWidth, Math.min(possibleProposedTileWidth,
                                                         availableHeight / effectiveNbLines))

                // Just enough space to have proposedTilesPerLine tiles on one line
                readonly property int effectiveFlowWidth: proposedTileWidth * proposedTilesPerLine + cumulativeProposedTileSpacing
            }

            Item {
                width: parent.width
                height: 2 * layouting.defaultTileSize

                DelegateModel {
                    id: questionTilesDelegateModel
                    model: ListModel {
                        id: questionTilesModel
                    }

                    delegate: DroppableTile {
                        width: layouting.tileWidth
                        onTileChanged: (newValue) => {
                            Activity.updatePupilAnswer(index, newValue)
                        }
                    }
                }

                Flow {
                    id: questionTilesFlow
                    width: layouting.flowWidth
                    height: parent.height

                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: layouting.tileSpacing

                    Repeater {
                        model: questionTilesDelegateModel
                    }
                }
            }


            DelegateModel {
                id: proposedTilesDelegateModel
                model: ListModel {
                    id: proposedTilesModel
                }

                delegate: DraggableTile {
                    width: layouting.proposedTileWidth
                }
            }

            Flow {
                id: proposedTilesFlow

                x: 60 * ApplicationInfo.ratio
                width: layouting.effectiveFlowWidth
                spacing: layouting.tileSpacing
                Repeater {
                    model: proposedTilesDelegateModel
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
            anchors.bottom: background.bottom
            anchors.bottomMargin: bar.height * 1.5
            anchors.right: background.right
            anchors.rightMargin: 10 * ApplicationInfo.ratio
            currentSubLevel: 0
            numberOfSubLevels: 10
            onStop: {
                Activity.nextLevel();
            }
        }

        BarButton {
            id: okButton
            anchors.right: score.left
            anchors.rightMargin: 10 * ApplicationInfo.ratio
            anchors.verticalCenter: score.verticalCenter
            z: 10
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: 70 * ApplicationInfo.ratio
            height: width
            sourceSize.height: height
            sourceSize.width: height
            onClicked: validateKey();
            enabled: !bonus.isPlaying && items.buttonsEnabled
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
                background.stop()
                background.start()
            }
        }

        Keys.onReturnPressed: validateKey();

        Keys.onEnterPressed: validateKey();

        function validateKey() {
            if(okButton.visible && okButton.enabled) {
                Activity.checkAnswer();
            }
        }

        SequentialAnimation {
            id: okButtonAnimation
            running: false
            NumberAnimation { target: okButton; property: "scale"; to: 0.9; duration: 70 }
            NumberAnimation { target: okButton; property: "scale"; to: 1; duration: 70 }
        }

        Timer {
            id: nextSubLevelTimer
            interval: 600
            onTriggered: Activity.nextSubLevel()
        }
    }

}
