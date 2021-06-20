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

var path = []
var position = [-1, -1]

function start(items_) {
    items = items_
    currentLevel = 0
    numberOfLevel = items.levels.length
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    
    items.rows = items.levels[currentLevel].rows
    items.cols = items.levels[currentLevel].cols
    
    for(var i=0; i<items.rows; ++i)
        for(var j=0; j<items.cols; ++j)
            items.mapListModel.append({ "path": false })
    
    loadMap(items.levels[currentLevel].path)
    
    if(items.mode === "encode")
        showPath();
        
//     var list = ["right", "bottom", "left", "up"]
//     for(var i=0; i<25; ++i) {
//         let r = Math.floor(Math.random() * 4)
//         items.movesListModel.append({
//             "direction" : list[r]
//         })
//     }
}

function findStart(map) {
    for(var i=0; i < map.length; ++i) {
        for(var j=0; i < map[i].length; ++j)
            if(map[i][j] === 's' || map[i][j] === 'S')
                return [j, i];
    }
    return [-1, -1]
}

function isValidPos(map, x, y, prev_x, prev_y) {
    if(prev_x === x && prev_y === y)
        return false;
    
    if(y >= map.length || y < 0 || x >= map[0].length || x < 0)
        return false;
    
    return map[y][x] === '*' || map[y][x] === 'S' || map [y][x] === 's';
}

function loadMap(map) {
    path = []
    var curr = findStart(map)
    var prev = [-1, -1]
    var next;
    
    while(isValidPos(map, curr[0], curr[1], prev[0], prev[1])) {
        path.push(curr);
        
        next = [-1, -1]
        if(isValidPos(map, curr[0], curr[1] - 1, prev[0], prev[1]))
            next = [curr[0], curr[1] - 1]
        else if(isValidPos(map, curr[0], curr[1] + 1, prev[0], prev[1]))
            next = [curr[0], curr[1] + 1]
        else if(isValidPos(map, curr[0] - 1, curr[1], prev[0], prev[1]))
            next = [curr[0] - 1, curr[1]]
        else if(isValidPos(map, curr[0] + 1, curr[1], prev[0], prev[1]))
            next = [curr[0] + 1, curr[1]]
            
        prev = curr
        curr = next
    }
}

function showPath() {
    for(var i=0; i < path.length; ++i) {
        items.mapListModel.set(path[i][1] * items.cols + path[i][0], {"path" : true})
    }
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
