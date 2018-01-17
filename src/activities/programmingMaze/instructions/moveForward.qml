/* GCompris - moveForward.qml
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

import "../programmingMaze.js" as Activity

Instruction {
    id: moveForward
    movementAnimationDuration: 1000

    property double xMovement: 0
    property double yMovement: 0

    //If there has been an x-axis movement, x co-ordinate will be animated without any effect on y-axis movement and same vice-versa.
    ParallelAnimation {
        id: movementAnimation
        SmoothedAnimation {
            target: Activity.items.player
            property: 'x'
            to: xMovement
            duration: moveForward.movementAnimationDuration
            reversingMode: SmoothedAnimation.Immediate
        }
        SmoothedAnimation {
            target: Activity.items.player
            property: 'y'
            to: yMovement
            duration: moveForward.movementAnimationDuration
            reversingMode: SmoothedAnimation.Immediate
        }
        onStopped: executionComplete()
    }

    function nextPositionExists(newX, newY) {
        var newXPosition = Math.floor(newX / Activity.stepX)
        var newYPosition = Math.floor(newY / Activity.stepY)
        var currentLevelCoordinates = Activity.mazeBlocks[Activity.currentLevel][Activity.BLOCKS_DATA_INDEX]
        for(var i = 0; i < currentLevelCoordinates.length; i++) {
            if(currentLevelCoordinates[i][0] == newXPosition && currentLevelCoordinates[i][1] == newYPosition)
                return true
        }
        return false
    }

    //Function to check if the current movement is possible or not and then process the instruction accordingly
    function checkAndExecuteMovement() {
        var currentX = Activity.items.player.x
        var currentY = Activity.items.player.y
        var currentRotation = Activity.getPlayerRotation()
        var newX = currentX
        var newY = currentY
        var nextTileExists = false

        if(currentRotation === Activity.EAST) {
            newX = currentX + Activity.stepX
        }

        else if(currentRotation === Activity.WEST) {
            newX = currentX - Activity.stepX
        }

        else if(currentRotation === Activity.SOUTH) {
            newY = currentY - Activity.stepY
        }

        else if(currentRotation === Activity.NORTH) {
            newY = currentY + Activity.stepY
        }

        nextTileExists = nextPositionExists(newX, newY)

        Activity.items.mainFunctionCodeArea.highlightMoveDuration = movementAnimationDuration
        Activity.items.procedureCodeArea.highlightMoveDuration = movementAnimationDuration

        if(nextTileExists) {
            xMovement = newX
            yMovement = newY
            movementAnimation.start()
        }
        else
            foundDeadEnd()
    }
}
