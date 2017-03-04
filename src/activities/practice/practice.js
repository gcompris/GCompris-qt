/* GCompris - practice.js
 *
 * Copyright (C) 2016 Rahul Yadav <rahulyadav170923@gmail.com>
 *
 * Authors:
 *   "Rahul Yadav" <rahulyadav170923@gmail.com>
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
var url = "qrc:/gcompris/src/activities/practice/resource/"
var currentLevel = 0
var numberOfLevel = 2
var items

var problemDataset = [
            [
                ['Anne ate 6 cookies.Samantha ate 4 more cookies than Anne.',[['How many cookies did Samantha eat?',10]]],
                ['Donna made 5 posters.Elizabeth made twice as many posters as Donna.They hung up 7 posters.',[['How many posters did Elizabeth make ?',10],['How many posters do they have left?',3]]],
            ],
            [
                ['Anne ate 6 cookies.Samantha ate 4 more cookies than Anne.',[['How many cookies did Samantha eat?',10]]],
                ['Donna made 5 posters.Elizabeth made twice as many posters as Donna.They hung up 7 posters.',[['How many posters did Elizabeth make ?',10],['How many posters do they have left?',3]]],
            ],
        ]




function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    items.sublevel = 0
    items.problemData = problemDataset[currentLevel][items.sublevel]
//    items.currentlevel = currentLevel
//    items.sublevel = 1
//    items.solved = false
//    if(items.warningDialog.visible)
//        items.warningDialog.visible = false
}

function initSublevel(){
    items.problemData = problemDataset[currentLevel][items.sublevel]
}

function nextSublevel() {
    if(++items.sublevel < problemDataset[currentLevel].length) {
        initSublevel()
    }
    else {
        nextLevel()
    }
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

function calculate_result(operand1,operator,operand2){
    if(operand1!="" && operator!="" && operand2!=""){
        var calculated_value;
        switch (operator) {
        case "+":
            calculated_value = Number(operand1) + Number(operand2)
            break;
        case "-":
            calculated_value = Number(operand1) - Number(operand2)
            break;
        case "/":
            calculated_value = Number(operand1) / Number(operand2)
            break;
        default:
            calculated_value = Number(operand1) * Number(operand2)
        }
        items.calculationResult = calculated_value
    }
    else
        items.calculationResult = ""
}

function check(problemRepeater){
    for( var i=0;i<problemRepeater.count;i++ ){
        if(problemRepeater.itemAt(i).correct)
            continue;
        else
            return false;
    }
    return true;
}
