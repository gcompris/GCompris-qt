/* GCompris - binary_bulb.js
 *
 * Copyright (C) 2018 Rajat Asthana <rajatasthana4@gmail.com>
 *
 * Authors:
 *   "RAJAT ASTHANA" <rajatasthana4@gmail.com> (Qt Quick port)
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

var nums = [1,2,3,1,4,9,13,15,57,152,248,239];

var currentLevel = 0
var numberOfLevel = 3
var items

function start(items_) {
    items = items_
    currentLevel = 0
}

function stop() {
}

function resetBulbs() {
    for(var i = 0; i < items.numberOfBulbs; i++) {
        items.bulbs.itemAt(i).state = "off"
    }     
}

function initializeValues() {
    items.sum = 0    
    items.numberOfBulbs = (currentLevel > 3) ? 8 : Math.pow(2,currentLevel+1)
    items.num = nums[items.score.currentSubLevel + ((currentLevel)*4) - 1]
}

function initLevel() {
    items.bar.level = currentLevel + 1
    items.score.numberOfSubLevels = 4
    items.score.currentSubLevel = 1
    initializeValues();
    resetBulbs();
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel ) {
        currentLevel = 0
    }
    items.score.currentSubLevel = 1
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    items.score.currentSubLevel = 1
    initLevel();
}
