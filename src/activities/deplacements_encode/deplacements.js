/* GCompris - deplacements.js
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 */
.pragma library
.import QtQuick 2.9 as Quick

var currentLevel = 0
var numberOfLevel
var items

function start(items_) {
    items = items_
    currentLevel = 0
    numberOfLevel = items.levels.length
    console.log(items.levels)
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    
    items.rows = items.levels[currentLevel].rows
    items.cols = items.levels[currentLevel].cols
    
    for(var i=0; i<items.rows; ++i)
        for(var j=0; j<items.cols; ++j) {
            let r = Math.floor(Math.random() * 2)
            if(r == 0)
                items.mapListModel.append({
                    "path" : true,
                    "player" : false
                })
            else
                items.mapListModel.append({
                    "path" : false,
                    "player" : false
                })
        }
        
    for(var i=0; i<25; ++i)
        items.movesListModel.append({
            "direction" : "up"
        })
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel) {
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
