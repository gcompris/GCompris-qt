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
.import "qrc:/gcompris/src/core/core.js" as Core

var mazeBlocks = [
            //level one
            [
                //maze blocks
                [[1,2],[2,2],[3,2]],
                //fish index
                [[3,2]],
                //instruction set
                [qsTr("move-forward"),
                 qsTr("turn-left"),
                 qsTr("turn-right")]
            ],
            //level two
            [
                [[1,3],[2,3],[2,2],[2,1],[3,1]],
                //fish index
                [[3,1]],
                //instruction set
                [qsTr("move-forward"),
                 qsTr("turn-left"),
                 qsTr("turn-right")]
            ],
            //level three
            [
                [[1,1],[2,1],[3,1],[3,2],[3,3],[2,3],[1,3]],
                [[1,3]],
                //instruction set
                [qsTr("move-forward"),
                 qsTr("turn-left"),
                 qsTr("turn-right"),
                 qsTr("call-procedure")]
            ],
            //level four
            [
                [[0,3],[1,3],[1,2],[2,2],[2,1],[3,1]],
                [[3,1]],
                //instruction set
                [qsTr("move-forward"),
                 qsTr("turn-left"),
                 qsTr("turn-right"),
                 qsTr("call-procedure")]
            ],
            //level five
            [
                [[0,3],[0,2],[0,1],[0,0],[1,0],[2,0],[2,1],
                 [2,2],[2,3],[3,3],[4,3],[4,2],[4,1],[4,0]],
                [[4,0]],
                //instruction set
                [qsTr("move-forward"),
                 qsTr("turn-left"),
                 qsTr("turn-right"),
                 qsTr("call-procedure")]
            ]
        ]
//[1,3],[2,3],[2,2],[2,1],[3,1]
//[1,1],[2,1],[3,1],[3,2],[3,3],[2,3],[1,3]
//[0,3],[1,3],[1,2],[2,2],[2,1],[3,1]
var countOfMazeBlocks
var initialX
var initialY
var stepX
var stepY
var playerCode = []
var currentInstruction
var tuxIceBlockNumber
var currentBlock
var nextBlock
var currentX
var currentY
var nextX
var nextY
var changedX
var changedY
var currentRotation
var changedRotation
var deadEndPoint = 0
var j = 0
var reset = 0
var blocksDataIndex = 0
var blocksFishIndex = 1
var blocksInstructionIndex = 2
var levelInstructions
var moveForward
var turnLeft
var turnRight
var callProcedure
var endProcedure
var procedureBlocks
var runningProcedure
var moveAnimDuration
var url = "qrc:/gcompris/src/activities/programmingMaze/resource/"
var reverseCountUrl = "qrc:/gcompris/src/activities/reversecount/resource/"
var okImage = "qrc:/gcompris/src/core/resource/bar_ok.svg"
var reloadImage = "qrc:/gcompris/src/core/resource/bar_reload.svg"
var currentLevel = 0
var numberOfLevel = 5
var items

function start(items_) {
    items = items_
    currentLevel = 0
    numberOfLevel = 5
    reset = 0
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    items.mazeModel.model = mazeBlocks[currentLevel][blocksDataIndex]

    if(!reset && !deadEndPoint) {
        items.answerModel.clear()
        items.procedureModel.clear()
    }
    countOfMazeBlocks = mazeBlocks[currentLevel][blocksDataIndex].length

    stepX = items.background.width / 10
    stepY = (items.background.height - items.background.height/10) / 10
    initialX = mazeBlocks[currentLevel][blocksDataIndex][0][0] * stepX
    initialY = mazeBlocks[currentLevel][blocksDataIndex][0][1] * stepY

    items.instructionModel.clear()
    levelInstructions = mazeBlocks[currentLevel][blocksInstructionIndex]
    for (var i = 0; i < levelInstructions.length ; i++) {
        items.instructionModel.append({"name":levelInstructions[i]});
        if(levelInstructions[i] == "call-procedure")
            callProcedure = levelInstructions[i]
        if(levelInstructions[i] == "end-procedure")
            endProcedure = levelInstructions[i]
        if(levelInstructions[i] == "move-forward")
            moveForward = levelInstructions[i]
        if(levelInstructions[i] == "turn-left")
            turnLeft = levelInstructions[i]
        if(levelInstructions[i] == "turn-right")
            turnRight = levelInstructions[i]
    }

    items.player.x = initialX
    items.player.y = initialY
    items.fish.x = mazeBlocks[currentLevel][blocksFishIndex][0][0] * stepX
    items.fish.y = mazeBlocks[currentLevel][blocksFishIndex][0][1] * stepY
    tuxIceBlockNumber = 0
    currentRotation = -90
    changedRotation = -90
    deadEndPoint = 0
    procedureBlocks = 0
    runningProcedure = false
    moveAnimDuration = 1000
    items.background.moveAnswerCell = false
    items.background.moveProcedureCell = false
    items.background.insertIntoMain = true
    items.background.insertIntoProcedure = false
    items.answerSheet.highlightMoveDuration = moveAnimDuration
    items.procedure.highlightMoveDuration = moveAnimDuration
    items.runCodeImage = okImage
    items.player.tuxIsBusy = false
    j = 0
    playerCode = []

    items.player.init()
}

