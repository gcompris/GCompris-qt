/* GCompris - guesscount-summer.js
 *
 * Copyright (C) 2016 Rahul Yadav <rahulyadav170923@gmail.com>
 *
 * Authors:
 *   <Pascal Georges> (GTK+ version)
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
.import QtQuick 2.0 as Quick
.import GCompris 1.0 as GCompris
.import "dataset.js" as Data
.import "qrc:/gcompris/src/core/core.js" as Core


var url = "qrc:/gcompris/src/activities/guesscount-summer/resource/"
var operators = [
            "+",
            "-",
            "/",
            "*",
        ]
var defaultOperators=Data.defaultOperators
var baseUrl = "qrc:/gcompris/src/activities/guesscount-summer/resource";
var builtinFile = baseUrl + "/levels-default.json";
var dataset=[]


var currentLevel
var numberOfLevel=Data.levelSchema.length
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
    //console.log(currentLevel)
    items.currentlevel = currentLevel
    items.sublevel = 1
    items.data=buidDataset(Data.dataset,Data.levelSchema)
    items.operandRow.repeater.model = items.data[items.sublevel-1][0]
    console.log("dataset :"+items.data  )
    items.levelchanged=false
}
function next_sublevel() {
    items.sublevel += 1
    items.operandRow.repeater.model = items.data[items.sublevel-1][0]
    items.solved=false
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel ) {
        currentLevel = 0
    }
    console.log(currentLevel)
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel();
}

function calculate(operand1,operator,operand2,operationRow)
{
    var result
    switch (operator) {
    case "+":
        result = operand1+operand2
        console.log(result)
        break;
    case "-":
        result = operand1-operand2
        console.log(result)
        break;
    case "/":
        result = operand1/operand2
        console.log(result)
        break;
    case "*":
        result = operand1*operand2
        console.log(result)
    }
    if(Math.round(result)-result==0)
    {
        operationRow.rowResult=result
        operationRow.endResult.text=operationRow.rowResult.toString()
    }
    else
    {
        items.dialog.visible=true
    }

}

function childrenChange(item,operationRow)
{
    if(item.children.length==2 && item.count==0)
    {
        item.count+=1
        console.log(" first item is dropped "+item.count)

    }
    else if(item.children.length==3)
    {
        item.droppedItem.parent=item.droppedItem.reparent
        console.log(" second item is replaced "+item.count)
    }
    else if(item.children.length==1)
    {
        item.count-=1
        console.log(" first item left "+item.count)
        operationRow.endResult.text=""
        operationRow.rowResult=0
        operationRow.complete=false
    }
}

function checkAnswer(row){
    if(items.sublevel<items.data.length)
    {
        items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/win.wav")
        items.timer.start()
    }
    else if(items.sublevel==items.data.length)
    {
        items.timer.start()
        items.bonus.good("smiley")
    }
}

function sync(array,level){
    items.levelArr=array
    console.log("level "+level+"  "+array[level])
}

function check(operator,array){
    for (var i in array){
        if(array[i]==operator ){
            return true
        }
    }
    return false
}

function configDone(array){
    for(var i in array){
        if(array[i].length==0){
            return false
        }
    }
    return true
}


function equal(levelOperators,array){
    for(var i in levelOperators){
        var found=0
        for(var j in array){
            if(levelOperators[i]==array[j])
                found=1
        }
        if(!found)
            return false
    }
    return true
}

function buidDataset(data,levelSchema){
    var level=[]
    var levelArr=items.mode=='builtin' ? defaultOperators : items.levelArr
    var noOfOperators=levelArr[currentLevel].length
    var questions
    for(var j in data[noOfOperators-1]){
        if(equal(levelArr[currentLevel],data[noOfOperators-1][j][0])){
            questions=data[noOfOperators-1][j][1]
            break
        }
    }
    var questions=Core.shuffle(questions)

    for(var m=0;m<levelSchema[currentLevel];m++){
        level.push(questions[m])
    }
    return level
}

