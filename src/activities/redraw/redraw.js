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

var dataset = [
            [
                'white', 'white', 'blue',  'white',
                'red',   'red',   'red',   'red',
                'white', 'blue',  'white', 'white',
                'white', 'white', 'white', 'white',
                'white', 'white', 'white', 'white',
            ],
            [
                'white', 'white', 'white', 'white',
                'red',   'red',   'red',   'red',
                'white', 'blue',  'blue',  'white',
                'white', 'red',   'red',   'red',
                'white', 'white', 'white', 'white',
            ],
            [
                'white', 'white', 'white', 'white',
                'red',   'red',   'red',   'red',
                'white', 'blue',  'white', 'white',
                'white', 'white', 'blue',  'white',
                'white', 'white', 'white', 'white',
            ]
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
    items.targetModelData = dataset[currentLevel]
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
