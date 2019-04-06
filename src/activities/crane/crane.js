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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
.pragma library
.import QtQuick 2.6 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core
.import GCompris 1.0 as GCompris

var levels = [{showGrid: 1, noOfItems: 2, inLine: true, columns: 4, rows: 3 },
              {showGrid: 1, noOfItems: 3, inLine: true, columns: 5, rows: 4 },
              {showGrid: 1, noOfItems: 4, inLine: true, columns: 6, rows: 5 },
              {showGrid: 0, noOfItems: 5, inLine: false, columns: 7, rows: 6 },
              {showGrid: 0, noOfItems: 6, inLine: false, columns: 7, rows: 6 },
              {showGrid: 1, noOfItems: 7, inLine: true, columns: 7, rows: 6 },
              {showGrid: 1, noOfItems: 8, inLine: true, columns: 7, rows: 6 },
              {showGrid: 0, noOfItems: 9, inLine: false, columns: 7, rows: 6 },
              {showGrid: 0, noOfItems: 10, inLine: false, columns: 7, rows: 6 },
              {showGrid: 0, noOfItems: 11, inLine: false, columns: 7, rows: 6 }]

var currentLevel = 0
var numberLevelsWords = 2
var maxWordLevels = 3 * numberLevelsWords
var maxImageLevels = levels.length
var numberOfLevel = maxWordLevels + maxImageLevels
var items
var url = "qrc:/gcompris/src/activities/crane/resource/"

var allNames = ["bulb.svg","letter-a.svg","letter-b.svg",
                "rectangle1.svg","rectangle2.svg","square1.svg",
                "square2.svg","triangle1.svg","triangle2.svg",
                "tux.svg","water_drop1.svg","water_drop2.svg",
                "water_spot1.svg","water_spot2.svg"]

var currentLocale

var words3Letters = []
var words4Letters = []
var words5Letters = []

var alreadyUsed3 = []
var alreadyUsed4 = []
var alreadyUsed5 = []

var names = []
var names2 = []
var good = []

function start(items_) {
    items = items_
    currentLevel = 0
    currentLocale = GCompris.ApplicationInfo.getVoicesLocale(GCompris.ApplicationSettings.locale)

    /*: Translators: NOTE: Word list for crane activity.
        Translate this into a list of 15–25 simple 3-letter
        words separated by semi-colons. The words can only contain
        lowercase ASCII letters (a–z). Example: cat;dog;win;red;yes
    */
    words3Letters = qsTr("cat;dog;win;red;yes;big;box;air;arm;car;bus;fun;day;eat;hat;leg;ice;old;egg").split(';')
    
    /*: Translators: NOTE: Word list for crane activity.
        Translate this into a list of 10–20 simple 4-letter
        words separated by semi-colons. The words can only contain
        lowercase ASCII letters (a–z). Example: blue;best;good;area
    */
    words4Letters = qsTr("blue;best;good;area;bell;coat;easy;farm;food;else;girl;give;hero;help;hour;sand;song").split(';')

    /*: Translators: NOTE: Word list for crane activity.
      Translate this into a list of 10–20 simple 5-letter
      words separated by semi-colons. The words can only contain
      lowercase ASCII letters (a–z). Example: happy;child;white;apple
    */
    words5Letters = qsTr("happy;child;white;apple;brown;truth;fresh;green;horse;hotel;house;paper;shape;shirt;study").split(';')

    alreadyUsed3 = []
    alreadyUsed4 = []
    alreadyUsed5 = []
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    Core.shuffle(words3Letters)
    Core.shuffle(words4Letters)
    Core.shuffle(words5Letters)
    init()
}

function init() {
    // reset the arrays
    names = []
    names2 = []

    // set models for repeaters
    if (currentLevel >= maxWordLevels)
        setRandomModelImage()
    else
        setRandomModelWord()

    items.gameFinished = false

    // set "initialIndex" to the position in the repeater
    for(var i = 0; i < names.length; i++) {
        if (items.repeater.itemAt(i).source != "") {
            items.repeater.itemAt(i).initialIndex = i
            good[i] = i
        }
        else {
            // set the initialIndex to -1 if there is no item inside (no source)
            items.repeater.itemAt(i).initialIndex = -1
            good[i] = -1
        }
    }

    // select the first item in the grid
    for(i = 0; i < items.repeater.count; i++) {
        if (items.repeater.itemAt(i).source != "") {
            items.selected = i
            break
        }
    }
}

