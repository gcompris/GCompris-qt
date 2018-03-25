/* GCompris - mining.js
 *
 * Copyright (C) 2014 Bruno Coudoin
 *
 * Authors:
 *   Peter Albrecht <pa-dev@gmx.de> (GTK+ version)
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

var url = "qrc:/gcompris/src/activities/mining/resource/"

var currentLevel = 0
var numberOfLevel = 3
var items

function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {
}

function getItem(source) {
    return {
        source: source ?
                    url + source + ".svg" :
                    "",
        rotation: Math.floor(Math.random() * 180) - 90,
        widthFactor: source === "sparkle" ? 0.4 : 0.2 + Math.random() * 0.4,
        isTarget: source === "sparkle"
    }
}

function createLevel() {
    var miningItems = new Array()
    for(var i = 0; i < 16; i++) {
        var index = (Math.floor(Math.random() * 16) + 1)
        if(index < 5)
            miningItems[i] = getItem("stone" + (Math.floor(Math.random() * 4) + 1))
        else
            miningItems[i] = getItem("")
    }
    // Place the sparkle
    // The Grid is 4*4 but we skip the last line free for the bar
    // The borders are harder to get so we allow them only on higher
    // levels.
    if(currentLevel < 2) {
        var choices = [5, 6, 9, 10]
        miningItems[choices[(Math.floor(Math.random() * 4))]] = getItem("sparkle")
    } else {
        miningItems[(Math.floor(Math.random() * 12))] = getItem("sparkle")
    }
    items.mineModel = miningItems
}

function initLevel() {
    items.bar.level = currentLevel + 1

    createLevel()
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
