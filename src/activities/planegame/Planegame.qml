/* gcompris - Planegame.qml

 Copyright (C) 2014 Johnny Jazeix <jazeix@gmail.com>

 2003, 2014: Bruno Coudoin: initial version
 2014: Johnny Jazeix: Qt port

 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.6
import GCompris 1.0

import "../../core"
import "planegame.js" as Activity

ActivityBase {
    id: activity
    focus: true

    onStart: { focus = true; }
    onStop: { }

    Keys.onPressed: Activity.processPressedKey(event)
    Keys.onReleased: Activity.processReleasedKey(event)

    property var dataset

    property int oldWidth: width
    onWidthChanged: {
        // Reposition helico and clouds, same for height
        Activity.repositionObjectsOnWidthChanged(width / oldWidth)
        oldWidth = width
    }

    property int oldHeight: height
    onHeightChanged: {
        // Reposition helico and clouds, same for height
        Activity.repositionObjectsOnHeightChanged(height / oldHeight)
        oldHeight = height
    }

    pageComponent: Image {
        id: background
        anchors.fill: parent
        signal start
        signal stop
        source: Activity.url + "../algorithm/resource/desert_scene.svg"
        sourceSize.width: parent.width

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }
        QtObject {
            id: items
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias score: score
            property alias plane: plane
            property GCAudio audioVoices: activity.audioVoices
            property GCSfx audioEffects: activity.audioEffects
            property alias movePlaneTimer: movePlaneTimer
            property alias cloudCreation: cloudCreation
        }
        onStart: Activity.start(items, dataset)
        onStop: Activity.stop();

        MultiPointTouchArea {
            anchors.fill: parent
            touchPoints: [ TouchPoint { id: point1 } ]

            onReleased: {
                plane.x = point1.x - plane.width / 2
                plane.y = point1.y - plane.height / 2
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: displayDialog(dialogHelp)
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }

        Score {
            id: score
            visible: false
            fontSize: 24
        }

        property int movePlaneTimerCounter: 0
        Timer {
            id: movePlaneTimer
            running: false
            repeat: true
            onTriggered: {
                plane.state = "play"
                interval = 50
                if(movePlaneTimerCounter++ % 3 == 0) {
                    /* Do not call this too often or plane commands are too hard */
                    Activity.handleCollisionsWithCloud();
                }
                Activity.computeVelocity();
                Activity.planeMove();
            }
        }

        Timer {
            id: cloudCreation
            running: false
            repeat: true
            interval: 10200 - (bar.level * 200)
            onTriggered: Activity.createCloud()
        }

        Plane {
            id: plane
            background: background
        }

    }
}
