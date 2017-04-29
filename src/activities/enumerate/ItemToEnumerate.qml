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
import QtQuick 2.6
import GCompris 1.0
import "enumerate.js" as Activity

Image {
    sourceSize.width: 90 * ApplicationInfo.ratio
    fillMode : Image.PreserveAspectFit
    z: 0
    // Let the items comes from random side of the screen
    x: Math.random() > 0.5 ? - width : main.width
    y: Math.random() > 0.5 ? - height : main.height

    property real xRatio
    property real yRatio
    property Item main

    Component.onCompleted: {        
        xRatio = Activity.getRandomInt(10, main.width - 220 * ApplicationInfo.ratio) /
                (main.width  - 220 * ApplicationInfo.ratio)
        yRatio = Activity.getRandomInt(10, main.height - 180 * ApplicationInfo.ratio) /
                (main.height - 180 * ApplicationInfo.ratio)
        positionMe()
    }

    function positionMe() {
        x = (main.width - 220 * ApplicationInfo.ratio) * xRatio
        y = (main.height- 180 * ApplicationInfo.ratio) * yRatio
    }

    Drag.active: dragArea.drag.active
    Drag.hotSpot.x : width / 2
    Drag.hotSpot.y : height / 2

    MouseArea {
        id: dragArea
        anchors.fill: parent
        drag.target: parent
        onPressed: {
            parent.z = ++Activity.globalZ
        }
        onReleased: parent.Drag.drop()
    }

    Behavior on x {
        PropertyAnimation  {
            duration: 2000
            easing.type: Easing.InOutQuad
        }
    }
    Behavior on y {
        PropertyAnimation  {
            duration: 2000
            easing.type: Easing.InOutQuad
        }
    }
}
