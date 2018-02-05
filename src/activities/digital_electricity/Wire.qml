/* GCompris - Wire.qml
 *
 * Copyright (C) 2016 Pulkit Gupta <pulkitnsit@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitnsit@gmail.com> (Qt Quick port)
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
import GCompris 1.0

import "digital_electricity.js" as Activity

Rectangle {
    id: wire

    property QtObject from
    property QtObject to
    property bool destructible

    height: 5
    color: from.value == 0 ? "red" : "green"
    radius: height / 2
    transformOrigin: Item.Left

    MouseArea {
        id: mouseArea
        enabled: destructible
        width: parent.width
        height: parent.height * 3
        anchors.centerIn: parent
        onPressed: {
            if(Activity.toolDelete) {
                Activity.removeWire(wire)
            }
        }
    }
}
