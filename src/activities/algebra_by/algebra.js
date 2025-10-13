/* GCompris - algebra.js
 *
 * SPDX-FileCopyrightText: 2014 Aruna Sankaranarayanan and Bruno Coudoin
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

.pragma library
.import QtQuick as Quick
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

/* Possible dataset content
 *
 * [
 *   {
 *    "randomOperands": true, (tells if random operands should be generated, else use the operands list)
 *    "numberSubLevels": 10, (allows to set the number of subLevels if operands are not defined, else default to 10)
 *    "min": 0, (minimum operand value)
 *    "max": 10, (maximum operand value)
 *    "limit": 0, (if != 0, set the maximum result value allowed)
 *    "shuffle": true, (if !randomOperands, tells if initial question order should be shuffled)
 *    "operands": [ (if !randomOperands and operands are defined here, they are used and numberSubLevels/min/max/limit are not used)
 *       {
 *        "first": 1,
 *        "second": 10,
 *       },
 *       {
 *        "first": 2,
 *        "second": 10
 *       }
 *     ]
 *   }
 * ]
 *
 */


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
    items.score.currentSubLevel = 0
    subLevelData = []

    /**
     It exists two types of levels:
      - the operation table where all operands are defined in the dataset
      - the generated question, where the dataset specify constraints
     Leveltype is determined by checking what is the inner structure of the dataset
    */
    var fixedOperands = false;
    if(!dataset[items.currentLevel].randomOperands && "operands" in dataset[items.currentLevel]) {
        fixedOperands = true;
        items.score.numberOfSubLevels = dataset[items.currentLevel].operands.length;
        for(var i = 0; i < items.score.numberOfSubLevels; i++) {
            subLevelData.push([dataset[items.currentLevel].operands[i].first, dataset[items.currentLevel].operands[i].second])
        }
    }
    else {
        // Generate random operations
        var minOperandValue = dataset[items.currentLevel].min
        var maxOperandValue = dataset[items.currentLevel].max
        var limit = dataset[items.currentLevel].limit
        if(dataset[items.currentLevel].numberSubLevels) {
            items.score.numberOfSubLevels = dataset[items.currentLevel].numberSubLevels;
        } else {
            items.score.numberOfSubLevels = 10; // default to 10 if not sepecified
        }
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

    if(!fixedOperands || (fixedOperands && dataset[items.currentLevel].shuffle)) {
        subLevelData = Core.shuffle(subLevelData)
    }
    calculateOperands()
    items.iAmReady.visible = true
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
    items.errorRectangle.resetState();
    items.score.stopWinAnimation();
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.errorRectangle.resetState();
    items.score.stopWinAnimation();
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
    items.iAmReady.visible = false
    items.numpad.answerFlag = false
    items.result = getAnswer(firstOperandVal, secondOperandVal)
    items.balloon.startMoving(100000 / speedSetting)
    items.buttonsBlocked = false
    items.client.startTiming()      // for server version
}

function checkAnswer() {
    items.buttonsBlocked = true
    items.balloon.startMoving(100000)
    if(validateAnswer(parseInt(items.numpad.answer))) {
        items.client.sendToServer(true)
        items.score.currentSubLevel++
        items.score.playWinAnimation()
        items.goodAnswerSound.play()
    } else {
        items.client.sendToServer(false)
        items.errorRectangle.startAnimation()
        items.badAnswerSound.play()
    }
}

function nextQuestion() {
    circularShiftElements();
    run();
}

function questionsLeft() {
    if(items.score.currentSubLevel >= items.score.numberOfSubLevels) {
        items.bonus.good("smiley")
    } else {
        nextQuestion();
    }
}
