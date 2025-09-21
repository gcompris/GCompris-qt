/* GCompris - multiple_choice_questions.qml
 *
 * SPDX-FileCopyrightText: 2024 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
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
        id: activityBackground
        anchors.fill: parent
        color: GCStyle.lightBlueBg
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
            property alias activityBackground: activityBackground
            property int currentLevel: activity.currentLevel
            property int currentSubLevel: 0
            property int numberOfSubLevel: 0
            property var levels: activity.datasets
            property string mode
            property int currentAnswerIndex: -1
            property alias bonus: bonus
            property alias score: score
            property alias errorRectangle: errorRectangle
            property alias goodAnswerSound: goodAnswerSound
            property alias badAnswerSound: badAnswerSound
            property alias instruction: instructionPanel.textItem
            property alias answerModel: answerModel
            property alias answerList: answerList
            property alias feedbackArea: feedbackArea
            property bool buttonsBlocked: true
            property alias client: client
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        ListModel { id: answerModel }

        GCSoundEffect {
            id: goodAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/completetask.wav"
        }

        GCSoundEffect {
            id: badAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/crash.wav"
        }

        Client {    // Client for server version. Prepare data from activity to server
            id: client
            getDataCallback: function() {
                var question = instructionPanel.textItem.text
                var answers = []
                var correctAnswer = []
                var selectedAnswer = []

                for(var i = 0; i < items.answerModel.count; i++) {
                    var answer = items.answerModel.get(i);
                    answers.push(answer.content_);
                    if(answer.checked_) {
                        selectedAnswer.push(answer.content_);
                    }
                    if(answer.isSolution_) {
                        correctAnswer.push(answer.content_);
                    }
                }
                var data = {
                    "question": question,
                    "expected": correctAnswer,
                    "selected": selectedAnswer,
                    "proposal": answers
                }
                print(JSON.stringify(data))
                return data
            }
        }

        Keys.onPressed: (event)=> {
            var acceptEvent = true;
            if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return){
                feedbackArea.visible ? feedbackArea.hide() : okButton.clicked();
            } else if(items.buttonsBlocked) {
                return;
            } else if(event.key === Qt.Key_Down){
                answerList.incrementCurrentIndex();
            } else if(event.key === Qt.Key_Up){
                answerList.decrementCurrentIndex();
            } else if(event.key === Qt.Key_Space && answerList.currentItem){
                answerList.currentItem.clicked();
            } else {
                acceptEvent = false;
            }
            event.accepted = acceptEvent;
        }

        GCTextPanel {
            id: instructionPanel
            panelWidth: parent.width - 2 * GCStyle.baseMargins
            panelHeight: Math.min(50 * ApplicationInfo.ratio, activityBackground.height * 0.2)
            fixedHeight: false
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: GCStyle.baseMargins
        }

        Item {
            id: sideArea
            anchors {
                top: instructionPanel.bottom
                right: activityBackground.right
                bottom: activityBackground.bottom
                margins: GCStyle.baseMargins
                bottomMargin: bar.height * 1.5
            }
            width: Math.max(score.width, okButton.width)

            Score {
                id: score
                numberOfSubLevels: items.numberOfSubLevel
                anchors {
                    top: undefined
                    bottom: parent.bottom
                    left: undefined
                    right: undefined
                    horizontalCenter: parent.horizontalCenter
                    margins: 0
                }

                onStop: {
                    if(!feedbackArea.triggerSubLevel) {
                        Activity.nextSubLevel();
                    }
                }
            }

            BarButton {
                id: okButton
                source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
                width: GCStyle.bigButtonHeight
                height: width
                anchors {
                    bottom: score.top
                    bottomMargin: GCStyle.baseMargins
                    horizontalCenter: parent.horizontalCenter
                }
                onClicked: Activity.checkResult()
                mouseArea.enabled: !items.buttonsBlocked
            }
        }

        ListView {
            id: answerList
            anchors {
                top: instructionPanel.bottom
                bottom: sideArea.bottom
                left: activityBackground.left
                right: sideArea.left
                margins: GCStyle.baseMargins
                bottomMargin: 0
            }
            spacing: GCStyle.tinyMargins
            orientation: Qt.Vertical
            verticalLayoutDirection: ListView.TopToBottom
            interactive: false
            model: answerModel
            currentIndex: -1

            highlight:  Rectangle {
                width: answerList.width
                height: answerList.buttonHeight
                color: GCStyle.highlightColor
                visible: answerList.currentIndex > -1
                y: answerList.currentItem ? answerList.currentItem.y : 0
                Behavior on y {
                    NumberAnimation {
                        duration: 100
                    }
                }
            }
            highlightFollowsCurrentItem: false

            property int buttonHeight: (height - spacing * (answerModel.count - 1)) / answerModel.count

            delegate: GCCheckButton {
                text: content_
                checked: checked_
                width: answerList.width
                height: answerList.buttonHeight
                enabled: !items.buttonsBlocked
                onClicked: {
                    if(items.mode === "oneAnswer") {
                        for(var i = 0; i < answerList.count; i++) {
                            if(i != index) {
                                answerList.itemAtIndex(i).checked = false;
                            }
                        }
                        if(checked) {
                            items.currentAnswerIndex = index;
                        } else {
                            items.currentAnswerIndex = -1;
                        }
                    }
                }

                onCheckedChanged: {
                    answerModel.setProperty(index, "checked_", checked);
                }
            }
        }

        ErrorRectangle {
            id: errorRectangle
            anchors.fill: answerList
            imageSize: okButton.width
            function releaseControls() {
                items.buttonsBlocked = false;
            }
        }

        Rectangle {
            id: feedbackArea
            color: GCStyle.darkBg
            border.color: GCStyle.whiteBorder
            border.width: GCStyle.thinnestBorder
            anchors.fill: answerList
            visible: false
            property bool isCorrectAnswer
            property bool triggerSubLevel

            function display(success: bool, text: string) {
                feedbackArea.isCorrectAnswer = success
                if(text) {
                    feedbackText.text = text;
                    feedbackArea.visible = true;
                    feedbackArea.triggerSubLevel = true;
                } else {
                    feedbackArea.triggerSubLevel = false;
                }
                if(isCorrectAnswer) {
                    items.score.currentSubLevel++;
                    items.score.playWinAnimation();
                    items.goodAnswerSound.play();
                } else {
                    items.badAnswerSound.play();
                    if(triggerSubLevel) {
                        items.buttonsBlocked = false;
                    } else {
                        errorRectangle.startAnimation();
                    }
                }
            }

            function hide() {
                if(isCorrectAnswer && !score.triggerSubLevel) {
                    Activity.nextSubLevel();
                }
                feedbackArea.visible = false;
            }

            GCText {
                id: feedbackText
                wrapMode: TextEdit.WordWrap
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                height: parent.height - 2 * GCStyle.baseMargins
                width: parent.width - 2 * GCStyle.baseMargins
                fontSizeMode: Text.Fit
                color: GCStyle.lightText
                anchors.centerIn: feedbackArea
            }
        }

        MouseArea {
            id: closeFeedbackClick
            enabled: feedbackArea.visible
            anchors.fill: parent
            onClicked: {
                feedbackArea.hide();
            }
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo

            onSaveData: {
                levelFolder = dialogActivityConfig.chosenLevels
                currentActivity.currentLevels = dialogActivityConfig.chosenLevels
            }
            onClose: home()
            onStartActivity: {
                activityBackground.stop()
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
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }
}
