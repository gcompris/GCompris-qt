/* GCompris - Tux.qml
 *
 * Copyright (C) 2014 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Emmanuel Charruau <echarruau@gmail.com> (Qt Quick port)
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
import "reversecount.js" as Activity
import GCompris 1.0

Image {
    id: tux

    source: activity.resourceUrl + "tux_top_south.svg"
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
