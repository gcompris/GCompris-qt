/* GCompris - tens_complement_find.qml
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-FileCopyrightText: 2022 Timothée Giet <animtim@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQml.Models 2.12
import core 1.0
import "../../core"
import "tens_complement_find.js" as Activity
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

        property int layoutMargins: 10 * ApplicationInfo.ratio

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias activityBackground: activityBackground
            property alias goodAnswerSound: goodAnswerSound
            property alias badAnswerSound: badAnswerSound
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias cardListModel: cardListModel
            property alias holderListModel: holderListModel
            property int selectedIndex: -1
            readonly property var levels: activity.datasets
            property alias okButton: okButton
            property alias score: score
            property double cardSize: Core.fitItems(numberContainerArea.width, numberContainerArea.height, 6)
            property bool isHorizontal: activityBackground.width >= activityBackground.height
            property bool buttonsBlocked: false
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        GCSoundEffect {
            id: goodAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/completetask.wav"
        }

        GCSoundEffect {
            id: badAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/crash.wav"
        }

        Item {
            id: layoutArea
            anchors {
                top: parent.top
                bottom: bar.top
                bottomMargin: bar.height * 0.2
                left: parent.left
                right: parent.right
            }
        }

        ListModel {
            id: cardListModel
        }

        Item {
            id: numberContainerArea
            height: width * 0.67
            width: (layoutArea.width - activityBackground.layoutMargins * 3) * 0.32
            anchors.left: layoutArea.left
            anchors.verticalCenter: answerHolderArea.verticalCenter
            anchors.leftMargin: activityBackground.layoutMargins
        }

        Rectangle {
            id: numberContainer
            width: items.cardSize * 3
            height: items.cardSize * Math.ceil(cardListModel.count / 3)
            anchors.verticalCenter: numberContainerArea.verticalCenter
            anchors.left: numberContainerArea.left
            color: "#80FFFFFF"
            radius: 15

            GridView {
                id: container
                height: parent.height
                width: parent.width
                interactive: false
                anchors.centerIn: parent
                cellHeight: items.cardSize
                cellWidth: items.cardSize
                model: cardListModel
                delegate: NumberQuestionCard {
                    height: items.cardSize
                    width: items.cardSize
                    selected: index == items.selectedIndex
                    onClicked: {
                        items.selectedIndex = index;
                    }
                }
            }
        }

        ListModel {
            id: holderListModel
        }

        Item {
            id: answerHolderArea
            anchors {
                left: numberContainer.right
                top: layoutArea.top
                bottom: score.top
                right: score.left
                margins: activityBackground.layoutMargins
            }

            ListView {
                height: Math.min(items.cardSize * holderListModel.count, answerHolderArea.height)
                width: Math.min(items.cardSize * 6, parent.width) // 6 as addition contains 6 cards + validation image
                interactive: false
                anchors.centerIn: parent
                model: holderListModel
                delegate: AnswerContainer {
                    readonly property int minHeight: holderListModel.count == 0 ? items.cardSize : answerHolderArea.height / holderListModel.count
                    height: Math.min(items.cardSize, minHeight)
                    width: Math.min(height * 6, ListView.view.width)
                }
            }
        }

        BarButton {
            id: okButton
            visible: false
            z: 2
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            anchors {
                bottom: score.top
                bottomMargin: activityBackground.layoutMargins
                horizontalCenter: score.horizontalCenter
            }
            width: 60 * ApplicationInfo.ratio
            enabled: !items.buttonsBlocked
            onClicked: Activity.checkAnswer()
        }

        Score {
            id: score
            anchors {
                right: layoutArea.right
                bottom: layoutArea.bottom
                rightMargin: activityBackground.layoutMargins
                bottomMargin: activityBackground.layoutMargins
            }
            onStop: Activity.nextSubLevel()
        }

        states: [
            State {
                name: "horizontalLayout"
                when: items.isHorizontal
                AnchorChanges {
                    target: numberContainerArea
                    anchors {
                        left: numberContainerArea.parent.left
                        verticalCenter: answerHolderArea.verticalCenter
                        horizontalCenter: undefined
                        bottom: undefined
                    }
                }
                PropertyChanges {
                    numberContainerArea {
                        anchors {
                            leftMargin: activityBackground.layoutMargins
                            bottomMargin: 0
                        }
                        height: numberContainerArea.width * 0.67
                        width: (layoutArea.width - activityBackground.layoutMargins * 3) * 0.32
                    }
                }
                AnchorChanges {
                    target: numberContainer
                    anchors {
                        verticalCenter: numberContainerArea.verticalCenter
                        left: numberContainerArea.left
                        horizontalCenter: undefined
                    }
                }
                AnchorChanges {
                    target: answerHolderArea
                    anchors {
                        left: numberContainer.right
                        top: answerHolderArea.parent.top
                        bottom: score.top
                        right: score.left
                    }
                }
            },
            State {
                name: "verticalLayout"
                when: !items.isHorizontal
                AnchorChanges {
                    target: numberContainerArea
                    anchors {
                        left: undefined
                        verticalCenter: undefined
                        horizontalCenter: layoutArea.horizontalCenter
                        bottom: score.top
                    }
                }
                PropertyChanges {
                    numberContainerArea {
                        anchors {
                            leftMargin: 0
                            bottomMargin: activityBackground.layoutMargins
                        }
                        width: Math.min(layoutArea.width - score.width * 2 - activityBackground.layoutMargins * 4,
                        layoutArea.height * 0.5)
                        height: numberContainerArea.width * 0.67
                    }
                }
                AnchorChanges {
                    target: numberContainer
                    anchors {
                        verticalCenter: numberContainerArea.verticalCenter
                        left: undefined
                        horizontalCenter: numberContainerArea.horizontalCenter
                    }
                }
                AnchorChanges {
                    target: answerHolderArea
                    anchors {
                        left: layoutArea.left
                        top: answerHolderArea.parent.top
                        bottom: numberContainerArea.top
                        right: layoutArea.right
                    }
                }
            }
        ]

        MouseArea {
            id: clickMask
            anchors.fill: layoutArea
            enabled: items.buttonsBlocked
        }

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
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
