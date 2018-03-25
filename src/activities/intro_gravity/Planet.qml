/* GCompris - intro_gravity.qml
*
* Copyright (C) 2015 Siddhesh suthar <siddhesh.it@gmail.com>
*
* Authors:
*   Bruno Coudoin <bruno.coudoin@gcompris.net> and Matilda Bernard (GTK+ version)
*   Siddhesh suthar <siddhesh.it@gmail.com> (Qt Quick port)
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
import "intro_gravity.js" as Activity

Item {
    id: planet
    y: 0

    property string planetSource
    property int planetWidth
    property alias value: planetImg.scale
    property double minimumValue: 0.5
    property double maximumValue: 2.2
    property bool isLeft


    Image {
        id: planetImg
        source: parent.planetSource
        sourceSize.width: parent.planetWidth
        x: parent.isLeft ? slider.x
                         : slider.x + slider.width - planet.planetWidth
        y: background.height / 2 - height / 2

        Behavior on scale {
            NumberAnimation{ duration: 10 }
        }
    }

    Image {
        id: slider
        source: Activity.url + "updown.svg"
        sourceSize.width: 40 * ApplicationInfo.ratio
        x: parent.isLeft ? 20 * ApplicationInfo.ratio :
                         parent.width - slider.width - 20 * ApplicationInfo.ratio
        y: background.height / 2 - height / 2
    }

    MultiPointTouchArea {
        id: touchArea
        anchors.fill: parent
        touchPoints: [ TouchPoint { id: point1 } ]
        property real startX
        property real startY
        property bool started
        property int direction: 0
        
        onStartedChanged: started ? retouch.start() : retouch.stop()

        onPressed: {
            startX = point1.x
            startY = point1.y

            if(startY < parent.height / 2)
                direction = 1
            else
                direction = -1

            move()
            started = true
        }
        
        function move() {
            if(direction < 0 && planet.value > planet.minimumValue)
                planet.value -= 0.1
            else if(direction > 0 && planet.value < planet.maximumValue)
                planet.value += 0.1
        }

        onUpdated: {
            if(!started)
                return false
            var moveX = point1.x - startX
            var moveY = point1.y - startY
            // Find the direction with the most move
            if(Math.abs(moveX) * ApplicationInfo.ratio > 10 &&
                    Math.abs(moveX) > Math.abs(moveY)) {
                if(moveX > 10 * ApplicationInfo.ratio)
                    direction = 1
                else if(moveX < -10 * ApplicationInfo.ratio)
                    direction = -1
            } else if(Math.abs(moveY) * ApplicationInfo.ratio > 10 &&
                      Math.abs(moveX) < Math.abs(moveY)) {
                if(moveY > 10 * ApplicationInfo.ratio)
                    direction = -1
                else if(moveY < -10 * ApplicationInfo.ratio)
                    direction = 1
            }
            move()
        }
        onReleased: started = false
    }
    
    Timer {
        id: retouch
        interval: 10
        repeat: true
        onTriggered: touchArea.started ? touchArea.move() : touchArea.move()
    }
}
