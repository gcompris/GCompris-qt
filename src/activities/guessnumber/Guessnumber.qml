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
import core 1.0

import "../../core"
import "qrc:/gcompris/src/core/core.js" as Core
import "guessnumber.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property alias currentActivity: activity.activityInfo

    pageComponent: Rectangle {
        id: activityBackground
        color: "#5a3820"

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
            property alias textArea: instructionPanel.textItem
            property alias infoText: userInfoPanel.textItem
            property alias answerArea: answerArea
            readonly property var levels: activity.datasets.length !== 0 ? activity.datasets : null
            property int currentMax: 0
            property alias numpad: numpad
            property int maxSize: activityBackground.height * 0.16
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

        Item {
            id: layoutArea
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 90 * ApplicationInfo.ratio // equal to the sum of top panels height + margins for top/bottm margins
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: numpad.columnWidth
            anchors.rightMargin: numpad.columnWidth

            Helico {
                id: helico
                height: Math.min(items.maxSize, GCStyle.bigButtonHeight)
            }
        }

        GCTextPanel {
            id: instructionPanel
            panelWidth: layoutArea.width
            panelHeight: 35 * ApplicationInfo.ratio
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: GCStyle.baseMargins
        }

        Row {
            anchors.top: instructionPanel.bottom
            anchors.left: layoutArea.left
            anchors.right: layoutArea.right
            anchors.topMargin: GCStyle.halfMargins
            height: instructionPanel.panelHeight
            spacing: GCStyle.baseMargins

            Item {
                id: userInfoArea
                width: parent.width * 0.7 - GCStyle.baseMargins
                height: parent.height

                GCTextPanel {
                    id: userInfoPanel
                    fixedHeight: true
                    hideIfEmpty: true
                    panelWidth: parent.width - 2 * GCStyle.baseMargins
                    panelHeight: parent.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: GCStyle.lightBg
                    border.width: 0
                    textItem.color: GCStyle.darkText
                }
            }

            Item {
                id: answerArea
                width: parent.width * 0.3
                height: parent.height

                GCTextPanel {
                    id: answerPanel
                    panelWidth: parent.width
                    panelHeight: parent.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: GCStyle.lightBg
                    border.width: 0
                    textItem.color: GCStyle.darkText

                    property string userEntry: ""

                    onUserEntryChanged: {
                        textItem.text = Core.convertNumberToLocaleString(Number(userEntry));
                        if(userEntry != "")
                            Activity.setUserAnswer(parseInt(userEntry))
                    }
                }
            }
        }

        NumPad {
            id: numpad
            onAnswerChanged: {
                answerPanel.userEntry = answer
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
