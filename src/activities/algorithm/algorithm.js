/* GCompris - algorithm.js
 *
 * Copyright (C) 2014 Bharath M S" <brat.197@gmail.com>
 *
 * Authors:
 *   Christof Petig and Ingo Konrad (GTK+ version)
 *   "Bharath M S" <brat.197@gmail.com> (Qt Quick port)
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

/*

functions :-

setUp() - the function is called to set the basic game layout each time (questionTray, answerTray)
getSetLength() - returns the number of unique indices in the chosen sample
getImages() - returns a random array of length 8 that is based on the chosen sample
setQuestion() - the function is called to set questionTray
setAnswer() - the function is called to set answerTray
clickHandler() - called to handle click event

variables :-

sample - this array has an array of arrays for each level
choiceCount (int) - initialised with the value 5 and the game is won when choiceCount is 8

Example 1:
sample: [0,1,0,1,0,1,0,1]
getSetLength() output - 2
getImages() sample output - [6,7,6,7,6,7,6,7]

Example 2:
sample: [0,1,2,0,1,2,0,1]
getSetLength() output - 3
getImages() sample output - [3,5,7,3,5,7,3,5]

Example 3:
sample: [0,1,2,3,3,2,1,0]
getSetLength() output - 4
getImages() sample output - [1,3,2,5,5,2,3,1]

*/

var currentLevel = 0
var numberOfLevel = 5
var max = 8
var index
var answerIndex
var items
var number
var images = ["apple",
              'banana',
              'cherries',
              'lemon',
              'orange',
              'pear',
              'pineapple',
              'plum']
var url = "qrc:/gcompris/src/activities/algorithm/resource/"

function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    setUp()
}

// Add more cases to sample and differentiate arrange according to level of difficulty
// Develop an algo to choose them accordingly for each level

var sample = [[[0,1,0,1,0,1,0,1],[0,1,2,0,1,2,0,1],[0,1,2,3,0,1,2,3],[0,1,2,3,3,2,1,0]],//level1
              [[0,1,2,3,1,0,0,1],[0,1,2,3,0,1,0,1],[0,1,2,3,1,2,1,2],[0,1,2,3,2,3,2,3]],//2
              [[0,1,2,3,0,1,2,0],[0,1,2,3,1,2,3,1],[0,1,2,3,2,1,3,1],[0,1,2,3,3,1,2,1]],//3
              [[0,1,2,3,1,2,3,0],[0,1,2,3,2,3,0,1],[0,1,2,3,3,0,1,2],[0,1,2,3,4,0,1,2]],//4
              [[0,1,2,3,3,1,2,0],[0,1,2,3,0,2,1,3],[0,1,2,3,2,3,1,0],[0,1,2,3,2,1,3,0]]]//5


function setUp(){
    number = Math.floor(Math.random() * 10000) % 4

    index = getImages(number, currentLevel)
    setQuestion(index)

    answerIndex = getImages(number, currentLevel)
    setAnswer(answerIndex)
}


function getSetLength(list){
    //used to determine how many unique images are required for a sample
    var count = []
    for(var i=0; i<list.length;i++) {
        if(!(list[i] in count)) {
            count.push(list[i])
        }
    }
    return count.length
}

// Returns a set of images that is used to set
// either the Sample algorithm or the Answer tray
function getImages(number, level) {
    var setLength = getSetLength(sample[level][number])
    var results = Core.shuffle(images).slice(0, setLength)
    // Repeat the set
    while(results.length < 8) {
        results = results.concat(results)
    }
    // Remove extra items
    results = results.slice(0, 8)
    return results
}

// The source of questionTray is changed to reflect the chosen
// set of random indices
function setQuestion(indices){
    items.question.model = indices
}

// The first 5 images of answerTray are set and the 6th is a question mark
function setAnswer(indices){

    var tempIndex = []
    for(var i=0; i < 5; i++) {
        tempIndex.push(indices[i])
    }
    tempIndex.push('question_mark')
    items.answer.model = tempIndex
}


var choiceCount = 5 //game is won when choiceCount = 8

function clickHandler(id){
    var tempIndex = []

    if(id === answerIndex[choiceCount]) { //correct answer
        tempIndex = items.answer.model
        choiceCount++;
        items.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/bleep.wav')

        if(choiceCount < 8){
            tempIndex.push('question_mark')
        }

        tempIndex[choiceCount - 1] = answerIndex[choiceCount - 1]
        items.answer.model = tempIndex

        if(choiceCount == 8){
            choiceCount = 5
            items.currentSubLevel++
            if(items.currentSubLevel == items.nbSubLevel) { // increment level after 3 successful games
                items.currentSubLevel-- // Don't display 4/3
                items.bonus.good("tux")
            } else {
                items.bonus.good("flower")
                items.bonus.isWin = false
                setUp()
            }
        }
        return 1
    } else { // Wrong answer, try again
        items.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/brick.wav')
    }
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel) {
        currentLevel = 0
    }
    items.currentSubLevel = 0;
    initLevel();
}


function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    items.currentSubLevel = 0;
    initLevel();
}

