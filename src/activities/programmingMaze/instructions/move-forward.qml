/* GCompris - move-forward.qml
 *
 * Copyright (C) 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Siddhesh Suthar <siddhesh.it@gmail.com>
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

    //Function to check if the current movement is possible or not and then process the instruction accordingly
    function checkAndExecuteMovement() {
        Activity.changedX = Activity.items.player.x
        Activity.changedY = Activity.items.player.y
        var currentRotation = Activity.getPlayerRotation()
        var currentLevelBlocksCoordinates = Activity.mazeBlocks[Activity.currentLevel][Activity.BLOCKS_DATA_INDEX]

        var currentBlock = Activity.tuxIceBlockNumber
        var isBackwardMovement = false
        var nextBlock

        var currentX = currentLevelBlocksCoordinates[currentBlock][0]
        var currentY = currentLevelBlocksCoordinates[currentBlock][1]

        // Checks if the tile at the next position exists.
        var nextTileExists = false

        if(currentRotation === Activity.EAST) {
            for(var i = 0; i < currentLevelBlocksCoordinates.length; i++) {
                if(currentLevelBlocksCoordinates[i][0] === currentX + 1 && currentLevelBlocksCoordinates[i][1] === currentY) {
                    nextTileExists = true
                }
            }
            if(nextTileExists) {
                if(Activity.isCoordinateVisited[currentX + 1][currentY]) {
                    isBackwardMovement = true
                }
            }
        }

        else if(currentRotation === Activity.WEST) {
            for(var i = 0; i < currentLevelBlocksCoordinates.length; i++) {
                if(currentLevelBlocksCoordinates[i][0] === currentX - 1 && currentLevelBlocksCoordinates[i][1] === currentY) {
                    nextTileExists = true
                }
            }
            if(nextTileExists) {
                if(Activity.isCoordinateVisited[currentX -1][currentY]) {
                    isBackwardMovement = true
                }
            }
        }

        else if(currentRotation === Activity.SOUTH) {
            for(var i = 0; i < currentLevelBlocksCoordinates.length; i++) {
                if(currentLevelBlocksCoordinates[i][0] === currentX && currentLevelBlocksCoordinates[i][1] === currentY - 1) {
                    nextTileExists = true
                }
            }
            if(nextTileExists) {
                if(Activity.isCoordinateVisited[currentX][currentY - 1]) {
                    isBackwardMovement = true
                }
            }
        }

        else if(currentRotation === Activity.NORTH) {
            for(var i = 0; i < currentLevelBlocksCoordinates.length; i++) {
                if(currentLevelBlocksCoordinates[i][0] === currentX && currentLevelBlocksCoordinates[i][1] === currentY + 1) {
                    nextTileExists = true
                }
            }
            if(nextTileExists) {
                if(Activity.isCoordinateVisited[currentX][currentY + 1]) {
                    isBackwardMovement = true
                }
            }
        }

        /**
         * Since now the direction of movement is detected (forward or backward), Tux can now make his movement.
         *
         * If isBackwardMovement is true, then the next tile Tux will visit is the previous one, else Tux will visit the forward tile
         */
        if(isBackwardMovement)
            nextBlock = Activity.tuxIceBlockNumber - 1
        else
            nextBlock = Activity.tuxIceBlockNumber + 1

        var nextX = currentLevelBlocksCoordinates[nextBlock][0]
        var nextY = currentLevelBlocksCoordinates[nextBlock][1]

        Activity.items.mainFunctionCodeArea.highlightMoveDuration = movementAnimationDuration
        Activity.items.procedureCodeArea.highlightMoveDuration = movementAnimationDuration

        if(nextX - currentX > 0 && currentRotation === Activity.EAST) {
            Activity.changedX += Activity.stepX
        }
        else if(nextX - currentX < 0 && currentRotation === Activity.WEST) {
            Activity.changedX -= Activity.stepX
        }
        else if(nextY - currentY < 0 && currentRotation === Activity.SOUTH) {
            Activity.changedY -= Activity.stepY
        }
        else if(nextY - currentY > 0 && currentRotation === Activity.NORTH) {
            Activity.changedY += Activity.stepY
        }
        else {
            Activity.items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/brick.wav")
            foundDeadEnd()
            return
        }

        // If the current tile wasn't visited as a result of backward movement, mark it as true to indicate next time it is visited, it will because of backward movement
        if(!isBackwardMovement) {
            ++Activity.tuxIceBlockNumber;
            Activity.isCoordinateVisited[currentX][currentY] = true
        }
        else {
            --Activity.tuxIceBlockNumber;
            Activity.isCoordinateVisited[currentX][currentY] = false
        }

        //If the instruction is running in procedure area, we continue executing next instruction and do not increment the main area codeIterator.
        if(Activity.runningProcedure) {
            Activity.items.procedureCodeArea.moveCurrentIndexRight()
        }
        else {
            Activity.codeIterator++
            Activity.items.mainFunctionCodeArea.moveCurrentIndexRight()
        }

        xMovement = Activity.changedX
        yMovement = Activity.changedY
        movementAnimation.start()
    }
}
