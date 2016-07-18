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

var url = "qrc:/gcompris/src/activities/guesscount-summer/resource/"
var signs = [
            "+",
            "-",
            "/",
            "*",
        ]
var dataset = [
            [
                [[1,2],3],
                [[3,1],4],
                [[3,4],7],
                [[4,6],10]
            ],
            [
                [[1,2],2],
                [[8,2],16],
                [[3,4],12],
                [[4,6],24]
            ],
            [
                [[4,2],2],
                [[6,6],1],
                [[20,5],4],
                [[4,1],13]
            ],
            [
                [[4,2,3],2],
                [[6,4,2],1],
                [[20,5,3],12],
                [[4,2,2,3],2]
            ]
        ]
var currentLevel = 0
var numberOfLevel = 4
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
    items.sublevel = 1
    items.operand_row.repeater.model = dataset[currentLevel][items.sublevel-1][0]
    items.data=dataset[currentLevel]
    items.solved=false
    //console.log(items.result)
}
function next_sublevel() {
    items.sublevel += 1
    items.operand_row.repeater.model = dataset[currentLevel][items.sublevel-1][0]
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

function calculate(operand1,operator,operand2,operation_row)
{
    switch (operator) {
    case "+":
        operation_row.row_result = operand1+operand2
        console.log(operation_row.row_result)
        break;
    case "-":
        operation_row.row_result = operand1-operand2
        console.log(operation_row.row_result)
        break;
    case "/":
        operation_row.row_result = operand1/operand2
        console.log(operation_row.row_result)
        break;
    case "*":
        operation_row.row_result = operand1*operand2
        console.log(operation_row.row_result)
    }
    operation_row.end_result.text=operation_row.row_result.toString()

}

function children_change(item,operation_row)
{
    if(item.children.length==2 && item.count==0)
    {
        item.count+=1
        console.log(" first item is dropped "+item.count)

    }
    else if(item.children.length==3)
    {
        item.dropped_item.parent=item.dropped_item.reparent
        console.log(" second item is replaced "+item.count)
    }
    else if(item.children.length==1)
    {
        item.count-=1
        console.log(" first item left "+item.count)
        operation_row.end_result.text=""
        operation_row.row_result=0
        operation_row.complete=false
    }
}

function check_answer(row){
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

