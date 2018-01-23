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
                4
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
                8
            ],
            //level three
            [
                [[0,3], [0,2], [0,1],
                 [1,1], [2,1], [3,1],
                 [3,2],
                 [3,3], [2,3]],
                //fish index
                [[2,3]],
                //instruction set
                [MOVE_FORWARD,
                 TURN_LEFT,
                 TURN_RIGHT],
                //constraint - maximum number of instructions allowed
                14
            ],
            //level four
            [
                [[0,1], [1,1], [1,0], [2,0], [3,0], [4,0],
                 [1,2], [1,3], [2,3], [3,3], [4,3], [4,2]],
                //fish index
                [[4,2]],
                //instruction set
                [MOVE_FORWARD,
                 TURN_LEFT,
                 TURN_RIGHT],
                //constraint - maximum number of instructions allowed
                14
            ],
            //level five
            [
                [[0,1], [0,0], [1,0], [2,0], [3,0], [4,0],
                 [0,2], [0,3],
                 [1,3], [2,3], [3,3], [4,3],
                 [2,1], [2,2],
                 [4,2]],
                //fish index
                [[4,2]],
                //instruction set
                [MOVE_FORWARD,
                 TURN_LEFT,
                 TURN_RIGHT],
                //constraint - maximum number of instructions allowed
                15
            ],
            //level six
            [
                [[1,1], [2,1], [3,1], [3,2], [3,3], [2,3], [1,3]],
                [[1,3]],
                //instruction set
                [MOVE_FORWARD,
                 TURN_LEFT,
                 TURN_RIGHT,
                 CALL_PROCEDURE],
                //constraint - maximum number of instructions allowed
                7
            ],
            //level seven
            [
                [[0,3], [1,3], [1,2], [2,2], [2,1], [3,1], [3,0], [4,0]],
                [[4,0]],
                //instruction set
                [MOVE_FORWARD,
                 TURN_LEFT,
                 TURN_RIGHT,
                 CALL_PROCEDURE],
                //constraint - maximum number of instructions allowed
                12
            ],
            //level eight
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
var mainFunctionCode = []
var procedureCode = []

// New rotation of Tux on turning.
var changedRotation

// Indicates if there is a dead-end
var deadEndPoint = false

// Stores the index of mainFunctionCode[] which is going to be processed
var codeIterator = 0

/**
 * Stores if the reset is done only when Tux is clicked.
 *
 * If resetTux is true, initLevel() is called and the instruction areas are not cleared.
 *
 * Else, it means that initLevel() is called to reset the entire level and the instruction areas are cleared as well.
 */
var resetTux = false

// Duration of movement of highlight in the execution area.
var moveAnimDuration

//Stores the currrent instruction which is going to be processed
var currentInstruction

var url = "qrc:/gcompris/src/activities/programmingMaze/resource/"
var reverseCountUrl = "qrc:/gcompris/src/activities/reversecount/resource/"
var currentLevel = 0
var numberOfLevel
var items

var NORTH = 0
var WEST = 90
var SOUTH = 180
var EAST = 270

var BLOCKS_DATA_INDEX = 0
var BLOCKS_FISH_INDEX = 1
var BLOCKS_INSTRUCTION_INDEX = 2
var MAX_NUMBER_OF_INSTRUCTIONS_ALLOWED_INDEX = 3

/**
 * Stores the qml file components of all the instructions used in the activity.
 *
 * To add a new instruction, add its component here, create its object in initLevel() along with the other instructions
 * for procedure area, and call its destroy function in destroyInstructionObjects().
 */
var instructionComponents = {
    "move-forward": Qt.createComponent("qrc:/gcompris/src/activities/programmingMaze/instructions/MoveForward.qml"),
    "turn-left": Qt.createComponent("qrc:/gcompris/src/activities/programmingMaze/instructions/TurnLeftOrRight.qml"),
    "turn-right": Qt.createComponent("qrc:/gcompris/src/activities/programmingMaze/instructions/TurnLeftOrRight.qml"),
    "call-procedure": Qt.createComponent("qrc:/gcompris/src/activities/programmingMaze/instructions/Procedure.qml")
}

/**
 * The procedure function's object. This object is linked to all its instructions with signal and slot.
 *
 * Since the signals of instructions created in procedureCode need to be connected to the procedure file,
 * hence only one object for procedure function is sufficient and this same
 * procedure object will be re-used to push into the main code when the code is run.
 */
var procedureFunctionObject

