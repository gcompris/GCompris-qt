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
import QtQuick
import core 1.0

import "../../core"
import "reversecount.js" as Activity


ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: activityBackground
        anchors.fill: parent
        color: "#1dade4"

        signal start
        signal stop

        readonly property bool horizontalLayout: layoutArea.width >= layoutArea.height

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias goodAnswerSound: goodAnswerSound
            property alias badAnswerSound: badAnswerSound
            property alias walkSound: walkSound
            readonly property string resourceUrl: activity.resourceUrl
            readonly property var levels: activity.datasets
            property alias activityBackground: activityBackground
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias chooseDiceBar: chooseDiceBar
            property alias tux: tux
            property alias fishToReach: fishToReach
            property int clockPosition: 4
            property string mode: "dot"
            property double heightBase: (activityBackground.horizontalLayout ? layoutArea.height : layoutArea.height - clock.height - GCStyle.baseMargins) * 0.2
            property double widthBase: (activityBackground.horizontalLayout ? layoutArea.width - clock.height - GCStyle.baseMargins : layoutArea.width) * 0.2
            property bool tuxIsMoving: false
            property bool tuxCanMove: true
            property alias client: client
        }

        onStart: { Activity.start(items) }
        onStop: {
            sizeChangedTimer.stop()
            Activity.stop()
        }

        Client {    // Client for server version. Prepare data from activity to server
            id: client
            getDataCallback: function() {
                var data = {
                    "index": Activity.fishIndex,
                    "currentPosition": Activity.tuxIceBlockNumber,
                    "dice1": chooseDiceBar.value1,
                    "dice2": chooseDiceBar.value2,
                }
                return data
            }
        }

        Keys.onEnterPressed: chooseDiceBar.click()
        Keys.onReturnPressed: chooseDiceBar.click()

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

        GCSoundEffect {
            id: goodAnswerSound
            source: "qrc:/gcompris/src/activities/gnumch-equality/resource/eat.wav"
        }

        GCSoundEffect {
            id: badAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/darken.wav"
        }

        GCSoundEffect {
            id: walkSound
            source: items.resourceUrl + "icy_walk.wav"
        }

        Timer {
            id: sizeChangedTimer
            interval: 100
            onTriggered: replaceItems()
        }

        Item {
            id: layoutArea
            anchors.fill: parent
            anchors.margins: GCStyle.baseMargins
            anchors.bottomMargin: bar.height * 1.2

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
                bottom: bar.top
                margins: GCStyle.baseMargins
            }
            width: 66 * ApplicationInfo.ratio
            height: width
            sourceSize.width: width
            sourceSize.height: width
            property int remainingLife: items.clockPosition
            onRemainingLifeChanged: {
                if(remainingLife >= 0) {
                    petalCount = items.resourceUrl + "flower" + remainingLife + ".svg"
                    clockAnim.restart()
                }
            }

            property string petalCount

            SequentialAnimation {
                id: clockAnim
                alwaysRunToEnd: true
                ParallelAnimation {
                    ScriptAction {
                        script: items.tuxCanMove = false;
                    }
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
                    value: clock.petalCount
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
                    ScriptAction {
                        script: items.tuxCanMove = true;
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
                activityBackground.stop()
                activityBackground.start()
            }
        }

        ChooseDiceBar {
            id: chooseDiceBar
            mode: items.mode
            anchors.centerIn: layoutArea
            anchors.verticalCenterOffset: activityBackground.horizontalLayout ? 0 : (-clock.height - GCStyle.baseMargins) * 0.5
            anchors.horizontalCenterOffset: activityBackground.horizontalLayout ? (-clock.width - GCStyle.baseMargins) * 0.5 : 0
            y: items.heightBase * 2
            width: items.widthBase * 3
            height: items.heightBase * 3
            enabled: items.tuxCanMove && !bonus.isPlaying
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
