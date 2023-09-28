/* GCompris - path.js
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 */
.pragma library
.import QtQuick 2.12 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var numberOfLevel
var items

var currPos = [-1, -1]
var prevPos = [-1, -1]
var map
var decodeIndex

var successSoundPath = 'qrc:/gcompris/src/core/resource/sounds/completetask.wav'
var errorSoundPath = 'qrc:/gcompris/src/core/resource/sounds/crash.wav'

var Directions = {
    UP: 'UP',
    RIGHT: 'RIGHT',
    DOWN: 'DOWN',
    LEFT: 'LEFT'
}

var mapModel = {
    "path": false,
    "flag": false,
    "invisible": false,
    "rock": false,
    "tree": false,
    "bush": false,
    "grass": false,
    "water": false
}

function start(items_) {
    items = items_
    numberOfLevel = items.levels.length
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    initLevel()
}

function stop() {
}

function initLevel() {

    items.rows = items.levels[items.currentLevel].path.length
    items.cols = items.levels[items.currentLevel].path[0].length

    items.mapListModel.clear()
    items.movesListModel.clear()

    for(var i=0; i < items.rows * items.cols; ++i)
        items.mapListModel.append(mapModel)

    map = items.levels[items.currentLevel].path

    // reset initial position
    prevPos = [-1, -1];
    // intialize position of tux
    currPos = findStartAndLoadObstacles()

    // find the initial direciton of tux
    items.tux.init(findCorrectDirectionAbsolute(currPos[0], currPos[1], -1, -1))

    // reset mapView
    items.mapView.init()

    // reset the error counter
    items.errorsCount = 0

    // load the moves if in decode mode
    if(items.mode === 'decode') {
        loadMoves()
        decodeIndex = 0
        items.movesListModel.set(0, {"active": true})
    }

    items.movesGridView.currentIndex = 0
}

function loadMoves() {
    var pos = currPos.slice()
    prevPos = [-1, -1]
    var direction = items.tux.direction

    while(map[pos[1]][pos[0]].toUpperCase() !== 'E') {
        var nextDirectionAbsolute = findCorrectDirectionAbsolute(pos[0], pos[1], prevPos[0], prevPos[1])
        var nextDirectionRelative = absoluteDirectionToRelative(nextDirectionAbsolute, direction)

        items.movesListModel.append({
            "direction" : (items.movement === 'absolute' ? nextDirectionAbsolute : nextDirectionRelative),
            "faded" : false,
            "active" : false
        })

        prevPos = pos
        pos = findNextPositionAbsolute(pos[0], pos[1], nextDirectionAbsolute)
        direction = nextDirectionAbsolute
    }

    prevPos = [-1, -1]
}

function absoluteDirectionToRelative(absoluteDirection, currentDirection) {
    var directions = [Directions.DOWN, Directions.LEFT, Directions.UP, Directions.RIGHT]

    var diff = directions.indexOf(absoluteDirection) - directions.indexOf(currentDirection)

    if(diff === -1 || diff === 3)
        return Directions.LEFT
    else if(diff === 1 || diff === -3)
        return Directions.RIGHT
    else if(diff === 0)
        return Directions.UP
    else
        return Directions.DOWN
}

