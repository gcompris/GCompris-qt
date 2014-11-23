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
var colors = {
    "white": '#33FFFFFF',
    "red": '#FFCC0000',
    "orange": '#FFCE5C00',
    "green": '#FF73D216',
    "blue": '#FF3465A4',
    "yellow": '#FFEDD400',
    "black": '#FF2E3436'
}


var dataset = [
            {
                "columns": 4,
                "image":
                    [
                    'white', 'white', 'blue',  'white',
                    'red',   'red',   'red',   'red',
                    'white', 'blue',  'white', 'white',
                    'white', 'white', 'white', 'white',
                    'white', 'white', 'white', 'white',
                ]
            },
            {
                "columns": 4,
                "image":
                    [
                    'white', 'white', 'white', 'white',
                    'red',   'red',   'red',   'red',
                    'white', 'blue',  'blue',  'white',
                    'white', 'red',   'red',   'red',
                    'white', 'white', 'white', 'white',
                ]
            },
            {
                "columns": 4,
                "image":
                    [
                    'white', 'white', 'white', 'white',
                    'red',   'red',   'red',   'red',
                    'white', 'blue',  'white', 'white',
                    'white', 'white', 'blue',  'white',
                    'white', 'white', 'white', 'white',
                ]
            },
            {
                "columns": 4,
                "image":
                    [
                    'orange', 'white', 'white', 'green',
                    'red',    'red',   'red',   'red',
                    'white',  'blue',  'blue',  'white',
                    'white',  'blue',  'blue',  'white',
                    'green',  'white', 'white', 'orange',
                ]
            },
            {
                "columns": 5,
                "image":
                    [
                    'orange', 'white', 'white', 'green',  'green',
                    'red',    'red',   'red',   'red',    'green',
                    'white',  'blue',  'blue',  'white',  'green',
                    'white',  'blue',  'blue',  'white',  'green',
                    'green',  'white', 'white', 'orange', 'green',
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
    items.userModel.reset()
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

function checkModel() {
    for(var i=0; i < items.userModel.count; ++i) {
        if(items.userModel.itemAt(i).color !== items.targetModel.itemAt(i).color)
            return false
    }
    return true
}
