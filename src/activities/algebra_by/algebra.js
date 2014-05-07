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
.import QtQuick 2.0 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var currentLevel
var coreItems
var otheritems
var operand
var secondOperandVal
var firstOperandVal
var operations = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

var nbLevel = 10

function start(coreItems_, otherItems_, operand_) {
    operand   = operand_
    coreItems = coreItems_
    otheritems = otherItems_
    currentLevel = 0
    coreItems.score.numberOfSubLevels = 10
    initLevel()
}

function stop() {
}

function initLevel() {
    coreItems.bar.level = currentLevel + 1
    coreItems.score.visible = false
    coreItems.score.currentSubLevel = 1
    operations = Core.shuffle(operations)
    calculateOperands()

    otheritems.iAmReady.visible = true
    otheritems.firstOp.visible = false
    otheritems.secondOp.visible = false
    coreItems.balloon.stopMoving()
}

function nextLevel() {
    if( ++currentLevel >= nbLevel ) {
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
    }

    otheritems.firstOp.text = firstOperandVal
    otheritems.secondOp.text = secondOperandVal
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
    }
}

function validateAnswer(screenAnswer)
{
        switch(operand.text)
        {
            case "x":
                return (getAnswer() === screenAnswer)

            case "+":
               return (getAnswer() === screenAnswer)

            case "-":
                return (getAnswer() === screenAnswer)
        }
}

function run() {
    calculateOperands()
    otheritems.numpad.resetText()
    coreItems.score.visible = true
    otheritems.iAmReady.visible = false
    otheritems.firstOp.visible = true
    otheritems.secondOp.visible = true
    otheritems.numpad.answerFlag = false
    otheritems.result = getAnswer()

    // TODO adjusting or disabling the difficulty
    coreItems.balloon.startMoving(20000)
}

function questionsLeft() {
    if(validateAnswer(parseInt(otheritems.numpad.answer))) {
        otheritems.numpad.answerFlag = true

        if(coreItems.score.currentSubLevel < 10) {
            coreItems.score.currentSubLevel++
            coreItems.timer.start()
        } else if(coreItems.score.currentSubLevel >= 10) {
            coreItems.score.currentSubLevel = 1
            coreItems.balloon.stopMoving()
            coreItems.bonus.good("smiley");
        }
    }
}

function keyEvent(key, pressed)
{
    var keyValue;

    switch(key)
    {
    case Qt.Key_0 :
        keyValue = 0;
        break;
    case Qt.Key_1:
        keyValue = 1;
        break;
    case Qt.Key_2:
        keyValue = 2;
        break;
    case Qt.Key_3:
        keyValue = 3;
        break;
    case Qt.Key_4:
        keyValue = 4;
        break;
    case Qt.Key_5:
        keyValue = 5;
        break;
    case Qt.Key_6:
        keyValue = 6;
        break;
    case Qt.Key_7:
        keyValue = 7;
        break;
    case Qt.Key_8:
        keyValue = 8;
        break;
    case Qt.Key_9:
        keyValue = 9;
        break;
    case Qt.Key_Backspace:
        keyValue = 10;
    }

    if(pressed && !otheritems.numpad.answerFlag)
    {
        if(keyValue < 5 &&
           otheritems.numpad.answer.length < otheritems.numpad.maxDigit)
        {
            otheritems.numpad.answer += keyValue;
            otheritems.numpad.leftPanelComponent.children[keyValue].color = Qt.lighter(otheritems.numpad.colours[keyValue])
            otheritems.numpad.leftPanelComponent.children[keyValue].border.width = 5
        }
        else if(keyValue < 10 &&
            otheritems.numpad.answer.length < otheritems.numpad.maxDigit)
        {
            otheritems.numpad.answer += keyValue;
            otheritems.numpad.rightPanelComponent.children[keyValue - 5].color = Qt.lighter(otheritems.numpad.colours[keyValue - 5])
            otheritems.numpad.rightPanelComponent.children[keyValue - 5].border.width = 5
        }
        else if(keyValue === 10)
        {
            otheritems.numpad.answer = otheritems.numpad.answer.substring(0,otheritems.numpad.answer.length - 1)
            otheritems.numpad.backspaceButtonComponent.color = Qt.lighter("white")
            otheritems.numpad.backspaceButtonComponent.border.width = 5
        }
    }
    else
    {
        if(keyValue < 5)
        {
            otheritems.numpad.leftPanelComponent.children[keyValue].color = otheritems.numpad.colours[keyValue]
            otheritems.numpad.leftPanelComponent.children[keyValue].border.width = 2
        }
        else if(keyValue < 10)
        {

            otheritems.numpad.rightPanelComponent.children[keyValue - 5].color = otheritems.numpad.colours[keyValue - 5]
            otheritems.numpad.rightPanelComponent.children[keyValue - 5].border.width = 2
        }
        else if(keyValue === 10)
        {
            otheritems.numpad.backspaceButtonComponent.color = "white"
            otheritems.numpad.backspaceButtonComponent.border.width = 2
        }
    }

}
