/* GCompris - tangram.qml
 *
 * Copyright (C) 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Yves Combe /  Philippe Banwarth (GTK+ version)
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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.1
import QtGraphicalEffects 1.0
import GCompris 1.0

import "../../core"
import "tangram.js" as Activity

MouseArea {
    id: rotateArea
    anchors.fill: parent
    enabled: items.selectedITem && items.selectedITem.selected
    property double prevRotation: 0
    onPositionChanged: {
        var backPoint = background.mapFromItem(parent, mouseX, mouseY)
        // Calc the angle touch / object center
        var rotation = Activity.getAngleOfLineBetweenTwoPoints(
                    items.selectedITem.x + items.selectedITem.width / 2, items.selectedITem.y +
                    items.selectedITem.height / 2,
                    backPoint.x, backPoint.y) * (180 / Math.PI)
        if(prevRotation) {
            items.selectedITem.rotation += rotation - prevRotation
        }
        prevRotation = rotation
    }
    onReleased: {
        prevRotation = 0
        // Force a modulo 45 rotation
        items.selectedITem.rotation = Math.floor((items.selectedITem.rotation + 45 / 2) / 45) * 45
        items.selectedITem.selected = false
        background.checkWin()
    }
}
