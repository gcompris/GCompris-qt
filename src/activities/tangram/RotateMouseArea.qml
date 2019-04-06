/* GCompris - tangram.qml
 *
 * Copyright (C) 2016 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Yves Combe / Philippe Banwarth (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
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
import QtGraphicalEffects 1.0
import GCompris 1.0

import "../../core"
import "tangram.js" as Activity

MouseArea {
    id: rotateArea
    anchors.fill: parent
    enabled: items.selectedItem && items.selectedItem.selected && items.selectedItem.rotable
    property double prevRotation: 0
    onPositionChanged: {
        var backPoint = background.mapFromItem(parent, mouseX, mouseY)
        // Calc the angle touch / object center
        var rotation = Activity.getAngleOfLineBetweenTwoPoints(
                    items.selectedItem.x + items.selectedItem.width / 2, items.selectedItem.y +
                    items.selectedItem.height / 2,
                    backPoint.x, backPoint.y) * (180 / Math.PI)
        if(prevRotation) {
            items.selectedItem.rotation += rotation - prevRotation
        }
        prevRotation = rotation
    }
    onReleased: {
        prevRotation = 0
        // Force a modulo 45 rotation
        items.selectedItem.rotation = Math.floor((items.selectedItem.rotation + 45 / 2) / 45) * 45
        items.selectedItem.selected = false
        background.checkWin()
    }
}
