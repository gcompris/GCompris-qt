/* GCompris - target.js
 *
 * SPDX-FileCopyrightText: 2014 Bruno coudoin
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.9 as Quick

var url = "qrc:/gcompris/src/activities/target/resource/"

var levels
var currentLevel = 0
var numberOfLevel
var items

function start(items_) {
    items = items_
    currentLevel = 0
    levels = items.levels
    numberOfLevel = levels.length
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
