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
    width: Math.min(70 * ApplicationInfo.ratio, Math.min(layoutArea.width, layoutArea.height) * 0.2)
    height: width
    sourceSize.width: width
    sourceSize.height: height
    fillMode: Image.PreserveAspectFit
    z: 0
    // Let the items comes from random side of the screen
    x: Math.random() > 0.5 ? -width : background.width
    y: Math.random() > 0.5 ? -height : background.height

    Component.onCompleted: {        
        positionMe()
    }

    function positionMe() {
        x = Activity.getRandomInt(0, layoutArea.width - width)
        y = Activity.getRandomInt(0 , layoutArea.height - width)
    }

    Drag.active: dragArea.drag.active
    Drag.hotSpot.x: width * 0.5
    Drag.hotSpot.y: height * 0.5

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
