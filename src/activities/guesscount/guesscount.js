/* GCompris - guesscount.js
 *
 * Copyright (C) 2016 Rahul Yadav <rahulyadav170923@gmail.com>
 *
 * Authors:
 *   Pascal Georges <pascal.georges1@free.fr> (GTK+ version)
 *   RAHUL YADAV <rahulyadav170923@gmail.com> (Qt Quick port)
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
.import GCompris 1.0 as GCompris
.import "dataset.js" as Data
.import "qrc:/gcompris/src/core/core.js" as Core


var url = "qrc:/gcompris/src/activities/guesscount/resource/"
var defaultOperators = Data.defaultOperators
var baseUrl = "qrc:/gcompris/src/activities/guesscount/resource";
var builtinFile = baseUrl + "/levels-default.json";
var dataset = []

var currentLevel
var numberOfLevel = Data.levelSchema.length
var items

function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    items.currentlevel = currentLevel
    items.sublevel = 1
    items.data = buildDataset(Data.dataset, Data.levelSchema)
    items.operandRow.repeater.model = items.data[items.sublevel-1][0]
    items.levelchanged = false
    items.solved = false
    if(items.warningDialog.visible)
        items.warningDialog.visible = false
}

function initSublevel(){
    items.sublevel += 1
    items.operandRow.repeater.model = items.data[items.sublevel-1][0]
    items.solved = false
}

function nextSublevel() {
    if(items.sublevel < items.data.length) {
        initSublevel()
    }
    else {
        nextLevel()
    }
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel) {
        currentLevel = 0
    }
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel();
}

function calculate(operand1, operator, operand2, operationRow)
{
    var repeat = operationRow.rowResult
    var result
    switch (operator) {
    case "+":
        result = operand1+operand2
        break;
    case "-":
        result = operand1-operand2
        break;
    case "/":
        result = operand1/operand2
        break;
    case "*":
        result = operand1*operand2
    }

    // result is positive integer
    if(Math.round(result)-result === 0 && result >= 0) {
        operationRow.rowResult = result
        operationRow.endResult.text = operationRow.rowResult.toString()
        operationRow.complete = true
    }
    else {
        if(result != repeat) {
            operationRow.endResult.text = ""
            operationRow.complete = false
            if(result < 0)
                items.warningDialog.dialogText.text = qsTr("result is not positive integer")
            else
                items.warningDialog.dialogText.text = qsTr("result is not an integer")
            items.warningDialog.visible = true
        }
    }
}


function childrenChange(item, operationRow)
{
    if(item.children.length == 2 && item.count == 0) {
        item.count += 1
    }
    else if(item.children.length == 3) {
        item.droppedItem.parent = item.droppedItem.reparent
        operationRow.complete=false
        if(items.warningDialog.visible)
            items.warningDialog.visible = false
    }
    else if(item.children.length == 1) {
        item.count -= 1
        operationRow.complete = false
        operationRow.endResult.text = ""
    }
}

function checkAnswer(row) {
    if(items.sublevel < items.data.length) {
        items.bonus.good("flower")
        items.timer.start()
    }
    else {
        items.timer.start()
        items.bonus.good("smiley")
    }
}

function sync(array, level) {
    items.levelArr = array
}

function check(operator, array) {
    for (var i in array) {
        if(array[i] == operator) {
            return true
        }
    }
    return false
}

function configDone(array) {
    for(var i in array) {
        if(array[i].length == 0) {
            return false
        }
    }
    return true
}

function equal(levelOperators, array) {
    for(var i in levelOperators) {
        var found = false
        for(var j in array) {
            if(levelOperators[i] == array[j])
                found = true
        }
        if(!found)
            return false
    }
    return true
}

function buildDataset(data, levelSchema) {
    var level = []
    var levelArr = items.mode == 'builtin' ? defaultOperators : items.levelArr
    var noOfOperators = levelArr[currentLevel].length
    var questions
    for(var j in data[noOfOperators-1]) {
        if(equal(levelArr[currentLevel], data[noOfOperators-1][j][0])) {
            questions = data[noOfOperators-1][j][1]
            break
        }
    }
    var questions = Core.shuffle(questions)

    for(var m = 0 ; m < levelSchema[currentLevel] ; ++ m) {
        level.push(questions[m])
    }
    return level
}
