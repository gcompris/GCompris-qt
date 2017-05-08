/* GCompris - Hat.qml
 *
 * Copyright (C) 2014 Thibaut ROMAIN
 *
 * Authors:
 *   Thibaut ROMAIN <thibrom@gmail.com>
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

var url = "qrc:/gcompris/src/activities/magic-hat-minus/resource/"

var currentLevel
var numberOfLevel = 9
var numberOfUserStars
var items;
var mode;
var magicHat
var numberOfStars
var nbStarsToAddOrRemove
var nbStarsToCount
var animationCount

function start(items_, mode_) {
    items = items_
    mode = mode_
    magicHat = items.hat
    currentLevel = 0
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    magicHat.state = "NormalPosition"
    numberOfStars = new Array(0, 0, 0)
    numberOfUserStars = new Array(0, 0, 0)
    nbStarsToAddOrRemove = new Array(0, 0, 0)
    nbStarsToCount = new Array(0, 0, 0)
    animationCount = 0
    
    if(currentLevel > 0) {
        items.introductionText.visible = false
    } else {
        items.introductionText.visible = true
    }

    for(var j=0; j<3; j++) {
        items.repeatersList[0].itemAt(j).initStars()
        items.repeatersList[1].itemAt(j).initStars()
        items.repeatersList[2].itemAt(j).resetStars()
    }

    var maxValue = mode === "minus" ? 10 : 9
    switch(currentLevel) {
        case 0: numberOfStars[0] = getRandomInt(2,4)
             break;
        case 1: numberOfStars[0] = getRandomInt(2,6)
             break;
        case 2: numberOfStars[0] = getRandomInt(2,maxValue)
            break;
        case 3: numberOfStars[0] = getRandomInt(2,5)
                numberOfStars[1] = getRandomInt(2,5)
            break;
        case 4: numberOfStars[0] = getRandomInt(2,8)
                numberOfStars[1] = getRandomInt(2,8)
             break;
        case 5: numberOfStars[0] = getRandomInt(2,maxValue)
                numberOfStars[1] = getRandomInt(2,maxValue)
             break;
        case 6: numberOfStars[0] = getRandomInt(2,4)
                numberOfStars[1] = getRandomInt(2,4)
                numberOfStars[2] = getRandomInt(2,4)
            break;
        case 7: numberOfStars[0] = getRandomInt(2,6)
                numberOfStars[1] = getRandomInt(2,6)
                numberOfStars[2] = getRandomInt(2,6)
            break;
        case 8: numberOfStars[0] = getRandomInt(2,8)
                numberOfStars[1] = getRandomInt(2,8)
                numberOfStars[2] = getRandomInt(2,8)
            break;
        case 9: numberOfStars[0] = getRandomInt(2,maxValue)
                numberOfStars[1] = getRandomInt(2,maxValue)
                numberOfStars[2] = getRandomInt(2,maxValue)
            break;
    }

    for(var i=0; i<3; i++) {
        items.repeatersList[0].itemAt(i).nbStarsOn = numberOfStars[i]
        items.repeatersList[1].itemAt(i).nbStarsOn = 0
        items.repeatersList[2].itemAt(i).nbStarsOn = 0
        items.repeatersList[2].itemAt(i).authorizeClick = false
        if(numberOfStars[i] > 0) {
            items.repeatersList[0].itemAt(i).opacity = 1
            items.repeatersList[1].itemAt(i).opacity = 1
            items.repeatersList[2].itemAt(i).opacity = 1
            if(mode === "minus")
                nbStarsToAddOrRemove[i] = getRandomInt(1, numberOfStars[i]-1)
            else
                nbStarsToAddOrRemove[i] = getRandomInt(1, 10-numberOfStars[i])
        }
        else {
            items.repeatersList[0].itemAt(i).opacity = 0
            items.repeatersList[1].itemAt(i).opacity = 0
            items.repeatersList[2].itemAt(i).opacity = 0
        }
    }

    if(mode === "minus") {
        for(var i=0; i<3; i++) {
            nbStarsToCount[i] = numberOfStars[i] - nbStarsToAddOrRemove[i]
            items.repeatersList[1].itemAt(i).nbStarsOn = 0
        }
    } else {
        for(var i=0; i<3; i++) {
            nbStarsToCount[i] = numberOfStars[i]+nbStarsToAddOrRemove[i]
            items.repeatersList[1].itemAt(i).nbStarsOn = nbStarsToAddOrRemove[i]
        }
    }
}

function userClickedAStar(barIndex,state) { 
    if(state)
        numberOfUserStars[barIndex]++
    else
        numberOfUserStars[barIndex]--
}

function verifyAnswer() {
    if(numberOfUserStars[0] === nbStarsToCount[0] &&
       numberOfUserStars[1] === nbStarsToCount[1] &&
       numberOfUserStars[2] === nbStarsToCount[2]) {
        items.bonus.good("flower")
    } else {
        items.bonus.bad("flower")
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

function moveStarsUnderHat() {
    if(currentLevel == 0) {
        items.introductionText.visible = false
    }

    for(var j=0; j<3; j++) {
        items.repeatersList[0].itemAt(j).moveStars()
    }
}

function moveBackMinusStars() {
    for(var j=0; j<3; j++) {
        items.repeatersList[0].itemAt(j).
          moveBackMinusStars(items.repeatersList[1].itemAt(j),
                             nbStarsToAddOrRemove[j])
    }
}

function movePlusStars() {
    for(var j=0; j<3; j++) {
        items.repeatersList[1].itemAt(j).moveStars()
    }
}

// Function called everytime the first animation ends
function animation1Finished(barGroupIndex) {
    animationCount++
    if(barGroupIndex == 0) {
        if(animationCount === numberOfStars[0] + numberOfStars[1] + numberOfStars[2]) {
            animationCount = 0
            if(mode === "minus")
                moveBackMinusStars()
            else
                movePlusStars()
        }
    } else {
        animationCount = 0
        userGuessNumberState()
    }
}

// Function called everytime the second animation ends
function animation2Finished()
{
    animationCount++
    if(animationCount === nbStarsToAddOrRemove[0] +
            nbStarsToAddOrRemove[1] + nbStarsToAddOrRemove[2]) {
        animationCount = 0
        userGuessNumberState()
    }
}

function userGuessNumberState() {
    for(var i=0; i<3; i++) {
        if(numberOfStars[i] + nbStarsToAddOrRemove[i])
            items.repeatersList[2].itemAt(i).authorizeClick = true
    }
    magicHat.state = "GuessNumber"
}

function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min);
}
