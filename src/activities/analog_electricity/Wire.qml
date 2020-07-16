/* GCompris - Wire.qml
 *
 * Copyright (C) 2020 Aiswarya Kaitheri Kandoth <aiswaryakk29@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitnsit@gmail.com> (Qt Quick port)
 *   Aiswarya Kaitheri Kandoth <aiswaryakk29@gmail.com> (AnalogElectricity activity)
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

import "analog_electricity.js" as Activity

Rectangle {
    id: wire

    property QtObject node1
    property QtObject node2
    property bool destructible

    height: 5 * ApplicationInfo.ratio
    color: Activity.wireColors[node1.colorIndex]
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
                Activity.removeWire(wire);
            }
        }
    }
}
