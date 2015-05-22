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
            },
            { // A
                "columns": 4,
                "image":
                [
                    0,2,2,0,
                    2,0,0,2,
                    2,1,3,2,
                    2,0,0,2,
                    2,0,0,2
                ]
            },
            { // B
                "columns": 4,
                "image":
                [
                    2,2,2,2,
                    2,0,0,2,
                    2,1,1,0,
                    2,0,0,2,
                    2,2,2,2
                ]
            },
            { // C
                "columns": 4,
                "image":
                [
                    2,3,3,3,
                    2,0,0,0,
                    2,0,0,0,
                    2,0,0,0,
                    2,3,3,3
                ]
            },
            { // D
                "columns": 4,
                "image":
                [
                    1,1,1,0,
                    1,0,0,2,
                    1,0,0,2,
                    1,0,0,2,
                    1,1,1,0
                ]
            },
            { // E
                "columns": 4,
                "image":
                [
                    1,1,1,1,
                    1,0,0,0,
                    1,2,2,0,
                    1,0,0,0,
                    1,1,1,1,
                ]
            },
            { // F
                "columns": 4,
                "image":
                [
                    1,1,1,1,
                    1,0,0,0,
                    1,2,2,0,
                    1,0,0,0,
                    1,0,0,0
                ]
            },
            { // G
                "columns": 4,
                "image":
                [
                    1,1,1,1,
                    1,0,0,0,
                    1,0,2,2,
                    1,0,0,2,
                    1,1,1,1
                ]
            },
            { // H
                "columns": 4,
                "image":
                [
                    1,0,0,1,
                    1,0,0,1,
                    1,2,3,1,
                    1,0,0,1,
                    1,0,0,1
                ]
            },
            { // I
                "columns": 4,
                "image":
                [
                    0,2,2,2,
                    0,0,1,0,
                    0,0,1,0,
                    0,0,1,0,
                    0,2,2,2
                ]
            },
            { // J
                "columns": 4,
                "image":
                [
                    0,1,1,1,
                    0,0,2,0,
                    0,0,2,0,
                    1,0,2,0,
                    1,1,1,0
                ]
            },
            { // K
                "columns": 4,
                "image":
                [
                    1,0,0,1,
                    1,0,2,0,
                    1,2,0,0,
                    1,0,2,0,
                    1,0,0,1
                ]
            },
            { // L
                "columns": 4,
                "image":
                [
                    1,0,0,0,
                    1,0,0,0,
                    1,0,0,0,
                    1,0,0,0,
                    2,2,2,2
                ]
            },
            { // M
                "columns": 5,
                "image":
                [
                    1,0,0,0,1,
                    1,2,0,2,1,
                    1,0,2,0,1,
                    1,0,0,0,1,
                    1,0,0,0,1
                ]
            },
            { // N
                "columns": 5,
                "image":
                [
                    1,0,0,0,1,
                    1,2,0,0,1,
                    1,0,2,0,1,
                    1,0,0,2,1,
                    1,0,0,0,1
                ]
            },
            { // O
                "columns": 4,
                "image":
                [
                    0,2,3,0,
                    1,0,0,1,
                    1,0,0,1,
                    1,0,0,1,
                    0,3,2,0
                ]
            },
            { // P
                "columns": 4,
                "image":
                [
                    1,1,1,1,
                    1,0,0,1,
                    1,2,2,1,
                    1,0,0,0,
                    1,0,0,0
                ]
            },
            { // Q
                "columns": 4,
                "image":
                [
                    0,1,1,0,
                    1,0,0,1,
                    1,0,0,1,
                    1,0,0,1,
                    0,1,1,0,
                    0,0,0,2,
                ]
            },
            { // R
                "columns": 5,
                "image":
                [
                    1,1,1,1,0,
                    1,0,0,0,1,
                    1,0,0,0,1,
                    1,1,1,1,0,
                    1,0,0,2,0,
                    1,0,0,0,2
                ]
            },
            { // S
                "columns": 6,
                "image":
                [
                    1,1,1,1,1,1,
                    2,0,0,0,0,1,
                    0,2,2,0,0,0,
                    0,0,0,2,2,0,
                    1,0,0,0,0,2,
                    1,1,1,1,1,1
                ]
            },
            { // T
                "columns": 5,
                "image":
                [
                    1,1,1,1,1,
                    0,0,2,0,0,
                    0,0,2,0,0,
                    0,0,2,0,0,
                    0,0,2,0,0
                ]
            },
            { // U
                "columns": 4,
                "image":
                [
                    1,0,0,1,
                    1,0,0,1,
                    1,0,0,1,
                    1,0,0,1,
                    2,1,1,3
                ]
            },
            { // V
                "columns": 5,
                "image":
                [
                    1,0,0,0,1,
                    1,0,0,0,1,
                    0,2,0,3,0,
                    0,2,0,3,0,
                    0,0,1,0,0,
                ]
            },
            { // W
                "columns": 7,
                "image":
                [
                    1,0,0,0,0,0,1,
                    1,0,0,0,0,0,1,
                    1,1,0,0,0,1,1,
                    0,1,0,0,0,1,0,
                    0,1,0,1,0,1,0,
                    0,0,2,0,3,0,0
                ]
            },
            { // X
                "columns": 5,
                "image":
                [
                    1,0,0,0,1,
                    0,2,0,3,0,
                    0,0,1,0,0,
                    0,3,0,2,0,
                    1,0,0,0,1
                ]
            },
            { // Y
                "columns": 5,
                "image":
                [
                    1,0,0,0,3,
                    0,1,0,3,0,
                    0,0,2,0,0,
                    0,0,2,0,0,
                    0,0,2,0,0
                ]
            },
            { // Z
                "columns": 5,
                "image":
                [
                    1,1,1,1,1,
                    0,0,0,2,0,
                    0,0,2,0,0,
                    0,2,0,0,0,
                    1,1,1,1,1
                ]
            },
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
