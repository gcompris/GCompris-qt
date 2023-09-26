/* GCompris - ReverseCount.qml
 *
 * SPDX-FileCopyrightText: 2014 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Emmanuel Charruau <echarruau@gmail.com> (Qt Quick port)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Major rework)
 *   Timothée Giet <animtim@gcompris.net> (Layout and graphics rework)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "reversecount.js" as Activity


ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: "#ff1dade4"

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
            property GCSfx audioEffects: activity.audioEffects
            readonly property string resourceUrl: activity.resourceUrl
            readonly property var levels: activity.datasetLoader.data
            property alias background: background
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias chooseDiceBar: chooseDiceBar
            property alias tux: tux
            property alias fishToReach: fishToReach
            property int clockPosition: 4
            property string mode: "dot"
            property var heightBase: (background.height - bar.height * 1.5) / 5
            property var widthBase: background.width / 5
            property bool tuxIsMoving: false
            property bool tuxCanMove: true
        }

        onStart: { Activity.start(items) }
        onStop: {
            sizeChangedTimer.stop()
            Activity.stop()
        }

        Keys.onEnterPressed: chooseDiceBar.moveTux()
        Keys.onReturnPressed: chooseDiceBar.moveTux()

        onWidthChanged: {
            sizeChangedTimer.restart()
        }

        onHeightChanged: {
            sizeChangedTimer.restart()
        }

        function replaceItems() {
            if(Activity.fishIndex > 0) {
                // set x
                fishToReach.x = Activity.iceBlocksLayout[Activity.fishIndex % Activity.iceBlocksLayout.length][0] *
            items.widthBase + (items.widthBase - fishToReach.width) / 2
                // set y
                fishToReach.y = Activity.iceBlocksLayout[Activity.fishIndex % Activity.iceBlocksLayout.length][1] *
            items.heightBase + (items.heightBase - fishToReach.height) / 2
                // Move Tux
                Activity.moveTuxToIceBlock()
            }
        }

        Timer {
            id: sizeChangedTimer
            interval: 100
            onTriggered: replaceItems()
        }

        // === The ice blocks ===
        Repeater {
            model: Activity.iceBlocksLayout

            Image {
                x: modelData[0] * items.widthBase
                y: modelData[1] * items.heightBase
                width: items.widthBase
                height: items.heightBase
                source: items.resourceUrl + "ice-block.svg"
            }
        }

        Tux {
            id: tux
            sourceSize.width: Math.min(items.widthBase, items.heightBase)
            z: 11
        }


        Image {
            id: fishToReach
            source: items.resourceUrl + "fish-blue.svg"
            sourceSize.width: Math.min(items.widthBase, items.heightBase)
            z: 10
            property int nextX
            property int nextY

            function showParticles() {
                particles.burst(40)
            }

            ParticleSystemStarLoader {
                id: particles
                clip: false
            }

            onOpacityChanged: {
                if(opacity == 0) {
                    x = nextX
                    y = nextY
                    opacity = 1
                    items.tuxCanMove = true
                }
            }

            Behavior on opacity { NumberAnimation { duration: 500 } }
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
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig)
            }
        }

        Image {
            id: clock
            anchors {
                right: parent.right
                bottom: parent.bottom
                margins: 10
            }
            sourceSize.width: 66 * bar.barZoom
            property int remainingLife: items.clockPosition
            onRemainingLifeChanged: if(remainingLife >= 0) clockAnim.restart()

            SequentialAnimation {
                id: clockAnim
                alwaysRunToEnd: true
                ParallelAnimation {
                    NumberAnimation {
                        target: clock; properties: "opacity";
                        to: 0; duration: 800; easing.type: Easing.OutCubic
                    }
                    NumberAnimation {
                        target: clock; properties: "rotation"; from: 0; to: 180;
                        duration: 800; easing.type: Easing.OutCubic
                    }
                }
                PropertyAction {
                    target: clock; property: 'source';
                    value: items.resourceUrl + "flower" + items.clockPosition + ".svg"
                }
                ParallelAnimation {
                    NumberAnimation {
                        target: clock; properties: "opacity";
                        to: 1; duration: 800; easing.type: Easing.OutCubic
                    }
                    NumberAnimation {
                        target: clock; properties: "rotation"; from: 180; to: 0;
                        duration: 800; easing.type: Easing.OutCubic
                    }
                }
            }
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo

            onClose: {
                home()
            }
            onSaveData: {
                levelFolder = dialogActivityConfig.chosenLevels
                currentActivity.currentLevels = dialogActivityConfig.chosenLevels
                ApplicationSettings.setCurrentLevels(currentActivity.name, dialogActivityConfig.chosenLevels)
            }
            onLoadData: {
                if(activityData && activityData["mode"]) {
                    items.mode = activityData["mode"];
                }
            }
            onStartActivity: {
                background.stop()
                background.start()
            }
        }

        ChooseDiceBar {
            id: chooseDiceBar
            mode: items.mode
            anchors.horizontalCenter: items.background.horizontalCenter
            y: items.heightBase * 2
            audioEffects: activity.audioEffects
        }

        Bonus {
            id: bonus
            winSound: "qrc:/gcompris/src/activities/ballcatch/resource/tuxok.wav"
            looseSound: "qrc:/gcompris/src/activities/ballcatch/resource/youcannot.wav"
            onWin: Activity.nextLevel()
            onLoose: Activity.initLevel()
        }
    }
}
