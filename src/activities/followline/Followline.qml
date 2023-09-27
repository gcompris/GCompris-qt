/* GCompris - FollowLine.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (Gameplay refactoring and improvements)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "followline.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        source: Activity.url + "background.svg"
        fillMode: Image.PreserveAspectCrop
        sourceSize.width: width
        sourceSize.height: height

        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property alias background: background
            property GCSfx audioEffects: activity.audioEffects
            property alias fireman: fireman
            property alias lineArea: lineArea
            property alias fire: fire
            property alias lineBrokenTimer: lineBrokenTimer
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property int currentLock: 0
            property int lastLock: 0
            property bool verticalLayout: lineArea.height > lineArea.width
        }

        onHeightChanged: Activity.initLevel()
        onWidthChanged: Activity.initLevel()

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Image {
            id: fireman
            source: Activity.url + "fireman.svg"
            sourceSize.width: 182 * ApplicationInfo.ratio
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: - height / 10
            }
        }

        Image {
            id: fire
            source: Activity.url + "fire.svg"
            sourceSize.width: 90 * ApplicationInfo.ratio
            anchors {
                right: parent.right
                bottom: bar.top
            }

            Image {
                id: fireflame
                source: Activity.url + "fire_flame.svg"
                sourceSize.width: 90 * ApplicationInfo.ratio
                anchors {
                    fill: parent
                }
                Behavior on opacity { NumberAnimation { duration: 2000 } }
                onOpacityChanged: if(opacity == 0) Activity.nextLevel()
            }
        }

        Image {
            id: water
            source: Activity.url + "water_spot.svg"
            sourceSize.width: 148 * ApplicationInfo.ratio
            z: 200
            opacity: 0
            anchors {
                right: parent.right
                bottom: fire.top
                bottomMargin: - fire.height / 2
            }
            Behavior on opacity { NumberAnimation { duration: 500 } }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        function win() {
            fireflame.opacity = 0
            water.opacity = 1
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: displayDialog(dialogHelp)
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onLevelChanged: {
                fireflame.opacity = 1
                water.opacity = 0
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }

        MouseArea {
            anchors.fill: parent
            enabled: !ApplicationInfo.isMobile
            hoverEnabled: true
            onPositionChanged: items.currentLock > 0 && water.opacity === 0 ?
                                   lineBrokenTimer.start() : false
        }

        Item {
            id: lineArea
            anchors.top: fireman.top
            anchors.left: fireman.right
            anchors.bottom: fire.top
            anchors.right: fire.left

            MultiPointTouchArea {
                anchors.fill: parent
                maximumTouchPoints: 1
                enabled: ApplicationInfo.isMobile && water.opacity === 0
                z: 1000
                onTouchUpdated: {
                    for(var i in touchPoints) {
                        var touch = touchPoints[i]
                        var part = lineArea.childAt(touch.x, touch.y)
                        if(part && part.isPart) {
                            if(items.currentLock <= part.index && !Activity.movedOut) {
                                items.currentLock = part.index
                                if(items.currentLock >= items.lastLock) {
                                    background.win()
                                    activity.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/water.wav")
                                } else {
                                    Activity.playAudioFx()
                                }
                            } else if(items.currentLock >= part.index && Activity.movedOut) {
                                lineBrokenTimer.stop();
                                Activity.movedOut = false;
                            }
                        } else {
                            lineBrokenTimer.start()
                        }
                    }
                }
                onReleased: if(water.opacity === 0) lineBrokenTimer.start()
            }
        }

        Timer {
            id: lineBrokenTimer
            interval: 20
            onTriggered: {
                if(items.currentLock > 0 && water.opacity === 0) {
                    Activity.cursorMovedOut();
                    restart();
                }
            }
        }
    }

}
