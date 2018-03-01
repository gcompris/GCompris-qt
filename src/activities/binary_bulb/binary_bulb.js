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

var currentLevel = 0
var numberOfLevel = 10
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
    items.numberOfBulbs = (currentLevel > 3) ? 8 : Math.pow(2,currentLevel)
    items.num = Math.floor(Math.random() * (Math.pow(2,items.numberOfBulbs) - 1)) + 1
}

function initLevel() {
    items.bar.level = currentLevel + 1
    initializeValues();
    resetBulbs();
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
