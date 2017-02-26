/* GCompris - ascending_order.js
 *
 * Copyright (C) 2016 Rudra Nil Basu <rudra.nil.basu.1996@gmail.com>
 *
 * Authors:
 *   Rudra Nil Basu <rudra.nil.basu.1996@gmail.com> (Qt Quick port)
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
var currentSubLevel = 0
var numberOfSubLevel = 3
var items

// num[] will contain the random numbers
var num = []
var originalArrangement = []

var thresholdDistance
var noOfTilesInPreviousLevel

function start(items_) {
    items = items_
    currentLevel = 0
    items.validMousePress = false

    noOfTilesInPreviousLevel = -1
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    initGrids()
}

function initGrids() {
    items.boxes.model = 2*(items.bar.level)+1

    if(noOfTilesInPreviousLevel != items.boxes.model) {
        /*
         * When the tiles don't automatically rearrange themself
         * manually check the marker off
         */
        items.flow.animationCheck = 0
        noOfTilesInPreviousLevel = items.boxes.model
    } else {
        restoreGrids()
    }

    generateRandomNumbers()

    for(var i=0;i<items.boxes.model;i++) {
        items.boxes.itemAt(i).imageX=num[i]
    }
}

function generateRandomNumbers() {
    var n = items.boxes.model
    // generate n random numbers and store it in num[]
    num = []
    var upperBound = (items.bar.level)*100
    while(num.length < n) {
        var randomNumber=Math.ceil(Math.random()*upperBound)
        if(num.indexOf(randomNumber) > -1) {
            continue;
        }
        num[num.length]=randomNumber
    }
    for(var i=0;i<num.length;i++) {
        originalArrangement[i] = num[i]
    }
}

function restoreGrids() {
    /* Restore the grid positions */
    /*
     * To make sure that the flow is properly indexed
     * before moving on to the next sub level.
     * This is required since if the previous level and
     * current level has the same number of tiles, the
     * indices are not automatically rearranged
     */
    for(var i=0;i<items.boxes.model;i++) {
        if(num[i] === originalArrangement[i]) {
            continue
        }
        var currentBlock = findBlockWithLabel(originalArrangement[i])
        var finalPosition = findBlockWithLabel(num[i])
        currentBlock.x = finalPosition.x
        currentBlock.y = finalPosition.y
    }
}

function nextLevel() {
    if(numberOfSubLevel <= ++currentSubLevel) {
        if(numberOfLevel <= ++currentLevel) {
            currentLevel = 0
        }
        currentSubLevel = 0
    }
    initLevel();
}

function previousLevel() {
    if(--currentSubLevel <0) {
        currentSubLevel = numberOfSubLevel-1
        if(--currentLevel <0) {
            currentLevel = numberOfLevel - 1
        }
    }
    initLevel();
}

function checkOrder() {
    for(var i=0;i<items.boxes.count-1;i++) {
        if(num[i] > num[i+1]) {
            items.bonus.bad("lion")
            return
        }
    }
    items.bonus.good("lion")
}

function placeBlock(box, initialPosition) {
    /*
     * find shortest distance from box to other nodes
     * if distance <= threshold distance then put box
     * in that block and that block in "initialPosition"
     */
    thresholdDistance = 4000 * items.boxes.itemAt(0).screen_ratio
    var minDistance = Number.POSITIVE_INFINITY
    var closestBlock
    for(var i=0;i<items.boxes.model;i++) {
        var currentBlock=items.boxes.itemAt(i)
        if(currentBlock.imageX === box.imageX) {
            continue
        } else {
            var blockDistance = distance(box, currentBlock)
            if( blockDistance < minDistance ) {
                minDistance = blockDistance
                closestBlock = currentBlock
            }
        }
    }

    if(minDistance<thresholdDistance) {

        var item1Pos = num.indexOf(box.imageX)
        var item2Pos = num.indexOf(closestBlock.imageX)

        var oldPositions = []
        var newPositions = []

        for(var i=0;i<num.length;i++) {
            oldPositions[i]=num[i]
            newPositions[i]=num[i]
        }

        if(item1Pos>item2Pos) {
            // update new position
            var currentBoxValue = newPositions[item1Pos]
            for(var i=item1Pos;i>item2Pos;i--) {
                newPositions[i]=newPositions[i-1]
            }
            newPositions[item2Pos]=currentBoxValue
        } else {
            // update new position
            var currentBoxValue = newPositions[item1Pos]
            for(var i=item1Pos;i<item2Pos;i++) {
                newPositions[i]=newPositions[i+1];
            }
            newPositions[item2Pos]=currentBoxValue
        }
        rearrange(oldPositions, newPositions, box, initialPosition)
        for(var i=0;i<num.length;i++) {
            num[i]=newPositions[i]
        }
    } else {
        box.x=initialPosition.x
        box.y=initialPosition.y
    }
}

function rearrange(oldPositions, newPositions, movingBlock, initialPosition) {
    for(var i=0;i<newPositions.length;i++) {
        if(oldPositions[i] === newPositions[i]) {
            continue
        }
        var currentBlock = findBlockWithLabel(newPositions[i])
        var finalPosition = findBlockWithLabel(oldPositions[i])
        if(finalPosition.imageX == movingBlock.imageX) {
            currentBlock.x=initialPosition.x
            currentBlock.y=initialPosition.y
        } else {
            currentBlock.x = finalPosition.x
            currentBlock.y = finalPosition.y
        }
    }
}

function findBlockWithLabel(label) {
    for(var i=0;i<items.boxes.model;i++) {
        if(items.boxes.itemAt(i).imageX == label) {
            return items.boxes.itemAt(i)
        }
    }
}

function distance(box, currentBlock) {
    return Math.pow((box.x-currentBlock.x),2) + Math.pow((box.y-currentBlock.y),2)
}
