/* GCompris - followline.qml
 *
 * Copyright (C) 2014 Bruno Coudoin
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
import QtQuick 2.1
import QtQuick.Controls 1.0
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
        sourceSize.width: parent.width

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
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias currentLock: hose.currentLock
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Image {
            id: fireman
            source: Activity.url + "fireman.svg"
            sourceSize.width: 182 * ApplicationInfo.ratio
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: height / 4
            }
        }

        Image {
            id: fire
            source: Activity.url + "fire.svg"
            sourceSize.width: 126 * ApplicationInfo.ratio
            anchors {
                right: parent.right
                bottom: bar.top
            }

            Image {
                id: fireflame
                source: Activity.url + "fire_flame.svg"
                sourceSize.width: 126 * ApplicationInfo.ratio
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

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | previous | next }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
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
            onPositionChanged: hose.currentLock > 0 && fireflame.opacity == 1 ?
                                   hose.currentLock-- : false
        }

        function win() {
            fireflame.opacity = 0
            water.opacity = 1
        }

        MultiPointTouchArea {
            anchors.fill: parent
            enabled: ApplicationInfo.isMobile
            maximumTouchPoints: 1
            onTouchUpdated: {
                for(var i in touchPoints) {
                    var touch = touchPoints[i]
                    var part = background.childAt(touch.x, touch.y)
                    if(part) {
                        if(part.i >= 0) {
                            if(hose.currentLock == part.i)
                                hose.currentLock++
                            if(hose.itemAt(hose.currentLock).opacity == 0) {
                                background.win()
                            }
                        } else {
                            hose.currentLock > 0 && fireflame.opacity == 1 ?
                                        hose.currentLock-- : false
                        }
                    }
                }
            }
        }

        Repeater {
            id: hose
            // We create more items than needed because
            // we don't know how much we really need
            model: Math.floor((activity.width - fireman.width - fire.width) / partWidth) * 4
            anchors.left: fireman.right

            property int partWidth: 50 * ApplicationInfo.ratio
            property int period: 50 / 2
            property int currentLock: 0
            property double initX: fireman.x + fireman.width

            Image {
                source: index == hose.currentLock ?
                            Activity.url + "hose_lock.svg" :
                            index < hose.currentLock ?
                                Activity.url + "hose_water.svg" :
                                Activity.url + "hose_part.svg"
                sourceSize.width: hose.partWidth
                height: (50 + 5 * 8 / bar.level) * ApplicationInfo.ratio
                // Do not display items when we reach the right target
                opacity: x > fire.x ? 0 : 1

                parent: background
                x: getX()
                y: getY()
                z: index == hose.currentLock ? myparent.z + 1 : 100
                transformOrigin: Item.Center
                rotation: getAngleOfLineBetweenTwoPoints(myparent.x, myparent.y, x, y) *
                          (180 / Math.PI)

                property int i: index
                property double rotationRadian: getAngleOfLineBetweenTwoPoints(myparent.x, myparent.y, x, y)
                property Item myparent: (index > 0) ? hose.itemAt(index - 1) : hose

                function getX() {
                    if(index == 0) {
                        return hose.initX
                    }

                    // 0.7 to have overlapping items
                    return myparent.x + width * 0.7 * Math.cos(myparent.rotationRadian)
                }

                function getY() {
                    var Y = fireman.y + height / 2 +
                            Math.cos(((Math.PI * 2 * index) / hose.period)) *
                            20 * ApplicationInfo.ratio * bar.level -
                            20 * ApplicationInfo.ratio * bar.level
                    return Y < 0 ? 0 : Y
                }

                // Determines the angle of a straight line drawn between point one and two.
                // The number returned, which is a float in radian,
                // tells us how much we have to rotate a horizontal line clockwise
                // for it to match the line between the two points.
                function getAngleOfLineBetweenTwoPoints(x1, y1, x2, y2) {
                    if(index == 0)
                        return 0
                    var xDiff = x2 - x1;
                    var yDiff = y2 - y1;
                    return Math.atan2(yDiff, xDiff);
                }

                MouseArea {
                    anchors.fill: parent
                    enabled: !ApplicationInfo.isMobile
                    hoverEnabled: true
                    onEntered: {
                        if(hose.currentLock == index) hose.currentLock++
                        if(hose.itemAt(hose.currentLock).opacity == 0) {
                            background.win()
                        }
                    }
                }

            }
        }
    }

}
