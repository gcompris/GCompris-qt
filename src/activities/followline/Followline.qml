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
import core 1.0

import "../../core"
import "followline.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: activityBackground
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
            property alias activityBackground: activityBackground
            property alias waterSound: waterSound
            property alias darkenSound: darkenSound
            property alias fireman: fireman
            property alias lineArea: lineArea
            property alias fire: fire
            property alias lineBrokenTimer: lineBrokenTimer
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property int currentLock: 0
            property int lastLock: 0
            property bool verticalLayout: lineArea.height > lineArea.width
            property bool inputBlocked: false
        }

        onHeightChanged: Activity.initLevel()
        onWidthChanged: Activity.initLevel()

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        GCSoundEffect {
            id: waterSound
            source: "qrc:/gcompris/src/core/resource/sounds/water.wav"
        }

        GCSoundEffect {
            id: darkenSound
            source: "qrc:/gcompris/src/core/resource/sounds/darken.wav"
        }

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
            items.inputBlocked = true
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
            onPositionChanged: {
                Activity.movedOut = true;
                if(items.currentLock > 0 && !items.inputBlocked) {
                    lineBrokenTimer.start();
                }
            }
        }

        MultiPointTouchArea {
            anchors.fill: parent
            maximumTouchPoints: 1
            enabled: ApplicationInfo.isMobile && !items.inputBlocked
            onTouchUpdated: (touchPoints) => {
                for(var i in touchPoints) {
                    var touch = touchPoints[i]
                    var part = lineArea.childAt(touch.x - lineArea.x, touch.y - lineArea.y)
                    if(part && part.isPart) {
                        if(items.currentLock <= part.index && !Activity.movedOut) {
                            items.currentLock = part.index
                            if(items.currentLock >= items.lastLock) {
                                activityBackground.win()
                                waterSound.play()
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
            onReleased: {
                Activity.movedOut = true;
                if(!items.inputBlocked) {
                    lineBrokenTimer.start();
                }
            }
        }

        Item {
            id: lineArea
            anchors.top: fireman.top
            anchors.left: fireman.right
            anchors.bottom: fire.top
            anchors.right: fire.left
        }

        Timer {
            id: lineBrokenTimer
            interval: 20
            onTriggered: {
                if(items.currentLock > 0 && !items.inputBlocked) {
                    Activity.cursorMovedOut();
                    restart();
                }
            }
        }
    }

}
