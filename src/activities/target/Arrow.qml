/* GCompris - arrow.qml
 *
 * Copyright (C) 2014 Bruno coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
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
import QtQuick 2.6
import GCompris 1.0

import "../../core"
import "target.js" as Activity

Repeater {
    id: arrowRepeater
    model: 0
    
    signal init(int nbArrow)
    
    onInit: {
        // Set to 0 to force a delete of previous arrows
        model = 0
        model = nbArrow
        items.currentArrow = 0
    }
    
    Rectangle {
        id: arrow
        width: 30 * ApplicationInfo.ratio
        height: 30 * ApplicationInfo.ratio
        radius: width / 2
        anchors.centerIn: parent
        border.width: 1 * ApplicationInfo.ratio
        border.color: "black"
        opacity: 0
        
        Behavior on scale {
            id: scale
            NumberAnimation {
                id: anim
                duration: 1000
                easing.type: Easing.InOutQuad
                onRunningChanged: {
                    if(!anim.running) {
                        // Reparent the arrow on the target
                        targetItem.attachArrow(arrow)
                    }
                }
            }
        }
    }
}