function getNextUnusedWord(wordsUsed, alreadyUsed) {
    var currentIndex = Math.floor(Math.random() * wordsUsed.length)
    while(alreadyUsed.indexOf(wordsUsed[currentIndex]) >= 0) {
        // there are no more words to use => clear the "alreadyUsed" vector
        if (alreadyUsed.length == wordsUsed.length)
            alreadyUsed = []
        // get another random index
        currentIndex = Math.floor(Math.random() * wordsUsed.length)
    }
    // add the word in the "alreadyUsed" vector
    alreadyUsed = alreadyUsed.concat(wordsUsed[currentIndex])
    return wordsUsed[currentIndex]
}

// levels with words as items
function setRandomModelWord() {
    var numbers = []
    var i
    var wordsUsed

    if (currentLevel < numberLevelsWords) {
        wordsUsed = words3Letters
        // show or hide the grid
        items.showGrid1.opacity = 1
        // set the two boards in line or not
        items.background.inLine = true
    }
    else if (currentLevel < numberLevelsWords * 2) {
        wordsUsed = words4Letters
        // show or hide the grid
        items.showGrid1.opacity = 1
        // set the two boards in line or not
        items.background.inLine = false
    }
    else {
        wordsUsed = words5Letters
        // show or hide the grid
        items.showGrid1.opacity = 0
        // set the two boards in line or not
        items.background.inLine = false
    }
    // take the first word and keep its length
    var currentWordsLength = wordsUsed[0].length;
    // set the number of columns and rows, be sure we have enough space to display the word
    items.columns = currentWordsLength + 1
    items.rows = currentWordsLength

    for (i = 0; i < items.columns * items.rows; i++) {
        names[i] = ""
        names2[i] = ""
        numbers[i] = i;  // generate columns*rows numbers
    }

    // before: // var currentIndex = currentLevel % numberLevelsWords

    // get a random word
    var word

    // use vectors to store the words already used
    if (currentWordsLength == 3) {
        word = getNextUnusedWord(wordsUsed, alreadyUsed3);
    }
    else if (currentWordsLength == 4) {
        word = getNextUnusedWord(wordsUsed, alreadyUsed4);
    }
    else if (currentWordsLength == 5) {
        word = getNextUnusedWord(wordsUsed, alreadyUsed5);
    }


    // place the word at a random position in the grid
    var randomRow = Math.floor(Math.random() * items.rows)
    var randomCol = Math.floor(Math.random() * items.columns)

    // check if the word goes out of the frame and replace to left it if needed
    if (items.columns - randomCol - word.length < 0)
        randomCol = randomCol - Math.abs(items.columns - randomCol - word.length)

    // set full path (url) to the letter image
    var index = 0;
    for (i = 0; i < word.length; i++) {
        index = randomRow * items.columns + randomCol + i
        names[index] =  url + "letters/" + word.charAt(i) + ".svg"
        names2[index] = names[index]
    }

    Core.shuffle(names)

    // set model for repeaters
    items.repeater.model = names.length
    items.modelRepeater.model = names2.length
    items.gridRepeater.model = names.length

    // set the source of items inside repeaters to names and names2
    for (i = 0; i < names.length; i++) {
        items.repeater.itemAt(i).source = names[i]
        items.modelRepeater.itemAt(i).source = names2[i]
    }
}

