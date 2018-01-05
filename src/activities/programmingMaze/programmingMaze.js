/* GCompris - programmingMaze.js
 *
 * Copyright (C) 2015 Siddhesh Suthar <siddhesh.it@gmail.com>
 *
 * Authors:
 *   "Siddhesh Suthar" <siddhesh.it@gmail.com> (Qt Quick port)
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
.pragma library
.import QtQuick 2.0 as Quick
.import GCompris 1.0 as GCompris //for ApplicationInfo

// possible instructions
var MOVE_FORWARD = "move-forward"
var TURN_LEFT = "turn-left"
var TURN_RIGHT = "turn-right"
var CALL_PROCEDURE = "call-procedure"
var START_PROCEDURE = "start-procedure"
var END_PROCEDURE = "end-procedure"

var mazeBlocks = [
            //level one
            [
                //maze blocks
                [[1,2],[2,2],[3,2]],
                //fish index
                [[3,2]],
                //instruction set
                [MOVE_FORWARD,
                 TURN_LEFT,
                 TURN_RIGHT]
            ],
            //level two
            [
                [[1,3],[2,3],[2,2],[2,1],[3,1]],
                //fish index
                [[3,1]],
                //instruction set
                [MOVE_FORWARD,
                 TURN_LEFT,
                 TURN_RIGHT]
            ],
            //level three
            [
                [[1,1],[2,1],[3,1],[3,2],[3,3],[2,3],[1,3]],
                [[1,3]],
                //instruction set
                [MOVE_FORWARD,
                 TURN_LEFT,
                 TURN_RIGHT,
                 CALL_PROCEDURE]
            ],
            //level four
            [
                [[0,3],[1,3],[1,2],[2,2],[2,1],[3,1]],
                [[3,1]],
                //instruction set
                [MOVE_FORWARD,
                 TURN_LEFT,
                 TURN_RIGHT,
                 CALL_PROCEDURE]
            ],
            //level five
            [
                [[0,3],[0,2],[0,1],[0,0],[1,0],[2,0],[2,1],
                 [2,2],[2,3],[3,3],[4,3],[4,2],[4,1],[4,0]],
                [[4,0]],
                //instruction set
                [MOVE_FORWARD,
                 TURN_LEFT,
                 TURN_RIGHT,
                 CALL_PROCEDURE]
            ]
        ]

// Length of 1 step along x-axis
var stepX

// Length of 1 step along y-axis
var stepY

// List of commands to be executed
var playerCode = []

// The index of tile, Tux currently is on
var tuxIceBlockNumber

// New x position of Tux after a forward / backward movement
var changedX

// New y position of Tux after a forward / backward movement
var changedY

// New rotation of Tux on turning.
var changedRotation

// Indicates if there is a dead-end
var deadEndPoint = false

// Stores the index of playerCode[] which is going to be processed
var codeIterator = 0
var reset = false

// Number of instructions in procedure model
var procedureBlocks

// Tells if procedure area instructions are running or not
var runningProcedure

// Duration of movement of highlight in the execution area.
var moveAnimDuration

var url = "qrc:/gcompris/src/activities/programmingMaze/resource/"
var reverseCountUrl = "qrc:/gcompris/src/activities/reversecount/resource/"
var okImage = "qrc:/gcompris/src/core/resource/bar_ok.svg"
var reloadImage = "qrc:/gcompris/src/core/resource/bar_reload.svg"
var currentLevel = 0
var numberOfLevel
var items

/**
 * A 2-dimensional array whose each cell stores:
 *  1. 0 if the tile at position x,y is visited by Tux during forward movement.
 *  2. 1 if the tile at position x,y is visited by Tux during backward movement on his path.
 *
 * According to this value, the number of covered tiles in the path is calculated:
 *  1. If the value at cell x,y is 0 (a forward movement), the number of tiles covered in the path increases by 1.
 *  2. If the value at cell x,y is 1 (a backward movement), the number of tiles covered in the path decreases by 1.
 */
var isCoordinateVisited

