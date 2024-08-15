/* GCompris - multiple_choice_questions.qml
 *
 * SPDX-FileCopyrightText: 2024 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import core 1.0

import "../../core"
import "qrc:/gcompris/src/core/core.js" as Core
import "multiple_choice_questions.js" as Activity

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
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property int currentLevel: activity.currentLevel
            property int currentSubLevel: 0
            property int numberOfSubLevel: 0
            property var levels: activity.datasets
            property alias bonus: bonus
            property alias score: score
            property alias goodAnswerSound: goodAnswerSound
            property alias badAnswerSound: badAnswerSound
            property alias instruction: instruction
            property alias answerModel: answerModel
            property alias feedbackArea: feedbackArea
            property bool buttonsBlocked: false
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        readonly property int baseMargins: 10 * ApplicationInfo.ratio
        readonly property int baseSizeValue: 60 * ApplicationInfo.ratio

        ListModel { id: answerModel }

        GCSoundEffect {
            id: goodAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/completetask.wav"
        }

        GCSoundEffect {
            id: badAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/crash.wav"
        }

        //Keys.onSpacePressed: answerColumn.currentItem.select();
        Keys.onEnterPressed: feedbackArea.visible ? feedbackArea.hide() : okButton.clicked();
        Keys.onReturnPressed: feedbackArea.visible ? feedbackArea.hide() : okButton.clicked();
        //Keys.onDownPressed: answerColumn.moveCurrentIndexDown();
        //Keys.onUpPressed: answerColumn.moveCurrentIndexUp();

        Rectangle {
            id: instructionArea
            opacity: 1
            radius: background.baseMargins
            color: "#373737"
            height: 40 * ApplicationInfo.ratio
            width: Math.min(320 * ApplicationInfo.ratio, parent.width - 2 * background.baseMargins)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: background.baseMargins

            GCText {
                id: instruction
                wrapMode: TextEdit.WordWrap
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                height: parent.height - background.baseMargins
                width: parent.width - 2 * background.baseMargins
                fontSizeMode: Text.Fit
                color: 'white'
                anchors.centerIn: instructionArea
            }
        }

        Item {
            id: layoutArea
            anchors.top: instructionArea.bottom
            anchors.bottom: bar.top
            anchors.left: background.left
            anchors.right: okButton.left
            anchors.margins: background.baseMargins
        }

        Column {
            id: answerColumn
            width: layoutArea.width
            height: layoutArea.height
            anchors.top: layoutArea.top
            anchors.topMargin: background.baseMargins * 0.5
            anchors.left: parent.left
            anchors.leftMargin: anchors.topMargin

            Repeater {
                model: answerModel
                Item {
                    width: answerColumn.width - 10 * ApplicationInfo.ratio
                    height: (layoutArea.height
                             - 10 * ApplicationInfo.ratio * answerModel.count) / answerModel.count
                    AnswerButton {
                        visible: mode_ === "oneAnswer"
                        anchors.fill: parent
                        textLabel: content_
                        blockAllButtonClicks: items.buttonsBlocked
                        isCorrectAnswer: isSolution_
                        onCorrectlyPressed: {
                            feedbackArea.display(isCorrectAnswer, correctAnswerText_)
                        }
                        onPressed: {
                            items.buttonsBlocked = true
                        }
                        onIncorrectlyPressed: {
                            feedbackArea.display(isCorrectAnswer, wrongAnswerText_)
                            items.buttonsBlocked = false
                        }
                    }
                    GCCheckBox {
                        visible: mode_ === "multipleAnswers"
                        anchors.fill: parent
                        text: content_
                        onCheckedChanged: {
                            checked_ = checked
                        }
                    }
                }
            }
        }
        Rectangle {
            id: feedbackArea
            opacity: 1
            radius: background.baseMargins
            color: "#373737"
            anchors.fill: answerColumn
            visible: false
            property bool isCorrectAnswer
            function display(success: bool, text: string) {
                feedbackArea.isCorrectAnswer = success
                if(text) {
                    feedbackText.text = text
                    feedbackArea.visible = true
                }
                else if(isCorrectAnswer) {
                    items.goodAnswerSound.play();
                    items.score.playWinAnimation();
                }
                else {
                    items.badAnswerSound.play();
                    items.buttonsBlocked = false;
                }
            }

            function hide() {
                feedbackArea.visible = false
                if(feedbackArea.isCorrectAnswer) {
                    items.score.playWinAnimation();
                    items.goodAnswerSound.play();
                }
                else {
                    items.badAnswerSound.play();
                    items.buttonsBlocked = false
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    feedbackArea.hide()
                }
            }
            GCText {
                id: feedbackText
                wrapMode: TextEdit.WordWrap
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                height: parent.height - background.baseMargins
                width: parent.width - 2 * background.baseMargins
                fontSizeMode: Text.Fit
                color: 'white'
                anchors.centerIn: feedbackArea
            }
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo

            onSaveData: {
                levelFolder = dialogActivityConfig.chosenLevels
                currentActivity.currentLevels = dialogActivityConfig.chosenLevels
                ApplicationSettings.setCurrentLevels(currentActivity.name, dialogActivityConfig.chosenLevels)
            }
            onClose: home()
            onStartActivity: {
                background.stop()
                background.start()
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Score {
            id: score
            numberOfSubLevels: items.numberOfSubLevel
            currentSubLevel: items.currentSubLevel
            anchors.top: undefined
            anchors.bottom: background.bottom
            anchors.bottomMargin: bar.height * 1.5
            anchors.right: background.right
            anchors.rightMargin: background.baseMargins
            onStop: Activity.nextSubLevel()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level | activityConfig }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        BarButton {
            id: okButton
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: 70 * ApplicationInfo.ratio
            height: width
            sourceSize.height: width
            sourceSize.width: width
            anchors.bottom: score.top
            anchors.bottomMargin: background.baseMargins
            anchors.horizontalCenter: score.horizontalCenter
            onClicked: Activity.checkResult()
            mouseArea.enabled: !items.buttonsBlocked
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
