/* GCompris - multiplication-chart.js
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

var currentLevel = 0
var numberOfLevel = 10
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
    items.multiplier = 1
    items.rowSelected = 0
    items.colSelected = 0
    items.multiplicand = items.bar.level

    items.rowQues = Math.floor((Math.random() * 10) + 1);
    items.colQues = Math.floor((Math.random() * 10) + 1);

    for(var i=0; i<items.repeaterGridRow.count; i++) {        // For initialization of top rows color
        items.repeaterGridRow.itemAt(i).color = "white"
    }
    for(i=0; i<items.repeaterGridCol.count; i++) {        // For initialization of side Column color
        items.repeaterGridCol.itemAt(i).color = "white"
    }
    for(i=0; i<items.repeater.count; i++) {        // For initialization of side Column color
        items.repeater.itemAt(i).color = "green"
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



function makeOtherColInRowWhite() {
    for(var i=0; i<items.repeaterGridRow.count; i++) {
        if(i != items.rowSelected) {
            items.repeaterGridRow.itemAt(i).state="default"
        }
    }
}

function makeOtherRowInColWhite() {
    for(var i=0; i<items.repeaterGridCol.count; i++) {
        if(i != items.colSelected) {
            items.repeaterGridCol.itemAt(i).state="default"
        }
    }
}

function changesInMainBoard() {
    for(var i=0; i<items.repeater.count; i++) {
        if((i%10 == items.rowSelected -1)) {           // This colors the row on main board corresponding to rowSelect
            items.repeater.itemAt(i).color = "pink"
        }
        else {                                         // This colors every other row green
            items.repeater.itemAt(i).color = "green"
        }

        if(i>= (items.colSelected-1)*10 && i < items.colSelected*10 ) { // After all the above ^^ this colors the column
            items.repeater.itemAt(i).color = "pink"
        }
    }
}


function checkit() {
    if (items.repeaterGridCol.itemAt(items.colQues).state == "active" && items.repeaterGridRow.itemAt(items.rowQues).state == "active") {
        items.bonus.good("flower")
    }
    else if(items.repeaterGridCol.itemAt(items.rowQues).state == "active" && items.repeaterGridRow.itemAt(items.colQues).state == "active") {
        items.bonus.good("flower")
    }
    else {
        items.bonus.bad("flower")
    }
}





