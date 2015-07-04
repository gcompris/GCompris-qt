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

    items.player.x = initialX
    items.player.y = initialY
    items.fish.x = mazeBlocks[currentLevel][countOfMazeBlocks -1][0] * stepX
    items.fish.y = mazeBlocks[currentLevel][countOfMazeBlocks -1][1] * stepY
    tuxIceBlockNumber = 0

    items.player.init()
}

function runCode() {

    //initiallize back to starting position and code
    playerCode = []
    items.player.x = initialX
    items.player.y = initialY

    for(var i = 0; i < items.answerModel.count; i++) {
        playerCode.push(items.answerModel.get([i]).name)
    }

    for( var j = 0; j < playerCode.length; j++) {
        currentInstruction = playerCode[j]
//        console.log(j +"th" +" tuxIceBlockNumber "+tuxIceBlockNumber +
//                    " x: " +items.player.x +" y: "+items.player.y)

        currentBlock = tuxIceBlockNumber % mazeBlocks[currentLevel].length
        nextBlock = (tuxIceBlockNumber + 1) % mazeBlocks[currentLevel].length
        currentX = mazeBlocks[currentLevel][currentBlock][0]
        currentY = mazeBlocks[currentLevel][currentBlock][1]
        nextX = mazeBlocks[currentLevel][nextBlock][0]
        nextY = mazeBlocks[currentLevel][nextBlock][1]

        if ( currentInstruction == "Move Forward") {

            if (nextX - currentX > 0) {
                items.player.x = mazeBlocks[currentLevel][currentBlock][0] *
                        stepX +
                        stepX
            }
            else if(nextX - currentX < 0){
                items.player.x = mazeBlocks[currentLevel][currentBlock][0] *
                        stepX -
                        stepX
            }

            if (nextY - currentY < 0) {
                items.player.y = mazeBlocks[currentLevel][currentBlock][1] *
                        stepY +
                        stepY
            }
            else if (nextY - currentY > 0 ) {
                items.player.y = mazeBlocks[currentLevel][currentBlock][1] *
                        stepY -
                        stepY
            }
            ++tuxIceBlockNumber;
        }

        if ( currentInstruction == "Turn Left") {
            items.player.rotation -= 90
        }
        if ( currentInstruction == "Turn Right") {
            items.player.rotation += 90
        }

        if(items.player.x == items.fish.x && items.player.y == items.fish.y){
            items.bonus.good("smiley")
        }
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

