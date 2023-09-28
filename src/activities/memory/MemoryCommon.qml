/* GCompris - MemoryCommon.qml
 *
 * SPDX-FileCopyrightText: 2014 JB BUTET <ashashiwa@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   JB BUTET <ashashiwa@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

import "."
import "../../core"
import "memory.js" as Activity

ActivityBase {
    id: activity
    focus: true

    property string backgroundImg
    property var dataset
    property bool withTux: false
    property bool needsVoices: false

    onStart: focus = true
    onStop: {}

    isMusicalActivity: needsVoices

    pageComponent: Image {
        id: background
        source: activity.backgroundImg
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop
        focus: true

        signal start
        signal stop

        property alias items: items
        property bool keyNavigationVisible: false
        // if audio is disabled, we display a dialog to tell users this activity requires audio anyway
        property bool audioDisabled: false
        property bool horizontalLayout: layoutArea.width >= layoutArea.height

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        QtObject {
            id: items
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property GCSfx audioEffects: activity.audioEffects
            property bool withTux: activity.withTux
            property int playerCount: 1
            property bool tuxTurn: false
            property bool player2Turn: false
            property alias player1Score: player1Score
            property alias player2Score: player2Score
            property var playQueue
            property int selectionCount
            readonly property var levels: activity.datasetLoader.data !=  0 ? activity.datasetLoader.data : activity.dataset
            property alias containerModel: containerModel
            property alias grid: grid
            property bool blockClicks: false
            property int columns
            property int rows
            property int spacing: 5 * ApplicationInfo.ratio
            property bool isMultipleDatasetMode: activity.datasetLoader.data != 0
        }

        onStart: {
            Activity.start(items);
            if(activity.needsVoices === true) {
                if(!ApplicationSettings.isAudioVoicesEnabled || !ApplicationSettings.isAudioEffectsEnabled)
                    background.audioDisabled = true
            }
        }

        onStop: {
            Activity.stop();
        }

        ListModel {
            id: containerModel
        }

        Item {
            id: layoutArea
            anchors.top: background.top
            anchors.bottom: bar.top
            anchors.left: background.left
            anchors.right: background.right
            anchors.margins: items.spacing
        }

        GridView {
            id: grid
            cellWidth: width / items.columns
            cellHeight: height / items.rows
            anchors {
                left: background.left
                right: player1Score.left
                top: background.top
                bottom: player1Score.bottom
                margins: items.spacing
            }

            model: containerModel

            function getItemAtIndex(i) {
                var xi = (i % items.columns) * cellWidth + anchors.margins
                var yi = (i / items.columns) * cellHeight + anchors.margins
                return itemAt(xi, yi)
            }

            delegate: CardItem {
                pairData: pairData_
                tuxTurn: background.items.tuxTurn
                width: grid.cellWidth - grid.anchors.margins
                height: grid.cellHeight - grid.anchors.margins
                audioVoices: activity.audioVoices
                audioEffects: activity.audioEffects
                onIsFoundChanged: background.keyNavigationVisible = false
            }
            interactive: false
            highlightFollowsCurrentItem: true
            highlightMoveDuration: 0
            highlight: Rectangle {
                color: "#D0FFFFFF"
                radius: 10
                scale: 1.1
                visible: background.keyNavigationVisible
            }
            add: Transition {
                PathAnimation {
                    path: Path {
                        PathCurve { x: 0; y: 0}
                        PathCurve {}
                    }
                    easing.type: Easing.InOutQuad
                    duration: 1000
                }
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
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
                       items.playerCount = activityData["mode"];
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


        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: (activity.activityInfo.hasConfig || items.isMultipleDatasetMode) ? (help | home | level | activityConfig ) : (help | home | level ) }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig)
            }
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: home()
        }

        ScoreItem {
            id: player1Score
            height: Math.min(background.height/7, Math.min(background.width/7, bar.height * 1.05))
            width: height * 1.2
            anchors {
                bottom: bar.top
                right: background.right
                rightMargin: items.spacing * 8
                bottomMargin: items.spacing * 6
            }
            playerImageSource: 'qrc:/gcompris/src/activities/memory/resource/child.svg'
            backgroundImageSource: 'qrc:/gcompris/src/activities/bargame/resource/score_1.svg'
        }

        ScoreItem {
            id: player2Score
            height: Math.min(background.height/7, Math.min(background.width/7, bar.height * 1.05))
            width: height * 1.2
            visible: activity.withTux || items.playerCount == 2
            anchors {
                bottom: player1Score.top
                right: background.right
                rightMargin: items.spacing * 8
                bottomMargin: items.spacing * 6
            }
            playerImageSource: 'qrc:/gcompris/src/activities/memory/resource/tux.svg'
            backgroundImageSource: 'qrc:/gcompris/src/activities/bargame/resource/score_2.svg'
        }


        states: [
            State {
                name: "horizontalCards"
                when: horizontalLayout
                AnchorChanges {
                    target: player2Score
                    anchors.bottom: player1Score.top
                    anchors.right: background.right
                }
                AnchorChanges {
                    target: grid
                    anchors.bottom: player1Score.bottom
                    anchors.right: player1Score.left
                }

            },
            State {
                name: "verticalCards"
                when: !horizontalLayout
                AnchorChanges {
                    target: player2Score
                    anchors.bottom: bar.top
                    anchors.right: player1Score.left
                }
                AnchorChanges {
                    target: grid
                    anchors.bottom: player1Score.top
                    anchors.right: background.right
                }
            }
        ]

        Bonus {
            id: bonus
            interval: 2000
            Component.onCompleted: {
                win.connect(Activity.nextLevel)
                loose.connect(Activity.repeatCurrentLevel)
            }
        }

        Keys.enabled: !items.blockClicks
        Keys.onPressed: {
            background.keyNavigationVisible = true
            if(event.key === Qt.Key_Left) {
                do {
                    if(grid.currentIndex <= 0) {
                        grid.currentIndex = grid.count - 1;
                    } else {
                        grid.currentIndex -= 1;
                    }
                }
                while(grid.currentItem.isFound && !items.blockClicks)
            }
            else if(event.key === Qt.Key_Right) {
                do {
                    if(grid.currentIndex >= grid.count - 1) {
                        grid.currentIndex = 0;
                    } else {
                        grid.currentIndex += 1
                    }
                }
                while(grid.currentItem.isFound && !items.blockClicks)
            }
            else if(event.key === Qt.Key_Up) {
                do {
                    if(grid.currentIndex === 0) {
                        grid.currentIndex = grid.count - 1
                    } else {
                        grid.currentIndex -= items.columns
                        if(grid.currentIndex < 0)
                            grid.currentIndex += grid.count - 1
                    }
                }
                while(grid.currentItem.isFound && !items.blockClicks)
            }
            else if(event.key === Qt.Key_Down) {
                do {
                    if(grid.currentIndex === grid.count - 1) {
                        grid.currentIndex = 0
                    } else {
                        grid.currentIndex += items.columns
                        if(grid.currentIndex >= grid.count)
                            grid.currentIndex -= grid.count - 1
                    }
                }
                while(grid.currentItem.isFound && !items.blockClicks)
            }
            else if(event.key === Qt.Key_Space || event.key === Qt.Key_Enter || event.key === Qt.Key_Return)
                if(grid.currentItem.isBack && !grid.currentItem.isFound && !grid.currentItem.tuxTurn && items.selectionCount < 2) grid.currentItem.selected()
        }

        Loader {
            id: audioNeededDialog
            sourceComponent: GCDialog {
                parent: activity
                isDestructible: false
                message: qsTr("This activity requires sound, so it will play some sounds even if the audio voices or effects are disabled in the main configuration.")
                button1Text: qsTr("Quit")
                button2Text: qsTr("Continue")
                onButton1Hit: activity.home();
                onClose: {
                    background.audioDisabled = false;
                }
            }
            anchors.fill: parent
            focus: true
            active: background.audioDisabled
            onStatusChanged: if (status == Loader.Ready) item.start()
        }
    }
}
