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

var currPos = [-1, -1]
var prevPos = [-1, -1]
var map

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
    
    for(var i=0; i < items.rows * items.cols; ++i)
        items.mapListModel.append(mapModel)
    
    loadMap(items.levels[currentLevel].path)
    
    // find the initial direciton of tux
    items.tux.init(findInitialDirection())
    
    // reset the error counter
    items.errors = 0
}

function findInitialDirection() {
    var fromX = currPos[0]
    var fromY = currPos[1]
    
    if(isValidPos([fromX, fromY + 1]))
        return 'DOWN'
    else if(isValidPos([fromX + 1, fromY]))
        return 'RIGHT'
    else if(isValidPos([fromX - 1, fromY]))
        return 'LEFT'
    else if(isValidPos([fromX, fromY - 1]))
        return 'UP'
    return null
}

function findStartAndLoadObstacles() {
    var start = [-1, -1]
    for(var i=0; i < map.length; ++i) {
        for(var j=0; j < map[i].length; ++j) {
            var c = map[i][j].toUpperCase()
            var index = positionToIndex([j, i])
            
            if(items.mode === 'encode' && ['*', 'E'].indexOf(c) != -1 )
                items.mapListModel.set(index, {"path": true})
            
            if(c === 'S') {
                items.mapListModel.set(index, {"path": true})
                start = [j, i];
            }
            else if(c === 'E')
                items.mapListModel.set(index, {"flag": true})
            else if(c === 'I')
                items.mapListModel.set(index, {"invisible": true})
            else if(c === 'S')
                items.mapListModel.set(index, {"stone": true})
            else if(c === 'T')
                items.mapListModel.set(index, {"tree": true})
            else if(c === 'B')
                items.mapListModel.set(index, {"bush": true})
            else if(c === 'G')
                items.mapListModel.set(index, {"grass": true})
            else if(c === 'W')
                items.mapListModel.set(index, {"water": true})
        }
    }
    return start
}

function isValidPos(pos) {
    if(prevPos[0] === pos[0] && prevPos[1] === pos[1])
        return false;
    
    if(pos[1] >= map.length || pos[1] < 0 || pos[0] >= map[0].length || pos[0] < 0)
        return false;
    
    return map[pos[1]][pos[0]] === '*' || map[pos[1]][pos[0]].toUpperCase() === 'S' || map[pos[1]][pos[0]].toUpperCase() === 'E';
}

function loadMap(map_) {
    map = map_
    currPos = findStartAndLoadObstacles()
}

function positionToIndex(posArray) {
    return posArray[1] * items.cols + posArray[0];
}

function moveTuxToBlock() {
    items.tux.x = items.mapView.x + currPos[0] * items.mapView.cellWidth
    items.tux.y = items.mapView.y + currPos[1] * items.mapView.cellHeight
}

function updateTux() {
    moveTuxToBlock()
    
    if(map[currPos[1]][currPos[0]].toUpperCase() === 'E')
        items.bonus.good ("tux")
}

function findNextPositionAbsolute(fromX, fromY, direction) {
    // find direction change in case of absolute movement
    if(direction === 'DOWN')
        return  [fromX, fromY + 1]
    else if(direction === 'UP')
        return [fromX, fromY - 1]
    else if(direction === 'RIGHT')
        return [fromX + 1, fromY]
    else if(direction === 'LEFT')
        return [fromX - 1, fromY]
    return [-1, -1]
}

function findNextDirectionRelative(fromX, fromY, direction) {
    // find direction change in case of relative movement
    var directions = ['DOWN', 'LEFT', 'UP', 'RIGHT']
    var keyboardDirections = ['UP', 'RIGHT', 'DOWN', 'LEFT']
    var newRelativeCardinalDirection = items.tux.rotation + keyboardDirections.indexOf(direction) * 90

    if(newRelativeCardinalDirection < 0)
        newRelativeCardinalDirection += 360
    
    newRelativeCardinalDirection = newRelativeCardinalDirection % 360
    
    return directions[newRelativeCardinalDirection / 90]
}

function moveTowards(direction) {
    if(items.tux.isAnimationRunning)
        return
        
    var absolutePosition = findNextPositionAbsolute(currPos[0], currPos[1], direction)
    
    var relativeDirection = findNextDirectionRelative(currPos[0], currPos[1], direction)
    var relativePosition = findNextPositionAbsolute(currPos[0], currPos[1],  relativeDirection)
    
    if((items.movement === 'absolute' && isValidPos(absolutePosition)) || 
     (items.movement === 'relative' && isValidPos(relativePosition))) {
        items.movesListModel.append({
            "direction" : direction
        })
        
        prevPos = currPos
        
        if(items.movement === 'absolute') {
            currPos = absolutePosition
            items.tux.direction = direction
        }
        else {
            currPos = relativePosition
            items.tux.direction = relativeDirection
        }
        
        updateTux()
    }
    else
        items.errors ++
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
