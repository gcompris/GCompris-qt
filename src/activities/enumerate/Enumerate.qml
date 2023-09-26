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
        id: background
        anchors.fill: parent
        signal start
        signal stop
        fillMode: Image.PreserveAspectCrop
        source: Activity.url + "background.svg"
        sourceSize.width: width
        sourceSize.height: height

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
            anchors {
                top: parent.top
                topMargin: 5
                horizontalCenter: parent.horizontalCenter
            }
            height: instructionTxt.contentHeight * 1.1
            width: Math.max(Math.min(parent.width * 0.8, instructionTxt.text.length * 10), parent.width * 0.3)
            opacity: 0.8
            visible: items.levels
            radius: 10
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

            GCText {
                id: instructionTxt
                anchors {
                    top: parent.top
                    topMargin: 5
                    horizontalCenter: parent.horizontalCenter
                }
                opacity: instruction.opacity
                z: instruction.z
                fontSize: smallSize
                color: "white"
                text: items.instructionText
                horizontalAlignment: Text.AlignHCenter
                width: parent.width * 0.8
                wrapMode: TextEdit.WordWrap
            }
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
            property alias background: background
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias okButton: okButton
            property alias answerColumn: answerColumn
            property alias itemListModel: itemList.model
            property alias instruction: instruction
            property string instructionText: ""
            property alias score: score
            property GCSfx audioEffects: activity.audioEffects
            readonly property var levels: activity.datasetLoader.data.length !== 0 ? activity.datasetLoader.data : null
            property int mode: 1 // default is automatic
        }

        DropArea {
            id: dropableArea
            anchors.left: background.left
            anchors.bottom: background.bottom
            width: background.width
            height: background.height
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
                margins: 10
            }
            spacing: 5

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

        // Reposition the items to find when whidh or height changes
        onWidthChanged: {
            for(var i in itemList.model)
                itemList.itemAt(i).positionMe()
        }

        onHeightChanged: {
            for(var i in itemList.model)
                itemList.itemAt(i).positionMe()
        }

        Repeater {
            id: itemList

            ItemToEnumerate {
                source: modelData
                main: background
            }
        }

        VirtualKeyboard {
            id: keyboard
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter

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

            onError: console.log("VirtualKeyboard error: " + msg);
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
                background.stop()
                background.start()
            }
        }

        Score {
            id: score
            anchors.top: undefined
            anchors.bottom: undefined
            anchors.verticalCenter: okButton.verticalCenter
            anchors.right: okButton.visible ? okButton.left : background.right
            anchors.rightMargin: 10 * ApplicationInfo.ratio
            onStop: Activity.initSubLevel()
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

        BarButton {
            id: okButton
            enabled: items.mode === 2
            visible: items.mode === 2
            anchors {
                bottom: bar.top
                right: parent.right
                rightMargin: 9 * ApplicationInfo.ratio
                bottomMargin: 9 * ApplicationInfo.ratio
            }
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            sourceSize.width: 80 * ApplicationInfo.ratio
            onClicked: Activity.checkAnswers();
        }

        Keys.onReturnPressed: okButton.visible && okButton.enabled === true ? Activity.checkAnswers() : ""
        Keys.onEnterPressed: okButton.visible && okButton.enabled === true ? Activity.checkAnswers() : ""

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }
}
