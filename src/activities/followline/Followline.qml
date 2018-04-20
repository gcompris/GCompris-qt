/* GCompris - FollowLine.qml
 *
 * Copyright (C) 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
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
        sourceSize.width: Math.max(parent.width, parent.height)

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
            property alias fire: fire
            property alias bar: bar
            property alias bonus: bonus
            property int currentLock: 0
            property int lastLock: 0
        }

        onHeightChanged: Activity.initLevel()

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

        MultiPointTouchArea {
            anchors.fill: parent
            maximumTouchPoints: 1
            z: 1000
            onTouchUpdated: {
                for(var i in touchPoints) {
                    var touch = touchPoints[i]
                    var part = background.childAt(touch.x, touch.y)
                    if(part) {
                        if(items.currentLock == part.index) {
                            items.currentLock++
                            if(items.currentLock == items.lastLock) {
                                background.win()
                                activity.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/water.wav")
                            } else {
                                activity.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/darken.wav")
                            }
                        }
                    }
                }
            }
        }

        Bar {
            id: bar
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
            onPositionChanged: items.currentLock > 0 && fireflame.opacity == 1 ?
                                   items.currentLock-- : false
        }

    }

}
