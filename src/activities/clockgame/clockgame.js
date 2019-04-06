/* GCompris - clockgame.js
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
var currentLevel = 0
var numberOfLevel = 10
var items
var selectedArrow

function start(items_) {
    items = items_
    currentLevel = 0
    numberOfLevel = items.levels.length
    initLevel()
}

function stop() {}

function initLevel() {
    items.bar.level = currentLevel + 1

    items.numberOfTry = items.levels[currentLevel].numberOfSubLevels
    items.currentH = Math.floor(Math.random() * 12)
    items.targetH = Math.floor(Math.random() * 12)
    items.minutesHandVisible = items.levels[currentLevel].displayMinutesHand
    if(!items.minutesHandVisible) {
        items.currentM = 0
        items.targetM = 0
    }
    else if(items.levels[currentLevel].fixedMinutes !== undefined) {
        items.currentM = Math.floor(Math.random() * 60)
        items.targetM = items.levels[currentLevel].fixedMinutes
    }
    else {
        items.currentM = Math.floor(Math.random() * 60)
        items.targetM = Math.floor(Math.random() * 60)
    }

    items.secondsHandVisible = items.levels[currentLevel].displaySecondsHand
    if(!items.secondsHandVisible) {
        items.currentS = 0
        items.targetS = 0
    }
    else if(items.levels[currentLevel].fixedSeconds !== undefined) {
        items.currentS = Math.floor(Math.random() * 60)
        items.targetS = items.levels[currentLevel].fixedSeconds
    }
    else {
        items.currentS = Math.floor(Math.random() * 60)
        items.targetS = Math.floor(Math.random() * 60)
    }

    if(items.levels[currentLevel].zonesVisible !== undefined) {
        items.zonesVisible = items.levels[currentLevel].zonesVisible
    }
    else {
        items.zonesVisible = true
    }
}

function nextTry() {
    if (items.numberOfTry <= ++items.currentTry) {
        items.currentTry = 0
        nextLevel()
    } else {
        initLevel()
    }
}

function nextLevel() {
    if (numberOfLevel <= ++currentLevel) {
        currentLevel = 0
    }
    items.currentTry = 0
    initLevel()
}

function previousLevel() {
    if (--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    items.currentTry = 0
    initLevel()
}

function get2CharValue(i) {
    if (String(i).length === 1)
        return "0" + i
    return i
}
