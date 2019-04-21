/* GCompris - TurnLeftOrRight.qml
 *
 * Copyright (C) 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Author:
 *   Aman Kumar Gupta <gupta2140@gmail.com>
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

import "../../programmingMaze.js" as Activity

Instruction {
    id: turnLeftOrRight
    movementAnimationDuration: 1000

    property real finalRotation: 0
    property string turnDirection

    RotationAnimation {
        id: movementAnimation
        target: Activity.items.player
        to: finalRotation
        duration: turnLeftOrRight.movementAnimationDuration
        direction: RotationAnimation.Shortest
        onStopped: executionComplete()
    }

    function checkAndExecuteMovement() {
        var currentRotation = Activity.getPlayerRotation()

        if(turnLeftOrRight.turnDirection === "turn-left")
            Activity.changedRotation = (currentRotation - 90) % 360
        else
            Activity.changedRotation = (currentRotation + 90) % 360

        setCodeAreaHighlightMoveDuration()

        turnLeftOrRight.finalRotation = Activity.changedRotation
        movementAnimation.start()
    }
}