var mainTutorialInstructions = [
            {
                "instruction": qsTr("<b><h7>Instruction Area</b></h7>" +
                                    "There are 4 commands in the order:" +
                                    "<b><li>1. Move forward:</b> Moves Tux one step forward in the direction it is facing.</li>" +
                                    "<b><li>2. Turn left:</b> Turns Tux in the left direction from where it is facing.</li>" +
                                    "<b><li>3. Turn right:</b> Turns Tux in the right direction from where it is facing.</li>"),
                "instructionImage": "qrc:/gcompris/src/activities/programmingMaze/resource/Tutorial1.png"
            },
            {
                "instruction": qsTr("<b><h7>Main Function:</b></h7>" +
                                    "<li>-The execution of code starts here on running.</li>" +
                                    "<li>-Click on any instruction in the <b>instruction area</b> to add them to the <b>Main Function</b></li>" +
                                    "<li>-The instructions will execute in order until there's none left, dead-end or Tux reaches the fish.</li>"),
                "instructionImage": "qrc:/gcompris/src/activities/programmingMaze/resource/Tutorial2.png"
            },
            {
                "instruction": qsTr("Below the instruction area, there is a <b>constraint which tells the number of instructions you can use in the code.</b>"),
                "instructionImage": "qrc:/gcompris/src/activities/programmingMaze/resource/Tutorial3.png"
            },
            {
                "instruction": qsTr("To <b>edit an instruction</b>, click on it and then select the instruction from the instruction area which you want to replace it with."),
                "instructionImage": "qrc:/gcompris/src/activities/programmingMaze/resource/Tutorial4.png"
            },
            {
                "instruction": qsTr("<li>-To <b>delete</b> an instruction, <b>drag it outside the code area and release the mouse.</b></li>" +
                                    "<li>-To <b>move</b> an instruction to another position, <b>drag and drop it to the place intended.</b></li>"),
                "instructionImage": "qrc:/gcompris/src/activities/programmingMaze/resource/Tutorial5.png"
            },
            {
                "instruction": qsTr("<li>-If you fail to reach the fish, <b>click on Tux to reset it without clearing the code.</b></li>" +
                                    "<li>-Click the <b>Reload</b> button to restart the level.</li>"),
                "instructionImage": "qrc:/gcompris/src/activities/programmingMaze/resource/Tutorial6.png"
            }
        ]

var procedureTutorialInstructions = [
            {
                "instruction": qsTr("<b><h7>Procedure:</b></h7>" +
                                    "<li>-<b>Procedure</b> is a reusable set of instructions which can be <b>used in a code by calling it where needed.</b></li>" +
                                    "<li>-To <b>switch</b> between the <b>Procedure area</b> and <b>Main Function area</b> to add your code, click on the label <b>Procedure</b> or <b>Main Function</b>.</li>"),
                "instructionImage": "qrc:/gcompris/src/activities/programmingMaze/resource/Tutorial7.png"
            },
        ]

function start(items_) {
    items = items_
    currentLevel = 0
    numberOfLevel = mazeBlocks.length
    resetTux = false
    initLevel()
}

function stop() {
    destroyInstructionObjects()
}

function destroyInstructionObjects() {
    for(var i = 0; i < mainFunctionCode.length; i++) {
        mainFunctionCode[i].destroy()
    }
    if(procedureCode[MOVE_FORWARD] && procedureCode[TURN_LEFT] && procedureCode[TURN_RIGHT]) {
        procedureCode[MOVE_FORWARD].destroy()
        procedureCode[TURN_LEFT].destroy()
        procedureCode[TURN_RIGHT].destroy()
        procedureFunctionObject.destroy()
    }

    mainFunctionCode = []
    procedureCode = []
}