/* 0= SOUTH
* 90= WEST
* 180 = NORTH
* 270 =EAST
*/
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
        //initiallize code
        playerCode = []
        items.player.tuxIsBusy = false
        procedureBlocks = items.procedureModel.count
        for(var i = 0; i < items.answerModel.count; i++) {
            if(items.answerModel.get([i]).name == callProcedure) {
                playerCode.push("start-procedure")
                for(var j =0; j < items.procedureModel.count; j++){
                    if(items.procedureModel.get([j]).name != endProcedure)
                        playerCode.push(items.procedureModel.get([j]).name)
                }
                playerCode.push("end-procedure")
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
        if(deadEndPoint == 1)
            console.log("it was a dead end")
        else{
           executeNextInstruction()
        }
    }
}

function executeNextInstruction() {
    currentInstruction = playerCode[j]
    if(!items.player.tuxIsBusy && j < playerCode.length && deadEndPoint == 0
            && currentInstruction != "start-procedure" && currentInstruction != "end-procedure") {
//        console.log("current instruction "+currentInstruction)
        changedX = items.player.x
        changedY = items.player.y
        currentRotation = getPlayerRotation()

        currentBlock = tuxIceBlockNumber
        nextBlock = tuxIceBlockNumber + 1
        currentX = mazeBlocks[currentLevel][blocksDataIndex][currentBlock][0]
        currentY = mazeBlocks[currentLevel][blocksDataIndex][currentBlock][1]
        nextX = mazeBlocks[currentLevel][blocksDataIndex][nextBlock][0]
        nextY = mazeBlocks[currentLevel][blocksDataIndex][nextBlock][1]

        if ( currentInstruction == moveForward) {
            ++tuxIceBlockNumber;
            items.background.moveAnswerCell = true
//            items.background.moveProcedureCell = true
            items.answerSheet.highlightMoveDuration = moveAnimDuration
            items.procedure.highlightMoveDuration = moveAnimDuration
            if (nextX - currentX > 0 && currentRotation == 270) {  //EAST 270
                changedX = currentX * stepX + stepX
                //                console.log("moving forward emitting the signal")
                items.player.x = changedX
                items.player.y = changedY
            }
            else if(nextX - currentX < 0 && currentRotation == 90){ //WEST 90
                changedX = currentX * stepX - stepX
                items.player.x = changedX
                items.player.y = changedY
            }
            else if (nextY - currentY < 0 && currentRotation == 180) { //NORTH 0
                changedY = currentY * stepY - stepY
                items.player.x = changedX
                items.player.y = changedY

            }
            else if (nextY - currentY > 0 && currentRotation == 0) { //SOUTH 180
                changedY = currentY * stepY + stepY
                items.player.x = changedX
                items.player.y = changedY
            }
            else {
                // add an animation to indicate that its not possible
                deadEndPoint = 1
                items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/brick.wav")
                console.log("dead end")
                deadEnd()
            }
        }

        else if ( currentInstruction == turnLeft) {
            changedRotation = (currentRotation - 90) % 360
            items.player.rotation = changedRotation
            items.background.moveAnswerCell = true
//            items.background.moveProcedureCell = true
            items.answerSheet.highlightMoveDuration = moveAnimDuration / 2
            items.procedure.highlightMoveDuration = moveAnimDuration / 2
        }
        else if ( currentInstruction == turnRight) {
            changedRotation = (currentRotation + 90) % 360
            items.background.moveAnswerCell = true
//            items.background.moveProcedureCell = true
            items.player.rotation = changedRotation
            items.answerSheet.highlightMoveDuration = moveAnimDuration / 2
            items.procedure.highlightMoveDuration = moveAnimDuration / 2
        }

        j = j + 1
        items.player.tuxIsBusy = true
        if(runningProcedure && procedureBlocks > 0
                && currentInstruction != "start-procedure" && currentInstruction != "end-procedure") {
            procedureBlocks--
            items.procedure.moveCurrentIndexRight()
        }
        if(!runningProcedure
                && currentInstruction != "start-procedure" && currentInstruction != "end-procedure") {
            items.answerSheet.moveCurrentIndexRight()
        }
        checkSuccess()
    }
    if(currentInstruction == "start-procedure") {
        runningProcedure = true
        items.background.moveProcedureCell = true
        items.background.moveAnswerCell = false
        j = j + 1
        executeNextInstruction()
    }
    else if(currentInstruction == "end-procedure") {
        runningProcedure = false
        procedureBlocks = items.procedureModel.count
        items.background.moveProcedureCell = false
        items.background.moveAnswerCell  =true
        j = j + 1
        executeNextInstruction()
    }

    //    items.player.tuxIsBusy = true
}

function deadEnd() {
    deadEndPoint = 1
    items.runCodeImage = reloadImage
//    initLevel();
}

function checkSuccess() {
    if(changedX === items.fish.x && changedY === items.fish.y){
        console.log("success")
        playerCode = []
        j = 0
        items.player.tuxIsBusy = false
        items.bonus.good("smiley")
    }
}

function nextLevel() {
    reset = 0
    if(numberOfLevel <= ++currentLevel ) {
        currentLevel = 0
    }
    initLevel();
}

function previousLevel() {
    reset = 0
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel();
}

function repositionObjectsOnWidthChanged(factor) {
    reset = 1
    if(items)
        initLevel()
}

function repositionObjectsOnHeightChanged(factor) {
    reset = 1
    if(items)
        initLevel()
}

