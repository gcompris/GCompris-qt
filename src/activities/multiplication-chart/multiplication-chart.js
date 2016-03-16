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
var tableControl = 0

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
    items.multiplicand = items.bar.level
    tableControl = 0

    for(var i=0; i<items.repeater.count; i++) {           // For initialization of Board
        items.repeater.itemAt(i).state="default"
    }

    for(i=0; i<items.gridTableRepeater.count; i++) {      // For initialization of Board
        items.gridTableRepeater.itemAt(i).opacity = 0
    }

    for(i=0; i<items.repeaterGridRow.count; i++) {        // For initialization of top rows color
        items.repeaterGridRow.itemAt(i).color = "white"
    }

    items.gridTableRepeater.itemAt(0).opacity = 1
    items.repeaterGridRow.itemAt(1).color = "pink"
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

function checkPlaceChangedSquares() {
    for(var i=0; i<items.repeater.count; i++) {
        if(items.repeater.itemAt(i).clickedFlag) {
            if( i%10 >= items.multiplier ) {
                items.answer = false
            }
            if( i >= items.multiplicand *10 ) {
                items.answer = false
            } // To check if red then not outside red area
            //console.log((i+1), "asdfgh", items.multiplicand, "asd", items.multiplier,"asdf",( i%10 >= items.multiplier ), "asdf", ( i >= items.multiplicand *10 ))
        }
        if(!(items.repeater.itemAt(i).clickedFlag)) {
            if( i%10 < items.multiplier && i < items.multiplicand *10 ) {
                items.answer = false
            }  // To check if green then not in red area
            //console.log((i+1), "asdfgh", items.multiplicand, "asd", ( i%10 < items.multiplier && i < items.multiplicand *10 ), "answere", items.answer)
        }
    }
}

function checkit() {
    if(items.answer) {
        items.multiplier++
        if(items.multiplier == 11) {
            items.bonus.good("flower")
        }
        tableControl++
        items.gridTableRepeater.itemAt(tableControl).opacity = 1.0
        items.repeaterGridRow.itemAt(tableControl).color = "white"
        items.repeaterGridRow.itemAt(tableControl+1).color = "pink"
    }
    else {
        items.bonus.bad("flower")
        items.answer = true
    }
}
