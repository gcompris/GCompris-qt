/* GCompris - target.js
 *
 * Copyright (C) 2014 Bruno coudoin
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
.pragma library
.import QtQuick 2.6 as Quick

var url = "qrc:/gcompris/src/activities/target/resource/"

var colors = [
            "#ff1b00",
            "#7edee2",
            "#f1f500",
            "#3dff00",
            "#b7d2d4",
            "#6db5ba"
        ]

var levels = [
            [
                {size: 50, color: colors[0], score: 5},
                {size: 100, color: colors[1], score: 4},
                {size: 150, color: colors[2], score: 3},
                {size: 200, color: colors[3], score: 2},
                {size: 250, color: colors[4], score: 1}
            ],
            [
                {size: 50, color: colors[0], score: 10},
                {size: 100, color: colors[1], score: 5},
                {size: 150, color: colors[2], score: 3},
                {size: 200, color: colors[3], score: 2},
                {size: 250, color: colors[4], score: 1}
            ],
            [
                {size: 50, color: colors[0], score: 20},
                {size: 100, color: colors[1], score: 10},
                {size: 150, color: colors[2], score: 8},
                {size: 200, color: colors[3], score: 5},
                {size: 250, color: colors[4], score: 3},
                {size: 300, color: colors[5], score: 2}
            ],
            [
                {size: 50, color: colors[0], score: 30},
                {size: 100, color: colors[1], score: 20},
                {size: 150, color: colors[2], score: 10},
                {size: 200, color: colors[3], score: 5},
                {size: 250, color: colors[4], score: 3},
                {size: 300, color: colors[5], score: 2}
            ],
            [
                {size: 50, color: colors[0], score: 50},
                {size: 100, color: colors[1], score: 30},
                {size: 150, color: colors[2], score: 20},
                {size: 200, color: colors[3], score: 8},
                {size: 250, color: colors[4], score: 3},
                {size: 300, color: colors[5], score: 2}
            ],
            [
                {size: 50, color: colors[0], score: 100},
                {size: 100, color: colors[1], score: 50},
                {size: 150, color: colors[2], score: 12},
                {size: 200, color: colors[3], score: 8},
                {size: 250, color: colors[4], score: 3},
                {size: 300, color: colors[5], score: 2}
            ],
            [
                {size: 50, color: colors[0], score: 500},
                {size: 100, color: colors[1], score: 100},
                {size: 150, color: colors[2], score: 50},
                {size: 200, color: colors[3], score: 15},
                {size: 250, color: colors[4], score: 7},
                {size: 300, color: colors[5], score: 3}
            ],
            [
                {size: 50, color: colors[0], score: 64},
                {size: 100, color: colors[1], score: 32},
                {size: 150, color: colors[2], score: 16},
                {size: 200, color: colors[3], score: 8},
                {size: 250, color: colors[4], score: 4},
                {size: 300, color: colors[5], score: 2}
            ]
        ]

var currentLevel = 0
var numberOfLevel = levels.length
var items

function start(items_) {
    items = items_
    currentLevel = 0
    items.currentSubLevel = 0
    items.numberOfSubLevel = 5
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    items.targetModel.clear()
    items.arrowFlying = false
    for(var i = levels[currentLevel].length - 1;  i >= 0 ; --i) {
        items.targetModel.append(levels[currentLevel][i])
    }
    // Reset the arrows first
    items.nbArrow = 0
    items.nbArrow = Math.min(currentLevel + 3, 6)
    items.targetItem.start()
    items.userEntry.text = ""
}

function nextSubLevel() {
    if(items.numberOfSubLevel <= ++items.currentSubLevel ) {
        nextLevel()
    } else {
        initLevel();
    }
}

function nextLevel() {
    items.currentSubLevel = 0
    if(numberOfLevel <= ++currentLevel ) {
        currentLevel = 0
    }
    initLevel();
}

function previousLevel() {
    items.currentSubLevel = 0
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel();
}
