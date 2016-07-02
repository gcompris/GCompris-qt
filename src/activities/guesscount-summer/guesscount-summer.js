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
var dataset=[
            [
                [[1,2,4,5],3],
                [[3,1],3],
                [[9,4],5],
                [[8,4],2]
            ],
            [
                [[6,7],42],
                [[8,4],2],
                [[10,2],8],
                [[8,4],12],
            ],
            [
                [[11,7],77],
                [[8,16,4],2],
                [[10,2,3],8]
            ],
            [
                [[9,7],63],
                [[4,2,9],17],
                [[15,3,2,3],21]
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

function calculate(operand1,operator,operand2,row_result)
{
    switch (operator) {
    case "+":
        row_result=operand1+operand2
        console.log(row_result)
        break;
    case "-":
        row_result=operand1-operand2
        console.log(row_result)
        break;
    case "/":
        row_result=operand1/operand2
        console.log(row_result)
        break;
    case "*":
        row_result=operand1*operand2
        console.log(row_result)
    }
    return row_result
}

function drop_item(item)
{
    if(item.count==0)
    {
        item.count+=1
    }
    else if(item.count==1)
    {
        item.dropped_item.parent=item.dropped_item.reparent
    }
    console.log(item.dropped_item.datavalue)
}

function children_change(item,end_result)
{
    if(!item.dropped_item && item.count)
    {               item.count-=1
    }
    end_result.text=Qt.binding(function() { return '' })
}

