/* GCompris - multiplication-tables.js
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
var tableControl = 1

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
    tableControl = 1

    for(var i=0; i<items.repeater.count; i++) {
        items.repeater.itemAt(i).state="default"
    }
    for(i=0; i<items.gridTableRepeater.count; i++) {
        items.gridTableRepeater.itemAt(i).opacity=0
    }
    items.gridTableRepeater.itemAt(0).opacity = 1
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

function checkit() {
    //console.log(items.multiplier, "asdf", items.multiplicand)
    if(items.answer) {
        items.multiplier++
        if(items.multiplier==11) {
            items.bonus.good("flower")
        }
        items.gridTableRepeater.itemAt(tableControl).opacity=1
        tableControl++
    }
    else {
        items.bonus.bad("flower")
        items.answer = true
    }
    console.log(items.multiplicand, "asdfgh", items.answer)
}
