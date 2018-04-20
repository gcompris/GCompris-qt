/* GCompris - Hat.qml
 *
 * Copyright (C) 2014 Thibaut ROMAIN <thibrom@gmail.com>
 *
 * Authors:
 *   Thibaut ROMAIN <thibrom@gmail.com>
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

import "../../core"
import "magic-hat.js" as Activity

Item {
    id: hatItem
    width: parent.width
    height: parent.height
    property alias state: hatImg.state
    property alias target: offStar
    property int starsSize
    property GCSfx audioEffects

    function getTarget() {
        return offStar
    }

    Image {
        id: hatImg
        source: Activity.url + "hat.svg"
        sourceSize.width: hatItem.width / 3
        fillMode: Image.PreserveAspectFit
        anchors.centerIn: parent
        state: "NormalPosition"

        transform: Rotation {
            id: rotate
            origin.x: 0
            origin.y: hatImg.height
            axis.x: 0
            axis.y: 0
            axis.z: 1
            Behavior on angle {
                animation: rotAnim
            }
        }

        states: [
            State {
                name: "NormalPosition"
                PropertyChanges {
                    target: rotate
                    angle: 0
                }
            },
            State {
                name: "Rotated"
                PropertyChanges {
                    target: rotate
                    angle: -45
                }
            },
            State {
                name: "GuessNumber"
                PropertyChanges{
                    target: hatImg
                    source: Activity.url + "hat-point.svg"
                }
                PropertyChanges {
                    target: rotate
                    angle: 0
                }
            }
        ]

     }

    RotationAnimation {
                id: rotAnim
                direction: hatImg.state == "Rotated" ?
                               RotationAnimation.Counterclockwise :
                               RotationAnimation.Clockwise
                duration: 500
                onRunningChanged: if(!rotAnim.running && hatImg.state == "Rotated") {
                        Activity.moveStarsUnderHat()
                    }
    }

    MouseArea {
        id: hatMouseArea
        anchors.fill:hatImg
        onClicked: {
            if(hatImg.state == "NormalPosition")
                hatImg.state = "Rotated"
        }
    }

    // The target for the moving stars
    Item {
        id: offStar
        height: hatItem.starsSize
        width: hatItem.starsSize
        y: hatImg.y + hatImg.paintedHeight - height
        anchors {
            horizontalCenter: parent.horizontalCenter
        }

        z: hatImg.z - 1
    }
}
