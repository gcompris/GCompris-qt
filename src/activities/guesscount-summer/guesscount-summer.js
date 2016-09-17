/* GCompris - guesscount-summer.js
 *
 * Copyright (C) 2016 YOUR NAME <xx@yy.org>
 *
 * Authors:
 *   <THE GTK VERSION AUTHOR> (GTK+ version)
 *   "YOUR NAME" <YOUR EMAIL> (Qt Quick port)
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

var url = "qrc:/gcompris/src/activities/guesscount-summer/resource/"
var operators = [
            "+",
            "-",
            "/",
            "*",
        ]
var defaultOperators
var baseUrl = "qrc:/gcompris/src/activities/guesscount-summer/resource";
var builtinFile = baseUrl + "/levels-default.json";
var dataset = [
            [
                [[1,2],3],
                [[3,1],4],

            ],
            [
                [[1,2],2],
                [[8,2],16],
            ],
            [
                [[9,6],3],
                [[6,4],2]
            ],
            [
                [[9,3],3],
                [[8,4],2]
            ],
            [
                [[4,2],8],
                [[6,6],1],
                [[20,5],4],
                [[4,1],4]
            ],
            [
                [[4,2,3],18],
                [[6,4,2],1],
                [[20,5,3],12],
                [[4,2,2,3],9]
            ],
            [
                [[4,2,3],18],
                [[6,4,2],1],
                [[20,5,3],12],
                [[4,2,2,3],9]
            ]
        ]
var currentLevel = 0
var numberOfLevel = dataset.length
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
    items.operandRow.repeater.model = dataset[currentLevel][items.sublevel-1][0]
    items.data=dataset[currentLevel]
    items.levelchanged=false
}
function next_sublevel() {
    items.sublevel += 1
    items.operandRow.repeater.model = dataset[currentLevel][items.sublevel-1][0]
    items.data=dataset[currentLevel]
    items.solved=false
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel ) {
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
    if(items.sublevel<dataset[currentLevel].length)
    {
        items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/win.wav")
        items.timer.start()
    }
    else if(items.sublevel==dataset[currentLevel].length)
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
function addLevelOperators(array,length){
    for(var i=array.length;i<length;i++)
        array.push(defaultOperators[i])
    return array
}



