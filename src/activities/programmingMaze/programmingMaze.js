/* GCompris - programmingMaze.js
 *
 * SPDX-FileCopyrightText: 2015 Siddhesh Suthar <siddhesh.it@gmail.com>
 * SPDX-FileCopyrightText: 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Siddhesh Suthar <siddhesh.it@gmail.com>
 *   Aman Kumar Gupta <gupta2140@gmail.com>
 *   Timothée Giet <animtim@gcompris.net> (Layout and graphics rework)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.12 as Quick
.import GCompris 1.0 as GCompris //for ApplicationInfo
.import "qrc:/gcompris/src/core/core.js" as Core

// possible instructions
var MOVE_FORWARD = "move-forward"
var TURN_LEFT = "turn-left"
var TURN_RIGHT = "turn-right"
var CALL_PROCEDURE = "call-procedure"
var EXECUTE_LOOPS = "execute-loop"

var mazeBlocks

// Length of 1 step along x-axis
var stepX

// Length of 1 step along y-axis
var stepY

/**
 * Lookup tables of instruction objects for main, procedure and loop areas which will be stored here on creation and can be
 * accessed when required to execute.
 */
var mainInstructionObjects = []
var procedureInstructionObjects = []
var loopInstructionObjects = []

// New rotation of Tux on turning.
var changedRotation

// Indicates if there is a dead-end
var deadEndPoint = false

// Stores the index of mainInstructionObjects[] which is going to be processed
var codeIterator = 0

// Stores the number of loops needed
var loopsNumber

/**
 * Stores if the reset is done only when Tux is clicked.
 *
 * If resetTux is true, initLevel() is called and the instruction areas are not cleared.
 *
 * Else, it means that initLevel() is called to reset the entire level and the instruction areas are cleared as well.
 */
var resetTux = false

//Stores the currrent instruction which is going to be processed
var currentInstruction

var url = "qrc:/gcompris/src/activities/programmingMaze/resource/"
var reverseCountUrl = "qrc:/gcompris/src/activities/reversecount/resource/"
var numberOfLevel
var items

var NORTH = 0
var WEST = 90
var SOUTH = 180
var EAST = 270

//Used to increment or decrement the loop counter, and display one as an initial value for the loop counter in the tutorial base.
var LoopEnumValues = {
    PLUS_SIGN : "\u002B",
    MINUS_SIGN : "\u2212"
}

/**
 * Stores the qml file components of all the instructions used in the activity.
 *
 * To add a new instruction, add its component here and add the instruction name in "instructionList" inside createInstructionObjects() along with the other instructions.
 */
var instructionComponents = {
    "move-forward": Qt.createComponent(url + "instructions/MoveForward.qml"),
    "turn-left": Qt.createComponent(url + "instructions/TurnLeftOrRight.qml"),
    "turn-right": Qt.createComponent(url + "instructions/TurnLeftOrRight.qml"),
    "call-procedure": Qt.createComponent(url + "instructions/Procedure.qml"),
    "execute-loop": Qt.createComponent(url + "instructions/Loop.qml")
}

var mainTutorialInstructions = [
            {
                "instruction": "<b><h7>" + qsTr("Instruction Area:") + "</h7></b>" +
                                    qsTr("There are 3 instructions which you can use to code and lead Tux to the fish:") + "<li>" +
                                    qsTr("<b>1. Move forward:</b> Moves Tux one step forward in the direction it is facing.") + "</li><li>" +
                                    qsTr("<b>2. Turn left:</b> Turns Tux to the left.") + "</li><li>" +
                                    qsTr("<b>3. Turn right:</b> Turns Tux to the right.") + "</li>",
                "instructionQml": "qrc:/gcompris/src/activities/programmingMaze/resource/tutorial1.qml"
            },
            {
                "instruction": "<b><h7>" + qsTr("Main Function:") + "</h7></b>" +
                                    qsTr("The execution of the code starts here.") + "<li>" +
                                    qsTr("-Click on any instruction in the <b>instruction area</b> to add it to the <b>Main Function</b>.") + "</li><li>" +
                                    qsTr("-The instructions will execute in order until there's none left, or until a dead-end, or when Tux reaches the fish.") + "</li>",
                "instructionQml": "qrc:/gcompris/src/activities/programmingMaze/resource/tutorial2.qml"
            },
        ]

var procedureTutorialInstructions = [
            {
                "instruction": "<b><h7>" + qsTr("Procedure:") + "</h7></b>" +
                                    qsTr("<b>Procedure</b> is a reusable set of instructions which can be <b>used in the code by calling it where needed</b>.") + "<li>" +
                                    qsTr("-To <b>switch</b> between the <b>Procedure area</b> and the <b>Main Function area</b> to add your code, click on the <b>Procedure</b> or <b>Main Function</b> label.") + "</li>",
                "instructionQml": "qrc:/gcompris/src/activities/programmingMaze/resource/tutorial3.qml"
            },
        ]

