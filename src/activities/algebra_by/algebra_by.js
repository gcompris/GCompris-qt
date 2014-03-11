/* GCompris - activity.js
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

var currentLevel
var items
var secondOperandVal
var firstOperandVal
var operations = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

var nbLevel = 10

function start(items_) {
    items = items_
    currentLevel = 0
    items.score.numberOfSubLevels = 10
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    items.score.visible = false
    items.score.currentSubLevel = 1
    operations = shuffle(operations)
    calculateOperands()

    items.iAmReady.visible = true
    items.firstOp.visible = false
    items.secondOp.visible = false
    items.balloon.stopMoving()
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
    firstOperandVal = items.bar.level
    secondOperandVal = operations[items.score.currentSubLevel - 1]
    items.firstOp.text = firstOperandVal
    items.secondOp.text = secondOperandVal
}

function validateAnswer(screenAnswer)
{
    return (firstOperandVal * secondOperandVal === screenAnswer)
}

function run() {
    calculateOperands()
    items.numpad.resetText()
    items.score.visible = true
    items.iAmReady.visible = false
    items.firstOp.visible = true
    items.secondOp.visible = true
    // TODO adjusting or disabling the difficulty
    items.balloon.startMoving(20000)
}

function questionsLeft() {
    if(validateAnswer(parseInt(items.numpad.answer))) {
        items.numpad.answerFlag = true

        if(items.score.currentSubLevel < 10) {
            items.score.currentSubLevel++
            items.timer.start()
        } else if(items.score.currentSubLevel >= 10) {
            items.score.currentSubLevel = 1
            items.balloon.stopMoving()
            items.bonus.good("smiley");
        }
    }
}

function shuffle(o) {
    for(var j, x, i = o.length; i;
        j = Math.floor(Math.random() * i), x = o[--i], o[i] = o[j], o[j] = x);
    return o;
}
