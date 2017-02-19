/* GCompris - ascending_order.js
 *
 * Copyright (C) 2016 Rudra Nil Basu <rudra.nil.basu.1996@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
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
var items

// num[] will contain the random numbers
var num=[]
var hash=[] // hash[i]=1 => ith grid is already pressed. =0 => it is not yet pressed
var entered=[] // the numbers entered by the user

var initColor = "#FFFFFF"
var visitedColor="#7CFC00"

var numEntered // the number of numbers entered by the user


var thresholdDistance = 8000
/*
var isSelected = false
var alreadySelectedBox
*/

/*
var xPos=[]
var yPos=[]
*/

function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    numEntered=0
    items.ansText.text=""
    initGrids()
}

function initGrids() {
    items.boxes.model = 2*(items.bar.level)+1

    generateRandomNumbers()

    hash=[]
    entered=[]
    for(var i=0;i<items.boxes.model;i++) {
        items.boxes.itemAt(i).imageX=num[i]
//        items.boxes.itemAt(i).color=initColor
        hash[i]=0
    }
    alignFlow()
}

function generateRandomNumbers() {
    var n=items.boxes.model
    // generate n random numbers and store it in num[]
    num=[]
    var upperBound = (items.bar.level)*100
    while(num.length < n) {
        var randomNumber=Math.ceil(Math.random()*upperBound)
        if(num.indexOf(randomNumber) > -1) {
            continue;
        }
        num[num.length]=randomNumber
    }
}