var loopTutorialInstructions = [
            {
                "instruction": "<b><h7>" + qsTr("Loop:") + "</h7></b>" +
                                    qsTr("<b>Loop</b> is a sequence of instructions that is <b>continually repeated the number of times defined by the number inside it</b>.") + "<li>" +
                                    qsTr("-To <b>switch</b> between the <b>Loop area</b> and the <b>Main Function area</b> to add your code, click on the <b>Loop</b> or <b>Main Function</b> label.") + "</li>",
                "instructionQml": "qrc:/gcompris/src/activities/programmingMaze/resource/tutorial4.qml"
            }
        ]

function start(items_) {
    items = items_
    mazeBlocks = items.levels
    numberOfLevel = mazeBlocks.length
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    resetTux = false
    initLevel()
}

function stop() {
    items.activityStopped = true
    destroyInstructionObjects()
}

/**
 * This function creates and populate instruction objects for main as well as procedure area.
 *
 * These are stored in the lookup table, provided in the parameter as "instructionObjects".
 * The instructions are then connected to the slots of their code area (main or procedure/loops), provided as "instructionCodeArea" in the parameter.
 *
 * The instructions can now be obtained from the look-up tables and executed when called.
 *
 * This saves the process of re-creating all the instruction objets, connecting them to their parent's slot and destroying
 * them everytime for each instruction call which will be very redundant and quite memory consuming on devices with
 * less RAM, weak processing power and slow performance specially for "loops" mode.
 *
 * Hence these look-up table objects will be created and destroyed only once in each level (depending on the need) and can be accessed when needed.
 */
function createInstructionObjects(instructionObjects, instructionCodeArea) {
    var instructionList = [MOVE_FORWARD, TURN_LEFT, TURN_RIGHT]
    for(var i = 0; i < instructionList.length; i++)
        createInstruction(instructionObjects, instructionList[i], instructionCodeArea)
}

function createInstruction(instructionObjects, instructionName, instructionCodeArea) {
    if(instructionName === TURN_LEFT || instructionName === TURN_RIGHT) {
        instructionObjects[instructionName] = instructionComponents[instructionName].createObject(instructionCodeArea, { "turnDirection": instructionName })
    }
    else {
        instructionObjects[instructionName] = instructionComponents[instructionName].createObject(instructionCodeArea)
    }

    instructionObjects[instructionName].foundDeadEnd.connect(instructionCodeArea.deadEnd)
    instructionObjects[instructionName].executionComplete.connect(instructionCodeArea.checkSuccessAndExecuteNextInstruction)
}

// Destroy instruction objects from the look-up tables
function destroyInstructionObjects() {
    var i
    var instructionList = Object.keys(mainInstructionObjects)
    for(i = 0; i < instructionList.length; i++) {
        mainInstructionObjects[instructionList[i]].destroy()
    }

    instructionList = Object.keys(procedureInstructionObjects)
    for(i = 0; i < instructionList.length; i++) {
        procedureInstructionObjects[instructionList[i]].destroy()
    }

    instructionList = Object.keys(loopInstructionObjects)
    for(i = 0; i < instructionList.length; i++) {
        loopInstructionObjects[instructionList[i]].destroy()
    }


    mainInstructionObjects = []
    procedureInstructionObjects = []
    loopInstructionObjects = []
}

