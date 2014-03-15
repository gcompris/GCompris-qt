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
import QtQuick 2.1
import "planegame.js" as Activity
import GCompris 1.0

Image {
    id: plane

    property Item score
    property Item background
    property int planeVelocity: 50
    property double heightRatio: 1

    source: "qrc:/gcompris/src/activities/planegame/resource/tuxhelico.svgz"
    fillMode: Image.PreserveAspectFit

    sourceSize.height: 200 * ApplicationInfo.ratio
    height: sourceSize.height * ApplicationInfo.ratio * heightRatio

    z: 10

    property int speedX: 0
    property int speedY: 0

    Behavior on x { SmoothedAnimation { velocity: planeVelocity } }
    Behavior on y { SmoothedAnimation { velocity: planeVelocity } }

    onSpeedXChanged: {
        rotation = Math.abs(plane.speedX) * 20 / Activity.max_speed
    }

    // Mirror the plan if it goes to right
    transform: Rotation {
        id: rotate
        origin { x: width / 2; y: 0 }
        axis { x: 0; y: 1; z: 0 }
        angle: plane.speedX >= 0 ? 0 : 180

        Behavior on angle { PropertyAnimation { duration: 400 } }
    }

    transitions: Transition {
        RotationAnimation {
            duration: 200;
            direction: RotationAnimation.Shortest
        }
    }
}
