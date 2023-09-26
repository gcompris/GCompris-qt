/* GCompris - crane.js
 *
 * SPDX-FileCopyrightText: 2016 Stefan Toncu <stefan.toncu29@gmail.com>
 *
 * Authors:
 *   <Marc BRUN> (GTK+ version)
 *   Stefan Toncu <stefan.toncu29@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.12 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core
.import GCompris 1.0 as GCompris

var numberLevelsWords = 2
var currentSubLevel = 0;
var numberOfLevel
var words3Letters = []
var words4Letters = []
var words5Letters = []
var items
var url = "qrc:/gcompris/src/activities/crane/resource/"
var currentLocale
var names = []
var names2 = []
var good = []
var levels
var maxSubLevel

function start(items_) {
    items = items_
    levels = items.levels
    numberOfLevel = levels.length
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    currentSubLevel = 0
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

    Core.shuffle(words3Letters)
    Core.shuffle(words4Letters)
    Core.shuffle(words5Letters)
    initLevel()
}

function stop() {
}

function initLevel() {
    maxSubLevel = levels[items.currentLevel].length
    currentSubLevel = 0;
    items.score.numberOfSubLevels = maxSubLevel
    initSubLevel()
}

function initSubLevel() {
    items.score.currentSubLevel = currentSubLevel + 1;
    // reset the arrays
    names = []
    names2 = []

    // set models for repeaters
    if (!levels[items.currentLevel][currentSubLevel].isWord)
        setModelImage()
    else
        setModelWord()

    items.gameFinished = false

    // set "initialIndex" to the position in the repeater
    for(var i = 0; i < names.length; i++) {
        if (items.answerRepeater.itemAt(i).source != "") {
            items.answerRepeater.itemAt(i).initialIndex = i
            good[i] = i
        }
        else {
            // set the initialIndex to -1 if there is no item inside (no source)
            items.answerRepeater.itemAt(i).initialIndex = -1
            good[i] = -1
        }
    }

    // select the first item in the grid
    for(i = 0; i < items.answerRepeater.count; i++) {
        if (items.answerRepeater.itemAt(i).source != "") {
            items.selected = i
            break
        }
    }
}

function getInternalWord() {
    // function to get a word from translated lists
    var currentWordLength = levels[items.currentLevel][currentSubLevel].wordLength
    var wordsUsed
    if (currentWordLength === 3) {
        wordsUsed = words3Letters
    }
    else if (currentWordLength === 4) {
        wordsUsed = words4Letters
    }
    else if (currentWordLength === 5) {
        wordsUsed = words5Letters
    }
    // choosing first word of a list and pushing it to the end of the list like a queue.
    var word = wordsUsed[0]
    wordsUsed.shift()
    wordsUsed.push(word)
    return word
}

// levels with words as items
function setModelWord() {
    var numbers = []
    var i
    var wordsUsed
    var word = levels[items.currentLevel][currentSubLevel].word

    // show or hide the grid
    items.showGrid1.opacity = levels[items.currentLevel][currentSubLevel].showGrid
    // set the two boards in line or not
    items.background.inLine = levels[items.currentLevel][currentSubLevel].inLine

    // set the number of columns and rows, be sure we have enough space to display the word
    items.columns = levels[items.currentLevel][currentSubLevel].columns
    items.rows = levels[items.currentLevel][currentSubLevel].rows;

    for (i = 0; i < items.columns * items.rows; i++) {
        names[i] = ""
        names2[i] = ""
        numbers[i] = i;  // generate columns*rows numbers
    }

    if(word === undefined) {
        word = getInternalWord()
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
    items.answerRepeater.model = names.length
    items.modelRepeater.model = names2.length
    items.gridRepeater.model = names.length

    // set the source of items inside repeaters to names and names2
    for (i = 0; i < names.length; i++) {
        items.answerRepeater.itemAt(i).source = names[i]
        items.modelRepeater.itemAt(i).source = names2[i]
    }
}

// levels with images as items
function setModelImage() {
    var numbers = []
    var i
    var imageList = levels[items.currentLevel][currentSubLevel].images;

    // set the number of columns and rows from "levels"
    items.columns = levels[items.currentLevel][currentSubLevel].columns
    items.rows = levels[items.currentLevel][currentSubLevel].rows

    for (i = 0; i < items.columns * items.rows; i++) {
        names[i] = ""
        names2[i] = ""
        numbers[i] = i;  // generate columns*rows numbers
    }

    // randomize the names
    Core.shuffle(imageList)

    //get "levels[items.currentLevel].noOfItems" random numbers
    Core.shuffle(numbers)

    for (i = 0; i < imageList.length; i++)
        names[numbers[i]] = imageList[i]

    Core.shuffle(numbers)

    for (i = 0; i < imageList.length; i++)
        names2[numbers[i]] = imageList[i]

    // set model for repeaters
    items.answerRepeater.model = names.length
    items.modelRepeater.model = names2.length
    items.gridRepeater.model = names.length

    // set the source of items inside repeaters to names and names2
    for (i = 0; i < names.length; i++) {
        items.answerRepeater.itemAt(i).source = names[i]
        items.modelRepeater.itemAt(i).source = names2[i]
    }

    // show or hide the grid
    items.showGrid1.opacity = levels[items.currentLevel][currentSubLevel].showGrid

    // set the two boards in line or not
    items.background.inLine = levels[items.currentLevel][currentSubLevel].inLine
}

// returns the next index needed for switching to another item
function getNextIndex() {
    // get the initialIndex
    var index = items.answerRepeater.itemAt(items.selected).initialIndex

    var min = 100
    var min2 = 100
    var biggerIndex = -1
    var smallestIndex = -1

    for (var i = 0; i < items.answerRepeater.count; i++) {
        var currentItemIndex = items.answerRepeater.itemAt(i).initialIndex
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
        var item = items.answerRepeater.itemAt(items.selected)
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
            if (items.selected < (items.answerRepeater.count-items.columns))
                makeMove(item, item.height, item.y, items.columns, "y")
        } else if (command === "next") {
            items.selected = getNextIndex()
        }
    }
}

//set the environment for making a move and start the animation
function makeMove(item, distance, startPoint, add, animationProperty) {
    if (items.answerRepeater.itemAt(items.selected+add).source == "") {
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
    for (var i = 0; i < items.answerRepeater.count && hasWon; i++) {
        if (items.answerRepeater.itemAt(i).source != items.modelRepeater.itemAt(i).source) {
            hasWon = false
        }
    }

    if (hasWon) {
        items.bonus.good("flower")
        items.gameFinished = true
    }
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function nextSubLevel() {
    if(++currentSubLevel >= maxSubLevel) {
        nextLevel()
    } else {
        items.score.playWinAnimation();
        initSubLevel();
    }
}
