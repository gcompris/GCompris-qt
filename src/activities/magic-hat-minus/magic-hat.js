/* GCompris - Hat.qml
 *
 * SPDX-FileCopyrightText: 2014 Thibaut ROMAIN
 *
 * Authors:
 *   Thibaut ROMAIN <thibrom@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.12 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var url = "qrc:/gcompris/src/activities/magic-hat-minus/resource/"

var numberOfLevel
var numberOfUserStars
var items;
var mode;
var magicHat
var numberOfStars
var nbStarsToAddOrRemove
var nbStarsToCount
var animationCount
var questionCoefficients = []
var maxStarSlots = 30
var answerCoefficients = []
var coefficientsNeeded = false

function start(items_, mode_) {
    items = items_
    mode = mode_
    magicHat = items.hat
    numberOfLevel = items.levels.length
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    initLevel()
}

function stop() {
}

function initLevel() {
    magicHat.state = "NormalPosition"
    numberOfStars = new Array(0, 0, 0)
    numberOfUserStars = new Array(0, 0, 0)
    nbStarsToAddOrRemove = new Array(0, 0, 0)
    nbStarsToCount = new Array(0, 0, 0)
    animationCount = 0
    var maxValue = items.levels[items.currentLevel].maxValue

    if(items.currentLevel > 0) {
        items.introductionText.visible = false
    } else {
        items.introductionText.visible = true
    }
    coefficientsNeeded = (maxValue / maxStarSlots <= 1) ? false : true
    for(var j = 0; j < 3; j++) {
        items.repeatersList[0].itemAt(j).initStars()
        items.repeatersList[1].itemAt(j).initStars()
        items.repeatersList[2].itemAt(j).resetStars()
    }
    if(!coefficientsNeeded) {
        questionCoefficients[0] = questionCoefficients[1] = questionCoefficients[2] = 1;
        answerCoefficients[0] = answerCoefficients[1] = answerCoefficients[2] = 1;
        setCoefficientVisibility(false)
    } else {
        for(var i = 0; i < 3; i++)
            questionCoefficients[i] = Math.round(items.levels[items.currentLevel].maxStars[i] / 10);
        answerCoefficients[0] = maxValue / 100;
        answerCoefficients[1] = maxValue / 20;
        answerCoefficients[2] = maxValue / 10;
        setCoefficientVisibility(true)
    }
    var subtractor = (mode === "minus") ? 0 : 1
    numberOfStars[0] = (items.levels[items.currentLevel].maxStars[0] > 0) ? getRandomInt(items.levels[items.currentLevel].minStars[0], (items.levels[items.currentLevel].maxStars[0] / questionCoefficients[0]) - subtractor) : 0
    numberOfStars[1] = (items.levels[items.currentLevel].maxStars[1] > 0) ? getRandomInt(items.levels[items.currentLevel].minStars[1], (items.levels[items.currentLevel].maxStars[1] / questionCoefficients[1]) - subtractor) : 0
    numberOfStars[2] = (items.levels[items.currentLevel].maxStars[2] > 0) ? getRandomInt(items.levels[items.currentLevel].minStars[2], (items.levels[items.currentLevel].maxStars[2] / questionCoefficients[2]) - subtractor) : 0

    for(var i=0; i<3; i++) {
        items.repeatersList[0].itemAt(i).nbStarsOn = numberOfStars[i]
        items.repeatersList[0].itemAt(i).coefficient = questionCoefficients[i]
        items.repeatersList[1].itemAt(i).nbStarsOn = 0
        items.repeatersList[1].itemAt(i).coefficient = questionCoefficients[i]
        items.repeatersList[2].itemAt(i).nbStarsOn = 0
        items.repeatersList[2].itemAt(i).authorizeClick = false
        items.repeatersList[2].itemAt(i).coefficient = answerCoefficients[i]
        if(numberOfStars[i] > 0) {
            items.repeatersList[0].itemAt(i).opacity = 1
            items.repeatersList[1].itemAt(i).opacity = 1
            items.repeatersList[2].itemAt(i).opacity = 1
            if(mode === "minus") {
                nbStarsToAddOrRemove[i] = getRandomInt(1, numberOfStars[i]-1)
            }
            else {
                // For first level, we have 5 stars max, we don't want to add up to 10 stars
                nbStarsToAddOrRemove[i] = getRandomInt(1, Math.min(10, maxValue)-numberOfStars[i])
            }
        }
        else {
            items.repeatersList[0].itemAt(i).opacity = 0
            items.repeatersList[1].itemAt(i).opacity = 0
            items.repeatersList[2].itemAt(i).opacity = 0
        }
    }

    if(mode === "minus") {
        for(var i = 0; i < 3; i++) {
            nbStarsToCount[i] = numberOfStars[i] - nbStarsToAddOrRemove[i]
            items.repeatersList[1].itemAt(i).nbStarsOn = 0
        }
    } else {
        for(var i = 0; i < 3; i++) {
            nbStarsToCount[i] = numberOfStars[i]+nbStarsToAddOrRemove[i]
            items.repeatersList[1].itemAt(i).nbStarsOn = nbStarsToAddOrRemove[i]
        }
    }
}

function setCoefficientVisibility(visibility) {
    for(var i = 0; i < 3; i++) {
        for(var j = 0; j < 3; j++) {
            items.repeatersList[j].itemAt(i).coefficientVisible = visibility
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
    if(items.levels[items.currentLevel].maxValue / maxStarSlots <= 1) {
        if(numberOfUserStars[0] === nbStarsToCount[0] &&
        numberOfUserStars[1] === nbStarsToCount[1] &&
        numberOfUserStars[2] === nbStarsToCount[2]) {
            items.bonus.good("flower")
        } else {
            items.bonus.bad("flower")
        }
    } else {
        var starsCalculatedByUser = numberOfUserStars[0] * answerCoefficients[0] + numberOfUserStars[1] * answerCoefficients[1] +
                                                    numberOfUserStars[2] * answerCoefficients[2];
        var actualNumberOfStars = nbStarsToCount[0] * questionCoefficients[0] + nbStarsToCount[1] * questionCoefficients[1] +
        nbStarsToCount[2] * questionCoefficients[2];
        if(starsCalculatedByUser == actualNumberOfStars)
            items.bonus.good("flower")
        else
            items.bonus.bad("flower")
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

function moveStarsUnderHat() {
    if(items.currentLevel == 0) {
        items.introductionText.visible = false
    }

    for(var j = 0; j < 3; j++) {
        items.repeatersList[0].itemAt(j).moveStars()
    }
}

function moveBackMinusStars() {
    for(var j = 0; j < 3; j++) {
        items.repeatersList[0].itemAt(j).
          moveBackMinusStars(items.repeatersList[1].itemAt(j),
                             nbStarsToAddOrRemove[j])
    }
}

function movePlusStars() {
    for(var j = 0; j < 3; j++) {
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
    for(var i = 0; i < 3; i++) {
        if(numberOfStars[i] + nbStarsToAddOrRemove[i])
            items.repeatersList[2].itemAt(i).authorizeClick = true
    }
    magicHat.state = "GuessNumber"
}

function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min);
}
