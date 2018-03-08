/* gcompris - Plane.qml

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
 along with this program; if not, see <https://www.gnu.org/licenses/>.
*/
import QtQuick 2.6
import "planegame.js" as Activity
import GCompris 1.0

Image {
    id: plane

    property Item background
    property real velocityX
    property real velocityY

    source: Activity.url + "resource/tuxhelico.svg"
    fillMode: Image.PreserveAspectFit

    sourceSize.height: 80 * ApplicationInfo.ratio

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
                x: 20
                y: parent.height / 2 - plane.height / 2
                velocityX: 200
                velocityY: 200
                height: sourceSize.height * (1.0 - 0.5 * Activity.currentLevel / 10)
            }
        }
    ]

    Behavior on x {
        SmoothedAnimation {
            velocity: velocityX * ApplicationInfo.ratio
            reversingMode: SmoothedAnimation.Immediate
        }
    }
    Behavior on y {
        SmoothedAnimation {
            velocity: velocityY * ApplicationInfo.ratio
            reversingMode: SmoothedAnimation.Immediate
        }
    }
    Behavior on height { PropertyAnimation { duration: 100 } }
    Behavior on rotation { PropertyAnimation { duration: 100 } }
}