// levels with images as items
function setRandomModelImage() {
    var numbers = []
    var i

    // set the number of columns and rows from "levels"
    items.columns = levels[currentLevel - maxWordLevels].columns
    items.rows = levels[currentLevel - maxWordLevels].rows

    for (i = 0; i < items.columns * items.rows; i++) {
        names[i] = ""
        names2[i] = ""
        numbers[i] = i;  // generate columns*rows numbers
    }

    // randomize the names
    Core.shuffle(allNames)

    //get "levels[currentLevel].noOfItems" random numbers
    Core.shuffle(numbers)

    for (i = 0; i < levels[currentLevel - maxWordLevels].noOfItems; i++)
        names[numbers[i]] = url + allNames[i]

    Core.shuffle(numbers)

    for (i = 0; i < levels[currentLevel - maxWordLevels].noOfItems; i++)
        names2[numbers[i]] = url + allNames[i]

    // set model for repeaters
    items.repeater.model = names.length
    items.modelRepeater.model = names2.length
    items.gridRepeater.model = names.length

    // set the source of items inside repeaters to names and names2
    for (i = 0; i < names.length; i++) {
        items.repeater.itemAt(i).source = names[i]
        items.modelRepeater.itemAt(i).source = names2[i]
    }

    // show or hide the grid
    items.showGrid1.opacity = levels[currentLevel - maxWordLevels].showGrid

    // set the two boards in line or not
    items.background.inLine = levels[currentLevel - maxWordLevels].inLine
}

// returns the next index needed for switching to another item
function getNextIndex() {
    // get the initialIndex
    var index = items.repeater.itemAt(items.selected).initialIndex

    var min = 100
    var min2 = 100
    var biggerIndex = -1
    var smallestIndex = -1

    for (var i = 0; i < items.repeater.count; i++) {
        var currentItemIndex = items.repeater.itemAt(i).initialIndex
        // get the immediat bigger index
        if (index < currentItemIndex) {
            if (min > currentItemIndex) {
                // update min and index
                min = currentItemIndex
                biggerIndex = i
            }
        }
        // in case current index is the biggest, search the smallest index from start
        if (currentItemIndex >= 0 && min2 > currentItemIndex) {
            min2 = currentItemIndex
            smallestIndex = i
        }
    }

    // if a bigger index was found, return it
    if (biggerIndex != -1)
        return biggerIndex

    // this is the biggest index; the next one is the smallest in the array
    return smallestIndex
}

//touchscreen gestures
function gesture(deltax, deltay) {
    if (Math.abs(deltax) > 40 || Math.abs(deltay) > 40)
        if (deltax > 30 && Math.abs(deltay) < items.sensivity)
            move("right")
        else if (deltax < -30 && Math.abs(deltay) < items.sensivity)
            move("left")
        else if (Math.abs(deltax) < items.sensivity && deltay > 30)
            move("down")
        else if (Math.abs(deltax) < items.sensivity && deltay < 30)
            move("up")
}

//depending on the command, make a move to left/right/up/down or select next item
function move(command) {
    if (items.ok && !items.gameFinished && !items.pieceIsMoving) {
        var item = items.repeater.itemAt(items.selected)
        if (command === "left") {
            if (items.selected % items.columns != 0)
                makeMove(item, -item.width, item.x, -1, "x")
        } else if (command === "right") {
            if ((items.selected+1) % items.columns != 0)
                makeMove(item, item.width, item.x, 1, "x")
        } else if (command === "up") {
            if (items.selected > items.columns-1)
                makeMove(item, -item.height, item.y, -items.columns, "y")
        } else if (command === "down") {
            if (items.selected < (items.repeater.count-items.columns))
                makeMove(item, item.height, item.y, items.columns, "y")
        } else if (command === "next") {
            items.selected = getNextIndex()
        }
    }
}

//set the environment for making a move and start the animation
function makeMove(item, distance, startPoint, add, animationProperty) {
    if (items.repeater.itemAt(items.selected+add).source == "") {
        items.pieceIsMoving = true
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
    var hasWon = true
    for (var i = 0; i < items.repeater.count && hasWon; i++) {
        if (items.repeater.itemAt(i).source != items.modelRepeater.itemAt(i).source) {
            hasWon = false
        }
    }

    if (hasWon) {
        items.bonus.good("flower")
        items.gameFinished = true
    }
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel) {
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

