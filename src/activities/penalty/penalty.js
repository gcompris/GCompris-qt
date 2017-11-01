/* GCompris - penalty.js
 *
 * Copyright (C) 2014 Stephane Mankowski <stephane@mankowski.fr>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Stephane Mankowski <stephane@mankowski.fr> (Qt Quick port)
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
.import QtQuick 2.6 as Quick

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
