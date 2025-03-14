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
import core 1.0
import "."

import "../../core"
import "enumerate.js" as Activity

ActivityBase {
    id: activity

    onStart: { focus: true }
    onStop: {}

    pageComponent: Image {
        id: activityBackground
        anchors.fill: parent
        signal start
        signal stop
        fillMode: Image.PreserveAspectCrop
        source: Activity.url + "background.svg"
        sourceSize.width: width
        sourceSize.height: height
        focus: true

        readonly property int answersWidth: Math.min(140 * ApplicationInfo.ratio, activityBackground.width * 0.25)

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }
        onStart: {
            Activity.start(items);
            keyboard.populate();
        }
        onStop: { Activity.stop() }

        //instruction rectangle
        GCTextPanel {
            id: instructionPanel
            panelWidth: parent.width - 3 * GCStyle.baseMargins - answer.width
            panelHeight: 60 * ApplicationInfo.ratio
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: (answer.width + GCStyle.baseMargins) * 0.5
            anchors.top: parent.top
            anchors.topMargin: GCStyle.baseMargins
            textItem.text:items.instructionText
            textItem.color: GCStyle.whiteText
            opacity: 0.9
            z: instructionPanel.opacity === 0 ? -10 : 10
            border.color: GCStyle.whiteBorder

            Behavior on opacity { PropertyAnimation { duration: 200 } }

            // show/hide the Instruction
            MouseArea {
                anchors.fill: parent
                onClicked: instructionPanel.opacity = instructionPanel.opacity == 0 ? 0.9 : 0
            }
        }

        QtObject {
            id: items
            property alias activityBackground: activityBackground
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias answerColumn: answerColumn
            property alias itemListModel: itemList.model
            property alias instructionPanel: instructionPanel
            property string instructionText: ""
            property alias score: score
            property alias errorRectangle: errorRectangle
            property alias goodAnswerSound: goodAnswerSound
            property alias badAnswerSound: badAnswerSound
            readonly property var levels: activity.datasets.length !== 0 ? activity.datasets : null
            property int mode: 1 // default is automatic
            property bool buttonsBlocked: false
            property bool okButtonBlocked: false
        }

        Keys.enabled: !items.buttonsBlocked
        Keys.onPressed: (event) => {
            Activity.resetAnswerAreaColor();
            Activity.appendText(event.text, answerColumn.itemAt(answerColumn.currentIndex));
        }

        Keys.onDownPressed: {
            Activity.resetAnswerAreaColor();
            if(++answerColumn.currentIndex >= answerColumn.count)
                answerColumn.currentIndex = 0
        }

        Keys.onUpPressed: {
            Activity.resetAnswerAreaColor();
            if(--answerColumn.currentIndex < 0)
                answerColumn.currentIndex = answerColumn.count - 1
        }

        Keys.onReturnPressed: {
            okButton.visible && !items.buttonsBlocked && !items.okButtonBlocked ? Activity.checkAnswers() : ""
        }

        Keys.onEnterPressed: {
            okButton.visible && !items.buttonsBlocked && !items.okButtonBlocked ? Activity.checkAnswers() : ""
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
            onEntered: instructionPanel.opacity !== 0 ? instructionPanel.opacity = 0 : null
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
                margins: GCStyle.baseMargins
            }
            width: activityBackground.answersWidth
            spacing: GCStyle.baseMargins

            Repeater {
                id: answerColumn
                property int currentIndex

                onModelChanged: currentIndex = 0
                AnswerArea {
                    imgPath: modelData
                    focus: true
                    state: "default"
                    isSelected: index === answerColumn.currentIndex
                    itemIndex: index
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
                margins: GCStyle.baseMargins
                bottomMargin: GCStyle.baseMargins * 2
            }
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: GCStyle.bigButtonHeight
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
            radius: GCStyle.halfMargins
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

            onKeypress: (text) => {
                Activity.appendText(text, answerColumn.itemAt(answerColumn.currentIndex));
            }

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
            anchors.rightMargin: GCStyle.baseMargins
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

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }
}
