/* GCompris - Comparator.qml
 *
 * SPDX-FileCopyrightText: 2022 Aastha Chauhan <aastha.chauhan01@gmail.com>
 *
 * Authors:
 *   Aastha Chauhan <aastha.chauhan01@gmail.com>
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0
import QtQml.Models 2.12
import QtQuick.Controls 2.12

import "../../core"
import "comparator.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        source: "qrc:/gcompris/src/activities/checkers/resource/background-wood.svg"
        anchors.centerIn: parent
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
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            readonly property var levels: activity.datasetLoader.data
            property alias dataListModel: dataListModel
            property int selectedLine: -1
            property int spacingOfElement: 20 * ApplicationInfo.ratio
            property int sizeOfElement: 36 * ApplicationInfo.ratio
            property int numberOfRowsCompleted: 0
            property alias score: score
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Item {
            id: layoutArea
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                bottom: bar.top
                bottomMargin: bar.height * 0.2
            }
        }

        ListModel {
            id: dataListModel
        }

        Keys.enabled: !bonus.isPlaying
        Keys.onPressed: {
            switch(event.key) {
                case Qt.Key_Less:
                event.accepted = true;
                symbolSelectionList.clickItemWithSign("<");
                break;
                case Qt.Key_Equal:
                event.accepted = true;
                symbolSelectionList.clickItemWithSign("=");
                break;
                case Qt.Key_Greater:
                event.accepted = true;
                symbolSelectionList.clickItemWithSign(">");
                break;
                case Qt.Key_Up:
                event.accepted = true;
                Activity.upAction();
                break;
                case Qt.Key_Down:
                event.accepted = true;
                Activity.downAction();
                break;
                case Qt.Key_Left:
                event.accepted = true;
                symbolSelectionList.decrementCurrentIndex();
                break;
                case Qt.Key_Right:
                event.accepted = true;
                symbolSelectionList.incrementCurrentIndex();
                break;
                case Qt.Key_Space:
                event.accepted = true;
                if(symbolSelectionList.currentItem) {
                    symbolSelectionList.currentItem.onClicked();
                }
                break;
                case Qt.Key_Return:
                case Qt.Key_Enter:
                event.accepted = true;
                if(okButton.visible) {
                    okButton.clicked();
                }
                break;
                case Qt.Key_Backspace:
                event.accepted = true;
                var equation = dataListModel.get(items.selectedLine);
                if(equation.symbol != "") {
                    equation.symbol = "";
                    items.numberOfRowsCompleted --;
                    equation.isValidationImageVisible = false;
                }
                break;
            }
        }

        Item {
            id: wholeExerciceDisplay
            width: layoutArea.width * 0.5
            height: parent.height * 0.5
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            Rectangle {
                width: parent.width
                height: parent.height
                color: "#FFFFFF"
                Column {
                    id: wholeExerciceDisplayContent
                    spacing: 5
                    anchors.right: parent.right
                    width: parent.width
                    Repeater {
                        model: dataListModel
                        delegate: ComparatorLine {
                        }
                    }
                }
            }
        }

        Item {
            id: upDownButtonSet
            height: layoutArea.height * 0.1
            width: layoutArea.width
            anchors.bottom: wholeExerciceDisplay.bottom
            anchors.topMargin: 20 * ApplicationInfo.ratio
            anchors.right: layoutArea.right
            Row {
                spacing: items.spacingOfElement
                anchors.right: parent.right
                BarButton {
                    id: upButton
                    source: "qrc:/gcompris/src/activities/path_encoding/resource/arrow.svg"
                    sourceSize.height: parent.height
                    rotation: -90
                    Rectangle {
                        anchors.fill: parent
                        radius: width * 0.5
                        color: "#FFFFFF"
                        border.color: "#000000"
                        border.width: 4
                        opacity: 0.2
                    }
                    onClicked: {
                        Activity.upAction()
                    }
                }

                BarButton {
                    id: downButton
                    source: "qrc:/gcompris/src/activities/path_encoding/resource/arrow.svg"
                    sourceSize.height: parent.height
                    rotation: 90
                    Rectangle {
                        anchors.fill: parent
                        radius: width * 0.5
                        color: "#FFFFFF"
                        border.color: "#000000"
                        border.width: 4
                        opacity: 0.2
                    }
                    onClicked: {
                        Activity.downAction()
                    }
                }
            }
        }
            
        ListView {
            id: symbolSelectionList
            height: layoutArea.height * 0.1
            anchors.bottom: bar.top
            width: wholeExerciceDisplay.width
            anchors.bottomMargin: 30 * ApplicationInfo.ratio
            anchors.horizontalCenter: wholeExerciceDisplay.horizontalCenter
            orientation: Qt.Horizontal
            interactive: false
            keyNavigationWraps: true
            spacing: items.sizeOfElement
        currentIndex: -1
            model: ["<", "=", ">"]
            delegate: ComparatorSign {
                height: ListView.view.height
                width: height
                signValue: modelData
                isSelected: ListView.isCurrentItem
                onClickTriggered: {
                    symbolSelectionList.currentIndex = index
                }
            }
            // We should use getItemAtIndex(model.get(sign)) instead of this method
            // but it's Qt 5.13 and we need to support Qt 5.12
            function clickItemWithSign(sign) {
                for(var i = 0 ; i < symbolSelectionList.count ; ++ i) {
                    symbolSelectionList.currentIndex = i;
                    if(symbolSelectionList.currentItem.signValue == sign) {
                        symbolSelectionList.currentItem.clicked();
                        break;
                    }
                }
            }
        }

        BarButton {
            id: okButton
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            visible: items.numberOfRowsCompleted == dataListModel.count
            sourceSize.width: 60 * ApplicationInfo.ratio
            enabled: !bonus.isPlaying
            anchors {
                top: score.top
                right: score.left
                rightMargin: 20
            }
            onClicked: {
                Activity.checkAnswer()
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
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

        Score {
            id: score
            anchors.right: parent.right
            anchors.bottom: bar.top
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
