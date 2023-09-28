/* GCompris - MoveForward.qml
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
    id: moveForward
    movementAnimationDuration: 2000

    property double playerXCoordinate: 0
    property double playerYCoordinate: 0

    //If there has been an x-axis movement, x co-ordinate will be animated without any effect on y-axis movement and same vice-versa.
    ParallelAnimation {
        id: movementAnimation
        SmoothedAnimation {
            target: Activity.items.player
            property: 'x'
            to: playerXCoordinate
            duration: moveForward.movementAnimationDuration
            reversingMode: SmoothedAnimation.Immediate
        }
        SmoothedAnimation {
            target: Activity.items.player
            property: 'y'
            to: playerYCoordinate
            duration: moveForward.movementAnimationDuration
            reversingMode: SmoothedAnimation.Immediate
        }
        onStopped: executionComplete()
    }

    function nextPositionExists(playerCenterX, playerCenterY) {
        var playerNextPositionX = Math.floor(playerCenterX / Activity.stepX)
        var playerNextPositionY = Math.floor(playerCenterY / Activity.stepY)
        var currentLevelCoordinates = Activity.mazeBlocks[Activity.items.currentLevel].map
        for(var i = 0; i < currentLevelCoordinates.length; i++) {
            if(currentLevelCoordinates[i].x == playerNextPositionX && currentLevelCoordinates[i].y == playerNextPositionY)
                return true
        }
        return false
    }

    //Function to check if the current movement is possible or not and then process the instruction accordingly
    function checkAndExecuteMovement() {
        var currentRotation = Activity.getPlayerRotation()
        var playerCenterX = Activity.items.player.playerCenterX
        var playerCenterY = Activity.items.player.playerCenterY
        var nextTileExists = false

        moveForward.playerXCoordinate = Activity.items.player.x
        moveForward.playerYCoordinate = Activity.items.player.y

        if(currentRotation === Activity.EAST) {
            playerCenterX += Activity.stepX
            moveForward.playerXCoordinate += Activity.stepX
        }

        else if(currentRotation === Activity.WEST) {
            playerCenterX -= Activity.stepX
            moveForward.playerXCoordinate -= Activity.stepX
        }

        else if(currentRotation === Activity.SOUTH) {
            playerCenterY -= Activity.stepY
            moveForward.playerYCoordinate -= Activity.stepY
        }

        else if(currentRotation === Activity.NORTH) {
            playerCenterY += Activity.stepY
            moveForward.playerYCoordinate += Activity.stepY
        }

        nextTileExists = nextPositionExists(playerCenterX, playerCenterY)

        if(nextTileExists) {
            movementAnimation.start()
        }
        else
            foundDeadEnd()
    }
}
