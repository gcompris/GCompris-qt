/* GCompris - algebra.js
 *
 * SPDX-FileCopyrightText: 2014 Aruna Sankaranarayanan and Bruno Coudoin
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

.pragma library
.import QtQuick 2.12 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var numberOfLevel
var items
var dataset
var operand
var secondOperandVal
var firstOperandVal
var subLevelData = []
var speedSetting
var operandText
var OperandsEnum = {
    TIMES_SIGN : "\u00D7",
    PLUS_SIGN : "\u002B",
    MINUS_SIGN : "\u2212",
    DIVIDE_SIGN : "\u2215"
}


function start(items_, operand_, speedSetting_) {
    operand = operand_
    items = items_
    speedSetting = speedSetting_
    dataset = items.levels
    numberOfLevel = dataset.length
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    initLevel()
}

function stop() {
    items.balloon.stopBalloon()
    items.timer.stop()
}

// get appropriate operands depending on operator
function getOperands(min, max)
{
    switch(operand.text)
    {
    case OperandsEnum.TIMES_SIGN:
        return [randomInRange(min,max), randomInRange(min,max)]

    case OperandsEnum.PLUS_SIGN:
        return [randomInRange(min,max), randomInRange(min,max)]

    case OperandsEnum.MINUS_SIGN:
        // Left operand is always greater than right operand
        var minusLeftOperand = randomInRange(min, max)
        var minusRightOperand = randomInRange(min, minusLeftOperand)
        return [minusLeftOperand, minusRightOperand]

    case OperandsEnum.DIVIDE_SIGN:
        // Left operand is a multiple of right operand
        var divideRightOperand = randomInRange(min, max)
        var divideLeftOperand = divideRightOperand * randomInRange(min, max)
        return [divideLeftOperand, divideRightOperand]
    }
}

function initLevel() {
    items.score.visible = false
    items.okButton.visible = false
    items.score.currentSubLevel = 1
    subLevelData = []

    /**
     It exists two types of levels:
      - the operation table where all operands are defined in the dataset
      - the generated question, where the dataset specify constraits
     Leveltype is determined by checking what is the inner structure of the dataset
    */
    if("operands" in dataset[items.currentLevel]) {
        items.score.numberOfSubLevels = dataset[items.currentLevel].operands.length;
        for(var i = 0; i < items.score.numberOfSubLevels; i++)
            subLevelData.push([dataset[items.currentLevel].operands[i].first, dataset[items.currentLevel].operands[i].second])
    }
    else {
        // Generate random operations
        var minOperandValue = dataset[items.currentLevel].min
        var maxOperandValue = dataset[items.currentLevel].max
        var limit = dataset[items.currentLevel].limit
        items.score.numberOfSubLevels = 10;
        for(var i = 0; i < items.score.numberOfSubLevels; i++)
        {
            var leftOperand = 0;
            var rightOperand = 0;
            do
            {
                [leftOperand, rightOperand] = getOperands(minOperandValue, maxOperandValue);
            } while(limit !== 0 && getAnswer(leftOperand, rightOperand) > limit);
            subLevelData.push([leftOperand, rightOperand])
        }
    }

    subLevelData = Core.shuffle(subLevelData)
    calculateOperands()
    items.iAmReady.visible = true
    items.firstOp.visible = false
    items.secondOp.visible = false
    items.balloon.stopMoving()
}

function randomInRange(min, max) {
    return Math.floor(min + Math.random() * (max - min + 1))
}

function circularShiftElements() {
    if(!validateAnswer(parseInt(items.numpad.answer)))
        subLevelData.push(subLevelData.shift())
    else
        subLevelData.shift()
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function calculateOperands()
{
    firstOperandVal = subLevelData[0][0]
    secondOperandVal = subLevelData[0][1]

    items.firstOp.text = firstOperandVal
    items.secondOp.text = secondOperandVal
}

// Return the expected answer
function getAnswer(val1, val2) {
    switch(operand.text)
    {
    case OperandsEnum.TIMES_SIGN:
        return (val1 * val2)

    case OperandsEnum.PLUS_SIGN:
        return (val1 + val2)

    case OperandsEnum.MINUS_SIGN:
        return (val1 - val2)

    case OperandsEnum.DIVIDE_SIGN:
        return (val1 / val2)
    }
}

function validateAnswer(screenAnswer)
{
    return (getAnswer(firstOperandVal, secondOperandVal) === screenAnswer)
}

function run() {
    calculateOperands()
    items.numpad.resetText()
    items.score.visible = true
    items.iAmReady.visible = false
    items.firstOp.visible = true
    items.secondOp.visible = true
    items.okButton.visible = true
    items.numpad.answerFlag = false
    items.result = getAnswer(firstOperandVal, secondOperandVal)
    items.balloon.startMoving(100000 / speedSetting)
}

function questionsLeft() {
    items.okButton.enabled = false
    items.balloon.startMoving(100000 / speedSetting)
    circularShiftElements()
    if(validateAnswer(parseInt(items.numpad.answer))) {
        items.numpad.answerFlag = true

        if(items.score.currentSubLevel < items.score.numberOfSubLevels) {
            items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/win.wav")
            items.score.currentSubLevel++
            items.timer.start()
        } else {
            items.balloon.stopMoving()
            items.bonus.good("smiley");
        }
    }
    else
        items.bonus.bad("smiley");
}
