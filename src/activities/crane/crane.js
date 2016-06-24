/* GCompris - crane.js
 *
 * Copyright (C) 2016 Stefan Toncu <stefan.toncu29@gmail.com>
 *
 * Authors:
 *   <Marc BRUN> (GTK+ version)
 *   Stefan Toncu <stefan.toncu29@gmail.com> (Qt Quick port)
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
.import "qrc:/gcompris/src/core/core.js" as Core


var currentLevel = 0
var numberOfLevel = 10
var items
var url = "qrc:/gcompris/src/activities/crane/resource/"

var showGrid = [1,1,1,0,0,1,1,0,0,0]
var howManyFigures = [3,3,3,4,5,5,6,7,8,9,10,11,12,13]
var allNames = ["bulb.svg","letter-a.svg","letter-b.svg",
                "rectangle1.svg","rectangle2.svg","square1.svg",
                "square2.svg","triangle1.svg","triangle2.svg",
                "tux.svg","water_drop1.svg","water_drop2.svg",
                "water_spot1.svg","water_spot2.svg"]
var words = ["cat","dog","win","good","happy"]
var names = []
var names2 = []
var good = []

function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1

    init()
}

function init() {
    items.columns = 7
    items.rows = 6
    items.gameFinished = false

    setRandomModel()

    for(var i = 0; i < names.length; i++) {
        if (items.repeater.itemAt(i).source != "") {
            items.repeater.itemAt(i).initialIndex = i
            good[i] = i
        }
        else {
            items.repeater.itemAt(i).initialIndex = -1
            good[i] = -1
        }
    }

    //select the first item in the grid
    for(var i = 0; i < items.repeater.count; i++) {
        if (items.repeater.itemAt(i).source != "") {
            items.selected = i
            break
        }
    }

    //set opacity for first item's "selection frame"
    items.repeater.itemAt(items.selected).selected.opacity = 1

    //show or hide the grid
    if (showGrid[currentLevel])
        items.showGrid1.opacity = 1
    else items.showGrid1.opacity = 0
}

function setRandomModel(){
    var numbers = []

    for (var i = 0; i < items.columns * items.rows; i++){
        names[i] = ""    // reset the board
        names2[i] = ""
        numbers[i] = i;  // generate columns*rows numbers
    }

    if (currentLevel >= words.length) {
        // randomize the names
        Core.shuffle(allNames)

        //get "howManyFigures[currentLevel]" random numbers
        Core.shuffle(numbers)

        for (i = 0; i < howManyFigures[currentLevel]; i++)
            names[numbers[i]] = url + allNames[i]

        Core.shuffle(numbers)

        for (i = 0; i < howManyFigures[currentLevel]; i++)
            names2[numbers[i]] = url + allNames[i]

    } else {

        var model = setModel()

        for (i = 0; i < model.length; i++) {
            if (model[i] != "") {
                names[i] = model[i]
                names2[i] = model[i]
            }
        }

        Core.shuffle(names)
    }

    items.repeater.model = names.length
    items.modelRepeater.model = names2.length
    items.gridRepeater.model = names.length

    for (i = 0; i < names.length; i++) {
        items.repeater.itemAt(i).source = names[i]
        items.repeater.itemAt(i).opac = 0
        items.modelRepeater.itemAt(i).source = names2[i]
    }
}

function setModel() {
    var model = []
    for (var i = 0; i < items.columns * items.rows; i++){
        model[i] = ""
    }

    var randomRow = Math.floor(Math.random() * items.rows)
    var randomCol = Math.floor(Math.random() * items.columns)

    if (items.columns - randomCol - words[currentLevel].length < 0)
        randomCol = randomCol - Math.abs(items.columns - randomCol - words[currentLevel].length)

    for (i=0; i<words[currentLevel].length; i++) {
        model[randomRow * items.columns + randomCol + i] =  url + "letters/" + words[currentLevel].charAt(i) + ".svg"
    }

    return model
}

function newFunction() {

    var index = items.repeater.itemAt(items.selected).initialIndex

    var min = 100
    var realMin = 100
    var indexx = -1
    var realMinIndex = -1

    for (var i = 0; i < items.repeater.count; i++) {
        if (index < items.repeater.itemAt(i).initialIndex) {
            if (min > items.repeater.itemAt(i).initialIndex) {
                min = items.repeater.itemAt(i).initialIndex
                indexx = i
            }
        }
        if (items.repeater.itemAt(i).initialIndex >= 0 && realMin > items.repeater.itemAt(i).initialIndex) {
            realMin = items.repeater.itemAt(i).initialIndex
            realMinIndex = i
        }
    }

    if (indexx != -1) {
        return indexx
    }

    return realMinIndex
}

//function getNextIndex (index) {
//    var i
//    var min = 100
//    var indexx = -1

//    for (i = 0; i < good.length; i++) {
//        if (good[i] > good[index] && min > good[i]) {
//            min = good[i]
//            indexx = i
//        }
//    }
//    if (min!=100) {
//        print("found after index")
//        return indexx
//    }

//    for (i = 0; i < good.length; i++) {
//        if (good[i] > 0 && min > good[i]) {
//            min = good[i]
//            indexx = i
//        }
//    }

//    print("found before index")
//    return indexx
//}

//touchscreen gestures
function gesture(deltax, deltay) {
    if (Math.abs(deltax) > 40 || Math.abs(deltay) > 40) {
        if (deltax > 30 && Math.abs(deltay) < items.sensivity) {
            move("right")
        } else if (deltax < -30 && Math.abs(deltay) < items.sensivity) {
            move("left")
        } else if (Math.abs(deltax) < items.sensivity && deltay > 30) {
            move("down")
        } else if (Math.abs(deltax) < items.sensivity && deltay < 30) {
            move("up")
        }
    }
}

//depeding on the command, make a move to left/right/up/down or select next item
function move(command) {
    if (items.ok == true && items.gameFinished == false) {
        var item = items.repeater.itemAt(items.selected)
        if (command === "left") {
            if (items.selected % items.columns != 0) {
//                var aux = good[items.selected-1]
//                good[items.selected-1] = good[items.selected]
//                good[items.selected] = aux
                makeMove(item,-item.width,item.x,-1,"x")
            }
        } else if (command === "right") {
            if ((items.selected+1) % items.columns != 0) {
//                aux = good[items.selected+1]
//                good[items.selected+1] = good[items.selected]
//                good[items.selected] = aux
                makeMove(item,item.width,item.x,1,"x")
            }
        } else if (command === "up") {
            if (items.selected > items.columns-1) {
//                aux = good[items.selected-items.columns]
//                good[items.selected-items.columns] = good[items.selected]
//                good[items.selected] = aux
                makeMove(item,-item.height,item.y,-items.columns,"y")
            }
        } else if (command === "down") {
            if (items.selected < (items.repeater.count-items.columns)) {
//                aux = good[items.selected+items.columns]
//                good[items.selected+items.columns] = good[items.selected]
//                good[items.selected] = aux
                makeMove(item,item.height,item.y,items.columns,"y")
            }
        } else if (command === "next") {
            items.repeater.itemAt(items.selected).selected.opacity = 0
//            items.selected = getNextIndex(items.selected)
            items.selected = newFunction()
            items.repeater.itemAt(items.selected).selected.opacity = 1
        }
    }
}

//set the environment for making a move and start the animation
function makeMove(item,distance,startPoint,add,animationProperty) {
    if (items.repeater.itemAt(items.selected+add).source == "") {
        //setup the animation
        item.distance = distance
        item.indexChange = add
        item.startPoint = startPoint
        item.animationProperty = animationProperty

        //start the animation
        item.anim.start()

        //update the selected item
        items.selected += add;
    }
}

//check the answer; advance to next level if the answer is good
function checkAnswer() {
    var count = 0
    for (var i = 0; i < items.repeater.count; i++) {
        if (items.repeater.itemAt(i).source != items.modelRepeater.itemAt(i).source){
            count = -1
        }
    }
    if (count == 0) {
        items.bonus.good("flower")
        items.gameFinished = true
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