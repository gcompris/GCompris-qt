/* GCompris - path.js
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
var position = 0

const mapModel = {
    "path": false,
    "flag": false,
    "invisible": false,
    "stone": false,
    "tree": false,
    "bush": false,
    "grass": false,
    "water": false
}

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
    
    items.mapListModel.clear()
    items.movesListModel.clear()
    
    for(var i=0; i<items.rows; ++i)
        for(var j=0; j<items.cols; ++j)
            items.mapListModel.append(mapModel)
    
    loadMap(items.levels[currentLevel].path)
    
    if(items.mode === "encode")
        showPath();
    
    // indicating we are at the starting of the path
    position = 0
    
    // intialize tux position
    items.tux.init()
}

function findStartAndLoadObstacles(map) {
    var start = [-1, -1]
    for(var i=0; i < map.length; ++i) {
        for(var j=0; j < map[i].length; ++j)
            if(map[i][j].toUpperCase() === 'S')
                start = [j, i];
            else if(map[i][j].toUpperCase() === 'E')
                items.mapListModel.set(positionToIndex([j, i]), {"flag": true})
            else if(map[i][j].toUpperCase() === 'I')
                items.mapListModel.set(positionToIndex([j, i]), {"invisible": true})
            else if(map[i][j].toUpperCase() === 'S')
                items.mapListModel.set(positionToIndex([j, i]), {"stone": true})
            else if(map[i][j].toUpperCase() === 'T')
                items.mapListModel.set(positionToIndex([j, i]), {"tree": true})
            else if(map[i][j].toUpperCase() === 'B')
                items.mapListModel.set(positionToIndex([j, i]), {"bush": true})
            else if(map[i][j].toUpperCase() === 'B')
                items.mapListModel.set(positionToIndex([j, i]), {"bush": true})
            else if(map[i][j].toUpperCase() === 'G')
                items.mapListModel.set(positionToIndex([j, i]), {"grass": true})
            else if(map[i][j].toUpperCase() === 'W')
                items.mapListModel.set(positionToIndex([j, i]), {"water": true})
    }
    return start
}

function isValidPos(map, x, y, prev_x, prev_y) {
    if(prev_x === x && prev_y === y)
        return false;
    
    if(y >= map.length || y < 0 || x >= map[0].length || x < 0)
        return false;
    
    return map[y][x] === '*' || map[y][x].toUpperCase() === 'S' || map[y][x].toUpperCase() === 'E';
}

function loadMap(map) {
    path = []
    var curr = findStartAndLoadObstacles(map)
    var prev = [-1, -1]
    var next;
    
    do {
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
    while(map[prev[1]][prev[0]].toUpperCase() != 'E')
    
    items.mapListModel.set(positionToIndex(prev), {"flag": true})
}

function positionToIndex(posArray) {
    return posArray[1] * items.cols + posArray[0];
}

function showPath() {
    for(var i=0; i < path.length; ++i) {
        items.mapListModel.set(positionToIndex(path[i]), {"path" : true})
    }
}

function setTuxDirection() {
    var tuxDirection = items.tux.direction
    var rotation = 0
    if(tuxDirection === 'LEFT')
        rotation = 90
    else if(tuxDirection === 'UP')
        rotation = 180
    else if(tuxDirection === 'RIGHT')
        rotation = 270
    
    items.tux.rotation = rotation
}

function moveTuxToBlock() {
    items.tux.x = items.mapView.x + path[position][0] * items.mapView.cellWidth
    items.tux.y = items.mapView.y + path[position][1] * items.mapView.cellHeight
}

function updateTux() {
    setTuxDirection()
    moveTuxToBlock()
    
    if(position == path.length - 1)
        items.bonus.good ("tux")
}

function findDirectionChange(fromX, fromY, toX, toY) {
    // find direction change in case of absolute movement
    var direction = null
    if(fromY + 1 === toY && fromX === toX)
        direction = 'DOWN'
    else if(fromY - 1 === toY && fromX === toX)
        direction = 'UP'
    else if(fromY === toY && fromX + 1 === toX)
        direction = 'RIGHT'
    else if(fromY === toY && fromX - 1 === toX)
        direction = 'LEFT'
    return direction
}

function moveTowards(direction) {
    if(items.tux.isAnimationRunning)
        return
    
    var correctDirection = findDirectionChange(path[position][0], path[position][1], 
                                        path[position+1][0], path[position+1][1])
    if(correctDirection === direction) {
        items.movesListModel.append({
            "direction" : direction
        })
        
        position = position + 1
        items.tux.direction = direction
        updateTux()
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
