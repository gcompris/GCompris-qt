/* gcompris - Plane.qml

 SPDX-FileCopyrightText: 2014 Johnny Jazeix <jazeix@gmail.com>

 2003, 2014: Bruno Coudoin: initial version
 2014: Johnny Jazeix: Qt port

 SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12
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
                height: sourceSize.height * (1.0 - 0.5 * Activity.items.currentLevel / 10)
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
                height: sourceSize.height * (1.0 - 0.5 * Activity.items.currentLevel / 10)
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
