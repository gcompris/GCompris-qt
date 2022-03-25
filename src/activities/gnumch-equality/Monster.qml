/* GCompris - Monster.qml
*
* SPDX-FileCopyrightText: 2014 Manuel Tondeur <manueltondeur@gmail.com>
*
* Authors:
*   Joe Neeman (spuzzzzzzz@gmail.com) (GTK+ version)
*   Manuel Tondeur <manueltondeur@gmail.com> (Qt Quick port)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12

import "gnumch-equality.js" as Activity

Creature {
    id: monster

    property int direction
    property var player

    signal stop

    Component.onCompleted: {
        activity.stop.connect(stop);
    }

    onStop: {
        timerMove.stop();
    }

    function checkCell() {
        if (index === player.index && player.movable) {
            player.getCaught(-1)
            eating = true
        }

        if (monsters.checkOtherMonster(index)) {
            eating = true
        }
    }

    opacity: 0

    onMovingOnChanged: {
        if (movingOn == false) {
            checkCell()
        }
    }

    onOpacityChanged: {
        if (opacity == 1) {
            checkCell()
        }
    }

    Timer {
        id: timerMove
        interval: 2000
        running: true
        repeat: true

        onTriggered: {
            if (!moveTo(direction)) {
                var vertical = Math.floor(direction/2)
                var sign = Math.pow(-1,(direction))
                y = y + sign * grid.cellHeight * vertical
                x = x - sign * grid.cellWidth * (vertical - 1)
                opacity = 0
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
