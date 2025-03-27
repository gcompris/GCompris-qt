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
import core 1.0

import "../../core"
import "ordering.js" as Activity

ActivityBase {
    id: activity

    // Mode : numbers | alphabets | sentences | chronology
    property string mode

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: activityBackground
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
            readonly property var levels: activity.datasets
            property alias activityBackground: activityBackground
            property alias originListModel: originListModel
            property alias targetListModel: targetListModel
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias instruction: instructionPanel.textItem
            property alias targetPlaceholder: targetPlaceholder
        }

        onStart: { Activity.start(items, mode) }
        onStop: { Activity.stop() }

        GCTextPanel {
            id: instructionPanel
            panelWidth: parent.width - 2 * GCStyle.baseMargins
            panelHeight: 50 * ApplicationInfo.ratio
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: GCStyle.baseMargins
            border.width: 0
            textItem.fontSize: textItem.tinySize
        }

        Item {
            id: layoutArea
            anchors.top: instructionPanel.bottom
            anchors.bottom: bar.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: GCStyle.baseMargins
            anchors.bottomMargin: bar.height * 0.3
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
            width: layoutArea.width
            height: (layoutArea.height - GCStyle.baseMargins) * 0.5
            mode: activity.mode
            placeholderName: "target"
            highestParent: activityBackground
            placeholderListModel: targetListModel
        }

        OrderingPlaceholder {
            id: originPlaceholder
            anchors.top: targetPlaceholder.bottom
            anchors.topMargin: GCStyle.baseMargins
            width: layoutArea.width
            height: targetPlaceholder.height
            mode: activity.mode
            placeholderName: "origin"
            highestParent: activityBackground
            placeholderListModel: originListModel
        }

        // used only to block input during bonus feedback
        MouseArea {
            anchors.fill: parent
            enabled: bonus.isPlaying
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo

            onSaveData: {
                levelFolder = dialogActivityConfig.chosenLevels
                currentActivity.currentLevels = dialogActivityConfig.chosenLevels
                ApplicationSettings.setCurrentLevels(currentActivity.name, dialogActivityConfig.chosenLevels)
                // restart activity on saving
                activityBackground.start()
            }
            onClose: {
                home()
            }
            onStartActivity: {
                activityBackground.start()
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        BarButton {
            id: ok
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg";
            width: Math.min(GCStyle.bigButtonHeight,
                    originPlaceholder.height, originPlaceholder.width)
            enabled: !bonus.isPlaying && visible
            visible: originListModel.count === 0
            anchors.centerIn: originPlaceholder
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
