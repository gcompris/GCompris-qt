/* GCompris - algorithm.js
 *
 * Copyright (C) 2014 <YOUR NAME HERE>
 *
 * Authors:
 *   <THE GTK VERSION AUTHOR> (GTK+ version)
 *   "YOUR NAME" <YOUR EMAIL> (Qt Quick port)
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

/*

functions :-

setUp() - the function is called to set the basic game layout each time (questionTray, answerTray)
getSetLength() - returns the number of unique indices in the chosen sample
getIndex() - returns a random array of length 8 that is based on the chosen sample
setQuestion() - the function is called to set questionTray
setAnswer() - the function is called to set answerTray
playSound() - the function used to play audio brick and bleep
clickHandler() - called to handle click event

variables :-

sample - this array has an array of arrays for each level
choiceCount (int) - initialised with the value 5 and the game is won when choiceCount is 8
times (int) - initialised with 0 level increases when times is 3

Example 1:
sample: [0,1,0,1,0,1,0,1]
getSetLength() output - 2
getIndex() sample output - [6,7,6,7,6,7,6,7]

Example 2:
sample: [0,1,2,0,1,2,0,1]
getSetLength() output - 3
getIndex() sample output - [3,5,7,3,5,7,3,5]

Example 3:
sample: [0,1,2,3,3,2,1,0]
getSetLength() output - 4
getIndex() sample output - [1,3,2,5,5,2,3,1]

*/

var currentLevel = 0
var numberOfLevel = 5
var max = 8
var index
var answerIndex
var items
var number
var images = ["apple.png",
              'cerise.png',
              'egg.png',
              'eggpot.png',
              'football.png',
              'glass.png',
              'peer.png',
              'strawberry.png',
              'question_mark.png'
]
var url = "qrc:/gcompris/src/activities/algorithm/resource/"

function start(items_) {
    console.log("algorithm activity: start")
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {
    console.log("algorithm activity: stop")
}

function initLevel() {
    items.bar.level = currentLevel + 1
    setUp()
}

//Add more cases to sample and differentiate arrange according to level of difficulty
//Develop an algo to choose them accordingly for each level

var sample = [[[0,1,0,1,0,1,0,1],[0,1,2,0,1,2,0,1],[0,1,2,3,0,1,2,3],[0,1,2,3,3,2,1,0]],//level1
              [[0,1,2,3,1,0,0,1],[0,1,2,3,0,1,0,1],[0,1,2,3,1,2,1,2],[0,1,2,3,2,3,2,3]],//2
              [[0,1,2,3,0,1,2,0],[0,1,2,3,1,2,3,1],[0,1,2,3,2,1,3,1],[0,1,2,3,3,1,2,1]],//3
              [[0,1,2,3,1,2,3,0],[0,1,2,3,2,3,0,1],[0,1,2,3,3,0,1,2],[0,1,2,3,4,0,1,2]],//4
              [[0,1,2,3,3,1,2,0],[0,1,2,3,0,2,1,3],[0,1,2,3,2,3,1,0],[0,1,2,3,2,1,3,0]]]//5


function setUp(){
    number = Math.floor(Math.random() * 10000) % 4

    index = getIndex(number, currentLevel)
    console.log("Sample:",index)
    setQuestion(index)

    answerIndex = getIndex(number, currentLevel)
    console.log("Answer:", answerIndex)
    setAnswer(answerIndex)
}


function getSetLength(list){
    //used to determine how many unique images are required for a sample
    var count = []
    for(var i=0; i<list.length;i++){
        if(!(list[i] in count)){
            count.push(list[i])
        }
    }
    return count.length
}

function getIndex(number, level){
// Returns a set of indices that is used to set either the Sample algorithm or the Answer tray
    var index = []
    var setLength = getSetLength(sample[level][number])
    for(var i=0;i<setLength;i++){
        index.push((Math.floor(Math.random()*10000)) % 8)
    }
    for(var i=setLength;i<max;i++){
        index.push(index[sample[level][number][i]])
    }
    return index
}

function setQuestion(indices){
// The source of questionTray is changed to reflect the chosen set of random indices

    items.questionTray.src1 = url+images[indices[0]]
    items.questionTray.src2 = url+images[indices[1]]
    items.questionTray.src3 = url+images[indices[2]]
    items.questionTray.src4 = url+images[indices[3]]
    items.questionTray.src5 = url+images[indices[4]]
    items.questionTray.src6 = url+images[indices[5]]
    items.questionTray.src7 = url+images[indices[6]]
    items.questionTray.src8 = url+images[indices[7]]
}

function setAnswer(indices){
// The first 5 images of answerTray are set, the 6th is a question mark and the other two images are not visible
    items.answerTray.src1 = url+images[indices[0]]
    items.answerTray.src2 = url+images[indices[1]]
    items.answerTray.src3 = url+images[indices[2]]
    items.answerTray.src4 = url+images[indices[3]]
    items.answerTray.src5 = url+images[indices[4]]
    items.answerTray.src6 = url+images[8]
    items.answerTray.visible7 =  false
    items.answerTray.visible8 = false
}


var choiceCount = 5 //game is won when choiceCount = 8
var times = 0 // level increases when times = 3

//The audio part does not work as expected

function playSound(id){
    if(id == "brick"){
        items.brick.play()
    }
    else if(id == "bleep"){
        items.bleep.play()
    }
}

function clickHandler(id){
    var str = (answerIndex[choiceCount]+1).toString()

    if(id == ('img'+str)){//correct answer

        choiceCount++;
        playSound('bleep')
        console.log("That was right.")
        if(choiceCount == 6){//1st answer
            items.answerTray.src6 = url+images[str-1]
            items.answerTray.src7 = url+images[8]
            items.answerTray.visible7 = true
        }

        if(choiceCount == 7){//2nd answer
            items.answerTray.src7 = url+images[str-1]
            items.answerTray.src8 = url+images[8]
            items.answerTray.visible8 = true
        }

        if(choiceCount == 8){//3rd answer
            items.answerTray.src8 = url+images[str-1]
            choiceCount = 5
            times++

            if(times == 3){//increment level after 3 successful games
                items.bonus.good("tux")
            }
            else{
                console.log("Repeat level.")
                items.bonus.good("flower")
                items.bonus.isWin = false
                setUp()
            }
        }
    }
    else{//Wrong answer, try again
        console.log("That was wrong.")
        playSound('brick')
    }
}

function nextLevel() {
    console.log("Next level.")
    if(numberOfLevel <= ++currentLevel ) {
        currentLevel = 0
    }
    times = 0;
    initLevel();
}


function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel();
}