function findCorrectDirectionAbsolute(fromX, fromY, prevX, prevY) {
    if(isValidPos([fromX, fromY + 1]) && !(fromX === prevX && fromY + 1 === prevY))
        return Directions.DOWN
    else if(isValidPos([fromX + 1, fromY]) && !(fromX + 1 === prevX && fromY === prevY))
        return Directions.RIGHT
    else if(isValidPos([fromX - 1, fromY]) && !(fromX - 1 === prevX && fromY === prevY))
        return Directions.LEFT
    else if(isValidPos([fromX, fromY - 1]) && !(fromX === prevX && fromY - 1 === prevY))
        return Directions.UP
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
            else if(c === 'R')
                items.mapListModel.set(index, {"rock": true})
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

function positionToIndex(posArray) {
    return posArray[1] * items.cols + posArray[0];
}

function indexToPosition(index) {
    return [index % items.cols, Math.floor(index / items.rows)]
}

function moveTuxToBlock() {
    items.tux.x = items.mapView.x + currPos[0] * items.mapView.cellSize
    items.tux.y = items.mapView.y + currPos[1] * items.mapView.cellSize
}

function updateTux() {
    moveTuxToBlock()

    items.audioEffects.play(successSoundPath)

    if(map[currPos[1]][currPos[0]].toUpperCase() === 'E')
        items.bonus.good ("tux")
}

function findNextPositionAbsolute(fromX, fromY, direction) {
    // find direction change in case of absolute movement
    if(direction === Directions.DOWN)
        return  [fromX, fromY + 1]
    else if(direction === Directions.UP)
        return [fromX, fromY - 1]
    else if(direction === Directions.RIGHT)
        return [fromX + 1, fromY]
    else if(direction === Directions.LEFT)
        return [fromX - 1, fromY]
    return [-1, -1]
}

function findNextDirectionRelative(fromX, fromY, direction) {
    // find direction change in case of relative movement
    var directions = [Directions.DOWN, Directions.LEFT, Directions.UP, Directions.RIGHT]
    var keyboardDirections = [Directions.UP, Directions.RIGHT, Directions.DOWN, Directions.LEFT]
    var newRelativeCardinalDirection = items.tux.rotation + keyboardDirections.indexOf(direction) * 90

    if(newRelativeCardinalDirection < 0)
        newRelativeCardinalDirection += 360

    newRelativeCardinalDirection = newRelativeCardinalDirection % 360

    return directions[newRelativeCardinalDirection / 90]
}

function findNextPositionRelative(fromX, fromY, direction) {
    var absoluteDirection = findNextDirectionRelative(fromX, fromY, direction)
    return findNextPositionAbsolute(fromX, fromY, absoluteDirection)
}

function moveTowards(direction) {
    if(items.tux.isAnimationRunning || items.bonus.isPlaying)
        return

    var absolutePosition = findNextPositionAbsolute(currPos[0], currPos[1], direction)

    var relativeDirection = findNextDirectionRelative(currPos[0], currPos[1], direction)
    var relativePosition = findNextPositionRelative(currPos[0], currPos[1],  direction)

    if((items.movement === 'absolute' && isValidPos(absolutePosition)) ||
     (items.movement === 'relative' && isValidPos(relativePosition))) {

        if(items.mode === 'encode') {
            items.movesListModel.append({
                "direction" : direction,
                "active" : false,
                "faded" : false
            })

            items.movesGridView.currentIndex = items.movesListModel.count - 1
        }

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
    else {
        items.audioEffects.play(errorSoundPath)
        items.errorsCount ++
    }
}

function processBlockClick(pos) {
    if(decodeIndex >= items.movesListModel.count || items.bonus.isPlaying)
        return

    var correctPos
    if(items.movement === 'absolute')
        correctPos = findNextPositionAbsolute(currPos[0], currPos[1], items.movesListModel.get(decodeIndex).direction)
    else
        correctPos = findNextPositionRelative(currPos[0], currPos[1], items.movesListModel.get(decodeIndex).direction)

    if(correctPos[0] === pos[0] && correctPos[1] === pos[1]) {
        moveTowards(items.movesListModel.get(decodeIndex).direction)

        items.movesListModel.set(decodeIndex, {"active" : false, "faded" : true})
        decodeIndex++
        if(decodeIndex < items.movesListModel.count) {
            items.movesListModel.set(decodeIndex, {"active" : true})
            items.movesGridView.currentIndex = decodeIndex
        }

        items.mapListModel.set(positionToIndex(currPos), {"path": true})
    }
    else {
        items.audioEffects.play(errorSoundPath)
        items.errorsCount ++
    }
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}
