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
.import QtQuick as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var url = "qrc:/gcompris/src/activities/target/resource/"

var levels
var items

function start(items_) {
    items = items_
    levels = items.levels
    items.numberOfLevel = levels.length
    items.score.currentSubLevel = 0
    items.numberOfSubLevel = 5

    items.currentLevel = Core.getInitialLevel(items.numberOfLevel);

    initLevel()
}

function stop() {
}

function initLevel() {
    items.errorRectangle.resetState()
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
    items.inputLocked = false
}

function nextSubLevel() {
    if(items.score.currentSubLevel >= items.numberOfSubLevel) {
        items.bonus.good("flower");
    } else {
        initLevel();
    }
}

function nextLevel() {
    items.score.stopWinAnimation();
    items.score.currentSubLevel = 0;
    items.currentLevel = Core.getNextLevel(items.currentLevel, items.numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.score.stopWinAnimation();
    items.score.currentSubLevel = 0;
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, items.numberOfLevel);
    initLevel();
}

function checkAnswer() {
    items.inputLocked = true;
    if(items.targetItem.scoreTotal.toString() === items.userEntry.text) {
        items.score.currentSubLevel++
        items.score.playWinAnimation()
        items.goodAnswerSound.play()
    }
    else {
        items.errorRectangle.startAnimation()
        items.badAnswerSound.play()
    }
}