var NORTH = 0
var WEST = 90
var SOUTH = 180
var EAST = 270

var BLOCKS_DATA_INDEX = 0
var BLOCKS_FISH_INDEX = 1
var BLOCKS_INSTRUCTION_INDEX = 2

function start(items_) {
    items = items_
    currentLevel = 0
    numberOfLevel = mazeBlocks.length
    reset = false
    initLevel()
}

function stop() {
}

function initLevel() {
    if(!items || !items.bar)
        return;

    items.bar.level = currentLevel + 1

    // Stores the co-ordinates of the tile blocks in the current level
    var currentLevelBlocksCoordinates = mazeBlocks[currentLevel][BLOCKS_DATA_INDEX]

    items.mazeModel.model = currentLevelBlocksCoordinates

    // The maximum value of x and y co-ordinates in the level
    var maxX = 0
    var maxY = 0

    for(var i = 0; i < currentLevelBlocksCoordinates.length; i++) {
        if(currentLevelBlocksCoordinates[i][0] > maxX)
            maxX = currentLevelBlocksCoordinates[i][0]
        if(currentLevelBlocksCoordinates[i][1] > maxY)
            maxY = currentLevelBlocksCoordinates[i][1]
    }

    isCoordinateVisited = []

    // A 2-D adjacency matrix of size maxX * maxY is formed to store the values (0 or 1) for each tile at that co-ordinate, marking it as visited during forward / backward movement.
    isCoordinateVisited = new Array(maxX + 1);

    for(var i = 0; i <= maxX; i++) {
        isCoordinateVisited[i] = new Array(maxY + 1);
    }

    // Initially all the cells are assigned 0 as for the first time they will be visited by Tux during forward movement.
    for(var i = 0; i <= maxX; i++) {
        for(var j = 0; j <= maxY; j++) {
            isCoordinateVisited[i][j] = 0
        }
    }

    if(!reset && !deadEndPoint) {
        items.answerModel.clear()
        items.procedureModel.clear()
    }

    stepX = items.mazeModel.itemAt(0).width
    stepY = items.mazeModel.itemAt(0).height

    items.instructionModel.clear()
    var levelInstructions = mazeBlocks[currentLevel][BLOCKS_INSTRUCTION_INDEX]
    for (var i = 0; i < levelInstructions.length; i++) {
        items.instructionModel.append({"name":levelInstructions[i]});
    }

    // Center Tux in its first case
    items.player.x = currentLevelBlocksCoordinates[0][0] * stepX + (stepX - items.player.width) / 2
    items.player.y = currentLevelBlocksCoordinates[0][1] * stepY + (stepY - items.player.height) / 2

    tuxIceBlockNumber = 0
    changedRotation = EAST
    deadEndPoint = false
    procedureBlocks = 0
    runningProcedure = false
    moveAnimDuration = 1000
    items.background.insertIntoMain = true
    items.background.insertIntoProcedure = false
    items.answerSheet.currentIndex = -1
    items.procedure.currentIndex = -1
    items.answerSheet.highlightMoveDuration = moveAnimDuration
    items.procedure.highlightMoveDuration = moveAnimDuration
    items.runCodeImage = okImage
    items.player.tuxIsBusy = false
    codeIterator = 0
    playerCode = []

    items.player.init()
}

function getPlayerRotation() {
    return ((changedRotation % 360) + 360) % 360
}

function runCode() {
    if(items.runCodeImage == reloadImage) {
        playerCode = []
        items.answerSheet.highlightFollowsCurrentItem = false
        initLevel()
    }
    else {
        items.answerSheet.highlightFollowsCurrentItem = true
        //initialize code
        playerCode = []
        items.player.tuxIsBusy = false
        procedureBlocks = items.procedureModel.count
        for(var i = 0; i < items.answerModel.count; i++) {
            if(items.answerModel.get([i]).name === CALL_PROCEDURE) {
                playerCode.push(START_PROCEDURE)
                for(var j = 0; j < items.procedureModel.count; j++) {
                    if(items.procedureModel.get([j]).name != END_PROCEDURE)
                        playerCode.push(items.procedureModel.get([j]).name)
                }
                playerCode.push(END_PROCEDURE)
            }
            else {
                playerCode.push(items.answerModel.get([i]).name)
            }
        }

        if(!items.player.tuxIsBusy) {
            executeNextInstruction()
        }
    }
}

