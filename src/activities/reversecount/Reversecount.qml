/* GCompris - ReverseCount.qml
 *
 * Copyright (C) 2014 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Emmanuel Charruau <echarruau@gmail.com> (Qt Quick port)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Major rework)
 *   Timothée Giet <animtim@gcompris.net> (Layout and graphics rework)
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
        color: "#ff1dade4"

        signal start
        signal stop

        Component.onCompleted: {
            dialogActivityConfig.getInitialConfiguration()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property GCSfx audioEffects: activity.audioEffects
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias chooseDiceBar: chooseDiceBar
            property alias tux: tux
            property alias fishToReach: fishToReach
            property int clockPosition: 4
            property string mode: "dot"
            property var heightBase: (background.height - bar.height * 1.5) / 5
            property var widthBase: background.width / 5
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Keys.onEnterPressed: Activity.moveTux()
        Keys.onReturnPressed: Activity.moveTux()

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
                source: Activity.url + "ice-block.svg"
            }
        }


        Tux {
            id: tux
            sourceSize.width: Math.min(items.widthBase, items.heightBase)
            z: 11
        }


        Image {
            id: fishToReach
            source: Activity.url + "fish-blue.svg"
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
            content: BarEnumContent { value: help | home | level | config }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onConfigClicked: {
                dialogActivityConfig.active = true
                dialogActivityConfig.setDefaultValues()
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
                    value: "qrc:/gcompris/src/activities/reversecount/resource/" +
                           "flower" + items.clockPosition + ".svg"
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

        DialogActivityConfig {
            id: dialogActivityConfig
            currentActivity: activity
            content: Component {
                Item {
                    property alias modeBox: modeBox
                    property var availableModes: [
                        { "text": qsTr("Dots"), "value": "dot" },
                        { "text": qsTr("Arabic numbers"), "value": "number" },
                        { "text": qsTr("Roman numbers"), "value": "roman" },
                        { "text": qsTr("Images"), "value": "image" }
                    ]
                    Flow {
                        id: flow
                        spacing: 5
                        width: dialogActivityConfig.width
                        GCComboBox {
                            id: modeBox
                            model: availableModes
                            background: dialogActivityConfig
                            label: qsTr("Select Domino Representation")
                        }
                    }
                }
            }
            onClose: home()
            onLoadData: {
                if(dataToSave && dataToSave["mode"]) {
                    items.mode = dataToSave["mode"];
                }
            }
            onSaveData: {
                var newMode = dialogActivityConfig.configItem.availableModes[dialogActivityConfig.configItem.modeBox.currentIndex].value;
                if (newMode !== items.mode) {
                    items.mode = newMode;
                    dataToSave = {"mode": items.mode};
                }
                Activity.initLevel();
            }
            function setDefaultValues() {
                for(var i = 0 ; i < dialogActivityConfig.configItem.availableModes.length ; i++) {
                    if(dialogActivityConfig.configItem.availableModes[i].value === items.mode) {
                        dialogActivityConfig.configItem.modeBox.currentIndex = i;
                        break;
                    }
                }
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
