/* GCompris - tens_complement_find.qml
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-FileCopyrightText: 2022 Timothée Giet <animtim@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQml.Models 2.12
import QtQuick.Controls 2.12
import GCompris 1.0
import "../../core"
import "tens_complement_find.js" as Activity
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
            property alias cardListModel: cardListModel
            property alias holderListModel: holderListModel
            property int selectedIndex: -1
            readonly property var levels: activity.datasetLoader.data
            property alias okButton: okButton
            property alias score: score
            property double cardSize: Core.fitItems(numberContainer.width, numberContainer.height, 6)
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
                id: cardListModel
            }

            Rectangle {
                id: numberContainer
                height: parent.height * 0.4
                width: parent.width * 0.32
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: parent.width * 0.02
                color: "pink"
                border.width: 2
                border.color: "black"
                radius: 30

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

            Rectangle {
                id: answerHolderArea
                anchors {
                    left: numberContainer.right
                    top: parent.top
                    bottom: parent.bottom
                    right: parent.right
                }

                ListView {
                    height: items.cardSize * 4
                    width: parent.width * 0.6
                    interactive: false
                    anchors.centerIn: parent
                    model: holderListModel
                    delegate: AnswerContainer {
                        height: items.cardSize
                        width: answerHolderArea.width * 0.6
                    }
                }

                BarButton {
                    id: okButton
                    visible: false
                    z: 2
                    source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        bottom: parent.bottom
                    }
                    sourceSize.width: 60 * ApplicationInfo.ratio
                    enabled: !bonus.isPlaying
                    onClicked: Activity.checkAnswer()
                }
            }

            Score {
                id: score
                color: "#76F361"
                height: items.cardSize * 0.5
                width: items.cardSize
            }
        }

        MouseArea {
            id: clickMask
            anchors.fill: layoutArea
            enabled: items.bonus.isPlaying
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
            Component.onCompleted: win.connect(Activity.nextSubLevel)
        }
    }

}
