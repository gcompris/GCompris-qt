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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
var url = "qrc:/gcompris/src/activities/clockgame/resource/"
var currentLevel = 0
var numberOfLevel = 10
var items
var selectedArrow

function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {}

function initLevel() {
    items.bar.level = currentLevel + 1

    items.currentH = Math.floor(Math.random() * 12)
    items.targetH = Math.floor(Math.random() * 12)

    /* Set hours */
    switch (items.bar.level) {
    case 1:
        items.currentM = Math.floor(Math.random() * 4) * 15
        items.targetM = Math.floor(Math.random() * 4) * 15
        break
    case 2:
        items.currentM = Math.floor(Math.random() * 12) * 5
        items.targetM = Math.floor(Math.random() * 12) * 5
        break
    default:
        items.currentM = Math.floor(Math.random() * 60)
        items.targetM = Math.floor(Math.random() * 60)
        break
    }

    if (items.bar.level > 3) {
        items.currentS = Math.floor(Math.random() * 60)
        items.targetS = Math.floor(Math.random() * 60)
    } else {
        items.currentS = 0
        items.targetS = 0
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
