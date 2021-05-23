/* GCompris - Ordering.qml
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 *
 * Authors:
 *   Harsh Kumar <hadron43@yahoo.com>
 *   Emmanuel Charruau <echarruau@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9
import GCompris 1.0
import QtQml.Models 2.1

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
        source: "resource/background.svg"
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
            property var levels: activity.datasetLoader.data
            property alias background: background
            property alias originListModel: originListModel
            property alias targetListModel: targetListModel
            property alias bar: bar
            property alias bonus: bonus
            property alias instruction: instruction
            property alias targetPlaceholder: targetPlaceholder
        }

        onStart: { Activity.start(items, mode) }
        onStop: { Activity.stop() }

        GCText {
            id: instruction
            wrapMode: TextEdit.WordWrap
            fontSize: tinySize
            horizontalAlignment: Text.Center
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.9
            color: 'white'
            Rectangle {
                z: -1
                opacity: 0.8
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#000" }
                    GradientStop { position: 0.9; color: "#666" }
                    GradientStop { position: 1.0; color: "#AAA" }
                }
                radius: 10
                border.color: 'black'
                border.width: 1
                anchors.centerIn: parent
                width: parent.width * 1.1
                height: parent.contentHeight
            }
        }

        Item {
            id: layoutArea
            anchors.top: instruction.bottom
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

            anchors {
                top: instruction.bottom
                topMargin: 20 * ApplicationInfo.ratio
            }
            
            height: (layoutArea.height - instruction.height - 30 * ApplicationInfo.ratio) / 2
            
            mode: activity.mode
            placeholderName: "target"
            highestParent: background

            placeholderListModel: targetListModel

            elementKey: "targetKey"
            targetPlaceholderKey: "originKey"
        }

        OrderingPlaceholder {
            id: originPlaceholder

            anchors {
                top: targetPlaceholder.bottom
                topMargin: 5 * ApplicationInfo.ratio
            }
            
            height: (layoutArea.height - instruction.height - 30 * ApplicationInfo.ratio) / 2
            
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
            anchors {
                right: parent.right
                bottom: bar.top
                bottomMargin: 10 * ApplicationInfo.ratio
                rightMargin: 10 * ApplicationInfo.ratio
            }
            onClicked: Activity.checkOrder()
        }

        Bar {
            id: bar
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
