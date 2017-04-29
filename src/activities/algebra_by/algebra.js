/* GCompris - algebra.js
 *
 * Copyright (C) 2014 Aruna Sankaranarayanan and Bruno Coudoin
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

var currentLevel
var coreItems
var otherItems
var operand
var secondOperandVal
var firstOperandVal
var operations = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

var nbLevel = operations.length

function start(coreItems_, otherItems_, operand_) {
    operand   = operand_
    coreItems = coreItems_
    otherItems = otherItems_
    currentLevel = 0
    coreItems.score.numberOfSubLevels = 10
    // for multiplication and addition, the first levels will display
    // currentLevel * N (N behind random)
    // where the last levels will do:
    // N * currentLevel
    if(operand.text === "x" || operand.text === "+")
        nbLevel = 2 * operations.length
    else
        nbLevel = operations.length
    initLevel()
}

function stop() {
    coreItems.balloon.stopMoving()
}

function initLevel() {
    coreItems.bar.level = currentLevel + 1
    coreItems.score.visible = false
    coreItems.score.currentSubLevel = 1
    operations = Core.shuffle(operations)
    calculateOperands()

    otherItems.iAmReady.visible = true
    otherItems.firstOp.visible = false
    otherItems.secondOp.visible = false
    coreItems.balloon.stopMoving()
}

function nextLevel() {
    if(++currentLevel >= nbLevel) {
        currentLevel = 0
    }
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = nbLevel - 1
    }
    initLevel();
}

function calculateOperands()
{
    switch(operand.text)
    {
    case "x":
        firstOperandVal = coreItems.bar.level
        secondOperandVal = operations[coreItems.score.currentSubLevel - 1]
        break;
    case "+":
        firstOperandVal = coreItems.bar.level
        secondOperandVal = operations[coreItems.score.currentSubLevel - 1]
        break;
    case "-":
        firstOperandVal = coreItems.bar.level + 9
        secondOperandVal = operations[coreItems.score.currentSubLevel - 1]
        break;
    case "/":
        firstOperandVal = coreItems.bar.level * operations[coreItems.score.currentSubLevel - 1]
        secondOperandVal = coreItems.bar.level
        break;
    }

    if(currentLevel < operations.length) {
        otherItems.firstOp.text = firstOperandVal
        otherItems.secondOp.text = secondOperandVal
    } else {
        otherItems.firstOp.text = secondOperandVal
        // Don't forget to remove the first operations.length levels
        firstOperandVal -= operations.length
        otherItems.secondOp.text = firstOperandVal
    }
}

// Return the expected answer
function getAnswer() {
    switch(operand.text)
    {
    case "x":
        return (firstOperandVal * secondOperandVal)

    case "+":
        return (firstOperandVal + secondOperandVal)

    case "-":
        return (firstOperandVal - secondOperandVal)
    
    case "/":
        return (firstOperandVal / secondOperandVal)
    }
}

function validateAnswer(screenAnswer)
{
    return (getAnswer() === screenAnswer)
}

function run() {
    calculateOperands()
    otherItems.numpad.resetText()
    coreItems.score.visible = true
    otherItems.iAmReady.visible = false
    otherItems.firstOp.visible = true
    otherItems.secondOp.visible = true
    otherItems.numpad.answerFlag = false
    otherItems.result = getAnswer()

    // TODO adjusting or disabling the difficulty
    coreItems.balloon.startMoving(20000)
}

function questionsLeft() {
    if(validateAnswer(parseInt(otherItems.numpad.answer))) {
        otherItems.numpad.answerFlag = true

        if(coreItems.score.currentSubLevel < coreItems.score.numberOfSubLevels) {
            coreItems.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/win.wav")
            coreItems.score.currentSubLevel++
            coreItems.timer.start()
        } else {
            coreItems.score.currentSubLevel = 1
            coreItems.balloon.stopMoving()
            coreItems.bonus.good("smiley");
        }
    }
}
