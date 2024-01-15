/* GCompris - scalesboard.js
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin
 *
 * Authors:
 *   miguel DE IZARRA <miguel2i@free.fr> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.12 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var url = "qrc:/gcompris/src/activities/scalesboard/resource/"

var numberOfLevel
var items
var currentTargets = []
var initCompleted = false

function start(items_) {
    items = items_
    numberOfLevel = items.levels.length
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    initLevel()
}

function stop() {
}

function initLevel() {
    items.errorRectangle.resetState()
    currentTargets = Core.shuffle(items.levels[items.currentLevel].targets)
    items.score.currentSubLevel = 0
    items.score.numberOfSubLevels = currentTargets.length
    items.rightDrop = items.levels[items.currentLevel].rightDrop
    items.question.text = items.levels[items.currentLevel].question != undefined ? items.levels[items.currentLevel].question : ""
    displayLevel()
}

function displayLevel()
{

    initCompleted = false
    items.numpad.answer = ""
    items.masseAreaLeft.init()
    items.masseAreaRight.init()
    items.masseAreaCenter.init()
    var data = items.levels[items.currentLevel]
    for(var i=0; i < data.masses.length; i++)
        items.masseAreaCenter.addMasse("masse" + (i % 5 + 1) + ".svg",
                                       data.masses[i][0],
                                       data.masses[i][1],
                                       i,
                                       /* dragEnabled */ true)

    items.giftWeight = currentTargets[items.score.currentSubLevel][0]
    items.masseAreaRight.addMasse("gift.svg",
                                  currentTargets[items.score.currentSubLevel][0],
                                  data.question ? "" : currentTargets[items.score.currentSubLevel][1],
                                  0,
                                  /* dragEnabled */ false)

    initCompleted = true
    items.buttonsBlocked = false
}

function checkAnswer() {
    items.buttonsBlocked = true
    if((initCompleted && items.scaleHeight == 0 && !items.question.visible)
            || (items.question.userEntry == items.question.answer)) {
        items.score.currentSubLevel++;
        items.score.playWinAnimation();
        items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/completetask.wav");
    }
    else {
        items.errorRectangle.startAnimation();
        items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/crash.wav");
    }
}

function nextSubLevel() {
    if(items.score.currentSubLevel >= items.score.numberOfSubLevels) {
        items.bonus.good("flower")
    } else {
        displayLevel()
    }
}

function nextLevel() {
    items.score.stopWinAnimation();
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.score.stopWinAnimation();
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}
