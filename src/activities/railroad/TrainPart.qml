/* GCompris - TrainPart.qml
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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.2
import "railroad.js" as Activity
import GCompris 1.0

Image {
    id: trainPart
    width: 236 ; height: 112
    y: background.width/40
    source: Activity.url + "loco1.svg"
    fillMode: Image.PreserveAspectFit
    z: 10



    NumberAnimation on x {
        id: animation
        to: 1300
        duration: 16000
        onRunningChanged: {
            if (!animation.running) {
                trainPart.visible = false
                engines.visible = true
                animation.destroy()
            }
            else{
                engines.visible = false
            }
        }
    }



    MouseArea {
        anchors.fill: trainPart
        onClicked: {
            if(trainPart.visible == true)
                trainPart.visible = false
            engines.visible = true
            animation.destroy()

        }

    }
}

