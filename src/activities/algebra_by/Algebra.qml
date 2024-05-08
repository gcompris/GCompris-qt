/* GCompris - Algebra.qml
 *
 * SPDX-FileCopyrightText: 2014 Aruna Sankaranarayanan <aruna.evam@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "algebra.js" as Activity

ActivityBase {
    id: activity
    property int speedSetting: 5

    onStart: {
        focus = true;
    }

    pageComponent: Image {
        id: background
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
            property alias background: background
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
            property GCSfx audioEffects: activity.audioEffects
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
                background.stop()
                background.start()
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
            x: parent.width * 0.7
            z: 10
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            anchors.verticalCenter: score.verticalCenter
            anchors.left: score.right
            anchors.leftMargin: 0.2 * height
            height: bar.height;
            width: height
            sourceSize.height: height
            sourceSize.width: height
            onClicked: Activity.checkAnswer();
            enabled: visible && !items.buttonsBlocked && numpad.answer != ""
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

        Score {
            id: score
            x: parent.width * 0.25
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: undefined
            anchors.bottom: undefined
            currentSubLevel: 0
            numberOfSubLevels: 10
            onStop: Activity.questionsLeft()
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

        Flow {
            id: textFlow
            x: parent.width / 2 - width / 2
            y: 80
            width: parent.width / 2
            height: 100
            anchors.margins: 4
            spacing: 10

            AlgebraText {
                id: firstOp
                visible: !iAmReady.visible
            }

            AlgebraText {
                id: operand
                visible: firstOp.visible
            }

            AlgebraText {
                id: secondOp
                visible: !iAmReady.visible
            }

            AlgebraText {
                id: equals
                visible: firstOp.visible
                text: "="
            }

            AlgebraText {
                id: result
                visible: !iAmReady.visible
                text: numpad.answer
            }
        }

        ErrorRectangle {
            id: errorRectangle
            anchors.top: textFlow.top
            anchors.bottom: okButton.top
            anchors.left: background.left
            anchors.right: background.right
            anchors.bottomMargin: 10 * ApplicationInfo.ratio
            imageSize: okButton.width
            function releaseControls() {
                Activity.run();
            }
        }

        NumPad {
            id: numpad
            maxDigit: ('' + items.result).length + 1
            enableInput: !items.buttonsBlocked
        }

        Keys.onPressed: {
            if(!items.buttonsBlocked)
                numpad.updateAnswer(event.key, true);
        }

        Keys.onReleased: {
            if(!items.buttonsBlocked)
                numpad.updateAnswer(event.key, false);
        }
    }
}
