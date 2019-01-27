/* GCompris - Monster.qml
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
*   along with this program; if not, see <https://www.gnu.org/licenses/>.
*/
import QtQuick 2.6

import "gnumch-equality.js" as Activity

Creature {
    id: monster

    property int direction
    property var player

    function checkCell() {
        if (index === player.index) {
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
