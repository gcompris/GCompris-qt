/* GCompris - Enumerate.qml
*
* SPDX-FileCopyrightText: 2014 Thib ROMAIN <thibrom@gmail.com>
*
* Authors:
*   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
*   Thib ROMAIN <thibrom@gmail.com> (Qt Quick port)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12
import GCompris 1.0
import "."

import "../../core"
import "enumerate.js" as Activity

ActivityBase {
    id: activity

    onStart: { focus: true }
    onStop: {}

    // When opening a dialog, it steals the focus and re set it to the activity.
    // We need to set it back to the answerColumn item in order to have key events.
    onFocusChanged: {
        if(focus) {
            Activity.focusAnswerInput();
        }
    }

    pageComponent: Image {
        id: activityBackground
        anchors.fill: parent
        signal start
        signal stop
        fillMode: Image.PreserveAspectCrop
        source: Activity.url + "background.svg"
        sourceSize.width: width
        sourceSize.height: height

        readonly property int answersWidth: Math.min(140 * ApplicationInfo.ratio, activityBackground.width * 0.25)
        readonly property int baseMargins: 10 * ApplicationInfo.ratio

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }
        onStart: { Activity.start(items); keyboard.populate(); }
        onStop: { Activity.stop() }

        //instruction rectangle
        Rectangle {
            id: instruction
            anchors.horizontalCenter: instructionTxt.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: activityBackground.baseMargins
            height: instructionTxt.contentHeight + activityBackground.baseMargins * 2
            width: instructionTxt.contentWidth + activityBackground.baseMargins * 2
            opacity: 0.8
            visible: items.levels
            radius: activityBackground.baseMargins
            border.width: 2
            z: instruction.opacity === 0 ? -10 : 10
            border.color: "#DDD"
            color: "#373737"

            Behavior on opacity { PropertyAnimation { duration: 200 } }

            //shows/hides the Instruction
            MouseArea {
                anchors.fill: parent
                onClicked: instruction.opacity = instruction.opacity == 0 ? 0.8 : 0
            }
        }

        GCText {
            id: instructionTxt
            anchors {
                top: parent.top
                right: parent.right
                left: answer.right
                margins: activityBackground.baseMargins * 2
            }
            height: 60 * ApplicationInfo.ratio
            opacity: instruction.opacity
            z: instruction.z
            fontSize: smallSize
            fontSizeMode: Text.Fit
            color: "white"
            text: items.instructionText
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignTop
            wrapMode: TextEdit.WordWrap
        }

        Keys.onDownPressed: {
            if(++answerColumn.currentIndex >= answerColumn.count)
                answerColumn.currentIndex = 0
            Activity.registerAnswerItem(answerColumn.itemAt(answerColumn.currentIndex))
        }
        Keys.onUpPressed: {
            if(--answerColumn.currentIndex < 0)
                answerColumn.currentIndex = answerColumn.count - 1
            Activity.registerAnswerItem(answerColumn.itemAt(answerColumn.currentIndex))
        }

        QtObject {
            id: items
            property alias activityBackground: activityBackground
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias okButton: okButton
            property alias answerColumn: answerColumn
            property alias itemListModel: itemList.model
            property alias instruction: instruction
            property string instructionText: ""
            property alias score: score
            property alias errorRectangle: errorRectangle
            property alias goodAnswerSound: goodAnswerSound
            property alias badAnswerSound: badAnswerSound
            readonly property var levels: activity.datasets.length !== 0 ? activity.datasets : null
            property int mode: 1 // default is automatic
            property bool buttonsBlocked: false
            property bool activityStopped: false
        }

        GCSoundEffect {
            id: goodAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/completetask.wav"
        }

        GCSoundEffect {
            id: badAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/crash.wav"
        }

        DropArea {
            id: dropableArea
            anchors.left: activityBackground.left
            anchors.bottom: activityBackground.bottom
            width: activityBackground.width
            height: activityBackground.height
            onEntered: instruction.opacity !== 0 ? instruction.opacity = 0 : null
        }

        Image {
            source: Activity.url + 'turtle.svg'
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            sourceSize.width: Math.max(parent.width, parent.height)
        }

        Column {
            id: answer
            anchors {
                left: parent.left
                top: parent.top
                margins: activityBackground.baseMargins
            }
            width: activityBackground.answersWidth
            spacing: activityBackground.baseMargins

            Repeater {
                id: answerColumn
                property int currentIndex

                onModelChanged: currentIndex = count - 1
                AnswerArea {
                    imgPath: modelData
                    focus: true
                    state: "default"
                }
            }

            add: Transition {
                NumberAnimation { properties: "x,y"; duration: 200 }
            }
        }

        BarButton {
            id: okButton
            enabled: items.mode === 2 && !items.buttonsBlocked
            visible: items.mode === 2
            anchors {
                bottom: bar.top
                right: parent.right
                margins: activityBackground.baseMargins
            }
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: 70 * ApplicationInfo.ratio
            onClicked: Activity.checkAnswers();
        }

        Item {
            id: layoutArea
            anchors.top: parent.top
            anchors.left: answer.right
            anchors.right: parent.right
            anchors.bottom: score.top

            onWidthChanged: resizeTimer.restart();
            onHeightChanged: resizeTimer.restart();

            function repositionItems() {
                if(items.itemListModel) {
                    for(var i in itemList.model) {
                        itemList.itemAt(i).positionMe();
                    }
                }
            }

            Repeater {
                id: itemList
                ItemToEnumerate {
                    source: modelData
                }
            }
        }

        // Reposition the items to find when width or height changes
        Timer {
            id: resizeTimer
            interval: 50
            onTriggered: {
                    layoutArea.repositionItems();
            }
        }

        ErrorRectangle {
            id: errorRectangle
            anchors.fill: answer
            imageSize: okButton.width
            function releaseControls() { items.buttonsBlocked = false; }
        }

        VirtualKeyboard {
            id: keyboard
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            enabled: visible && !items.buttonsBlocked

            function populate() {
                layout = [ [
                    { label: "0" },
                    { label: "1" },
                    { label: "2" },
                    { label: "3" },
                    { label: "4" },
                    { label: "5" },
                    { label: "6" },
                    { label: "7" },
                    { label: "8" },
                    { label: "9" }
                ] ]
            }

            onKeypress: Activity.currentAnswerItem.appendText(text)

            onError: (msg) => console.log("VirtualKeyboard error: " + msg);
        }


        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo
            onSaveData: {
                levelFolder = dialogActivityConfig.chosenLevels
                currentActivity.currentLevels = dialogActivityConfig.chosenLevels
                ApplicationSettings.setCurrentLevels(currentActivity.name, dialogActivityConfig.chosenLevels)
            }
            onLoadData: {
                if(activityData && activityData["mode"]) {
                    items.mode = activityData["mode"];
                }
            }
            onClose: {
                home()
            }
            onStartActivity: {
                activityBackground.stop()
                activityBackground.start()
            }
        }

        Score {
            id: score
            anchors.top: undefined
            anchors.bottom: undefined
            anchors.verticalCenter: okButton.verticalCenter
            anchors.right: okButton.visible ? okButton.left : activityBackground.right
            anchors.rightMargin: activityBackground.baseMargins
            onStop: Activity.nextSubLevel()
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            anchors.bottom: keyboard.top
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

        Keys.onReturnPressed: okButton.visible && okButton.enabled === true ? Activity.checkAnswers() : ""
        Keys.onEnterPressed: okButton.visible && okButton.enabled === true ? Activity.checkAnswers() : ""

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }
}
