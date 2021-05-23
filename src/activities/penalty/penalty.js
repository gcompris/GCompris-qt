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
.import QtQuick 2.9 as Quick

var currentLevel = 0
var numberOfLevel = 9
var items

var url = "qrc:/gcompris/src/activities/penalty/resource/"

function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    if(currentLevel === 0) items.duration = 1000
    else if(currentLevel === 1) items.duration = 800
    else if(currentLevel === 2) items.duration = 700
    else if(currentLevel === 3) items.duration = 600
    else if(currentLevel === 4) items.duration = 500
    else if(currentLevel === 5) items.duration = 400
    else if(currentLevel === 6) items.duration = 350
    else if(currentLevel === 7) items.duration = 300
    else if(currentLevel === 8) items.duration = 250

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
    if(numberOfLevel <= ++currentLevel) {
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
