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
.import QtQuick 2.12 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var url = "qrc:/gcompris/src/activities/target/resource/"

var levels
var numberOfLevel
var items

function start(items_) {
    items = items_
    levels = items.levels
    numberOfLevel = levels.length
    items.currentSubLevel = 0
    items.numberOfSubLevel = 5

    items.currentLevel = Core.getInitialLevel(numberOfLevel);

    initLevel()
}

function stop() {
}

function initLevel() {
    items.targetModel.clear()
    items.arrowFlying = false
    for(var i = levels[items.currentLevel].length - 1;  i >= 0 ; --i) {
        items.targetModel.append(levels[items.currentLevel][i])
    }
    // Reset the arrows first
    items.nbArrow = 0
    items.nbArrow = Math.min(items.currentLevel + 3, 6)
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
    items.currentSubLevel = 0;
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.currentSubLevel = 0;
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function checkAnswer() {
    if(items.targetItem.scoreTotal.toString() === items.userEntry.text) {
        items.bonus.good("flower")
        items.inputLocked = true
    }
    else
        items.bonus.bad("flower")
}
