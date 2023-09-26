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
.import QtQuick 2.12 as Quick
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
                "instruction": qsTr("Their corresponding bits are set to 1, the others are set to 0. Decimal 5 is equal to binary 101."),
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
    numberOfLevel = dataset.length
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
    items.score.numberOfSubLevels = dataset[items.currentLevel].numbersToBeConverted.length
    items.score.currentSubLevel = 1
    items.numberOfBulbs = dataset[items.currentLevel].bulbCount
    levelDataset = Core.shuffle(dataset[items.currentLevel].numbersToBeConverted)
    initializeValues()
    resetBulbs()
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    items.score.currentSubLevel = 1
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    items.score.currentSubLevel = 1
    initLevel();
}
