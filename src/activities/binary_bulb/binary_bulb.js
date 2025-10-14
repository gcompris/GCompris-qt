/* GCompris - binary_bulb.js
 *
 * SPDX-FileCopyrightText: 2018 Rajat Asthana <rajatasthana4@gmail.com>
 *
 * Authors:
 *   "RAJAT ASTHANA" <rajatasthana4@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var numberOfLevel
var items
var dataset
var url = "qrc:/gcompris/src/activities/binary_bulb/resource/"
var levelDataset

function start(items_) {
    items = items_
    numberOfLevel = items.levels.length
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
}

function stop() {
}

function resetBulbs() {
    for(var i = 0; i < items.numberOfBulbs; i++) {
        items.bulbs.itemAt(i).state = "off"
    }
}

function initializeValues() {
    items.currentSelectedBulb = -1
    items.numberSoFar = 0
    items.numberToConvert = levelDataset[items.score.currentSubLevel]
    items.client.startTiming()      // for server version
}

function equalityCheck() {
    items.buttonsBlocked = true
    if(items.numberSoFar === items.numberToConvert) {
        items.score.currentSubLevel++
        items.score.playWinAnimation()
        items.goodAnswerSound.play()
        items.client.sendToServer(true)     // for server version

    } else {
        items.errorRectangle.startAnimation()
        items.badAnswerSound.play()
        items.client.sendToServer(false)    // for server version
    }
}

function nextSubLevel() {
    if (items.score.currentSubLevel >= items.score.numberOfSubLevels) {
        items.bonus.good("lion")
    } else {
        resetBulbs()
        initializeValues()
        items.buttonsBlocked = false
    }
}

function changeState(index) {
    var currentBulb = items.bulbs.itemAt(index)
    if(currentBulb.state === "off") {
        currentBulb.state = "on"
        items.numberSoFar += currentBulb.value
    }
    else {
        currentBulb.state = "off"
        items.numberSoFar -= currentBulb.value
    }
}

function initLevel() {
    dataset = items.levels[items.currentLevel]
    items.errorRectangle.resetState()
    items.score.currentSubLevel = 0
    items.numberOfBulbs = dataset.bulbCount
    var numberList = new Array();
    if(dataset.random) {
        var maxValue = Math.pow(2, dataset.bulbCount) - 1;
        // Find between 1 and max-1
        for(var i = 0; i < dataset.numberSubLevels; ++ i) {
            numberList.push(Math.floor(Math.random() * maxValue) + 1)
        }
    }
    else {
        numberList = dataset.numbersToBeConverted;
    }
    if(dataset.shuffle) {
        levelDataset = Core.shuffle(numberList)
    }
    else {
        levelDataset = numberList
    }

    items.score.numberOfSubLevels = levelDataset.length
    initializeValues()
    resetBulbs()
    items.buttonsBlocked = false
}

function nextLevel() {
    items.score.stopWinAnimation()
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.score.stopWinAnimation()
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}
