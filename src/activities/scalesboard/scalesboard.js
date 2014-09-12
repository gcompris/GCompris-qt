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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
.pragma library
.import QtQuick 2.0 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var url = "qrc:/gcompris/src/activities/scalesboard/resource/"

var dataset = [
            {
                "masses": [1, 2, 2, 5, 5, 10, 10],
                "targets": [3, 4, 6, 7, 8, 9]
            },
            {
                "masses": [1, 2, 2, 5, 5, 10, 10],
                "targets": [12, 13, 14, 15, 16]
            },
            {
                "masses": [2, 2, 5, 5, 5],
                "targets": [8, 11, 13]
            },
            {
                "masses": [2, 5, 10, 10],
                "targets": [3, 8, 13]
            },
            {
                "masses": [2, 4, 7, 10],
                "targets": [3, 5, 8, 9]
            },
            {
                "masses": [5, 8, 9, 10, 11, 12],
                "targets": [6, 7, 13, 14, 15, 16, 17, 18]
            }
]

var currentLevel = 0
var currentSubLevel = 0
var numberOfLevel = dataset.length
var items
var currentTargets = []
var initCompleted = false

function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    currentSubLevel = 0
    currentTargets = Core.shuffle(dataset[currentLevel].targets)
    displayLevel()
}

function displayLevel()
{
    initCompleted = false
    items.masseAreaLeft.init()
    items.masseAreaRight.init()
    items.masseAreaCenter.init()
    var data = dataset[currentLevel]
    for(var i=0; i < data.masses.length; i++)
        items.masseAreaCenter.addMasse("masse" + (i % 5 + 1) + ".svg",
                                       data.masses[i],
                                       i,
                                       /* dragEnabled */ true)

    items.masseAreaRight.addMasse("masse" + 1 + ".svg",
                                  currentTargets[currentSubLevel],
                                  0,
                                  /* dragEnabled */ false)

    initCompleted = true
}

function nextSubLevel() {
    if(currentTargets.length <= ++currentSubLevel ) {
        displayLevel()
    }
    nextLevel();
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
