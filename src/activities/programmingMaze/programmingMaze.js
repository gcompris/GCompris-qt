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

var mazeBlocks = [
            //level one
            [
                //maze blocks
                [[1,2],[2,2],[3,2]],
                //fish index
                [[3,2]],
                //instruction set
                ["move-forward",
                 "turn-left",
                 "turn-right"]
            ],
            //level two
            [
                [[1,3],[2,3],[2,2],[2,1],[3,1]],
                //fish index
                [[3,1]],
                //instruction set
                ["move-forward",
                 "turn-left",
                 "turn-right"]
            ],
            //level three
            [
                [[1,1],[2,1],[3,1],[3,2],[3,3],[2,3],[1,3]],
                [[1,3]],
                //instruction set
                ["move-forward",
                 "turn-left",
                 "turn-right",
                 "call-procedure"]
            ],
            //level four
            [
                [[0,3],[1,3],[1,2],[2,2],[2,1],[3,1]],
                [[3,1]],
                //instruction set
                ["move-forward",
                 "turn-left",
                 "turn-right",
                 "call-procedure"]
            ],
            //level five
            [
                [[0,3],[0,2],[0,1],[0,0],[1,0],[2,0],[2,1],
                 [2,2],[2,3],[3,3],[4,3],[4,2],[4,1],[4,0]],
                [[4,0]],
                //instruction set
                ["move-forward",
                 "turn-left",
                 "turn-right",
                 "call-procedure"]
            ]
        ]
//[1,3],[2,3],[2,2],[2,1],[3,1]
//[1,1],[2,1],[3,1],[3,2],[3,3],[2,3],[1,3]
//[0,3],[1,3],[1,2],[2,2],[2,1],[3,1]
var countOfMazeBlocks
var stepX
var stepY
var playerCode = []
var currentInstruction
var tuxIceBlockNumber
var changedX
var changedY
var currentRotation
var changedRotation
var deadEndPoint = false
var codeIterator = 0
var reset = false
var procedureBlocks
var runningProcedure
var moveAnimDuration
var url = "qrc:/gcompris/src/activities/programmingMaze/resource/"
var reverseCountUrl = "qrc:/gcompris/src/activities/reversecount/resource/"
var okImage = "qrc:/gcompris/src/core/resource/bar_ok.svg"
var reloadImage = "qrc:/gcompris/src/core/resource/bar_reload.svg"
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

var MOVE_FORWARD = "move-forward"
var TURN_LEFT = "turn-left"
var TURN_RIGHT = "turn-right"
var CALL_PROCEDURE = "call-procedure"
var END_PROCEDURE = "end-procedure"

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
    items.mazeModel.model = mazeBlocks[currentLevel][BLOCKS_DATA_INDEX]

    if(!reset && !deadEndPoint) {
        items.answerModel.clear()
        items.procedureModel.clear()
    }
    countOfMazeBlocks = mazeBlocks[currentLevel][BLOCKS_DATA_INDEX].length

    stepX = items.background.width / 10
    stepY = (items.background.height - items.background.height/10) / 10

    items.instructionModel.clear()
    var levelInstructions = mazeBlocks[currentLevel][BLOCKS_INSTRUCTION_INDEX]
    for (var i = 0; i < levelInstructions.length ; i++) {
        items.instructionModel.append({"name":levelInstructions[i]});
    }

    items.player.x = mazeBlocks[currentLevel][BLOCKS_DATA_INDEX][0][0] * stepX
    items.player.y = mazeBlocks[currentLevel][BLOCKS_DATA_INDEX][0][1] * stepY
    items.fish.x = mazeBlocks[currentLevel][BLOCKS_FISH_INDEX][0][0] * stepX
    items.fish.y = mazeBlocks[currentLevel][BLOCKS_FISH_INDEX][0][1] * stepY
    tuxIceBlockNumber = 0
    currentRotation = EAST
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
        for(var i = 0; i < items.answerModel.count; i ++) {
            if(items.answerModel.get([i]).name == CALL_PROCEDURE) {
                playerCode.push("start-procedure")
                for(var j = 0; j < items.procedureModel.count; j++) {
                    if(items.procedureModel.get([j]).name != END_PROCEDURE)
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
        if(deadEndPoint) {
            console.log("it was a dead end")
        }
        else{
           executeNextInstruction()
        }
    }
}

function executeNextInstruction() {
    currentInstruction = playerCode[codeIterator]

    if(!items.player.tuxIsBusy && codeIterator < playerCode.length && !deadEndPoint
            && currentInstruction != "start-procedure" && currentInstruction != "end-procedure") {
        changedX = items.player.x
        changedY = items.player.y
        currentRotation = getPlayerRotation()

        var currentBlock = tuxIceBlockNumber
        var nextBlock = tuxIceBlockNumber + 1

        var currentX = mazeBlocks[currentLevel][BLOCKS_DATA_INDEX][currentBlock][0]
        var currentY = mazeBlocks[currentLevel][BLOCKS_DATA_INDEX][currentBlock][1]
        var nextX = mazeBlocks[currentLevel][BLOCKS_DATA_INDEX][nextBlock][0]
        var nextY = mazeBlocks[currentLevel][BLOCKS_DATA_INDEX][nextBlock][1]

        if(currentInstruction == MOVE_FORWARD) {
            ++tuxIceBlockNumber;
            items.answerSheet.highlightMoveDuration = moveAnimDuration
            items.procedure.highlightMoveDuration = moveAnimDuration
            if (nextX - currentX > 0 && currentRotation == EAST) {
                changedX = currentX * stepX + stepX
            }
            else if(nextX - currentX < 0 && currentRotation == WEST) {
                changedX = currentX * stepX - stepX
            }
            else if(nextY - currentY < 0 && currentRotation == SOUTH) {
                changedY = currentY * stepY - stepY
            }
            else if(nextY - currentY > 0 && currentRotation == NORTH) {
                changedY = currentY * stepY + stepY
            }
            else {
                // add an animation to indicate that its not possible
                deadEndPoint = true
                items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/brick.wav")
                console.log("dead end")
                deadEnd()
            }
            items.player.x = changedX
            items.player.y = changedY
        }
        else if(currentInstruction == TURN_LEFT) {
            changedRotation = (currentRotation - 90) % 360
            items.player.rotation = changedRotation
            items.answerSheet.highlightMoveDuration = moveAnimDuration / 2
            items.procedure.highlightMoveDuration = moveAnimDuration / 2
        }
        else if(currentInstruction == TURN_RIGHT) {
            changedRotation = (currentRotation + 90) % 360
            items.player.rotation = changedRotation
            items.answerSheet.highlightMoveDuration = moveAnimDuration / 2
            items.procedure.highlightMoveDuration = moveAnimDuration / 2
        }

        codeIterator = codeIterator + 1
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
    else if(currentInstruction == "start-procedure") {
        runningProcedure = true
        items.answerSheet.currentIndex += 1
        items.procedure.currentIndex = -1
        codeIterator = codeIterator + 1
        executeNextInstruction()
    }
    else if(currentInstruction == "end-procedure") {
        runningProcedure = false
        procedureBlocks = items.procedureModel.count
        codeIterator = codeIterator + 1
        executeNextInstruction()
    }
}

function deadEnd() {
    deadEndPoint = true
    items.runCodeImage = reloadImage
}

function checkSuccess() {
    if(changedX === items.fish.x && changedY === items.fish.y) {
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