function initLevel() {
    if(!items || !items.bar)
        return;

    items.bar.level = currentLevel + 1
    destroyInstructionObjects()

    items.mainFunctionCodeArea.currentIndex = -1
    items.procedureCodeArea.procedureIterator = -1

    //In the levels where there are procedure code area, create instructions for it and connect the instructions' signals to procedureFunctionObject's slots.
    if(currentLevel >= 5) {
        if(!items.tutorialImage.shownProcedureTutorialInstructions) {
            items.tutorialImage.shownProcedureTutorialInstructions = true
            items.tutorialImage.visible = true
        }

        procedureFunctionObject = instructionComponents[CALL_PROCEDURE].createObject(items.background)
        procedureCode[MOVE_FORWARD] = instructionComponents[MOVE_FORWARD].createObject(procedureFunctionObject)
        procedureCode[TURN_LEFT] = instructionComponents[TURN_LEFT].createObject(procedureFunctionObject, { "turnDirection": "turn-left" })
        procedureCode[TURN_RIGHT] = instructionComponents[TURN_RIGHT].createObject(procedureFunctionObject, { "turnDirection": "turn-right" })

        procedureFunctionObject.foundDeadEnd.connect(items.background.deadEnd)
        procedureFunctionObject.executionComplete.connect(items.background.currentInstructionExecutionComplete)

        procedureCode[MOVE_FORWARD].foundDeadEnd.connect(procedureFunctionObject.deadEnd)
        procedureCode[MOVE_FORWARD].executionComplete.connect(procedureFunctionObject.checkSuccessAndExecuteNextInstruction)

        procedureCode[TURN_LEFT].foundDeadEnd.connect(procedureFunctionObject.deadEnd)
        procedureCode[TURN_LEFT].executionComplete.connect(procedureFunctionObject.checkSuccessAndExecuteNextInstruction)

        procedureCode[TURN_RIGHT].foundDeadEnd.connect(procedureFunctionObject.deadEnd)
        procedureCode[TURN_RIGHT].executionComplete.connect(procedureFunctionObject.checkSuccessAndExecuteNextInstruction)
    }

    // Stores the co-ordinates of the tile blocks in the current level
    var currentLevelBlocksCoordinates = mazeBlocks[currentLevel][BLOCKS_DATA_INDEX]

    items.mazeModel.model = currentLevelBlocksCoordinates

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

    changedRotation = EAST
    deadEndPoint = false
    moveAnimDuration = 1000
    items.background.insertIntoMain = true
    items.background.insertIntoProcedure = false
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

//store all the instructions from main and procedure areas in their respective instruction lists.
function runCode() {
    items.mainFunctionCodeArea.highlightFollowsCurrentItem = true
    items.mainFunctionCodeArea.resetEditingValues()
    items.procedureCodeArea.resetEditingValues()

    //initialize code
    mainFunctionCode = []

    var instructionName
    var instructionObject

    /**
     * Create and append objects of all the instructions in the main area code.
     *
     * If the instruction is call-procedure, append the procedureFunctionObject, and it will access the instructions created in procedureCode which are linked to this object.
     */
    for(var i = 0; i < items.mainFunctionModel.count; i++) {
        instructionName = items.mainFunctionModel.get([i]).name
        if(instructionName != CALL_PROCEDURE) {
            if(instructionName === TURN_LEFT)
                instructionObject = instructionComponents[instructionName].createObject(items.background, { "turnDirection": "turn-left" })
            else if(instructionName === TURN_RIGHT)
                instructionObject = instructionComponents[instructionName].createObject(items.background, { "turnDirection": "turn-right" })
            else
                instructionObject = instructionComponents[instructionName].createObject(items.background)

            instructionObject.foundDeadEnd.connect(items.background.deadEnd)
            instructionObject.executionComplete.connect(items.background.currentInstructionExecutionComplete)

            mainFunctionCode.push(instructionObject)
        }
        else {
            mainFunctionCode.push(procedureFunctionObject)
        }
    }

    //Append all the instructions from the procedure area.
    for(var j = 0; j < items.procedureModel.count; j++) {
        instructionName = items.procedureModel.get([j]).name
        procedureFunctionObject.procedureCode.append({ "name" : instructionName })
    }

    items.isRunCodeEnabled = false
    if(mainFunctionCode.length > 0)
        executeNextInstruction()
    else
        deadEnd()
}

function executeNextInstruction() {
    if(codeIterator < mainFunctionCode.length && !deadEndPoint) {
        items.mainFunctionCodeArea.currentIndex += 1
        mainFunctionCode[codeIterator].checkAndExecuteMovement()
    }
}

function deadEnd() {
    deadEndPoint = true
    items.isTuxMouseAreaEnabled = true
    items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/brick.wav")
    items.bonus.bad("tux")
}

function checkSuccessAndExecuteNextInstruction() {
    var fishX = mazeBlocks[currentLevel][BLOCKS_FISH_INDEX][0][0]
    var fishY = mazeBlocks[currentLevel][BLOCKS_FISH_INDEX][0][1]

    var tuxX = Math.floor(items.player.playerCenterX / stepX)
    var tuxY = Math.floor(items.player.playerCenterY / stepY)

    if(tuxX === fishX && tuxY === fishY) {
        codeIterator = 0
        items.bonus.good("tux")
    }
    else if(codeIterator === mainFunctionCode.length - 1) {
        deadEnd()
    }
    else {
        codeIterator++
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
