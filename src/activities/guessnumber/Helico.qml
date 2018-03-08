/* GCompris - guessnumber.qml
 *
 * Copyright (C) 2014 Thib ROMAIN <thibrom@gmail.com>
 *
 * Authors:
 *   Thib ROMAIN <thibrom@gmail.com> (Qt Quick port)
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

Image {
    id: helico
    source: "resource/tuxhelico.svg"
    sourceSize.height: 120 * ApplicationInfo.ratio

    function init() {
        x = 2
        y = parent.height / 2 - height / 2
    }

    Behavior on x {
        PropertyAnimation {
            id: xAnim
            easing.type: Easing.OutQuad
            duration:  1000
        }
    }
    Behavior on y {
        PropertyAnimation {easing.type: Easing.OutQuad; duration:  1000}
    }

    transform: Rotation {
            id: helicoRotation;
            origin.x: helico.width / 2;
            origin.y: helico.height / 2;
            axis { x: 0; y: 0; z: 1 }
            Behavior on angle {
                animation: rotAnim
            }
    }

    states: [
        State {
            name: "horizontal"
            PropertyChanges {
                target: helicoRotation
                angle: 0
            }
        },
        State {
            name: "advancing"
            PropertyChanges {
                target: helicoRotation
                angle: 25
            }
        }
    ]

    RotationAnimation {
                id: rotAnim
                direction: helico.state == "horizontal" ?
                               RotationAnimation.Counterclockwise :
                               RotationAnimation.Clockwise
                duration: 500
                onRunningChanged: if(!rotAnim.running && helico.state == "advancing")
                                      helico.state = "horizontal"
    }
}


