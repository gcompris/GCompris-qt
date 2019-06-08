/* GCompris - ReverseCount.qml
 *
 * Copyright (C) 2014 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Emmanuel Charruau <echarruau@gmail.com> (Qt Quick port)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Major rework)
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

import "../../core"
import "reversecount.js" as Activity


ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: "#ff00a4b0"

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
            property var levels: activity.datasetLoader.item.data
            property alias background: background
            property alias backgroundImg: backgroundImg
            property alias bar: bar
            property alias bonus: bonus
            property alias chooseDiceBar: chooseDiceBar
            property alias tux: tux
            property alias fishToReach: fishToReach
            property int clockPosition: 4
            property string mode: "dot"
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Keys.onEnterPressed: Activity.moveTux()
        Keys.onReturnPressed: Activity.moveTux()

        onWidthChanged: {
            if(Activity.fishIndex > 0) {
                // set x
                fishToReach.x = Activity.iceBlocksLayout[Activity.fishIndex % Activity.iceBlocksLayout.length][0] *
            background.width / 5 + (background.width / 5 - tux.width) / 2
                // set y
                fishToReach.y = Activity.iceBlocksLayout[Activity.fishIndex % Activity.iceBlocksLayout.length][1] *
            (background.height - background.height/5) / 5 +
            (background.height / 5 - tux.height) / 2
                // Move Tux
                Activity.moveTuxToIceBlock()
            }
        }

        onHeightChanged: {
            if(Activity.fishIndex > 0) {
                // set x
                fishToReach.x = Activity.iceBlocksLayout[Activity.fishIndex % Activity.iceBlocksLayout.length][0] *
            background.width / 5 + (background.width / 5 - tux.width) / 2
                // set y
                fishToReach.y = Activity.iceBlocksLayout[Activity.fishIndex % Activity.iceBlocksLayout.length][1] *
            (background.height - background.height/5) / 5 +
            (background.height / 5 - tux.height) / 2
                // Move Tux
                Activity.moveTuxToIceBlock()
            }
        }

        Image {
            id: backgroundImg
            source: activity.resourceUrl + Activity.backgrounds[0]
            sourceSize.height: parent.height * 0.5
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }

        // === The ice blocks ===
        Repeater {
            model: Activity.iceBlocksLayout

            Image {
                x: modelData[0] * background.width / 5
                y: modelData[1] * (background.height- background.height/5) / 5
                width: background.width / 5
                height: background.height / 5
                source: activity.resourceUrl + "iceblock.svg"
            }
        }


        Tux {
            id: tux
            sourceSize.width: Math.min(background.width / 6, background.height / 6)
            z: 11
        }


        Image {
            id: fishToReach
            sourceSize.width: Math.min(background.width / 6, background.height / 6)
            z: 10
            property string nextSource
            property int nextX
            property int nextY

            function showParticles() {
                particles.burst(40)
            }

            ParticleSystemStarLoader {
                id: particles
                clip: false
            }

            onOpacityChanged: { if(opacity == 0) { source = ""; source = nextSource; } }

            onSourceChanged: {
                if(source != "") {
                    x = nextX
                    y = nextY
                    opacity = 1
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
                    value: activity.resourceUrl + "flower" + items.clockPosition + ".svg"
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
                levelFolder = dialogActivityConfig.chosenLevel
                currentActivity.currentLevel = dialogActivityConfig.chosenLevel
                ApplicationSettings.setCurrentLevel(currentActivity.name, dialogActivityConfig.chosenLevel)
                home()
            }
            onLoadData: {
                if(activityData && activityData["mode"]) {
                    items.mode = activityData["mode"];
                }
            }
            onStartActivity: {
                background.start()
            }
        }

        ChooseDiceBar {
            id: chooseDiceBar
            mode: items.mode
            x: background.width / 5 + 20
            y: (background.height - background.height/5) * 3 / 5
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
