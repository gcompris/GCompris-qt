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
.import QtQuick 2.6 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

/*

functions :-

setUp() - the function is called to set the basic game layout each time (questionTray, answerTray)
getImages() - returns a random array of length 8 that is based on the chosen sample
setQuestion() - the function is called to set questionTray
setAnswer() - the function is called to set answerTray
clickHandler() - called to handle click event

variables :-

sample - this array has an array of arrays for each level
choiceCount (int) - initialised with the value 5 and the game is won when choiceCount is 8

Example 1:
sample: [0,1,0,1,0,1,0,1]
getImages() sample output - names of images with indexes [6,7,6,7,6,7,6,7]

Example 2:
sample: [0,1,2,0,1,2,0,1]
getImages() sample output - names of images with indexes [3,5,7,3,5,7,3,5]

Example 3:
sample: [0,1,2,3,3,2,1,0]
getImages() sample output - names of images with indexes [1,3,2,5,5,2,3,1]

*/

var matchesVisible = 4
var currentLevel = 0
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

// Add more cases to sample and differentiate arrange according to level of difficulty.
// Develop an algo to choose them accordingly for each level.
var sample = [[[0,1,0,1,0,1,0,1],[0,1,1,0,0,1,1,0],[1,1,0,0,0,0,1,1],[1,0,0,1,0,1,1,0]],//level1
              [[0,1,2,0,1,2,0,1],[0,1,2,3,0,1,2,3],[0,1,2,3,3,2,1,0],[0,1,2,1,0,1,2,0]],//2
              [[0,1,2,3,1,0,0,1],[0,1,2,3,0,1,0,1],[0,1,2,3,1,2,1,2],[0,1,2,3,2,3,2,3]],//3
              [[0,1,2,3,0,1,2,0],[0,1,2,3,1,2,3,1],[0,1,2,3,2,1,3,1],[0,1,2,3,3,1,2,1]],//4
              [[0,1,2,3,1,2,3,0],[0,1,2,3,2,3,0,1],[0,1,2,3,3,0,1,2],[0,1,2,3,3,0,1,2]],//5
              [[0,1,2,3,3,1,2,0],[0,1,2,3,0,2,1,3],[0,1,2,3,2,3,1,0],[0,1,2,3,2,1,3,0]],//6
              [[0,1,2,3,3,0,1,1],[0,1,2,3,2,2,3,2],[0,1,2,3,1,1,0,3],[0,1,2,3,1,2,3,2]]]//7
var numberOfLevel = sample.length

function setUp(){
    number = Math.floor(Math.random() * 10000) % sample[currentLevel].length

    index = getImages(number, currentLevel)
    setQuestion(index)

    answerIndex = getImages(number, currentLevel)
    setAnswer(answerIndex)
}

// Returns a set of images that is used to set either the Sample algorithm or the Answer tray.
function getImages(number, level) {
    var substitution = Core.shuffle(images)
    // Create results table based on sample and substitution
    var results = []
    for(var i=0; i<sample[level][number].length; i++) {
        results.push(substitution[sample[level][number][i]])
    }
    return results
}

// The source of questionTray is changed to reflect the chosen
// set of random indices
function setQuestion(indices){
    items.question.model = indices
}

// The first `matchesVisible` images of answerTray are set and the `matchesVisible+1`th is a question mark.
function setAnswer(indices){

    var tempIndex = []
    for(var i=0; i < matchesVisible; i++) {
        tempIndex.push(indices[i])
    }
    tempIndex.push('question_mark')
    items.answer.model = tempIndex
}

// Game is won when choiceCount == 8.
var choiceCount = matchesVisible

function clickHandler(id){
    var tempIndex = []

    // Correct answer
    if(id === answerIndex[choiceCount]) {
        tempIndex = items.answer.model
        choiceCount++;
        items.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/bleep.wav')

        if(choiceCount < max) {
            tempIndex.push('question_mark')
        }

        tempIndex[choiceCount - 1] = answerIndex[choiceCount - 1]
        items.answer.model = tempIndex

        if(choiceCount == max) {
            items.blockClicks = true
            if(items.currentSubLevel+1 === items.nbSubLevel)
                items.bonus.good("tux")
            else
                items.bonus.good("flower")
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

function nextSubLevel() {
    choiceCount = matchesVisible
    items.currentSubLevel++
    // Increment level after 3 successful games.
    if (items.currentSubLevel === items.nbSubLevel) {
        nextLevel()
    }
    setUp()
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    items.currentSubLevel = 0;
    initLevel();
}
