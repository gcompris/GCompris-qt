/* GCompris - redraw.js
 *
 * Copyright (C) 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
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

var url = "qrc:/gcompris/src/activities/redraw/resource/"
var colorShortcut = {
    0: 'white',
    1: 'red',
    2: 'orange',
    3: 'green',
    4: 'blue',
    5: 'yellow',
    6: 'black'
}
var colors = {
    0: '#33FFFFFF',
    1: '#FFCC0000',
    2: '#FFFCAE3D',
    3: '#FF73D216',
    4: '#FF3465A4',
    5: '#FFEDD400',
    6: '#FF2E3436'
}


var dataset
var currentLevel
var numberOfLevel
var items

function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {
}

function initLevel() {
    dataset = items.levels
    items.bar.level = currentLevel + 1
    numberOfLevel = dataset.length
    items.numberOfColumn = dataset[currentLevel].columns
    items.targetModelData = dataset[currentLevel].image
    items.numberOfColor = getNumberOfColors(items.targetModelData)
    items.colorSelector = 0
    items.userModel.reset()
    if(currentLevel == 0) {
        // To help determine the puzzle mirroring type set a color
        // at first level
        items.userModel.itemAt(0).paint(items.targetModelData[0])
    }
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

function getNumberOfColors(model) {
    var nbColor = 0
    for(var i=0; i < model.length; ++i) {
        nbColor = Math.max(nbColor, model[i])
    }
    return nbColor + 1
}

function checkModel() {
    for(var i=0; i < items.userModel.count; ++i) {
        if(items.userModel.itemAt(i).color !== items.targetModel.itemAt(i).color)
            return false
    }
    return true
}

// Dump the user drawing in the format we use for drawing definition
// Can be used to create content
function dump() {
    var line = "["
    for(var i=0; i < items.userModel.count; ++i) {
        if(i % items.numberOfColumn == 0) {
            print(line)
            line = "   "
        }
        line += items.userModel.itemAt(i).colorIndex + ","
    }
    print(line)
    print("]")
}
