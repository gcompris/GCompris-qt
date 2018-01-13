/* GCompris - programmingMaze.js
 *
 * Copyright (C) 2015 Siddhesh Suthar <siddhesh.it@gmail.com>
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
.pragma library
.import QtQuick 2.6 as Quick
.import GCompris 1.0 as GCompris //for ApplicationInfo

// possible instructions
var MOVE_FORWARD = "move-forward"
var TURN_LEFT = "turn-left"
var TURN_RIGHT = "turn-right"
var CALL_PROCEDURE = "call-procedure"

var mazeBlocks = [
            //level one
            [
                //maze blocks
                [[1,2], [2,2], [3,2]],
                //fish index
                [[3,2]],
                //instruction set
                [MOVE_FORWARD,
                 TURN_LEFT,
                 TURN_RIGHT],
                //constraint - maximum number of instructions allowed
                2
            ],
            //level two
            [
                [[1,3], [2,3], [2,2], [2,1], [3,1]],
                //fish index
                [[3,1]],
                //instruction set
                [MOVE_FORWARD,
                 TURN_LEFT,
                 TURN_RIGHT],
                //constraint - maximum number of instructions allowed
                6
            ],
            //level three
            [
                [[1,1], [2,1], [3,1], [3,2], [3,3], [2,3], [1,3]],
                [[1,3]],
                //instruction set
                [MOVE_FORWARD,
                 TURN_LEFT,
                 TURN_RIGHT,
                 CALL_PROCEDURE],
                //constraint - maximum number of instructions allowed
                6
            ],
            //level four
            [
                [[0,3], [1,3], [1,2], [2,2], [2,1], [3,1]],
                [[3,1]],
                //instruction set
                [MOVE_FORWARD,
                 TURN_LEFT,
                 TURN_RIGHT,
                 CALL_PROCEDURE],
                //constraint - maximum number of instructions allowed
                7
            ],
            //level five
            [
                [[0,3], [0,2], [0,1], [0,0], [1,0], [2,0], [2,1],
                 [2,2], [2,3], [3,3], [4,3], [4,2], [4,1], [4,0]],
                [[4,0]],
                //instruction set
                [MOVE_FORWARD,
                 TURN_LEFT,
                 TURN_RIGHT,
                 CALL_PROCEDURE],
                //constraint - maximum number of instructions allowed
                15
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

/**
 * Stores if the reset is done only when Tux is clicked.
 *
 * If resetTux is true, initLevel() is called and the instruction areas are not cleared.
 *
 * Else, it means that initLevel() is called to reset the entire level and the instruction areas are cleared as well.
 */
var resetTux = false

// Tells if procedure area instructions are running or not.
var runningProcedure

// Duration of movement of highlight in the execution area.
var moveAnimDuration

var isNewLevel

//Stores the currrent instruction which is going to be processed
var currentInstruction

var url = "qrc:/gcompris/src/activities/programmingMaze/resource/"
var reverseCountUrl = "qrc:/gcompris/src/activities/reversecount/resource/"
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
var MAX_NUMBER_OF_INSTRUCTIONS_ALLOWED_INDEX = 3

var instructionComponents = {
    "move-forward": Qt.createComponent("qrc:/gcompris/src/activities/programmingMaze/instructions/move-forward.qml"),
    "turn-left": Qt.createComponent("qrc:/gcompris/src/activities/programmingMaze/instructions/turn-left.qml"),
    "turn-right": Qt.createComponent("qrc:/gcompris/src/activities/programmingMaze/instructions/turn-right.qml"),
    "call-procedure": Qt.createComponent("qrc:/gcompris/src/activities/programmingMaze/instructions/call-procedure.qml")
}

//A global look-up table to access the object of instructions which is being executed anywhere in the entire code.
var instructionObjects = []

function start(items_) {
    items = items_
    currentLevel = 0
    numberOfLevel = mazeBlocks.length
    resetTux = false
    instructionObjects[MOVE_FORWARD] = instructionComponents[MOVE_FORWARD].createObject()
    instructionObjects[TURN_LEFT] = instructionComponents[TURN_LEFT].createObject()
    instructionObjects[TURN_RIGHT] = instructionComponents[TURN_RIGHT].createObject()
    instructionObjects[CALL_PROCEDURE] = instructionComponents[CALL_PROCEDURE].createObject()
    initLevel()
}

function stop() {
    instructionObjects[MOVE_FORWARD].destroy()
    instructionObjects[TURN_LEFT].destroy()
    instructionObjects[TURN_RIGHT].destroy()
    instructionObjects[CALL_PROCEDURE].destroy()
}