function playerRunningChanged() {
    if(!items.player.tuxIsBusy) {
        if(deadEndPoint) {
            console.log("it was a dead end")
        }
        else{
            executeNextInstruction()
        }
    }
}

function executeNextInstruction() {
    var currentInstruction = playerCode[codeIterator]

    if(!items.player.tuxIsBusy && codeIterator < playerCode.length && !deadEndPoint
            && currentInstruction != START_PROCEDURE && currentInstruction != END_PROCEDURE) {
        changedX = items.player.x
        changedY = items.player.y
        var currentRotation = getPlayerRotation()

        var currentBlock = tuxIceBlockNumber
        var nextBlock
        var isBackwardMovement = false

        var currentLevelBlocksCoordinates = mazeBlocks[currentLevel][BLOCKS_DATA_INDEX]

        var currentX = currentLevelBlocksCoordinates[currentBlock][0]
        var currentY = currentLevelBlocksCoordinates[currentBlock][1]

        // Checks if the tile at the next position exists.
        var nextTileExists = false

        /**
         * This If condition determines whether a tile exists in the direction of movement of Tux and if the tile is visited during forward / backward movement.
         *
         * If a tile at position x,y is marked as 1, it signifies that it is being visited during a backward movement and then marked as 0 (as when it is visited next time, it will be due to forward movement).
         */
        if(currentInstruction === MOVE_FORWARD) {
            if(currentRotation === EAST) {
                for(var i = 0; i < currentLevelBlocksCoordinates.length; i++) {
                    if(currentLevelBlocksCoordinates[i][0] === currentX + 1 && currentLevelBlocksCoordinates[i][1] === currentY) {
                        nextTileExists = true
                    }
                }
                if(nextTileExists) {
                    if(isCoordinateVisited[currentX + 1][currentY] === 1) {
                        isCoordinateVisited[currentX][currentY] = 0
                        isBackwardMovement = true
                    }
                }
            }

            else if(currentRotation === WEST) {
                for(var i = 0; i < currentLevelBlocksCoordinates.length; i++) {
                    if(currentLevelBlocksCoordinates[i][0] === currentX - 1 && currentLevelBlocksCoordinates[i][1] === currentY) {
                        nextTileExists = true
                    }
                }
                if(nextTileExists) {
                    if(isCoordinateVisited[currentX -1][currentY] === 1) {
                        isCoordinateVisited[currentX][currentY] = 0
                        isBackwardMovement = true
                    }
                }
            }

            else if(currentRotation === SOUTH) {
                for(var i = 0; i < currentLevelBlocksCoordinates.length; i++) {
                    if(currentLevelBlocksCoordinates[i][0] === currentX && currentLevelBlocksCoordinates[i][1] === currentY - 1) {
                        nextTileExists = true
                    }
                }
                if(nextTileExists) {
                    if(isCoordinateVisited[currentX][currentY - 1] === 1) {
                        isCoordinateVisited[currentX][currentY] = 0
                        isBackwardMovement = true
                    }
                }
            }

            else if(currentRotation === NORTH) {
                for(var i = 0; i < currentLevelBlocksCoordinates.length; i++) {
                    if(currentLevelBlocksCoordinates[i][0] === currentX && currentLevelBlocksCoordinates[i][1] === currentY + 1) {
                        nextTileExists = true
                    }
                }
                if(nextTileExists) {
                    if(isCoordinateVisited[currentX][currentY + 1] === 1) {
                        isCoordinateVisited[currentX][currentY] = 0
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
                nextBlock = tuxIceBlockNumber - 1
            else
                nextBlock = tuxIceBlockNumber + 1

            var nextX = currentLevelBlocksCoordinates[nextBlock][0]
            var nextY = currentLevelBlocksCoordinates[nextBlock][1]

            items.answerSheet.highlightMoveDuration = moveAnimDuration
            items.procedure.highlightMoveDuration = moveAnimDuration
            if (nextX - currentX > 0 && currentRotation === EAST) {
                changedX += stepX
            }
            else if(nextX - currentX < 0 && currentRotation === WEST) {
                changedX -= stepX
            }
            else if(nextY - currentY < 0 && currentRotation === SOUTH) {
                changedY -= stepY
            }
            else if(nextY - currentY > 0 && currentRotation === NORTH) {
                changedY += stepY
            }
            else {
                items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/brick.wav")
                deadEnd()
                return
            }

            // If the current tile wasn't visited as a result of backward movement, mark it as 1 to indicate next time it is visited, it will because of backward movement
            if(!isBackwardMovement) {
                ++tuxIceBlockNumber;
                isCoordinateVisited[currentX][currentY] = 1
            }
            else {
                --tuxIceBlockNumber;
            }

            items.player.x = changedX
            items.player.y = changedY
        }
        else if(currentInstruction === TURN_LEFT) {
            changedRotation = (currentRotation - 90) % 360
            items.player.rotation = changedRotation
            items.answerSheet.highlightMoveDuration = moveAnimDuration / 2
            items.procedure.highlightMoveDuration = moveAnimDuration / 2
        }
        else if(currentInstruction === TURN_RIGHT) {
            changedRotation = (currentRotation + 90) % 360
            items.player.rotation = changedRotation
            items.answerSheet.highlightMoveDuration = moveAnimDuration / 2
            items.procedure.highlightMoveDuration = moveAnimDuration / 2
        }

        codeIterator ++
        items.player.tuxIsBusy = true
        if(runningProcedure && procedureBlocks > 0
                && currentInstruction != START_PROCEDURE && currentInstruction != END_PROCEDURE) {
            procedureBlocks--
            items.procedure.moveCurrentIndexRight()
        }
        if(!runningProcedure
                && currentInstruction != START_PROCEDURE && currentInstruction != END_PROCEDURE) {
            items.answerSheet.moveCurrentIndexRight()
        }
        checkSuccess()
    }
    else if(currentInstruction === START_PROCEDURE) {
        runningProcedure = true
        items.answerSheet.currentIndex += 1
        items.procedure.currentIndex = -1
        codeIterator++
        executeNextInstruction()
    }
    else if(currentInstruction === END_PROCEDURE) {
        runningProcedure = false
        procedureBlocks = items.procedureModel.count
        codeIterator++
        executeNextInstruction()
    }
}

function deadEnd() {
    deadEndPoint = true
    items.runCodeImage = reloadImage
}

function checkSuccess() {
    var currentLevelBlocksCoordinates = mazeBlocks[currentLevel][BLOCKS_DATA_INDEX]

    var fishX = mazeBlocks[currentLevel][BLOCKS_FISH_INDEX][0][0];
    var fishY = mazeBlocks[currentLevel][BLOCKS_FISH_INDEX][0][1];
    var tuxX = currentLevelBlocksCoordinates[tuxIceBlockNumber][0]
    var tuxY = currentLevelBlocksCoordinates[tuxIceBlockNumber][1]

    if(tuxX === fishX && tuxY === fishY) {
        playerCode = []
        codeIterator = 0
        items.player.tuxIsBusy = false
        items.bonus.good("smiley")
    }
}

function nextLevel() {
    reset = false
    if(numberOfLevel <= ++currentLevel) {
        currentLevel = 0
    }
    initLevel();
}

function previousLevel() {
    reset = false
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel();
}

function repositionObjectsOnWidthChanged(factor) {
    reset = true
    if(items)
        initLevel()
}

function repositionObjectsOnHeightChanged(factor) {
    reset = true
    if(items)
        initLevel()
}

function reloadLevel() {
    if(deadEndPoint) {
        playerCode = []
    }
    initLevel()
}
