/* GCompris - guessnumber.qml
 *
 * Copyright (C) 2014 Thib ROMAIN <thibrom@gmail.com>
 *
 * Authors:
 *   Clement Coudoin <clement.coudoin@free.fr> (GTK+ version)
 *   Thib ROMAIN <thibrom@gmail.com> (Qt Quick port)
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
import GCompris 1.0

import "../../core"
import "guessnumber.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property alias currentActivity: activity.activityInfo

    pageComponent: Image {
        id: background
        fillMode: Image.PreserveAspectCrop
        source: "resource/cave.svg"
        anchors.fill: parent

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
            property alias bar: bar
            property alias bonus: bonus
            property alias helico: helico
            property alias textArea: textArea
            property alias infoText: userInfo
            property alias answerArea: answerArea
            property var levels: activity.datasetLoader.data.length !== 0 ? activity.datasetLoader.data : null
            property int currentMax: 0
            property alias numpad: numpad
            property int maxSize: 120
            property int minSize: 80
            property int barHeightAddon: ApplicationSettings.isBarHidden ? 1 : 3
            property int size: Math.min(background.width / 9, background.height / (8 + barHeightAddon))
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Helico {
            id: helico
            fillMode: "PreserveAspectFit"
            sourceSize.height: items.maxSize * ApplicationInfo.ratio
            height: (items.size>items.minSize) ?
                                   (items.size<items.maxSize) ? items.size * ApplicationInfo.ratio :
                                                                items.maxSize * ApplicationInfo.ratio :
                                   items.minSize * ApplicationInfo.ratio
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
                background.start()
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
                background.start()
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
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