function initLevel() {
    if(!items || !items.bar)
        return;

    isNewLevel = true

    items.bar.level = currentLevel + 1
    playerCode = []
    instructionObjects[CALL_PROCEDURE].procedureModel.clear()

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
            isCoordinateVisited[i][j] = false
        }
    }

    if(!resetTux) {
        items.mainFunctionModel.clear()
        items.procedureModel.clear()
        items.numberOfInstructionsAdded = 0
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
    runningProcedure = false
    moveAnimDuration = 1000
    items.background.insertIntoMain = true
    items.background.insertIntoProcedure = false
    items.mainFunctionCodeArea.currentIndex = -1
    items.procedureCodeArea.currentIndex = -1
    items.mainFunctionCodeArea.highlightMoveDuration = moveAnimDuration
    items.procedureCodeArea.highlightMoveDuration = moveAnimDuration
    items.isTuxMouseAreaEnabled = false
    items.isRunCodeEnabled = true
    items.maxNumberOfInstructionsAllowed = mazeBlocks[currentLevel][MAX_NUMBER_OF_INSTRUCTIONS_ALLOWED_INDEX]
    items.constraintInstruction.show()
    items.mainFunctionCodeArea.resetEditingValues()
    items.procedureCodeArea.resetEditingValues()
    resetTux = false
    codeIterator = 0

    items.player.init()
}

function getPlayerRotation() {
    return ((changedRotation % 360) + 360) % 360
}

//store all the instructions from main code area in playerCode and start executing.
function runCode() {
    items.mainFunctionCodeArea.highlightFollowsCurrentItem = true
    items.mainFunctionCodeArea.resetEditingValues()
    items.procedureCodeArea.resetEditingValues()

    //initialize code
    playerCode = []
    isNewLevel = false

    for(var i = 0; i < items.mainFunctionModel.count; i++)
        playerCode.push(items.mainFunctionModel.get([i]).name)

    items.isRunCodeEnabled = false
    executeNextInstruction()
}

/**
 * If the current instruction is not a function call, continue executing the instructions and call the object function from instructionObjects to make movement.
 *
 * Else, append all the procedure area instructions into the call-procedure object's model and start it's execution.
 *
 * Till the time runningProcedure is true, main code instructions will not execute. Successive executions for procedureModel is made until it is empty.
 */
function executeNextInstruction() {
    currentInstruction = playerCode[codeIterator]
    var currentLevelBlocksCoordinates = mazeBlocks[currentLevel][BLOCKS_DATA_INDEX]

    if(codeIterator < playerCode.length && !deadEndPoint && tuxIceBlockNumber < currentLevelBlocksCoordinates.length - 1) {
        if(!runningProcedure) {
            if(currentInstruction != CALL_PROCEDURE) {
                instructionObjects[currentInstruction].checkAndExecuteMovement()
            }
            else {
                var callProcedureComponentModel = instructionObjects[CALL_PROCEDURE].procedureModel

                for(var j = 0; j < items.procedureModel.count; j++) {
                    var name = items.procedureModel.get([j]).name
                    callProcedureComponentModel.append({ "name": name })
                }

                items.mainFunctionCodeArea.currentIndex += 1
                items.procedureCodeArea.currentIndex = -1
                instructionObjects[CALL_PROCEDURE].checkAndExecuteMovement()
            }
        }
        else {
            instructionObjects[CALL_PROCEDURE].checkAndExecuteMovement()
        }
    }
}

function deadEnd() {
    deadEndPoint = true
    items.isTuxMouseAreaEnabled = true
    items.bonus.bad("tux")
}

function checkSuccess() {
    var currentLevelBlocksCoordinates = mazeBlocks[currentLevel][BLOCKS_DATA_INDEX]

    var fishX = mazeBlocks[currentLevel][BLOCKS_FISH_INDEX][0][0];
    var fishY = mazeBlocks[currentLevel][BLOCKS_FISH_INDEX][0][1];
    var tuxX = currentLevelBlocksCoordinates[tuxIceBlockNumber][0]
    var tuxY = currentLevelBlocksCoordinates[tuxIceBlockNumber][1]

    if(tuxX === fishX && tuxY === fishY) {
        codeIterator = 0
        items.bonus.good("tux")
    }
    else if(codeIterator === playerCode.length && instructionObjects[CALL_PROCEDURE].procedureModel.count == 0) {
        deadEnd()
    }
    else {
        executeNextInstruction()
    }
}

function nextLevel() {
    resetTux = false
    if(numberOfLevel <= ++currentLevel) {
        currentLevel = 0
    }
    initLevel();
}

function previousLevel() {
    resetTux = false
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel();
}

function repositionObjectsOnWidthChanged(factor) {
    resetTux = true
    if(items)
        initLevel()
}

function repositionObjectsOnHeightChanged(factor) {
    resetTux = true
    if(items)
        initLevel()
}

function reloadLevel() {
    initLevel()
}
