/* GCompris - redraw.js
 *
 * Copyright (C) 2014 <YOUR NAME HERE>
 *
 * Authors:
 *   <THE GTK VERSION AUTHOR> (GTK+ version)
 *   "YOUR NAME" <YOUR EMAIL> (Qt Quick port)
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


var dataset = [
            {
                "columns": 4,
                "image":
                [
                    2,0,0,0,
                    0,1,0,0,
                    0,0,1,0,
                    0,1,0,0,
                    0,0,0,0
                ]
            },
            {
                "columns": 4,
                "image":
                [
                    1,1,0,0,
                    0,2,2,0,
                    0,0,1,1,
                    0,2,2,0,
                    1,1,0,0
                ]
            },
            {
                "columns": 4,
                "image":
                [
                    1,0,0,0,
                    0,1,0,0,
                    0,0,2,3,
                    0,1,0,0,
                    1,0,0,0
                ]
            },
            {
                "columns": 4,
                "image":
                [
                    4,4,4,4,
                    0,2,2,2,
                    0,3,3,0,
                    2,2,2,0,
                    4,4,4,4
                ]
            },
            {
                "columns": 5,
                "image":
                [
                    0,1,1,1,0,
                    1,0,0,0,3,
                    1,0,0,0,3,
                    1,2,2,2,3,
                    1,0,0,0,3
                ]
            },
            {
                "columns": 5,
                "image":
                [
                    3,4,4,2,0,
                    3,0,0,0,1,
                    3,4,4,4,0,
                    3,0,0,0,1,
                    3,4,4,2,0
                ]
            },
            {
                "columns": 5,
                "image":
                [
                    0,1,1,1,0,
                    3,0,0,0,0,
                    3,0,0,0,0,
                    3,0,0,0,0,
                    0,2,2,2,0
                ]
            },
            {
                "columns": 5,
                "image":
                [
                    1,3,3,3,0,
                    1,0,0,0,4,
                    1,0,0,0,4,
                    1,0,0,0,4,
                    1,2,2,2,0
                ]
            },
            {
                "columns": 6,
                "image":
                [
                    1,1,1,1,1,1,
                    1,2,0,0,0,1,
                    1,0,2,3,0,1,
                    1,0,2,3,0,1,
                    1,2,0,0,0,1,
                    1,1,1,1,1,1
                ]
            },
            {
                "columns": 6,
                "image":
                [
                    1,2,2,2,2,2,
                    3,1,0,0,0,2,
                    3,0,1,4,0,2,
                    3,0,4,1,0,2,
                    3,0,0,0,1,2,
                    3,3,3,3,3,1
                ]
            },
            {
                "columns": 6,
                "image":
                [
                    1,2,2,2,2,3,
                    4,0,0,0,0,4,
                    4,0,0,0,0,4,
                    4,0,0,0,0,4,
                    4,0,0,0,0,4,
                    3,2,2,2,2,1
                ]
            },
            {
                "columns": 6,
                "image":
                [
                    1,1,1,1,1,1,
                    2,0,0,0,0,0,
                    2,3,3,3,3,0,
                    2,3,3,3,3,0,
                    2,0,0,0,0,0,
                    1,1,1,1,1,1
                ]
            },
            {
                "columns": 6,
                "image":
                [
                    1,1,1,1,1,1,
                    1,1,1,1,1,1,
                    2,2,0,0,0,0,
                    2,2,3,3,3,3,
                    2,2,3,3,3,3,
                    2,2,0,0,0,0
                ]
            },
            {
                "columns": 7,
                "image":
                [
                    0,1,1,1,1,1,0,
                    2,0,0,0,0,0,0,
                    2,0,0,0,0,0,0,
                    2,0,0,0,0,0,0,
                    2,0,0,0,5,5,4,
                    2,0,0,0,0,0,4,
                    0,3,3,3,3,3,0
                ]
            },
            {
                "columns": 7,
                "image":
                [
                    0,1,1,1,1,1,0,
                    1,0,0,0,0,0,1,
                    1,0,3,0,2,0,1,
                    1,0,0,0,0,0,1,
                    1,0,2,1,3,0,1,
                    1,0,0,0,0,0,1,
                    0,1,1,1,1,1,0
                ]
            },
            {
                "columns": 7,
                "image":
                [
                    1,0,1,0,1,0,1,
                    0,2,0,2,0,2,0,
                    3,0,3,0,3,0,3,
                    0,4,0,4,0,4,0,
                    5,0,5,0,5,0,5,
                    0,6,0,6,0,6,0,
                    1,0,1,0,1,0,1
                ]
            }
        ]

var currentLevel = 0
var numberOfLevel = dataset.length
var items

function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
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
