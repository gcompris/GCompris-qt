/* GCompris - wind.qml
 *
 * Copyright (C) 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
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
import "../../core"

Image {
    id: windTurbine
    source: activity.url + "wind/mast.svg"
    sourceSize.width: parent.width * 0.01
    property int duration

    Image {
        id: blade
        source: activity.url + "wind/blade.svg"
        sourceSize.height: parent.height * 1.3
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.top
            verticalCenterOffset: parent.height * 0.06
        }
        
        SequentialAnimation on rotation {
            id: anim
            loops: Animation.Infinite
            running: cloud.started
            NumberAnimation {
                from: 0; to: 360
                duration: windTurbine.duration
            }
        }
    }
}
