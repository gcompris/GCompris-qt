/* GCompris - redraw.js
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.12 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

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
var numberOfLevel
var items

function start(items_) {
    items = items_
    dataset = items.levels
    numberOfLevel = dataset.length
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    initLevel()
}

function stop() {
}

function initLevel() {
    items.numberOfColumn = dataset[items.currentLevel].columns
    items.targetModelData = dataset[items.currentLevel].image
    items.numberOfColor = getNumberOfColors(items.targetModelData)
    items.colorSelector = 0
    items.userModel.reset()
    if(items.currentLevel == 0) {
        // To help determine the puzzle mirroring type set a color
        // at first level
        items.userModel.itemAt(0).paint(items.targetModelData[0])
    }
    items.colorSelector = 1
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
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
