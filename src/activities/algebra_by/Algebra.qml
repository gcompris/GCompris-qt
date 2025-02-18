/* GCompris - Algebra.qml
 *
 * SPDX-FileCopyrightText: 2014 Aruna Sankaranarayanan <aruna.evam@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import core 1.0

import "../../core"
import "algebra.js" as Activity

ActivityBase {
    id: activity
    property int speedSetting: 5

    onStart: {
        focus = true;
    }

    pageComponent: Image {
        id: activityBackground
        source: "qrc:/gcompris/src/activities/algebra_by/resource/background.svg"
        fillMode: Image.PreserveAspectCrop
        sourceSize.width: width
        sourceSize.height: height
        signal start
        signal stop

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        Item {
            id: items
            property alias activityBackground: activityBackground
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias score: score
            property alias errorRectangle: errorRectangle
            property alias okButton: okButton
            property alias balloon: balloon
            property alias iAmReady: iAmReady
            property alias firstOp: firstOp
            property alias secondOp: secondOp
            property alias numpad: numpad
            property int result
            readonly property var levels: activity.datasets
            property alias goodAnswerSound: goodAnswerSound
            property alias badAnswerSound: badAnswerSound
            property bool buttonsBlocked: false
        }

        onStart: {
            operand.text = Activity.operandText;
            Activity.start(items, operand, speedSetting);
        }

        onStop: Activity.stop()

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo
            onClose: {
                home()
            }
            onSaveData: {
                levelFolder = dialogActivityConfig.chosenLevels
                currentActivity.currentLevels = dialogActivityConfig.chosenLevels
                ApplicationSettings.setCurrentLevels(currentActivity.name, dialogActivityConfig.chosenLevels)
            }

            onLoadData: {
                if(activityData && activityData["speedSetting"]) {
                    activity.speedSetting = activityData["speedSetting"];
                }
            }

            onStartActivity: {
                activityBackground.stop()
                activityBackground.start()
            }
        }

        DialogHelp {
            id: dialogHelpLeftRight
            onClose: home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: (help | home | level | activityConfig) }
            onHelpClicked: {
                displayDialog(dialogHelpLeftRight)
            }
            onPreviousLevelClicked: {
                Activity.previousLevel()
            }
            onNextLevelClicked: {
                Activity.nextLevel()
            }
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig)
            }
            onHomeClicked: home()
        }

        BarButton {
            id: okButton
            z: 10
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            y: Math.max((parent.height- height)* 0.5, textFlowBackground.y + firstOp.height * 2 + GCStyle.baseMargins + GCStyle.halfMargins)
            anchors.left: score.right
            anchors.leftMargin: GCStyle.baseMargins
            width: GCStyle.bigButtonHeight
            onClicked: Activity.checkAnswer();
            enabled: visible && !items.buttonsBlocked && numpad.answer != ""
            visible: !iAmReady.visible
        }

        Keys.onReturnPressed: validateKey();

        Keys.onEnterPressed: validateKey();

        function validateKey() {
            if(iAmReady.visible) {
                iAmReady.clicked();
            } else if(okButton.enabled === true) {
                okButton.clicked()
                okButtonAnimation.start()
            }
        }

        SequentialAnimation {
            id: okButtonAnimation
            running: false
            NumberAnimation { target: okButton; property: "scale"; to: 0.9; duration: 70 }
            NumberAnimation { target: okButton; property: "scale"; to: 1; duration: 70 }
        }

        Balloon {
            id: balloon
            onTimeout: bonus.bad("smiley")
        }

        GCSoundEffect {
            id: goodAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/completetask.wav"
        }

        GCSoundEffect {
            id: badAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/crash.wav"
        }

        Score {
            id: score
            x: textFlowBackground.x
            anchors.verticalCenter: okButton.verticalCenter
            anchors.right: undefined
            anchors.bottom: undefined
            currentSubLevel: 0
            numberOfSubLevels: 10
            onStop: Activity.questionsLeft()
            visible: !iAmReady.visible
        }

        Bonus {
            id: bonus
            Component.onCompleted: {
                loose.connect(Activity.run)
                win.connect(Activity.nextLevel)
            }
        }

        ReadyButton {
            id: iAmReady
            onClicked: Activity.run()
        }

        Rectangle {
            id: textFlowBackground
            anchors.top: textFlow.top
            anchors.left: textFlow.left
            anchors.leftMargin: -GCStyle.halfMargins
            width: textFlow.childrenRect.width + 3 * GCStyle.halfMargins
            height: textFlow.childrenRect.height
            color: GCStyle.lightTransparentBg
            radius: GCStyle.halfMargins
            visible: !iAmReady.visible
        }

        Flow {
            id: textFlow
             x: parent.width * 0.25
             y: parent.height * 0.1
             width: parent.width * 0.5
             height: parent.height * 0.3
             spacing: GCStyle.halfMargins

            AlgebraText {
                id: firstOp
                visible: !iAmReady.visible
            }

            AlgebraText {
                id: operand
                visible: !iAmReady.visible
            }

            AlgebraText {
                id: secondOp
                visible: !iAmReady.visible
            }

            AlgebraText {
                id: equals
                visible: !iAmReady.visible
                text: "="
            }

            AlgebraText {
                id: resultText
                visible: !iAmReady.visible
                // setting a space on empty answer looks better,
                // and is a workaround to force updating textFlow.childrenRect size
                text: numpad.answer == "" ? " " : numpad.answer
            }
        }

        ErrorRectangle {
            id: errorRectangle
            anchors.fill: textFlowBackground
            imageSize: okButton.width
            radius: GCStyle.halfMargins
            function releaseControls() {
                Activity.run();
            }
        }

        NumPad {
            id: numpad
            maxDigit: ('' + items.result).length + 1
            enableInput: !items.buttonsBlocked
        }

        Keys.onPressed: (event) => {
            if(!items.buttonsBlocked)
                numpad.updateAnswer(event.key, true);
        }

        Keys.onReleased: (event) => {
            if(!items.buttonsBlocked)
                numpad.updateAnswer(event.key, false);
        }
    }
}
