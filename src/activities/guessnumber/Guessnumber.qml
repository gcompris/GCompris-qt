/* GCompris - guessnumber.qml
 *
 * SPDX-FileCopyrightText: 2014 Thib ROMAIN <thibrom@gmail.com>
 *
 * Authors:
 *   Clement Coudoin <clement.coudoin@free.fr> (GTK+ version)
 *   Thib ROMAIN <thibrom@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "guessnumber.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property alias currentActivity: activity.activityInfo

    pageComponent: Rectangle {
        id: background
        color: "#5a3820"

        signal start
        signal stop

        onWidthChanged: helico.init()
        onHeightChanged: helico.init()

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
            property alias bonus: bonus
            property alias helico: helico
            property alias textArea: textArea
            property alias infoText: userInfo
            property alias answerArea: answerArea
            readonly property var levels: activity.datasetLoader.data.length !== 0 ? activity.datasetLoader.data : null
            property int currentMax: 0
            property alias numpad: numpad
            property int maxSize: background.height * 0.16
            property int size: 70 * ApplicationInfo.ratio
            property int barHeightAddon: ApplicationSettings.isBarHidden ? 1 : 3
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        // the cave image needs to be aligned on the right to always see the exit
        Image {
            source: "resource/cave.svg"
            height: parent.height
            sourceSize.height: height
            anchors.right: parent.right
        }

        Helico {
            id: helico
            fillMode: "PreserveAspectFit"
            sourceSize.height: height
            height: (items.size>items.maxSize) ? items.maxSize : items.size
        }

        GCText {
            id: textArea
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: numpad.columnWidth + 10
            anchors.right: answerArea.left
            horizontalAlignment: Text.AlignHCenter
            width: parent.width - answerArea.width - 10
            wrapMode: TextEdit.WordWrap
            color: "white"
            font.bold: true
            fontSize: mediumSize
        }

        AnswerArea {
            id: answerArea
            anchors.right: parent.right
            anchors.rightMargin: numpad.visible ?
                                     numpad.columnWidth + 10 * ApplicationInfo.ratio :
                                     10 * ApplicationInfo.ratio
            anchors.top: parent.top
            anchors.topMargin: 10
        }

        GCText {
            id: userInfo
            anchors.top: textArea.top
            anchors.topMargin: 15 + textArea.contentHeight
            anchors.horizontalCenter: textArea.horizontalCenter
            color: "white"
            font.bold: true
            fontSize: regularSize
        }

        NumPad {
            id: numpad
            onAnswerChanged: {
                if(answer && answerArea.userEntry != answer)
                    activity.audioEffects.play('qrc:/gcompris/src/activities/guessnumber/resource/helicopter.wav')
                answerArea.userEntry = answer
            }
            maxDigit: ("" + items.currentMax).length
            columnWidth: 60 * ApplicationInfo.ratio
            enableInput: !bonus.isPlaying
        }

        Keys.onPressed: {
            numpad.updateAnswer(event.key, true);
        }

        Keys.onReleased: {
            numpad.updateAnswer(event.key, false);
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
                if(activityData) {
                    Activity.initLevel()
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
