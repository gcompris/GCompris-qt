/* gcompris - Plane.qml

 SPDX-FileCopyrightText: 2014 Johnny Jazeix <jazeix@gmail.com>

 2003, 2014: Bruno Coudoin: initial version
 2014: Johnny Jazeix: Qt port

 SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick
import "planegame.js" as Activity
import "../../core"
import core 1.0

Image {
    id: plane

    property real velocityX
    property real velocityY

    source: Activity.url + "resource/tuxhelico.svg"
    fillMode: Image.PreserveAspectFit
    width: height * 1.75
    sourceSize.height: height

    z: 10

    states: [
        State {
            name: "init"
            PropertyChanges {
                plane {
                    x: GCStyle.baseMargins
                    y: (parent.height - plane.height) * 0.5
                    velocityX: 700
                    velocityY: 700
                }
            }
        },
        State {
            name: "play"
            PropertyChanges {
                plane {
                    x: GCStyle.baseMargins
                    y: (parent.height - plane.height) * 0.5
                    velocityX: 200
                    velocityY: 200
                }
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
