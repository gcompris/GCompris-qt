/* GCompris - TurnLeftOrRight.qml
 *
 * SPDX-FileCopyrightText: 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Author:
 *   Aman Kumar Gupta <gupta2140@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
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

        turnLeftOrRight.finalRotation = Activity.changedRotation
        movementAnimation.start()
    }
}
