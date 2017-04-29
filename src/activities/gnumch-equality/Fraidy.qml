/* GCompris - Fraidy.qml
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

// Fraidy is an afraid monster. He won't go in the center but he'll
// stay close to the border.
Monster {
    id: fraidy

    property int firstDirection

    function setFirstDirection() {
        var firstDir = direction
        firstDirection = firstDir
    }

    monsterType: "fraidy"
    frames: 3
    frameW: 53
    widthRatio: 0.74

    onMovingOnChanged: {
        // He will either follow the border or go outside.
        if (movingOn == false) {
            if (Math.random() > 0.5) {
                // He will go outside in this case.
                if (firstDirection % 2 == 0) {
                    direction = firstDirection + 1
                } else {
                    direction = firstDirection - 1
                }
            }
        }
    }

    onOpacityChanged: {
        // When fraidy appear, he will not go straight but follow the border or go outside.
        if (opacity == 1) {
            direction = (direction + Math.pow(-1, Math.floor(Math.random()*2))) % 4
            if (direction < 0)
                direction = 3
        }
    }

    Component.onCompleted: setFirstDirection()
}
