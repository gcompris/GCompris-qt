/* GCompris - tens_complement_find.qml
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-FileCopyrightText: 2022 Timothée Giet <animtim@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQml.Models
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
            property int cardSize
            property bool isHorizontal: activityBackground.width >= activityBackground.height
            property bool buttonsBlocked: false
            property alias client: client
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Client {    // Client for gcompris-teachers. Prepare data from activity to server
            id: client
            getDataCallback: function() {
                var data = {
                    "proposedNumbers": Activity.proposedNumbers,
                    "questionList": Activity.questionList
                }

                return data;
            }
        }

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
                left: parent.left
                right: parent.right
                bottom: score.top
                margins: GCStyle.baseMargins
            }
        }

        ListModel {
            id: cardListModel
        }

        Item {
            id: numberContainerArea
            anchors.bottom: layoutArea.bottom
            anchors.left: layoutArea.left
        }

        Rectangle {
            id: numberContainer
            width: items.cardSize * 3
            height: items.cardSize * Math.ceil(cardListModel.count / 3)
            color: "#80FFFFFF"
            radius: GCStyle.halfMargins

            GridView {
                id: container
                anchors.fill: parent
                interactive: false
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
                top: layoutArea.top
                right: layoutArea.right
            }

            ListView {
                id: additionList
                height: items.cardSize * holderListModel.count
                width: items.cardSize * 6 // 6 as additions contains 5 cards + feedback image
                interactive: false
                anchors.verticalCenter: answerHolderArea.verticalCenter // other anchors in states
                model: holderListModel
                delegate: AnswerContainer {
                    height: items.cardSize
                    width: items.cardSize * 6
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
                bottomMargin: GCStyle.baseMargins
                horizontalCenter: score.horizontalCenter
            }
            width: Math.min(items.cardSize, GCStyle.bigButtonHeight)
            enabled: !items.buttonsBlocked
            onClicked: Activity.checkAnswer()
        }

        Score {
            id: score
            anchors {
                right: layoutArea.right
                rightMargin: (GCStyle.bigButtonHeight - width) * 0.5
                bottom: activityBackground.bottom
                bottomMargin: bar.height * 1.2
            }
            onStop: Activity.nextSubLevel()
        }

        states: [
            State {
                name: "horizontalLayout"
                when: items.isHorizontal
                PropertyChanges {
                    items {
                        // fit 10 items horizontally (3 card columns on left + 5 addition cards + feedback + okButton = 10)
                        // and 3 vertically (3 additions)
                        cardSize: Math.min((layoutArea.width - GCStyle.baseMargins * 2) / 10,
                                        layoutArea.height / 3)
                    }
                    numberContainerArea {
                        height: layoutArea.height
                        width: items.cardSize * 3
                    }
                    answerHolderArea {
                        height: layoutArea.height
                        width: layoutArea.width - GCStyle.baseMargins - numberContainerArea.width
                    }
                }
                AnchorChanges {
                    target: numberContainer
                    anchors.right: numberContainerArea.right
                    anchors.verticalCenter: numberContainerArea.verticalCenter
                    anchors.top: undefined
                    anchors.horizontalCenter: undefined
                }
                AnchorChanges {
                    target: additionList
                    anchors.left: answerHolderArea.left
                    anchors.horizontalCenter: undefined
                }
            },
            State {
                name: "verticalLayout"
                when: !items.isHorizontal
                PropertyChanges {
                    items {
                        // fit 6 items horizontally (5 addition cards + feedback)
                        // and 5 vertically (3 additions + 2 card rows)
                        cardSize: Math.min(layoutArea.width / 6,
                                        (layoutArea.height - GCStyle.baseMargins) / 5)
                    }
                    numberContainerArea {
                        width: layoutArea.width
                        height: items.cardSize * 2
                    }
                    answerHolderArea {
                        width: layoutArea.width
                        height: layoutArea.height - GCStyle.baseMargins - numberContainerArea.height
                    }
                }
                AnchorChanges {
                    target: numberContainer
                    anchors.right: undefined
                    anchors.verticalCenter: undefined
                    anchors.top: numberContainerArea.top
                    anchors.horizontalCenter: numberContainerArea.horizontalCenter
                }
                AnchorChanges {
                    target: additionList
                    anchors.left: undefined
                    anchors.horizontalCenter: answerHolderArea.horizontalCenter
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