function initLevel() {
    if(!items)
        return

    loopsNumber = 1
    destroyInstructionObjects()

    var levelInstructions = mazeBlocks[items.currentLevel].instructions

    if(levelInstructions.indexOf(CALL_PROCEDURE) !== -1)
        items.currentLevelContainsProcedure = true
    else
        items.currentLevelContainsProcedure = false

    if(levelInstructions.indexOf(EXECUTE_LOOPS) !== -1)
        items.currentLevelContainsLoop = true
    else
        items.currentLevelContainsLoop = false

    // Create, populate and connect signals of instructions for main function code area and store them in mainInstructionObjects.
    createInstructionObjects(mainInstructionObjects, items.background)

    if(items.currentLevelContainsProcedure) {
        if(!items.tutorialImage.shownProcedureTutorialInstructions) {
            items.tutorialImage.shownProcedureTutorialInstructions = true
            items.tutorialImage.visible = true
        }

        // Create procedure object in the main look-up table ,if the level has procedure, to execute it for procedure/loop calls from the main code area.
        createInstruction(mainInstructionObjects, CALL_PROCEDURE, items.background)

        // Create, populate and connect signals of instructions for procedure code area if the level has procedure.
        createInstructionObjects(procedureInstructionObjects, mainInstructionObjects[CALL_PROCEDURE])
    }

    if(items.currentLevelContainsLoop) {
        if(!items.tutorialImage.shownLoopTutorialInstructions) {
            items.tutorialImage.shownLoopTutorialInstructions = true
            items.tutorialImage.visible = true
        }

        if(resetTux) {
            loopsNumber = items.loopCounterSelection.loopNumber
        }

        createLoopObjectAndInstructions()
    }

    // Stores the co-ordinates of the tile blocks in the current level
    var currentLevelBlocksCoordinates = mazeBlocks[items.currentLevel].map

    items.mazeModel.model = currentLevelBlocksCoordinates

    if(!resetTux) {
        items.mainFunctionModel.clear()
        items.procedureModel.clear()
        items.numberOfInstructionsAdded = 0
        items.loopCounterSelection.loopNumber = loopsNumber;
    }

    stepX = items.mazeModel.itemAt(0).width
    stepY = items.mazeModel.itemAt(0).height

    items.instructionModel.clear()

    for (var i = 0; i < levelInstructions.length; i++)
        items.instructionModel.append({"name":levelInstructions[i]})

    // Center Tux in its first case
    items.player.x = currentLevelBlocksCoordinates[0].x * stepX + (stepX - items.player.width) / 2
    items.player.y = currentLevelBlocksCoordinates[0].y * stepY + (stepY - items.player.height) / 2
    items.player.rotation = EAST

    // Center fish at it's co-ordinate
    items.fish.x = mazeBlocks[items.currentLevel].fish.x * stepX + (stepX - items.fish.width) / 2
    items.fish.y = mazeBlocks[items.currentLevel].fish.y * stepY + (stepY - items.fish.height) / 2

    changedRotation = EAST
    deadEndPoint = false
    items.isRunCodeEnabled = true
    items.maxNumberOfInstructionsAllowed = mazeBlocks[items.currentLevel].maxNumberOfInstructions
    items.constraintInstruction.show()
    items.mainFunctionCodeArea.resetEditingValues()
    items.procedureCodeArea.resetEditingValues()
    items.background.areaWithKeyboardInput = items.instructionArea
    resetCodeAreasIndices()
    resetTux = false
    codeIterator = 0
}

function createLoopObjectAndInstructions() {
    // Create loop object in the main look-up table ,if the activity mode is loops, to execute it loops from the main code area.
    createInstruction(mainInstructionObjects, EXECUTE_LOOPS, items.background)

    // Create, populate and connect signals of instructions for loop code area itself.
    createInstructionObjects(loopInstructionObjects, mainInstructionObjects[EXECUTE_LOOPS])
}

function resetCodeAreasIndices() {
    items.instructionArea.currentIndex = -1
    items.mainFunctionCodeArea.currentIndex = -1
    items.procedureCodeArea.currentIndex = -1
    items.instructionArea.instructionToInsert = ''
}

function getPlayerRotation() {
    return ((changedRotation % 360) + 360) % 360
}

function runCode() {
    items.mainFunctionCodeArea.resetEditingValues()
    items.procedureCodeArea.resetEditingValues()

    var instructionName

    // Append all the procedure instructions to the procedure area object in basic mode.
    // Append all the loop instructions to the loop area object in loops mode.
    for(var j = 0; j < items.procedureModel.count; j++) {
        instructionName = items.procedureModel.get(j).name
        if(items.currentLevelContainsProcedure) {
            mainInstructionObjects[CALL_PROCEDURE].procedureCode.append({ "name" : instructionName })
        }
        else {
            mainInstructionObjects[EXECUTE_LOOPS].loopCode.append({ "name" : instructionName })
        }
    }

    items.isRunCodeEnabled = false
    if(items.mainFunctionModel.count > 0)
        executeNextInstruction()
    else
        deadEnd()
}

function executeNextInstruction() {
    if((codeIterator < items.mainFunctionModel.count) && !deadEndPoint) {
        items.mainFunctionCodeArea.currentIndex += 1
        var instructionToExecute = items.mainFunctionModel.get(codeIterator).name
        mainInstructionObjects[instructionToExecute].checkAndExecuteMovement()
    }
}

function deadEnd() {
    deadEndPoint = true
    items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/brick.wav")
    items.bonus.bad("tux")
}

function resetTuxPosition() {
    resetTux = true
    if(!items.activityStopped) {
        initLevel()
    }
}

function checkSuccessAndExecuteNextInstruction() {
    var fishX = mazeBlocks[items.currentLevel].fish.x
    var fishY = mazeBlocks[items.currentLevel].fish.y

    var tuxX = Math.floor(items.player.playerCenterX / stepX)
    var tuxY = Math.floor(items.player.playerCenterY / stepY)

    if(tuxX === fishX && tuxY === fishY) {
        codeIterator = 0
        items.bonus.good("tux")
    }
    else if(codeIterator === (items.mainFunctionModel.count - 1)) {
        deadEnd()
    }
    else {
        codeIterator++
        executeNextInstruction()
    }
}

function nextLevel() {
    resetTux = false
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    resetTux = false
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function repositionObjectsOnWidthChanged(factor) {
    resetTux = true
    if(items && !items.activityStopped)
        initLevel()
}

function repositionObjectsOnHeightChanged(factor) {
    resetTux = true
    if(items && !items.activityStopped)
        initLevel()
}

function reloadLevel() {
    resetTux = false
    initLevel()
}
