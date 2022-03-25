/* GCompris - arrow.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
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
        width: 15 * ApplicationInfo.ratio
        height: 15 * ApplicationInfo.ratio
        radius: width / 2
        anchors.centerIn: parent
        border.width: 1 * ApplicationInfo.ratio
        border.color: "#60000000"
        opacity: 0
        color: "#d6d6d6"
        scale: 2
        
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
