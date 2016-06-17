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

var currentLevel = 0
var numberOfLevel = 6
var items
var url = "qrc:/gcompris/src/activities/crane/resource/"

var howManyFigures = [4,5,6,7,7,7]
var allNames = ["resource/bulb.png","resource/letter-a.png","resource/letter-b.png",
                "resource/rectangle1.png","resource/rectangle2.png","resource/square1.png",
                "resource/square2.png","resource/triangle1.png","resource/triangle2.png",
                "resource/tux.png","resource/water_drop1.png","resource/water_drop2.png",
                "resource/water_spot1.png","resource/water_spot2.png"]


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

    setRandomModel()
    items.selected = getNextIndex1(0)
}

function shuffle(input) {
    for (var i = input.length-1; i >= 0; i--) {

        var randomIndex = Math.floor(Math.random()*(i+1));
        var itemAtIndex = input[randomIndex];

        input[randomIndex] = input[i];
        input[i] = itemAtIndex;
    }
}

var names = []
var names2 = []


function setRandomModel(){
    // randomize the names
    shuffle(allNames)

    var numbers = []


    for (var i = 0; i < items.columns * items.rows; i++){
        names[i] = ""    // reset the board
        names2[i] = ""
        numbers[i] = i;  // generate columns*rows numbers
    }

    //get "howManyFigures[currentLevel]" random numbers
    shuffle(numbers)

    for (i = 0; i < howManyFigures[currentLevel]; i++)
        names[numbers[i]] = allNames[i]

    shuffle(numbers)

    for (i = 0; i < howManyFigures[currentLevel]; i++)
        names2[numbers[i]] = allNames[i]

    //DEBUGGING
    //    print("names: ",names)
    //    print("names2: ",names2)

    items.repeater.model = names.length
    items.modelRepeater.model = names2.length

    for (i = 0; i < names.length; i++) {
        items.repeater.itemAt(i).source = names[i]
        items.modelRepeater.itemAt(i).source = names2[i]
    }
}


function getNextIndex1(index) {
    var length = items.repeater.count
    for(var i = index-1; i >= 0; i--) {
        if (items.repeater.itemAt(i).source != ""){
            return i
        }
    }
    for(i = length-1; i > index; i--) {
        if (items.repeater.itemAt(i).source != ""){
            return i
        }
    }
    return -1;
}

//names
function getNextIndex(source) {
    var length = names.length

    //find index of curent image in ordonated "names" list
    for(var i = 0; i < length; i++) {
        var name = "qrc:/gcompris/src/activities/crane/" + names[i]
//        print("name: ",name)
        if (name == source) {
            break
        }
    }

    //go to next index
    i++

    //bool variable
    var ok = false

    //search from current index
    for (; i<names.length; i++) {
        if (names[i] != "")  {
            ok = true  // the item was found in the right part of the list
            break
        }
    }

    // ok == true only if the image is in the right part of the list
    if (ok==true) {
        for (var j = 0; j<items.repeater.count; j++) {
            name = "qrc:/gcompris/src/activities/crane/" + names[i]
            if (name == items.repeater.itemAt(j).source)
                return j
        }
    }
    //ok == false, meaning that we have to start the search from left
    else {   //search from begging of the list
        for (i=0; i<names.length; i++) {
            if (names[i] != "")  {
                ok = true
                //when finding the first image, stop
                break
            }
        }
        //search for the index of that image in the repater and
        //return the index
        for (j = 0; j<items.repeater.count; j++) {
            name = "qrc:/gcompris/src/activities/crane/" + names[i]
            if (name == items.repeater.itemAt(j).source)
                return j
        }
    }

    return -1;
}

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

function move(move) {
    if (move === "left") {
        if (items.selected % items.columns != 0)
            makeMove(-1)
    } else if (move === "right") {
        if ((items.selected+1) % items.columns != 0)
            makeMove(1)
    } else if (move === "up") {
        if (items.selected > items.columns-1)
            makeMove(-items.columns)
    } else if (move === "down") {
        if (items.selected < (items.repeater.count-items.columns))
            makeMove(items.columns)
    } else if (move === "next") {
        items.selected = getNextIndex(items.repeater.itemAt(items.selected).source)
    }
}

function makeMove(add) {
    if (items.repeater.itemAt(items.selected+add).source == "") {
        items.repeater.itemAt(items.selected+add).source = items.repeater.itemAt(items.selected).source
        items.repeater.itemAt(items.selected).source = ""
        items.selected += add;
        checkAnswer()
    }
}

function checkAnswer() {
    var count = 0
    for (var i = 0; i < items.repeater.count; i++) {
        if (items.repeater.itemAt(i).source != items.modelRepeater.itemAt(i).source){
            count = -1
        }
    }
    if (count == 0) {
        items.bonus.good("flower")
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
