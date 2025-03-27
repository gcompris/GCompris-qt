/* GCompris - Oware.qml
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 *
 * Authors:
 *   Harsh Kumar <hadron43@yahoo.com>
 *   Timothée Giet <animtim@gmail.com> (redesign)
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0

import "../../core"
import "oware.js" as Activity

ActivityBase {
    id: activity

    property bool twoPlayers: false

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: activityBackground
        anchors.fill: parent
        source: "qrc:/gcompris/src/activities/hanoi_real/resource/background.svg"
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop
        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias activityBackground: activityBackground
            property alias bonus: bonus
            property alias board: board
            property alias player1score: player1score
            property alias player2score: player2score
            property alias hand1: hand1
            property alias hand2: hand2
            property alias animationSeed: animationSeed
            property alias teleportAnimation: teleportAnimation
            property alias delayAnimation: delayAnimation
            property alias captureAnimation: captureAnimation
            property alias invalidMoveAnimation: invalidMoveAnimation
            property alias instructionPanel: instructionPanel
            property alias selectedPit: teleportAnimation.fromPit
            property bool isDistributionAnimationPlaying: false
            property bool forceStop: false
            property bool gameOver: false
            property int playerWithFirstMove: Player.PLAYER2
        }

        onStart: { Activity.start(items, twoPlayers) }
        onStop: {
            stopAllAnimation()
            Activity.stop()
        }

        GCSoundEffect {
            id: scrollSound
            source: "qrc:/gcompris/src/core/resource/sounds/scroll.wav"
        }

        Item {
            id: topPanel
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            height: Math.min(parent.height / 6, parent.width / 6)

            ScoreItem {
                id: player1score
                player: 1
                height: topPanel.height / 1.5
                width: height*11/8
                anchors {
                    top: topPanel.top
                    left: topPanel.left
                    margins: GCStyle.halfMargins
                }
                playerImageSource: "qrc:/gcompris/src/core/resource/player_1.svg"
                backgroundImageSource: "qrc:/gcompris/src/activities/bargame/resource/score_1.svg"
                playerItem.source: Activity.url + "seed.svg"
                playerItem.height: playerItem.parent.height * 0.35
                playerItem.anchors.leftMargin: playerItem.parent.height * 0.15
                playerItem.anchors.bottomMargin: playerItem.parent.height * 0.10
            }

            Pit {
                id: hand1
                responsive: false
                label: false
                player: 1
                seeds: 0
                visible: player1score.playersTurn === true
                width: topPanel.height - 2 * anchors.topMargin
                anchors {
                    top: topPanel.top
                    topMargin: GCStyle.halfMargins
                    left: player1score.right
                    leftMargin: GCStyle.halfMargins + 0.4 * player1score.width
                }
            }

            GCTextPanel {
                id: instructionPanel
                visible: false
                panelWidth: hand2.x - (hand1.x + hand1.width) - 2 * GCStyle.baseMargins
                panelHeight: Math.min(50 * ApplicationInfo.ratio, hand1.height)
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: hand1.verticalCenter
                border.width: 0

                signal start(string message)

                onStart: (message) => {
                    textItem.text = message
                    instructionPanel.visible = true
                    instructionPauseAnimation.running = true
                }
                PauseAnimation {
                    id: instructionPauseAnimation
                    duration: 1000
                    onStopped: {
                        instructionPanel.visible = false
                    }
                }
            }

            Pit {
                id: hand2
                responsive: false
                label: false
                player: 2
                seeds: 0
                visible: player2score.playersTurn === true
                width: topPanel.height - 2 * anchors.topMargin
                anchors {
                    top: topPanel.top
                    topMargin: GCStyle.halfMargins
                    right: player2score.left
                    rightMargin: GCStyle.halfMargins + 0.4 * player2score.width
                }
            }

            ScoreItem {
                id: player2score
                player: 2
                height: topPanel.height / 1.5
                width: height*11/8
                anchors {
                    top: topPanel.top
                    right: topPanel.right
                    margins: GCStyle.halfMargins
                }
                playerImageSource: "qrc:/gcompris/src/core/resource/player_2.svg"
                backgroundImageSource: "qrc:/gcompris/src/activities/bargame/resource/score_2.svg"
                playerItem.source: Activity.url + "seed.svg"
                playerItem.height: playerItem.parent.height * 0.35
                playerItem.anchors.leftMargin: playerItem.parent.height * 0.10
                playerItem.anchors.bottomMargin: playerItem.parent.height * 0.10
                playerScaleOriginX: player2score.width
            }
        }

        Item {
            id: layoutArea
            anchors {
                top: topPanel.bottom
                left: parent.left
                right: parent.right
                bottom: bar.top
                bottomMargin: bar.height * 0.2
            }
        }

        Board {
            id: board
            anchors {
                horizontalCenter: layoutArea.horizontalCenter
                verticalCenter: layoutArea.verticalCenter
            }
            width: Math.min(layoutArea.width / 6, layoutArea.height / 4) * 6
        }

        Image {
            id: animationSeed
            source: Activity.url + "seed.svg"
            visible: false
            height: width
            sourceSize.width: width
            property Pit fromPit
            property Pit toPit
            property int animationDurationMillis: 750

            signal startAnimation(Pit from, Pit to)
            signal stop

            onStartAnimation: (from, to) => {
                items.isDistributionAnimationPlaying = true
                animationSeed.fromPit = from
                animationSeed.toPit = to

                var fromPos = Activity.getGlobalPos(animationSeed.fromPit)
                x = fromPos[0] + animationSeed.fromPit.width / 2
                y = fromPos[1] + animationSeed.fromPit.width / 2

                var toPos = Activity.getGlobalPos(animationSeed.toPit)
                xAnim.to = toPos[0] + animationSeed.toPit.width / 2
                yAnim.to = toPos[1] + animationSeed.toPit.width / 2

                width = animationSeed.fromPit.getSeedSize()
                sizeAnim.to = animationSeed.toPit.getSeedSize()

                visible = true
                animationSeed.fromPit.seeds = animationSeed.fromPit.seeds - 1
                parallelAnimation.running = true
            }

            ParallelAnimation {
                id: parallelAnimation
                alwaysRunToEnd: true
                NumberAnimation {
                    id: xAnim
                    target: animationSeed
                    property: "x"
                    duration: animationSeed.animationDurationMillis
                }
                NumberAnimation {
                    id: yAnim
                    target: animationSeed
                    property: "y"
                    duration: animationSeed.animationDurationMillis
                }
                PropertyAnimation {
                    id: sizeAnim
                    target: animationSeed
                    property: "width"
                    duration: animationSeed.animationDurationMillis
                }

                onStopped: {
                    scrollSound.play()
                    animationSeed.visible = false
                    animationSeed.toPit.seeds = animationSeed.toPit.seeds + 1
                    if(items.forceStop  || items.gameOver)
                        return
                    Activity.redistribute()
                }
            }
        }

        Item {
            id: teleportAnimation
            property Pit fromPit
            property Pit toPit
            property int noOfSeeds
            property int animationDurationMillis: 750

            signal start(Pit from, Pit to)

            onStart: (from, to) => {
                teleportAnimation.fromPit = from
                teleportAnimation.toPit = to
                noOfSeeds = teleportAnimation.fromPit.seeds
                teleportSequenceAnimation.running = true
            }

            SequentialAnimation {
                id: teleportSequenceAnimation
                PropertyAnimation {
                    id: fromHighlightOnAnim
                    target: teleportAnimation.fromPit
                    property: "selected"
                    to: true
                }
                PauseAnimation { duration: teleportAnimation.animationDurationMillis }
                PropertyAnimation {
                    id: fromReduceAnim
                    target: teleportAnimation.fromPit
                    property: "seeds"
                    to: 0
                }
                PropertyAnimation {
                    id: toIncreaseAnim
                    target: teleportAnimation.toPit
                    property: "seeds"
                    to: teleportAnimation.noOfSeeds
                }
                PauseAnimation { duration: teleportAnimation.animationDurationMillis }
                PauseAnimation { duration: teleportAnimation.animationDurationMillis }

                onStopped: {
                    if(items.forceStop  || items.gameOver) {
                        teleportAnimation.fromPit.selected = false;
                        return;
                    }
                    Activity.redistribute();
                }
            }
        }

        Item {
            id: delayAnimation
            property int player
            property int index

            signal start(var player_, var index_)

            onStart: (player_, index_) => {
                player = player_
                index = index_
                pauseAnimation.running = true
            }

            PauseAnimation {
                id: pauseAnimation
                duration: 750

                onStopped: {
                    if(items.forceStop || items.gameOver)
                        return
                    Activity.processMove(delayAnimation.player, delayAnimation.index)
                }
            }
        }

        Item {
            id: captureAnimation
            property Pit fromPit
            property ScoreItem score
            property int finalScore
            property string originalHighlightColor

            signal start(Pit fromPit_, ScoreItem score_)

            onStart: (fromPit_, score_) => {
                fromPit = fromPit_
                score = score_
                finalScore = fromPit_.seeds + score_.playerScore
                originalHighlightColor = fromPit_.highlightColor
                captureSequentialAnimation.running = true
            }

            SequentialAnimation {
                id: captureSequentialAnimation
                PropertyAnimation {
                    target: captureAnimation.fromPit
                    property: "highlightColor"
                    to: "#e77936" //orange
                }
                PropertyAnimation {
                    target: captureAnimation.fromPit
                    property: "highlight"
                    to: true
                }
                PauseAnimation { duration: 500 }
                PropertyAnimation {
                    target: captureAnimation.fromPit
                    property: "seeds"
                    to: 0
                }
                PropertyAnimation {
                    target: captureAnimation.score
                    property: "playerScore"
                    to: captureAnimation.finalScore
                }
                PropertyAnimation {
                    target: captureAnimation.fromPit
                    property: "highlightColor"
                    to: captureAnimation.originalHighlightColor
                }
                PropertyAnimation {
                    target: captureAnimation.fromPit
                    property: "highlight"
                    to: false
                }
                PauseAnimation { duration: 500 }
                onStopped: {
                    if(items.forceStop || items.gameOver)
                        return
                    Activity.checkCapture()
                }
            }
        }

        Item {
            id: invalidMoveAnimation
            property Pit targetPit
            property string originalHighlightColor

            signal start(Pit targetPit_)

            onStart: (targetPit_) => {
                items.isDistributionAnimationPlaying = true
                targetPit = targetPit_
                originalHighlightColor = targetPit.highlightColor
                targetPit.highlightColor = "#DF543D" //red
                targetPit.highlight = true
                invalidMovePauseAnimation.running = true
            }

            PauseAnimation {
                id: invalidMovePauseAnimation
                duration: 750
                onStopped: {
                    invalidMoveAnimation.targetPit.highlightColor = invalidMoveAnimation.originalHighlightColor
                    invalidMoveAnimation.targetPit.highlight = false
                    items.isDistributionAnimationPlaying = false
                }
            }
        }

        function stopAllAnimation() {
            items.forceStop = true
            invalidMovePauseAnimation.complete()
            parallelAnimation.complete()
            teleportSequenceAnimation.complete()
            pauseAnimation.complete()
            captureSequentialAnimation.complete()
            items.forceStop = false
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | reload }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onHomeClicked: activity.home()
            onReloadClicked: {
                stopAllAnimation()
                Activity.initLevel()
            }
        }

        Bonus {
            id: bonus
        }
    }

}
