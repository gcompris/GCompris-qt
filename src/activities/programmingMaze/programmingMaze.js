/* GCompris - programmingMaze.js
 *
 * Copyright (C) 2014 <Siddhesh Suthar>
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

var currentLevel = 0
var numberOfLevel = 4
var items
var reverseCountUrl = "qrc:/gcompris/src/activities/reversecount/resource/"
var mazeBlocks = [
            [[1,2],[2,2],[3,2]],
            [[1,3],[2,3],[2,2],[2,1],[3,1]],
            [[1,1],[2,1],[3,1],[3,2],[3,3],[2,3],[1,3]],
            [[0,3],[1,3],[1,2],[2,2],[2,1],[3,1]]
        ]
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
var flag = 0
var j =0
//var busy = false

function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    items.mazeModel.model = mazeBlocks[currentLevel]
    items.answerModel.clear()
    countOfMazeBlocks = mazeBlocks[currentLevel].length

    stepX = items.background.width / 8
    stepY = (items.background.height - items.background.height/8) / 8
    initialX = mazeBlocks[currentLevel][0][0] * stepX
    initialY = mazeBlocks[currentLevel][0][1] * stepY

//    busy = false
    items.player.tuxIsBusy = false
    j = 0
    playerCode = []

    items.player.x = initialX
    items.player.y = initialY
    items.fish.x = mazeBlocks[currentLevel][countOfMazeBlocks -1][0] * stepX
    items.fish.y = mazeBlocks[currentLevel][countOfMazeBlocks -1][1] * stepY
    tuxIceBlockNumber = 0
    currentRotation = -90
    changedRotation = -90
    flag = 0

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

    //initiallize back to starting position and code
    playerCode = []
    items.player.tuxIsBusy = false
    for(var i = 0; i < items.answerModel.count; i++) {
        playerCode.push(items.answerModel.get([i]).name)
    }

    if(!items.player.tuxIsBusy) {
        executeNextInstruction()
    }
}


function playerRunningChanged() {

    if(!items.player.tuxIsBusy) {
        if(flag == 1) {
            deadEnd()
        }
        executeNextInstruction()
    }
}

function executeNextInstruction() {
    if(!items.player.tuxIsBusy && j < playerCode.length ) {
        changedX = items.player.x
        changedY = items.player.y
        currentRotation = getPlayerRotation()

        currentInstruction = playerCode[j]
        console.log(j + " executing next " +currentInstruction)
        currentBlock = tuxIceBlockNumber
        nextBlock = tuxIceBlockNumber + 1
        currentX = mazeBlocks[currentLevel][currentBlock][0]
        currentY = mazeBlocks[currentLevel][currentBlock][1]
        nextX = mazeBlocks[currentLevel][nextBlock][0]
        nextY = mazeBlocks[currentLevel][nextBlock][1]

        if ( currentInstruction == "Move Forward") {
            ++tuxIceBlockNumber;
            if (nextX - currentX > 0 && currentRotation == 270) {  //EAST 270
                changedX = currentX * stepX + stepX
                console.log("moving forward emitting the signal")
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
                console.log("moving forward emitting the signal")
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
                flag = 1
                items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/brick.wav")
                console.log("dead end")
                return
            }
        }

        else if ( currentInstruction == "Turn Left") {
            changedRotation = (currentRotation - 90) % 360
            //        console.log("turning left")
            items.player.rotation = changedRotation
        }
        else if ( currentInstruction == "Turn Right") {
            changedRotation = (currentRotation + 90) % 360
            items.player.rotation = changedRotation
        }
        j = j + 1
//        busy = true
        items.player.tuxIsBusy = true
        checkSuccess()
    }
}

function deadEnd() {
    playerCode = []
    j =0
    items.player.tuxIsBusy = false
    console.log("ending")
}

function checkSuccess() {
    if(changedX === items.fish.x && changedY === items.fish.y){
        console.log("success")
        playerCode = []
        j = 0
//        busy = false
        items.player.tuxIsBusy = false
        items.bonus.good("smiley")
    }
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel ) {
        currentLevel = 0
    }
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel();
}

function repositionObjectsOnWidthChanged(factor) {
    if(items)
        initLevel()
}

function repositionObjectsOnHeightChanged(factor) {
    if(items)
        initLevel()
}

