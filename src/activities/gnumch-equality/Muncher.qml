/* GCompris - Muncher.qml
*
* SPDX-FileCopyrightText: 2014 Manuel Tondeur <manueltondeur@gmail.com>
* SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
*
* Authors:
*   Joe Neeman (spuzzzzzzz@gmail.com) (GTK+ version)
*   Manuel Tondeur <manueltondeur@gmail.com> (Qt Quick port)
*   Timothée Giet <animtim@gmail.com> (refactoring)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12
import core 1.0
import "../../core"
import "gnumch-equality.js" as Activity

Creature {
    id: creature
    property bool caught: false
    required property bool life
    required property GCSoundEffect smudgeSound

    monsterType: "muncher"
    frames: 4
    Drag.active: ApplicationInfo.isMobile ? muncherArea.drag.active : false
    Drag.hotSpot.x: width / 2
    Drag.hotSpot.y: height / 2
    movable: opacity == 1

    onIndexChanged: {
        if(opacity == 1)
            smudgeSound.play()

        if(Activity.isThereAMonster(index)) {
            Activity.playerGotCaught(-1)
        }
    }

    onOpacityChanged: {
        if(opacity == 0) {
            creature.init()
        }
    }
}
