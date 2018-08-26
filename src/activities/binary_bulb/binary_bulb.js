/* GCompris - binary_bulb.js
 *
 * Copyright (C) 2018 Rajat Asthana <rajatasthana4@gmail.com>
 *
 * Authors:
 *   "RAJAT ASTHANA" <rajatasthana4@gmail.com>
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

var numberOfLevel
var items
var dataset
var levelDataset

function start(items_, dataset_) {
    items = items_
    dataset = dataset_.get()
    items.currentLevel = 0
    numberOfLevel = dataset.length
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
    items.numberToConvert = levelDataset[items.score.currentSubLevel - 1]
}

function equalityCheck() {
    if(items.numberSoFar == items.numberToConvert) {
        if(items.score.currentSubLevel < items.score.numberOfSubLevels) {
            items.score.currentSubLevel++;
            items.score.playWinAnimation()
            resetBulbs()
            initializeValues()
        }
        else {
            items.bonus.good("lion")
            resetBulbs()
        }
    }
    else {
        items.bonus.bad("lion")
        resetBulbs()
        items.numberSoFar = 0
    }
}

function changeState(index) {
    var currentBulb = items.bulbs.itemAt(index)
    if(currentBulb.state == "off") {
        currentBulb.state = "on"
        items.numberSoFar += currentBulb.value
    }
    else {
        currentBulb.state = "off"
        items.numberSoFar -= currentBulb.value
    }
}

function initLevel() {
    items.bar.level = items.currentLevel + 1
    items.score.numberOfSubLevels = dataset[items.currentLevel].numbersToBeConverted.length
    items.score.currentSubLevel = 1
    items.numberOfBulbs = dataset[items.currentLevel].bulbCount
    levelDataset = Core.shuffle(dataset[items.currentLevel].numbersToBeConverted)
    initializeValues()
    resetBulbs()
}

function nextLevel() {
    if(numberOfLevel <= items.currentLevel + 1) {
        items.currentLevel = 0
    }
    else {
        ++ items.currentLevel
    }
    items.score.currentSubLevel = 1
    initLevel();
}

function previousLevel() {
    if(items.currentLevel-1 < 0) {
        items.currentLevel = numberOfLevel - 1
    }
    else {
        --items.currentLevel
    }
    items.score.currentSubLevel = 1
    initLevel();
}
