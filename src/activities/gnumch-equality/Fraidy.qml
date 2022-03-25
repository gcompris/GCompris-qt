/* GCompris - Fraidy.qml
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
