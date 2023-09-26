/* GCompris - guesscount.js
 *
 * SPDX-FileCopyrightText: 2016 Rahul Yadav <rahulyadav170923@gmail.com>
 *
 * Authors:
 *   Pascal Georges <pascal.georges1@free.fr> (GTK+ version)
 *   RAHUL YADAV <rahulyadav170923@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.12 as Quick
.import "dataset.js" as Data
.import "qrc:/gcompris/src/core/core.js" as Core


var url = "qrc:/gcompris/src/activities/guesscount/resource/"
var defaultOperators = Data.defaultOperators
var baseUrl = "qrc:/gcompris/src/activities/guesscount/resource";
var builtinFile = baseUrl + "/levels-default.json";
var dataset = []

var numberOfLevel = Data.levelSchema.length
var items
var dataItems
var levelSchema

function start(items_) {
    items = items_
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    initLevel()
}

function stop() {
    items.timer.stop();
}

function initLevel() {
    items.currentlevel = items.currentLevel
    items.sublevel = 1

    var multipleDataOperators = []
    var multipleDataItems = []
    var multipleDataSchema = []

    if(items.levels && items.mode === 'builtin') {

        for(var i = 0; i < items.levels.length; i++) {
            multipleDataOperators = multipleDataOperators.concat(items.levels[i].defaultOperators)
            multipleDataSchema = multipleDataSchema.concat(items.levels[i].levelSchema)
            multipleDataItems = multipleDataItems.concat(items.levels[i].dataItems)
        }

        defaultOperators = multipleDataOperators
        numberOfLevel = multipleDataSchema.length
        dataItems = multipleDataItems
        levelSchema = multipleDataSchema
        items.data = buildDataset(dataItems, levelSchema)
        items.operatorRow.repeater.model = defaultOperators[items.currentLevel]
    }
    else if(items.mode === "admin") {
        numberOfLevel = Data.levelSchema.length
        items.data = buildDataset(Data.dataset, Data.levelSchema)
        items.operatorRow.repeater.model = items.levelArr[items.currentLevel]
    }

    items.operandRow.repeater.model = Core.shuffle(items.data[items.sublevel-1][0])
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
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
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

function findIndex(data) {

    var index
    var levelArr = defaultOperators

    for(var i = 0; i < data.length; i++) {
        for(var j in data[i]) {
            if(equal(levelArr[items.currentLevel], data[i][j][0])) {
                return i
            }
        }
    }
}

function buildDataset(data, levelSchema) {

    var level = []
    var levelArr = (items.mode === 'builtin' && items.levels) ? defaultOperators : items.levelArr
    var noOfOperators = levelArr[items.currentLevel].length
    var index = (items.mode === 'builtin' && items.levels) ? findIndex(data) : noOfOperators - 1

    for(var j in data[index]) {
        if(equal(levelArr[items.currentLevel], data[index][j][0])) {
            questions = data[index][j][1]
            break
        }
    }

    var questions = Core.shuffle(questions)

    for(var m = 0 ; m < levelSchema[items.currentLevel] ; ++ m) {
        level.push(questions[m])
    }
    return level
}

