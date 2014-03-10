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
var main
var background
var bar
var bonus
var score
var balloon
var iAmReady
var firstOp
var secondOp
var timer
var numpad
var secondOperandVal
var firstOperandVal
var operations = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

var nbLevel = 10

function start(_main, _background, _bar, _bonus, _score, _balloon,
               _iAmReady, _firstOp, _secondOp, _timer, _numpad) {
    main = _main
    background = _background
    bar = _bar
    bonus = _bonus
    score = _score
    balloon = _balloon
    iAmReady = _iAmReady
    firstOp = _firstOp
    secondOp = _secondOp
    timer = _timer
    numpad = _numpad
    currentLevel = 0
    score.numberOfSubLevels = 10
    initLevel()
}

function stop() {
}

function initLevel() {
    bar.level = currentLevel + 1
    score.visible = false
    score.currentSubLevel = 1
    operations = shuffle(operations)
    calculateOperands()

    iAmReady.visible = true
    firstOp.visible = false
    secondOp.visible = false
    balloon.stopMoving()
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
    firstOperandVal = bar.level
    secondOperandVal = operations[score.currentSubLevel - 1]
    firstOp.text = firstOperandVal
    secondOp.text = secondOperandVal
}

function validateAnswer(screenAnswer)
{
    return (firstOperandVal * secondOperandVal === screenAnswer)
}

function run() {
    calculateOperands()
    numpad.resetText()
    score.visible = true
    iAmReady.visible = false
    firstOp.visible = true
    secondOp.visible = true
    // TODO adjusting or disabling the difficulty
    balloon.startMoving(20000)
}

function questionsLeft() {
    if(validateAnswer(parseInt(numpad.answer))) {
        numpad.answerFlag = true

        if(score.currentSubLevel < 10) {
            score.currentSubLevel++
            timer.start()
        } else if(score.currentSubLevel >= 10) {
            score.currentSubLevel = 1
            balloon.stopMoving()
            bonus.good("smiley");
        }
    }
}

function shuffle(o) {
    for(var j, x, i = o.length; i;
        j = Math.floor(Math.random() * i), x = o[--i], o[i] = o[j], o[j] = x);
    return o;
}
