/* gcompris - Plane.qml

 Copyright (C)
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
import QtQuick 2.2
import "planegame.js" as Activity
import GCompris 1.0

Image {
    id: plane

    property Item background
    property real velocityX
    property real velocityY

    source: "qrc:/gcompris/src/activities/planegame/resource/tuxhelico.svgz"
    fillMode: Image.PreserveAspectFit

    sourceSize.height: 200 * ApplicationInfo.ratio

    z: 10

    states: [
        State {
            name: "init"
            PropertyChanges {
                target: plane
                x: 20
                y: parent.height / 2 - plane.height / 2
                velocityX: 700
                velocityY: 700
                height: sourceSize.height * (1.0 - 0.5 * Activity.currentLevel / 10)
            }
        },
        State {
            name: "play"
            PropertyChanges {
                target: plane
                height: sourceSize.height * (1.0 - 0.5 * Activity.currentLevel / 10)
            }
        }
    ]

    Behavior on x {
        SmoothedAnimation {
            velocity: Math.abs(velocityX) * ApplicationInfo.ratio
            reversingMode: SmoothedAnimation.Immediate
        }
    }
    Behavior on y {
        SmoothedAnimation {
            velocity: Math.abs(velocityY) * ApplicationInfo.ratio
            reversingMode: SmoothedAnimation.Immediate
        }
    }
    Behavior on height { PropertyAnimation { duration: 100 } }

    onVelocityXChanged: {
        if(plane.state == "play") {
            if(rotate.angle == 0 && velocityX < 0)
                rotation = velocityX * 15 / Activity.max_velocity
            else
                rotation = Math.abs(velocityX) * 15 / Activity.max_velocity
        }
    }

    transform: Rotation {
        id: rotate
        origin { x: width / 2; y: 0 }
        axis { x: 0; y: 1; z: 0 }
        angle: plane.velocityX >= -200 ? 0 : 180

        Behavior on angle { PropertyAnimation { duration: 400 } }
    }

    transitions: Transition {
        RotationAnimation {
            duration: 200;
            direction: RotationAnimation.Shortest
        }
    }

    MultiPointTouchArea {
        anchors.fill: parent
        touchPoints: [ TouchPoint { id: point1 } ]

        onReleased: {
            var pStart = plane.mapFromItem(null, point1.startX, point1.startY)
            var pEnd = plane.mapFromItem(null, point1.x, point1.y)
            velocityX = (pEnd.x - pStart.x) / ApplicationInfo.ratio
            if(velocityX > 0)
                velocityX = Math.min(velocityX, Activity.max_velocity)
            else if(velocityX < 0)
                velocityX = Math.max(velocityX, -Activity.max_velocity)

            velocityY = (pEnd.y - pStart.y) / ApplicationInfo.ratio
            if(velocityY > 0)
                velocityY = Math.min(velocityY, Activity.max_velocity)
            else if(velocityY < 0)
                velocityY = Math.max(velocityY, -Activity.max_velocity)

            if(Math.abs(velocityX) < 10) velocityX = 0
            if(Math.abs(velocityY) < 10) velocityY = 0
        }
    }
}
