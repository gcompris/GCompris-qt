/* GCompris - guessnumber.qml
 *
 * SPDX-FileCopyrightText: 2014 Thib ROMAIN <thibrom@gmail.com>
 *
 * Authors:
 *   Thib ROMAIN <thibrom@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

Image {
    id: helico
    source: "qrc:/gcompris/src/activities/planegame/resource/tuxhelico.svg"
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


