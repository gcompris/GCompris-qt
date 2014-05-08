/* GCompris - ItemToEnumerate.qml
*
* Copyright (C) 2014 Thib ROMAIN <thibrom@gmail.com>
*
* Authors:
*   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
*   Thib ROMAIN <thibrom@gmail.com> (Qt Quick port)
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
import QtQuick 2.0
import "enumerate.js" as Activity

Item {
    height: 100
    width: 100
    z: 0
    x: Activity.getRandomInt(10, main.width - 220)
    y: Activity.getRandomInt(10, main.height - 150)

    property string imgPath
    property int type: 0
    property Item main

    Image {
        id: img
        source: imgPath
        width: Math.min(100, main.width / 6)
        fillMode : Image.PreserveAspectFit
    }

    Drag.active: dragArea.drag.active
    Drag.hotSpot.x : 10
    Drag.hotSpot.y : 10

    MouseArea {
        id: dragArea
        anchors.fill: parent
        drag.target: parent
        onPressed: {
            parent.z = ++Activity.globalZ
        }
        onReleased: parent.Drag.drop()
    }
}
