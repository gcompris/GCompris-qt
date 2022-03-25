/* GCompris - Tux.qml
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import "path.js" as Activity
import GCompris 1.0

Image {
    id: tux

    source: "qrc:/gcompris/src/activities/maze/resource/tux_top_south.svg"
    fillMode: Image.PreserveAspectFit
    sourceSize.width: width

    z: 10

    property int duration: 1000
    property bool animationEnabled: true
    property bool isAnimationRunning: xAnimation.running || yAnimation.running || rAnimation.running

    // values: UP, DOWN, LEFT, RIGHT
    property string direction
    rotation: [Activity.Directions.DOWN, Activity.Directions.LEFT, Activity.Directions.UP, Activity.Directions.RIGHT].indexOf(direction) * 90

    signal init(string initialDirection)

    onInit: {
        animationEnabled = false
        direction = initialDirection
        Activity.moveTuxToBlock()
        animationEnabled = true
    }

    Behavior on x {
        enabled: animationEnabled
        SmoothedAnimation {
            id: xAnimation
            reversingMode: SmoothedAnimation.Immediate
            duration: tux.duration
        }
    }
    Behavior on y {
        enabled: animationEnabled
        SmoothedAnimation {
            id: yAnimation
            reversingMode: SmoothedAnimation.Immediate
            duration: tux.duration
        }
    }
    Behavior on rotation {
        enabled: animationEnabled
        RotationAnimation {
            id: rAnimation
            duration: tux.duration / 4
            direction: RotationAnimation.Shortest
        }
    }

}
