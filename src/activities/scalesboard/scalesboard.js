/* GCompris - scalesboard.js
 *
 * Copyright (C) 2014 Bruno Coudoin
 *
 * Authors:
 *   miguel DE IZARRA <miguel2i@free.fr> (GTK+ version)
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
.import "qrc:/gcompris/src/core/core.js" as Core

var url = "qrc:/gcompris/src/activities/scalesboard/resource/"

var currentLevel = 0
var numberOfLevel
var items
var currentTargets = []
var initCompleted = false

function start(items_) {
    items = items_
    currentLevel = 0
    numberOfLevel = items.dataset.length
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    currentTargets = Core.shuffle(items.dataset[currentLevel].targets)
    items.currentSubLevel = 1
    items.numberOfSubLevels = currentTargets.length
    displayLevel()
}

function displayLevel()
{

    initCompleted = false
    items.numpad.answer = ""
    items.masseAreaLeft.init()
    items.masseAreaRight.init()
    items.masseAreaCenter.init()
    var data = items.dataset[currentLevel]
    for(var i=0; i < data.masses.length; i++)
        items.masseAreaCenter.addMasse("masse" + (i % 5 + 1) + ".svg",
                                       data.masses[i][0],
                                       data.masses[i][1],
                                       i,
                                       /* dragEnabled */ true)

    items.giftWeight = currentTargets[items.currentSubLevel - 1][0]
    items.masseAreaRight.addMasse("gift.svg",
                                  currentTargets[items.currentSubLevel - 1][0],
                                  data.question ? "" : currentTargets[items.currentSubLevel - 1][1],
                                  0,
                                  /* dragEnabled */ false)

    initCompleted = true
}

function nextSubLevel() {
    if(items.numberOfSubLevels < ++items.currentSubLevel ) {
        nextLevel();
    }
    displayLevel()
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
