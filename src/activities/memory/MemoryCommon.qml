/* GCompris - MemoryCommon.qml
 *
 * Copyright (C) 2014 JB BUTET <ashashiwa@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   JB BUTET <ashashiwa@gmail.com> (Qt Quick port)
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
            property alias bar: bar
            property alias bonus: bonus
            property GCSfx audioEffects: activity.audioEffects
            property bool withTux: activity.withTux
            property bool tuxTurn: false
            property var playQueue
            property int selectionCount
            property int tuxScore: tuxScore.text
            property int playerScore: playerScore.text
            property var levels: activity.datasetLoader.data !=  0 ? activity.datasetLoader.data : activity.dataset
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
                activity.isMusicalActivity = true
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
                right: player.left
                top: background.top
                bottom: player.bottom
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
            content: BarEnumContent { value: items.isMultipleDatasetMode ? (help | home | level | activityConfig) : (help | home | level) }
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

        Rectangle {
            id: player
            color: "#B0ffffff"
            width: bar.height
            height: bar.height
            radius: items.spacing
            anchors {
                bottom: bar.top
                right: background.right
                rightMargin: 2 * ApplicationInfo.ratio
                bottomMargin: items.spacing * 2
            }

            Image {
                id: playerImage
                source: 'qrc:/gcompris/src/activities/memory/resource/child.svg'
                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                }
                width: parent.width * 0.5
                height: parent.height
                sourceSize.width: width
                fillMode: Image.PreserveAspectFit
            }

            GCText {
                id: playerScore
                width: playerImage.width
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "#373737"
                font.bold: true
                font.pointSize: NaN  // need to clear font.pointSize explicitly
                fontSizeMode: Text.Fit
                minimumPixelSize: 10
                font.pixelSize: width
                style: Text.Outline
                styleColor: "white"
                text: items.playerScore
            }
        }

        Rectangle {
            id: tux
            visible: activity.withTux
            color: "#B0ffffff"
            width: bar.height
            height: bar.height
            radius: items.spacing
            anchors {
                bottom: player.top
                right: background.right
                rightMargin: 2 * ApplicationInfo.ratio
                bottomMargin: items.spacing * 2
            }
            Image {
                id: tuxImage
                source: 'qrc:/gcompris/src/activities/memory/resource/tux.svg'
                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                }
                width: parent.width * 0.5
                height: parent.height
                sourceSize.width: width
                fillMode: Image.PreserveAspectFit
            }

            GCText {
                id: tuxScore
                width: tuxImage.width
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "#373737"
                font.bold: true
                font.pointSize: NaN  // need to clear font.pointSize explicitly
                fontSizeMode: Text.Fit
                minimumPixelSize: 10
                font.pixelSize: width
                style: Text.Outline
                styleColor: "white"
                text: items.tuxScore
            }
        }

        states: [
            State {
                name: "horizontalCards"
                when: horizontalLayout
                AnchorChanges {
                    target: tux
                    anchors.bottom: player.top
                    anchors.right: background.right
                }
                AnchorChanges {
                    target: grid
                    anchors.bottom: player.bottom
                    anchors.right: player.left
                }

            },
            State {
                name: "verticalCards"
                when: !horizontalLayout
                AnchorChanges {
                    target: tux
                    anchors.bottom: bar.top
                    anchors.right: player.left
                }
                AnchorChanges {
                    target: grid
                    anchors.bottom: player.top
                    anchors.right: background.right
                }
            }
        ]

        Bonus {
            id: bonus
            interval: 2000
            Component.onCompleted: win.connect(Activity.nextLevel)
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
