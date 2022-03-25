/* GCompris - ItemToEnumerate.qml
*
* SPDX-FileCopyrightText: 2014 Thib ROMAIN <thibrom@gmail.com>
*
* Authors:
*   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
*   Thib ROMAIN <thibrom@gmail.com> (Qt Quick port)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12
import GCompris 1.0
import "enumerate.js" as Activity

Image {
    sourceSize.width: Math.min(90 * ApplicationInfo.ratio, main.width / 5)
    fillMode: Image.PreserveAspectFit
    z: 0
    // Let the items comes from random side of the screen
    x: Math.random() > 0.5 ? -width : main.width
    y: Math.random() > 0.5 ? -height : main.height

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
    Drag.hotSpot.x: width / 2
    Drag.hotSpot.y: height / 2

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
        PropertyAnimation {
            duration: 2000
            easing.type: Easing.InOutQuad
        }
    }
    Behavior on y {
        PropertyAnimation {
            duration: 2000
            easing.type: Easing.InOutQuad
        }
    }
}
