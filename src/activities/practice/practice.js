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
function calculate_result(input,choice){
    var calculated_value;
    switch (input["operator"]) {
    case "+":
        //console.log(input["firstop"]+input["secondop"]);
        calculated_value=input["firstop"]+input["secondop"]
        break;
    case "-":
        //console.log(input["firstop"]-input["secondop"]);
        calculated_value=input["firstop"]-input["secondop"]
        break;
    case "/":
        //console.log(input["firstop"]/input["secondop"]);
        calculated_value=input["firstop"]/input["secondop"]
        break;
    default:
        //console.log(input["firstop"]*input["secondop"]);
        calculated_value=input["firstop"]*input["secondop"]
    }
     if(input["expected_result"]==calculated_value)
         return [true,calculated_value]
     return [false,calculated_value]

}