function alignFlow() {
    // count no of elements present in the first row
    var noOfElements = 0
    for(var i=0;i<items.boxes.model;i++) {
        if(items.boxes.itemAt(i).y === 0) {
            noOfElements++
        } else {
            break
        }
    }
    // calculate width of the flow
    var width = (items.boxes.itemAt(0).width * noOfElements) + (noOfElements-1)*items.flow.spacing
    items.container.width = width
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

/*
function check(currentNum) {
    for(var i=0;i<items.boxes.model;i++) {
        if(items.boxes.itemAt(i).imageX ==currentNum) {
            if(hash[i]===1) {
                continue
            } else {

                items.boxes.itemAt(i).color=visitedColor
                hash[i]=1
                entered[numEntered++]=currentNum
                if(numEntered===num.length) {
                    items.ansText.text=items.ansText.text.concat(currentNum.toString(), " .")
                    result()
                } else {
                    items.ansText.text=items.ansText.text.concat(currentNum.toString(), ", ")
                }
            }
        }
    }
}
*/

/*
function selectBox(box) {
    if(!isSelected) {
        alreadySelectedBox = box
        isSelected = true
        box.selected = true
    } else {
        if(box != alreadySelectedBox) {
            var x = alreadySelectedBox.x
            var y = alreadySelectedBox.y
            alreadySelectedBox.x = box.x
            alreadySelectedBox.y = box.y
            box.x = x
            box.y = y



            if(box.x === alreadySelectedBox.x) {
                box.pos = 1
                alreadySelectedBox.pos = 2

                box.currentPos = box.x
                alreadySelectedBox.currentPos = box.x

                box.animateHor = !box.animateHor
                alreadySelectedBox.animateHor = !alreadySelectedBox.animateHor
            } else if(box.y === alreadySelectedBox.y) {
                console.log(box.x+","+box.y)
                console.log(alreadySelectedBox.x+","+alreadySelectedBox.y)

                box.pos = 1
                alreadySelectedBox.pos = 2

                box.currentPos = box.y
                alreadySelectedBox.currentPos = box.y

                box.animateVert = !box.animateVert
                alreadySelectedBox.animateVert = !alreadySelectedBox.animateVert

                console.log(box.currentPos+","+alreadySelectedBox.currentPos)
            }



            var item1Pos = num.indexOf(box.imageX)
            var item2Pos = num.indexOf(alreadySelectedBox.imageX)
            var intermidiateValue = num[item1Pos]
            num[item1Pos] = num[item2Pos]
            num[item2Pos] = intermidiateValue

            alreadySelectedBox.selected = false

            isSelected = false
        }
    }
}
*/

function checkOrder() {
    /*
    for(var i=0;i<items.boxes.count;i++) {console.log(num[i])}
    console.log("-----------")
    */
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
    for(var i=0;i<items.boxes.model;i++) {
        xPos[i]=items.boxes.itemAt(i).x
        yPos[i]=items.boxes.itemAt(i).y
    }
    */
    // find shortest distance from box to other nodes
    // if distance <= threshold distance then put box
    // in that block and that block in "initialPosition"
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
    /*
    console.log("closest block:"+closestBlock.imageX)
    console.log("min distance: "+minDistance)
    */

    if(minDistance<thresholdDistance) {
        /*
        box.x=closestBlock.x
        box.y=closestBlock.y

        closestBlock.x=initialPosition.x
        closestBlock.y=initialPosition.y
        */

        var item1Pos = num.indexOf(box.imageX)
        var item2Pos = num.indexOf(closestBlock.imageX)
//        console.log(item1Pos+","+item2Pos)
        /*
        var intermidiateValue = num[item1Pos]
        num[item1Pos] = num[item2Pos]
        num[item2Pos] = intermidiateValue
        */
        if(item1Pos>item2Pos) {
            /*
            // dragged box is present *after* the new position
            box.x=closestBlock.x
            box.y=closestBlock.y
            for(var i=item2Pos;i<item1Pos-1;i++) {
                items.boxes.itemAt(i).x=items.boxes.itemAt(i+1).x
                items.boxes.itemAt(i).y=items.boxes.itemAt(i+1).y
            }
            items.boxes.itemAt(item1Pos-1).x = initialPosition.x
            items.boxes.itemAt(item1Pos-1).y = initialPosition.y
            // updating num[]
            var currentBoxValue=num[item1Pos]
            for(var i=item2Pos;i<item1Pos;i++) {
                num[i+1]=num[i]
            }
            num[item2Pos]=currentBoxValue
            // updating the index
            for(var i=0;i<items.boxes.model;i++) {
                items.boxes.itemAt(i).index = num.indexOf(items.boxes.itemAt(i).imageX)
            }
            */
            /*
            var oldPositions = num
            var newPositions = num
            */
            var oldPositions = []
            var newPositions = []
            for(var i=0;i<num.length;i++) {
                oldPositions[i]=num[i]
                newPositions[i]=num[i]
            }
            // update new position
//            console.log(newPositions)
            var currentBoxValue = newPositions[item1Pos]
            for(var i=item1Pos;i>item2Pos;i--) {
                newPositions[i]=newPositions[i-1]
            }
            newPositions[item2Pos]=currentBoxValue
//            console.log(newPositions)
            /*
            rearrange(oldPositions, newPositions, box, initialPosition)
            for(var i=0;i<num.length;i++) {
                num[i]=newPositions[i]
            }
            */
        } else {
            var oldPositions = []
            var newPositions = []
            for(var i=0;i<num.length;i++) {
                oldPositions[i]=num[i]
                newPositions[i]=num[i]
            }
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

/*
function result() {
    for(var i=0;i<entered.length-1;i++) {
        if(Number(entered[i])>Number(entered[i+1])) {
            //WRONG answer
            items.ok.visible=true
            items.ansText.text=items.ansText.text.concat("\n")
            printSorted()
            items.bonus.bad("lion")
            return
        }
    }
    // CORRECT answer
    items.bonus.good("lion")
}
*/

/*
function printSorted() {
    for(var i=0;i<entered.length-1;i++) {
        for(var j=0;j<entered.length-i-1;j++) {
            if(Number(entered[j]>Number(entered[j+1]))) {
                var temp=entered[j+1];
                entered[j+1]=entered[j]
                entered[j]=temp
            }
        }
    }
    for(i=0;i<entered.length;i++) {
        if(i!=entered.length-1) {
            items.ansText.text=items.ansText.text.concat(entered[i], ", ");
        } else {
            items.ansText.text=items.ansText.text.concat(entered[i], " .");
        }
    }
}
*/

/*
function retry() {
    items.ok.visible=false
    initLevel()
}
*/
