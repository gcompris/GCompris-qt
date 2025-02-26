/* GCompris - Comparator.qml
 *
 * SPDX-FileCopyrightText: 2022 Aastha Chauhan <aastha.chauhan01@gmail.com>
 *
 * Authors:
 *   Aastha Chauhan <aastha.chauhan01@gmail.com>
 *   Timothée Giet <animtim@gmail.com>
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0
import QtQml.Models 2.12

import "../../core"
import "comparator.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: activityBackground
        source: "qrc:/gcompris/src/activities/chess/resource/background-wood.svg"
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

        function resetSelectedButton() {
            symbolSelectionList.currentIndex = -1;
        }

        QtObject {
            id: items
            property Item main: activity.main
            property alias activityBackground: activityBackground
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias goodAnswerSound: goodAnswerSound
            property alias badAnswerSound: badAnswerSound
            readonly property var levels: activity.datasets
            property alias dataListModel: dataListModel
            property int selectedLine: -1
            property int lineHeight: Math.min(45 * ApplicationInfo.ratio,
                (layoutArea.height - GCStyle.bigButtonHeight - GCStyle.baseMargins) / Math.max(1, lineRepeater.count))
            property int lineWidth: Math.min(450 * ApplicationInfo.ratio,
                layoutArea.width - (GCStyle.bigButtonHeight + GCStyle.baseMargins) * 2)
            property int numberOfRowsCompleted: 0
            property alias score: score
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
                left: parent.left
                right: parent.right
                bottom: bar.top
                margins: GCStyle.baseMargins
                bottomMargin: bar.height * 0.5
            }
        }

        ListModel {
            id: dataListModel
        }

        Keys.enabled: !bonus.isPlaying
        Keys.onPressed: (event) => {
            if(items.buttonsBlocked)
                return;
            switch(event.key) {
                case Qt.Key_Less:
                event.accepted = true;
                symbolSelectionList.enterSign("<");
                break;
                case Qt.Key_Equal:
                event.accepted = true;
                symbolSelectionList.enterSign("=");
                break;
                case Qt.Key_Greater:
                event.accepted = true;
                symbolSelectionList.enterSign(">");
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
                symbolSelectionList.moveCurrentIndexLeft();
                break;
                case Qt.Key_Right:
                event.accepted = true;
                symbolSelectionList.moveCurrentIndexRight();
                break;
                case Qt.Key_Space:
                event.accepted = true;
                if(symbolSelectionList.currentItem) {
                    symbolSelectionList.currentItem.clicked();
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

        Rectangle {
            id: wholeExerciceDisplay
            height: items.lineHeight * lineRepeater.count
            width: items.lineWidth
            anchors.horizontalCenter: layoutArea.horizontalCenter
            anchors.verticalCenter: layoutArea.verticalCenter
            anchors.verticalCenterOffset: (-GCStyle.bigButtonHeight - GCStyle.baseMargins) * 0.5
            color: GCStyle.lightBg
            Column {
                id: wholeExerciceDisplayContent
                spacing: 0
                width: parent.width
                height: parent.height
                Repeater {
                    id: lineRepeater
                    model: dataListModel
                    delegate: ComparatorLine {
                        width: items.lineWidth
                        height: items.lineHeight
                    }
                }
            }
        }

        Item {
            id: upDownButtonSet
            anchors.top: wholeExerciceDisplay.top
            anchors.bottom: wholeExerciceDisplay.bottom
            anchors.right: wholeExerciceDisplay.left
            anchors.margins: GCStyle.baseMargins
            property int buttonSize: Math.min(GCStyle.bigButtonHeight,
                                            (height - GCStyle.baseMargins) * 0.5)
            BarButton {
                id: upButton
                source: "qrc:/gcompris/src/activities/path_encoding/resource/arrow.svg"
                width: upDownButtonSet.buttonSize
                rotation: -90
                anchors.top: parent.top
                anchors.right: parent.right
                Rectangle {
                    anchors.fill: parent
                    radius: width * 0.5
                    color: GCStyle.whiteBg
                    border.color: "#000000"
                    border.width: GCStyle.thinBorder
                    opacity: 0.2
                }
                onClicked: {
                    Activity.upAction()
                }
            }
            BarButton {
                id: downButton
                source: "qrc:/gcompris/src/activities/path_encoding/resource/arrow.svg"
                width: upDownButtonSet.buttonSize
                rotation: 90
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                Rectangle {
                    anchors.fill: parent
                    radius: width * 0.5
                    color: GCStyle.whiteBg
                    border.color: "#000000"
                    border.width: GCStyle.thinBorder
                    opacity: 0.2
                }
                onClicked: {
                    Activity.downAction()
                }
            }
        }
            
        GridView {
            id: symbolSelectionList
            height: GCStyle.bigButtonHeight
            anchors.top: wholeExerciceDisplay.bottom
            anchors.topMargin: GCStyle.baseMargins
            anchors.left: wholeExerciceDisplay.left
            anchors.right: wholeExerciceDisplay.right
            cellWidth: width / 3
            cellHeight: height
            interactive: false
            keyNavigationWraps: true
            currentIndex: -1
            model: ["<", "=", ">"]
            delegate: ComparatorSign {
                width: symbolSelectionList.cellWidth
                height: symbolSelectionList.cellHeight
                signValue: modelData
                isSelected: GridView.isCurrentItem
            }
            function enterSign(sign: string) {
                //increment the numberOfRowsCompleted if there was no symbol previously
                if(dataListModel.get(items.selectedLine).symbol === "") {
                    items.numberOfRowsCompleted ++;
                }
                dataListModel.get(items.selectedLine).symbol = sign;
                dataListModel.get(items.selectedLine).isValidationImageVisible = false;
            }
        }

        Item {
            id: rightSideArea
            anchors.left: wholeExerciceDisplay.right
            anchors.right: layoutArea.right
            anchors.top: layoutArea.top
            anchors.bottom: layoutArea.bottom
        }

        BarButton {
            id: okButton
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            visible: items.numberOfRowsCompleted == dataListModel.count
            width: GCStyle.bigButtonHeight
            enabled: !bonus.isPlaying
            anchors {
                verticalCenter: symbolSelectionList.verticalCenter
                horizontalCenter: rightSideArea.horizontalCenter
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
                activityBackground.start()
            }
            onClose: {
                home()
            }
            onStartActivity: {
                activityBackground.start()
            }
        }

        Score {
            id: score
            anchors.right: undefined
            anchors.bottom: layoutArea.bottom
            anchors.left: layoutArea.left
            anchors.margins: 0
            onStop: Activity.nextSubLevel()
        }

        MouseArea {
            id: inputLock
            anchors.fill: layoutArea
            enabled: items.buttonsBlocked
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
