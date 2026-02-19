/* GCompris - magic-hat.js
 *
 * SPDX-FileCopyrightText: 2014 Thibaut ROMAIN
 * SPDX-FileCopyrightText: 2026 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Thibaut ROMAIN <thibrom@gmail.com>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick as Quick
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
    var maxResultPerRow = 10;
    var minStars = [];
    var maxStars = [];
    var rowCoefficients = []
    var firstMinStars = mode === "minus" ? 2 : 1;
    var multiplier = 0;

    coefficientsNeeded = items.levels[items.currentLevel].useCoefficients ?
        items.levels[items.currentLevel].useCoefficients : false;

    if(!coefficientsNeeded) {
        // init values when no coefficient is needed
        maxResultPerRow = items.levels[items.currentLevel].maxResultPerRow;
        minStars = items.levels[items.currentLevel].minStars.slice(0);
        maxStars = items.levels[items.currentLevel].maxStars.slice(0);
        items.useDifferentStars = items.levels[items.currentLevel].useDifferentStars ?
            items.levels[items.currentLevel].useDifferentStars : false;

        // first minStars and maxStars should be at least 2 for subtractions, 1 for additions
        if(maxStars[0] < firstMinStars) {
            maxStars[0] = firstMinStars;
        }
        if(minStars[0] < firstMinStars) {
            minStars[0] = firstMinStars;
        }

        // all values should not be more than 10 for subtractions, or 9 for additions, so clamp if higher values are given
        var modeMaxStars = mode === "minus" ? 10 : 9;
        for(var i = 0; i < maxStars.length; i++) {
            if(maxStars[i] > modeMaxStars) {
                maxStars[i] = modeMaxStars;
            }
            if(mode === "plus" && maxResultPerRow <= maxStars[i]) {
                // in addition mode, if a maxStars value is equal or bigger than maxResultPerRow, bump maxResultPerRow to this value + 1
                maxResultPerRow = maxStars[i] + 1;
            }
        }
        for(var i = 0; i < minStars.length; i++) {
            if(minStars[i] > modeMaxStars) {
                minStars[i] = modeMaxStars;
            } else if(minStars[i] > maxStars[i]) {
                // all minStars values should not be higher than corresponding maxStars values
                minStars[i] = maxStars[i];
            }
        }
        if(maxResultPerRow > 10) {
            maxResultPerRow = 10;
        }

    } else {
        // init values when coefficients are needed
        multiplier = items.levels[items.currentLevel].multiplier ?
            items.levels[items.currentLevel].multiplier : 1;
        items.useDifferentStars = false;
        maxResultPerRow = 10;
        rowCoefficients = items.levels[items.currentLevel].rowCoefficients.slice(0);
        if(rowCoefficients[0] < 1) {
            rowCoefficients[0] = 1;
        }

        var modeMaxStars = mode === "minus" ? 10 : 9;
        maxStars = [modeMaxStars, modeMaxStars, modeMaxStars];
        minStars = [firstMinStars, 1, 1];

        for(var i = 1; i < 3; i++) {
            if(rowCoefficients[i] === 0) {
                maxStars[i] = 0;
                minStars[i] = 0;
            }
        }
    }

    if(items.currentLevel > 0) {
        items.instructionPanel.visible = false;
    } else {
        items.instructionPanel.visible = true;
    }

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
            questionCoefficients[i] = rowCoefficients[i] * multiplier;
        answerCoefficients[0] = multiplier;
        answerCoefficients[1] = multiplier * 5;
        answerCoefficients[2] = multiplier * 10;
        setCoefficientVisibility(true)
    }

    if(mode === "minus") {
        numberOfStars[0] = getRandomInt(minStars[0], maxStars[0]);
        numberOfStars[1] = (maxStars[1] > 0) ? getRandomInt(minStars[1], maxStars[1]) : 0;
        numberOfStars[2] = (maxStars[2] > 0) ? getRandomInt(minStars[2], maxStars[2]) : 0;
    } else {
        numberOfStars[0] = getRandomInt(minStars[0], maxStars[0]);
        if(maxStars[1] > 0) {
            numberOfStars[1] = getRandomInt(minStars[1], maxStars[1]);
        } else {
            numberOfStars[1] = 0;
        }
        if(maxStars[2] > 0) {
            numberOfStars[2] = getRandomInt(minStars[2], maxStars[2]);
        } else {
            numberOfStars[2] = 0;
        }
    }

    for(var i=0; i<3; i++) {
        items.repeatersList[0].itemAt(i).nbStarsOn = numberOfStars[i];
        items.repeatersList[0].itemAt(i).coefficient = questionCoefficients[i];
        items.repeatersList[1].itemAt(i).nbStarsOn = 0;
        items.repeatersList[1].itemAt(i).coefficient = questionCoefficients[i];
        items.repeatersList[2].itemAt(i).nbStarsOn = 0;
        items.repeatersList[2].itemAt(i).authorizeClick = false;
        items.repeatersList[2].itemAt(i).coefficient = answerCoefficients[i];
        if(numberOfStars[i] > 0) {
            items.repeatersList[0].itemAt(i).opacity = 1;
            items.repeatersList[1].itemAt(i).opacity = 1;
            items.repeatersList[2].itemAt(i).opacity = 1;
            if(mode === "minus") {
                // Make sure result for this row is less than maxResultPerRow
                var diffToMaxValue = numberOfStars[i] - maxResultPerRow;
                if(i === 0) {
                    // avoid result 0 on first row
                    nbStarsToAddOrRemove[i] = getRandomInt(Math.max(1, diffToMaxValue), numberOfStars[i] - 1);
                } else {
                    nbStarsToAddOrRemove[i] = getRandomInt(Math.max(1, diffToMaxValue), numberOfStars[i]);
                }
            }
            else {
                nbStarsToAddOrRemove[i] = getRandomInt(1, maxResultPerRow - numberOfStars[i]);
            }
        } else {
            items.repeatersList[0].itemAt(i).opacity = 0;
            items.repeatersList[1].itemAt(i).opacity = 0;
            if(coefficientsNeeded) {
                items.repeatersList[2].itemAt(i).opacity = 1;
            } else {
                items.repeatersList[2].itemAt(i).opacity = 0;
            }
        }
    }

    if(mode === "minus") {
        for(var i = 0; i < 3; i++) {
            nbStarsToCount[i] = numberOfStars[i] - nbStarsToAddOrRemove[i];
            items.repeatersList[1].itemAt(i).nbStarsOn = 0;
        }
    } else {
        for(var i = 0; i < 3; i++) {
            nbStarsToCount[i] = numberOfStars[i]+nbStarsToAddOrRemove[i];
            items.repeatersList[1].itemAt(i).nbStarsOn = nbStarsToAddOrRemove[i];
        }
    }
    items.inputBlocked = false;
}

function setCoefficientVisibility(visibility) {
    items.coefficientVisible = visibility;
}

function userClickedAStar(barIndex,state) { 
    if(state)
        numberOfUserStars[barIndex]++
    else
        numberOfUserStars[barIndex]--
}

function verifyAnswer() {
    if(items.useDifferentStars) {
        if(numberOfUserStars[0] === nbStarsToCount[0] &&
            numberOfUserStars[1] === nbStarsToCount[1] &&
            numberOfUserStars[2] === nbStarsToCount[2]) {
            items.bonus.good("flower")
        } else {
            items.bonus.bad("flower")
        }
    } else {
        var starsCalculatedByUser = numberOfUserStars[0] * answerCoefficients[0] +
                                    numberOfUserStars[1] * answerCoefficients[1] +
                                    numberOfUserStars[2] * answerCoefficients[2];
        var actualNumberOfStars = nbStarsToCount[0] * questionCoefficients[0] +
                                  nbStarsToCount[1] * questionCoefficients[1] +
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
        if(numberOfStars[i] + nbStarsToAddOrRemove[i] || coefficientsNeeded) {
            items.repeatersList[2].itemAt(i).authorizeClick = true;
        }
    }
    magicHat.state = "GuessNumber"
}

function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min);
}
