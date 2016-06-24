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
                [[1,2],3],
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
    console.log(currentLevel)
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
