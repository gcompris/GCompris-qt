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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
.pragma library
.import QtQuick 2.6 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var numberOfLevel
var items
var dataset
var url = "qrc:/gcompris/src/activities/binary_bulb/resource/"
var tutorialInstructions = [
            {
                "instruction": qsTr("This activity teaches how to convert decimal numbers to binary numbers."),
                "instructionQml" : "qrc:/gcompris/src/activities/binary_bulb/resource/tutorial1.qml"
            },
            {
                "instruction": qsTr("Computers use transistors to count and transistors have only two states, 0 and 1. Mathematically, these states are represented by 0 and 1, which makes up the binary system of numeration."),
                "instructionQml" : "qrc:/gcompris/src/activities/binary_bulb/resource/tutorial2.qml"
            },
            {
                "instruction": qsTr("In the activity 0 and 1 are simulated by bulbs, switched on or off."),
                "instructionQml": "qrc:/gcompris/src/activities/binary_bulb/resource/tutorial3.qml"
            },
            {
                "instruction": qsTr("Binary system uses these numbers very efficiently, allowing to count from 0 to 255 with 8 bits only."),
                "instructionQml": "qrc:/gcompris/src/activities/binary_bulb/resource/tutorial4.qml"
            },
            {
                "instruction": qsTr("Each bit adds a progressive value, corresponding to the powers of 2, ascending from right to left: bit 1 → 2⁰=1 , bit 2 → 2¹=2 , bit 3 → 2²=4 , bit 4 → 2³=8 , bit 5 → 2⁴=16 , bit 6 → 2⁵=32 , bit 7 → 2⁶=64 , bit 8 → 2⁷=128."),
                "instructionQml": "qrc:/gcompris/src/activities/binary_bulb/resource/tutorial5.qml"
            },
            {
                "instruction":  qsTr("To convert a decimal 5 to a binary value, 1 and 4 are added."),
                "instructionQml": "qrc:/gcompris/src/activities/binary_bulb/resource/tutorial6.qml"
            },
            {
                "instruction": qsTr("Their corresponding bits are set to 1, the others set to 0. Decimal 5 is equal to binary 101."),
                "instructionQml": "qrc:/gcompris/src/activities/binary_bulb/resource/tutorial7.qml"
            },
            {
                "instruction": qsTr("This image will help you to compute bits' value."),
                "instructionQml": "qrc:/gcompris/src/activities/binary_bulb/resource/tutorial5.qml"
            }
        ]
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
