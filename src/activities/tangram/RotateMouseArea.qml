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
    enabled: items.selected
    property double prevRotation: 0
    onPositionChanged: {
        // Calc the angle touch / object center
        var rotation = Activity.getAngleOfLineBetweenTwoPoints(
                    items.selected.x + items.selected.width / 2, items.selected.y + items.selected.height / 2,
                    mouseX, mouseY) * (180 / Math.PI)
        if(prevRotation) {
            items.selected.rotation += rotation - prevRotation
        }
        prevRotation = rotation
    }
    onReleased: {
        prevRotation = 0
        // Force a modulo 45 rotation
        items.selected.rotation = Math.floor((items.selected.rotation + 45 / 2) / 45) * 45
        background.checkWin()
    }
}
