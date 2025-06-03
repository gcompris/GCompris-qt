/* GCompris - tangram.qml
 *
 * SPDX-FileCopyrightText: 2016 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Yves Combe / Philippe Banwarth (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick

import "tangram.js" as Activity

MouseArea {
    id: rotateArea
    anchors.fill: parent
    property double prevRotation: 0
    required property Item selectedItem
    onPositionChanged: {
        var backPoint = activityBackground.mapFromItem(parent, mouseX, mouseY)
        // Calc the angle touch / object center
        var rotation = Activity.getAngleOfLineBetweenTwoPoints(
                    selectedItem.x + selectedItem.width / 2, selectedItem.y +
                    selectedItem.height / 2,
                    backPoint.x, backPoint.y) * (180 / Math.PI)
        if(prevRotation) {
            selectedItem.rotation += rotation - prevRotation
        }
        prevRotation = rotation
    }
    onReleased: {
        prevRotation = 0
        // Force a modulo 45 rotation
        selectedItem.rotation = Math.floor((selectedItem.rotation + 45 / 2) / 45) * 45
        selectedItem.selected = false
        activityBackground.checkWin()
    }
}
