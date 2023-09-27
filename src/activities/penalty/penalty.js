/* GCompris - penalty.js
 *
 * SPDX-FileCopyrightText: 2014 Stephane Mankowski <stephane@mankowski.fr>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Stephane Mankowski <stephane@mankowski.fr> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.12 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var numberOfLevel = 9
var items

var url = "qrc:/gcompris/src/activities/penalty/resource/"

function start(items_) {
    items = items_
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    initLevel()
}

function stop() {
}

function initLevel() {
    if(items.currentLevel === 0) items.duration = 1000
    else if(items.currentLevel === 1) items.duration = 800
    else if(items.currentLevel === 2) items.duration = 700
    else if(items.currentLevel === 3) items.duration = 600
    else if(items.currentLevel === 4) items.duration = 500
    else if(items.currentLevel === 5) items.duration = 400
    else if(items.currentLevel === 6) items.duration = 350
    else if(items.currentLevel === 7) items.duration = 300
    else if(items.currentLevel === 8) items.duration = 250

    resetLevel()
}

function resetLevel() {
    items.ball.state = "INITIAL"
    items.saveBallState = "INITIAL"
    items.progressRight.ratio = 0
    items.progressLeft.ratio = 0
    items.progressTop.ratio = 0
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}
