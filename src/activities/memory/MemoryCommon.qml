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
import core 1.0

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
        id: activityBackground
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
            property alias winSound: winSound
            property alias flipSound: flipSound
            property bool withTux: activity.withTux
            property int playerCount: 1
            property bool tuxTurn: false
            property bool player2Turn: false
            property alias player1Score: player1Score
            property alias player2Score: player2Score
            property var playQueue
            property int selectionCount
            readonly property var levels: activity.datasets !=  0 ? activity.datasets : activity.dataset
            property alias containerModel: containerModel
            property alias cardGrid: cardGrid
            property bool blockClicks: false
            property int columns
            property int rows
            property bool isMultipleDatasetMode: activity.datasets != 0
        }

        onStart: {
            Activity.start(items);
            if(activity.needsVoices === true) {
                if(!ApplicationSettings.isAudioVoicesEnabled || !ApplicationSettings.isAudioEffectsEnabled)
                    activityBackground.audioDisabled = true
            }
        }

        onStop: {
            Activity.stop();
        }

        GCSoundEffect {
            id: flipSound
            source: Activity.url + "card_flip.wav"
        }

        GCSoundEffect {
            id: winSound
            source: "qrc:/gcompris/src/core/resource/sounds/win.wav"
        }

        ListModel {
            id: containerModel
        }

        Item {
            id: layoutArea
            anchors.fill: parent
            anchors.margins: GCStyle.baseMargins
            anchors.bottomMargin: bar.height * 1.2
        }

        GridView {
            id: cardGrid
            cellWidth: width / items.columns
            cellHeight: height / items.rows
            anchors {
                left: layoutArea.left
                top: layoutArea.top
            }

            property real cardImageWidth: Math.min(cellWidth - GCStyle.baseMargins,
                                                   (cellHeight - GCStyle.baseMargins) / 1.4)
            property real cardImageHeight: Math.min(cellHeight - GCStyle.baseMargins,
                                                    (cellWidth - GCStyle.baseMargins) * 1.4)

            model: containerModel
            delegate: CardItem {
                pairData: pairData_
                tuxTurn: activityBackground.items.tuxTurn
                width: cardGrid.cellWidth
                height: cardGrid.cellHeight
                cardImageWidth: cardGrid.cardImageWidth
                cardImageHeight: cardGrid.cardImageHeight
                audioVoices: activity.audioVoices
                onIsFoundChanged: activityBackground.keyNavigationVisible = false
            }
            interactive: false
            highlightFollowsCurrentItem: true
            highlightMoveDuration: 0
            highlight: Rectangle {
                color: GCStyle.whiteBg
                opacity: 0.8
                radius: GCStyle.halfMargins
                visible: activityBackground.keyNavigationVisible
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
                activityBackground.stop()
                activityBackground.start()
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

        Item {
            id: scoreArea
            anchors.bottom: layoutArea.bottom
            anchors.right: layoutArea.right
        }

        ScoreItem {
            id: player1Score
            height: Math.min(layoutArea.height/7, layoutArea.width/7, bar.height * 1.05)
            width: height * 1.2
            playerScaleOriginX: width * 0.5
            playerScaleOriginY: height * 0.5
            anchors.bottom: scoreArea.bottom
            anchors.right: scoreArea.right
            anchors.bottomMargin: height * 0.2
            anchors.rightMargin: width * 0.2
            playerImageSource: 'qrc:/gcompris/src/activities/memory/resource/child.svg'
            backgroundImageSource: 'qrc:/gcompris/src/activities/bargame/resource/score_1.svg'
        }

        ScoreItem {
            id: player2Score
            height: player1Score.height
            width: player1Score.width
            visible: activity.withTux || items.playerCount == 2
            playerScaleOriginX: player1Score.playerScaleOriginX
            playerScaleOriginY: player1Score.playerScaleOriginY
            playerImageSource: 'qrc:/gcompris/src/activities/memory/resource/tux.svg'
            backgroundImageSource: 'qrc:/gcompris/src/activities/bargame/resource/score_2.svg'
        }


        states: [
            State {
                name: "horizontalCards"
                when: horizontalLayout
                PropertyChanges {
                    scoreArea.width: player1Score.width * 1.4
                    player2Score.anchors.bottomMargin: player2Score.height * 0.4 + GCStyle.halfMargins
                    player2Score.anchors.rightMargin: player2Score.width * 0.2
                    cardGrid.anchors.rightMargin: GCStyle.halfMargins
                    cardGrid.anchors.bottomMargin: 0
                }
                AnchorChanges {
                    target: scoreArea
                    anchors.top: layoutArea.top
                    anchors.left: undefined
                }
                AnchorChanges {
                    target: player2Score
                    anchors.bottom: player1Score.top
                    anchors.right: layoutArea.right
                }
                AnchorChanges {
                    target: cardGrid
                    anchors.bottom: layoutArea.bottom
                    anchors.right: scoreArea.left
                }

            },
            State {
                name: "verticalCards"
                when: !horizontalLayout
                PropertyChanges {
                    scoreArea.height: player1Score.height * 1.4
                    player2Score.anchors.bottomMargin: player2Score.height * 0.2
                    player2Score.anchors.rightMargin: player2Score.width * 0.4 + GCStyle.halfMargins
                    cardGrid.anchors.rightMargin: 0
                    cardGrid.anchors.bottomMargin: GCStyle.halfMargins
                }
                AnchorChanges {
                    target: scoreArea
                    anchors.top: undefined
                    anchors.left: layoutArea.left
                }
                AnchorChanges {
                    target: player2Score
                    anchors.bottom: layoutArea.bottom
                    anchors.right: player1Score.left
                }
                AnchorChanges {
                    target: cardGrid
                    anchors.bottom: scoreArea.top
                    anchors.right: layoutArea.right
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
        Keys.onPressed: (event) => {
            activityBackground.keyNavigationVisible = true
            if(event.key === Qt.Key_Left) {
                do {
                    if(cardGrid.currentIndex <= 0) {
                        cardGrid.currentIndex = cardGrid.count - 1;
                    } else {
                        cardGrid.currentIndex -= 1;
                    }
                }
                while(cardGrid.currentItem.isFound && !items.blockClicks)
            }
            else if(event.key === Qt.Key_Right) {
                do {
                    if(cardGrid.currentIndex >= cardGrid.count - 1) {
                        cardGrid.currentIndex = 0;
                    } else {
                        cardGrid.currentIndex += 1
                    }
                }
                while(cardGrid.currentItem.isFound && !items.blockClicks)
            }
            else if(event.key === Qt.Key_Up) {
                do {
                    if(cardGrid.currentIndex === 0) {
                        cardGrid.currentIndex = cardGrid.count - 1
                    } else {
                        cardGrid.currentIndex -= items.columns
                        if(cardGrid.currentIndex < 0)
                            cardGrid.currentIndex += cardGrid.count - 1
                    }
                }
                while(cardGrid.currentItem.isFound && !items.blockClicks)
            }
            else if(event.key === Qt.Key_Down) {
                do {
                    if(cardGrid.currentIndex === cardGrid.count - 1) {
                        cardGrid.currentIndex = 0
                    } else {
                        cardGrid.currentIndex += items.columns
                        if(cardGrid.currentIndex >= cardGrid.count)
                            cardGrid.currentIndex -= cardGrid.count - 1
                    }
                }
                while(cardGrid.currentItem.isFound && !items.blockClicks)
            }
            else if(event.key === Qt.Key_Space || event.key === Qt.Key_Enter || event.key === Qt.Key_Return)
                if(cardGrid.currentItem.isBack && !cardGrid.currentItem.isFound && !cardGrid.currentItem.tuxTurn && items.selectionCount < 2) cardGrid.currentItem.selected()
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
                    activityBackground.audioDisabled = false;
                }
            }
            anchors.fill: parent
            focus: true
            active: activityBackground.audioDisabled
            onStatusChanged: if (status == Loader.Ready) item.start()
        }
    }
}
