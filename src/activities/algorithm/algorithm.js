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

var currentLevel = 0
var numberOfLevel = 4
var max = 8
var index
var difficulty = 0
var answerIndex
var items
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
    number = Math.floor(Math.random() * 10000) % 8
    index = getIndex(number)
    setSample(index)
    answerIndex = getIndex(number)
    setAnswer(answerIndex)
}
var sample = [[0,1,2,3,0,1,2,3],[0,1,2,3,3,1,2,0],[0,1,2,3,0,2,1,3],
              [0,1,2,3,2,3,1,0],[0,1,2,3,4,0,1,2],[0,1,2,3,1,2,3,1],[0,1,2,3,1,0,0,1],[0,1,0,1,0,1,0,1]]

//Add more cases to sample and differentiate arrange according to level of difficulty
//Develop an algo to choose them accordingly for each level
var number

function getIndex(number){
// Returns a set of indices that is used to set either the Sample algorithm or the Answer tray

    var x = []
    for(var i=0;i<4;i++){
        x.push((Math.floor(Math.random()*10000)) % 8)
    }
    for(var i=4;i<max;i++){
        x.push(x[sample[number][i]])

    }
    console.log(x)
    return x
}

function setSample(indices){
// The source of algoTray is changed to reflect the chosen set of random indices

    items.algoTray.src1 = url+images[indices[0]]
    items.algoTray.src2 = url+images[indices[1]]
    items.algoTray.src3 = url+images[indices[2]]
    items.algoTray.src4 = url+images[indices[3]]
    items.algoTray.src5 = url+images[indices[4]]
    items.algoTray.src6 = url+images[indices[5]]
    items.algoTray.src7 = url+images[indices[6]]
    items.algoTray.src8 = url+images[indices[7]]
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
var count = 5
var times = 0
function clickHandler(id){
    var str = (answerIndex[count]+1).toString()
    if(id == ('img'+str)){
        count++;
        items.bleep.play()
        if(count == 6){
            items.answerTray.src6 = url+images[str-1]
            items.answerTray.src7 = url+images[8]
            items.answerTray.visible7 = true
        }
        if(count == 7){
            items.answerTray.src7 = url+images[str-1]
            items.answerTray.src8 = url+images[8]
            items.answerTray.visible8 = true
        }
        if(count == 8){
            items.answerTray.src8 = url+images[str-1]
            // Make something graphical happen here
            count = 5
            times++
            initLevel()
            if(times == 3){
                nextLevel()
            }
        }

    }
    else{
        // Make something graphical happen here
        items.brick.play()
    }

}

function nextLevel() {
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
