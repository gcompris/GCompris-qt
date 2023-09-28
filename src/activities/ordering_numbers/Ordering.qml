/* GCompris - Ordering.qml
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 *
 * Authors:
 *   Harsh Kumar <hadron43@yahoo.com>
 *   Emmanuel Charruau <echarruau@gmail.com>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "ordering.js" as Activity

ActivityBase {
    id: activity

    // Mode : numbers | alphabets | sentences | chronology
    property string mode

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        sourceSize.width: width
        sourceSize.height: height
        source: "qrc:/gcompris/src/activities/braille_fun/resource/hillside.svg"
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
            readonly property string resourceUrl: activity.resourceUrl
            readonly property var levels: activity.datasetLoader.data
            property alias background: background
            property alias originListModel: originListModel
            property alias targetListModel: targetListModel
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias instruction: instruction
            property alias targetPlaceholder: targetPlaceholder
        }

        onStart: { Activity.start(items, mode) }
        onStop: { Activity.stop() }

        GCText {
            id: instruction
            z: 5
            wrapMode: TextEdit.WordWrap
            fontSize: tinySize
            horizontalAlignment: Text.Center
            width: parent.width * 0.9
            color: 'white'
            anchors.centerIn: instructionArea
        }

        Rectangle {
            id: instructionArea
            opacity: 1
            radius: 10
            color: "#373737"
            width: instruction.contentWidth * 1.1
            height: instruction.contentHeight * 1.1
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 5 * ApplicationInfo.ratio
        }

        Item {
            id: layoutArea
            anchors.top: instructionArea.bottom
            anchors.topMargin: 10 * ApplicationInfo.ratio
            anchors.bottom: bar.top
            anchors.bottomMargin: bar.height * 0.2
            anchors.left: parent.left
            anchors.right: parent.right
        }

        ListModel {
            id: originListModel
        }

        ListModel {
            id: targetListModel
        }

        OrderingPlaceholder {
            id: targetPlaceholder

            anchors.top: layoutArea.top
            height: (layoutArea.height - 10 * ApplicationInfo.ratio) / 2
            mode: activity.mode
            placeholderName: "target"
            highestParent: background

            placeholderListModel: targetListModel

            elementKey: "targetKey"
            targetPlaceholderKey: "originKey"
        }

        OrderingPlaceholder {
            id: originPlaceholder

            anchors.top: targetPlaceholder.bottom
            anchors.topMargin: 5 * ApplicationInfo.ratio
            height: targetPlaceholder.height
            mode: activity.mode
            placeholderName: "origin"
            highestParent: background

            placeholderListModel: originListModel

            elementKey: "originKey"
            targetPlaceholderKey: "targetKey"
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo

            onSaveData: {
                levelFolder = dialogActivityConfig.chosenLevels
                currentActivity.currentLevels = dialogActivityConfig.chosenLevels
                ApplicationSettings.setCurrentLevels(currentActivity.name, dialogActivityConfig.chosenLevels)
                // restart activity on saving
                background.start()
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

        BarButton {
            id: ok
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg";
            sourceSize.width: 70 * ApplicationInfo.ratio
            enabled: !bonus.isPlaying && (originListModel.count === 0)
            visible: originListModel.count === 0
            anchors.horizontalCenter: originPlaceholder.horizontalCenter
            anchors.verticalCenter: originPlaceholder.verticalCenter
            onClicked: Activity.checkOrder()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
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
