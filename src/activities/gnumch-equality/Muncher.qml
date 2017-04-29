/* GCompris - Muncher.qml
*
* Copyright (C) 2014 Manuel Tondeur <manueltondeur@gmail.com>
*
* Authors:
*   Joe Neeman (spuzzzzzzz@gmail.com) (GTK+ version)
*   Manuel Tondeur <manueltondeur@gmail.com> (Qt Quick port)
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

Creature {
    function getCaught(index) {
        if (!movable) {
            return
        }

        caughted = true

        opacity = 0
        warningRect.setFault(index)
        warningRect.opacity = 0.95

        if (topPanel.life.opacity == 1) {
            topPanel.life.opacity = 0
            spawningMonsters.stop()
            movable = false
            monsters.setMovable(false)
        } else {
            bonus.bad("tux")
            monsters.destroyAll()
            spawningMonsters.restart()
            start()
        }
    }

    property bool caughted: false

    monsterType: "muncher"
    frames: 4
    frameW: 80
    widthRatio: 1.35
    Drag.active: ApplicationInfo.isMobile ? muncherArea.drag.active : false
    Drag.hotSpot.x: width / 2
    Drag.hotSpot.y: height / 2

    onMovingOnChanged: {
        if (movingOn == false && caughted) {
            init()
            caughted = false
        }
    }

    onIndexChanged: {
        audioEffects.stop()
        audioEffects.play("qrc:/gcompris/src/core/resource/sounds/smudge.wav")

        if (monsters.isThereAMonster(index)) {
            getCaught(-1)
        }
    }

    onOpacityChanged: {
        if (opacity == 0) {
            init()
        }
    }
}
