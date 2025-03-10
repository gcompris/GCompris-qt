/* GCompris - Monster.qml
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
import "gnumch-equality.js" as Activity

Creature {
    id: monster
    property int direction
    required property Muncher muncher

    signal stop

    Component.onCompleted: {
        activity.stop.connect(stop);
    }

    onStop: {
        timerMove.stop();
    }

    opacity: 0

    onMovingOnChanged: {
        if (movingOn == false) {
            Activity.monsterCheckCell(monster)
        }
    }

    onOpacityChanged: {
        if (opacity == 1) {
            Activity.monsterCheckCell(monster)
        }
    }

    Timer {
        id: timerMove
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            if (!monster.moveTo(monster.direction)) {
                var vertical = Math.floor(monster.direction / 2)
                var sign = Math.pow(-1, (monster.direction))
                monster.y = monster.y + sign * monster.height * vertical
                monster.x = monster.x - sign * monster.width * (vertical - 1)
                monster.opacity = 0
            }
        }
    }

    Behavior on opacity {
        NumberAnimation {
            id: animationEnd
            duration: 500

            onRunningChanged: {
                if (!animationEnd.running && monster.opacity == 0) {
                    monster.destroy()
                }
            }
        }
    }
}
