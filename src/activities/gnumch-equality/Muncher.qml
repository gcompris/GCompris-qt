/* GCompris - Muncher.qml
*
* SPDX-FileCopyrightText: 2014 Manuel Tondeur <manueltondeur@gmail.com>
*
* Authors:
*   Joe Neeman (spuzzzzzzz@gmail.com) (GTK+ version)
*   Manuel Tondeur <manueltondeur@gmail.com> (Qt Quick port)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.6
import GCompris 1.0

import "gnumch-equality.js" as Activity

Creature {
    function getCaught(index) {
        if (!movable) {
            return
        }

        caughted = true

        opacity = 0
        warningRect.setFault(index)
        warningRect.opacity = 1

        if (topPanel.life.opacity == 1) {
            topPanel.life.opacity = 0
            spawningMonsters.stop()
            monsters.setMovable(false)
        } else {
            bonus.bad("gnu")
            monsters.destroyAll()
            spawningMonsters.restart()
            background.initLevel()
        }
    }

    property bool caughted: false

    monsterType: "muncher"
    frames: 4
    Drag.active: ApplicationInfo.isMobile ? muncherArea.drag.active : false
    Drag.hotSpot.x: width / 2
    Drag.hotSpot.y: height / 2
    movable: opacity == 1

    onMovingOnChanged: {
        if (movingOn == false && caughted) {
            init()
            caughted = false
        }
    }

    onIndexChanged: {
        audioEffects.stop()
        if(opacity == 1)
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
