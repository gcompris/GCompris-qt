/* GCompris - Tux.qml
 *
 * SPDX-FileCopyrightText: 2014 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Emmanuel Charruau <echarruau@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import "reversecount.js" as Activity
import GCompris 1.0

Image {
    id: tux

    source: "qrc:/gcompris/src/activities/maze/resource/tux_top_south.svg"
    fillMode: Image.PreserveAspectFit
    z: 10

    property int duration: 1000

    signal init

    onInit: {
       tux.rotation = -90
        Activity.moveTuxToIceBlock()
    }

    Behavior on x {
        SmoothedAnimation {
            reversingMode: SmoothedAnimation.Immediate
            onRunningChanged: Activity.tuxRunningChanged()
            duration: tux.duration
        }
    }
    Behavior on y {
        SmoothedAnimation {
            reversingMode: SmoothedAnimation.Immediate
            onRunningChanged: Activity.tuxRunningChanged()
            duration: tux.duration
        }
    }
    Behavior on rotation {
        RotationAnimation {
            duration: tux.duration / 2
            direction: RotationAnimation.Shortest
        }
    }

}
