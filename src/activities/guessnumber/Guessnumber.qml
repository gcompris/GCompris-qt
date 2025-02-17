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
        id: activityBackground
        color: "#5a3820"

        readonly property int baseMargins: 10 * ApplicationInfo.ratio

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
            property alias bonus: bonus
            property alias helico: helico
            property alias textArea: textArea
            property alias infoText: userInfo
            property alias answerArea: answerArea
            readonly property var levels: activity.datasets.length !== 0 ? activity.datasets : null
            property int currentMax: 0
            property alias numpad: numpad
            property int maxSize: activityBackground.height * 0.16
            property int size: 70 * ApplicationInfo.ratio
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        GCSoundEffect {
            id: helicopterSound
            source: "qrc:/gcompris/src/activities/guessnumber/resource/helicopter.wav"
        }

        // the cave image needs to be aligned on the right to always see the exit
        Image {
            source: "resource/cave.svg"
            height: parent.height
            sourceSize.height: height
            anchors.right: parent.right
        }

        Item {
            id: layoutArea
            anchors.top: parent.top
            anchors.topMargin: bar.height
            anchors.bottom: bar.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: numpad.columnWidth
            anchors.rightMargin: numpad.columnWidth

            Helico {
                id: helico
                height: Math.min(items.maxSize, items.size)
            }
        }

        Rectangle {
            id: textAreaBg
            anchors.centerIn: textArea
            width: textArea.contentWidth + 2 * activityBackground.baseMargins
            height: textArea.contentHeight + activityBackground.baseMargins
            color: "#373737"
            radius: activityBackground.baseMargins
        }

        GCText {
            id: textArea
            anchors.top: parent.top
            anchors.topMargin: activityBackground.baseMargins
            anchors.left: parent.left
            anchors.leftMargin: numpad.columnWidth + activityBackground.baseMargins
            anchors.right: parent.right
            anchors.rightMargin: numpad.columnWidth + activityBackground.baseMargins
            height: 25 * ApplicationInfo.ratio
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: TextEdit.WordWrap
            color: "#f2f2f2"
            font.bold: true
            fontSize: mediumSize
            fontSizeMode: Text.Fit
        }

        AnswerArea {
            id: answerArea
            anchors.top: textAreaBg.bottom
            anchors.topMargin: activityBackground.baseMargins
            anchors.right: textArea.right
            anchors.rightMargin: activityBackground.baseMargins
            width: textArea.width * 0.3
            height: textArea.height

        }

        Rectangle {
            id: userInfoBg
            anchors.centerIn: userInfo
            width: userInfo.contentWidth + 2 * activityBackground.baseMargins
            height: userInfo.contentHeight + activityBackground.baseMargins
            visible: userInfo.text != ""
            color: "#f2f2f2"
            radius: activityBackground.baseMargins
        }

        GCText {
            id: userInfo
            anchors.top: textAreaBg.bottom
            anchors.topMargin: activityBackground.baseMargins
            anchors.left: textArea.left
            anchors.leftMargin: activityBackground.baseMargins
            anchors.right: answerArea.left
            anchors.rightMargin: activityBackground.baseMargins
            height: answerArea.height
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: "#373737"
            fontSize: mediumSize
            fontSizeMode: Text.Fit
        }

        NumPad {
            id: numpad
            onAnswerChanged: {
                if(answer && answerArea.userEntry != answer)
                    helicopterSound.play()
                answerArea.userEntry = answer
            }
            maxDigit: ("" + items.currentMax).length
            columnWidth: 60 * ApplicationInfo.ratio
            enableInput: !bonus.isPlaying
        }

        Keys.onPressed: (event) => {
            numpad.updateAnswer(event.key, true);
        }

        Keys.onReleased: (event) => {
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
