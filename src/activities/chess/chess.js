/* GCompris - chess.js
 *
 * Copyright (C) 2015 YOUR NAME <xx@yy.org>
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
.import "engine.js" as Engine

var url = "qrc:/gcompris/src/activities/chess/resource/"

var currentLevel = 0
var numberOfLevel = 4
var items
var state

function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    state = Engine.p4_new_game()
    items.from = -1
    items.state = simplifiedState(state['board'])
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

function simplifiedState(state) {
    var newState = new Array()
    for (var i = 0; i < state.length; i++) {
        if(state[i] != 16) {
            switch(state[i]) {
                case 0:
                    newState.push("")
                    break
                case 2:
                    newState.push("wp")
                    break
                case 3:
                    newState.push("bp")
                    break
                case 4:
                    newState.push("wr")
                    break
                case 5:
                    newState.push("br")
                    break
                case 6:
                    newState.push("wn")
                    break
                case 7:
                    newState.push("bn")
                    break
                case 8:
                    newState.push("wb")
                    break
                case 9:
                    newState.push("bb")
                    break
                case 10:
                    newState.push("wk")
                    break
                case 11:
                    newState.push("bk")
                    break
                case 12:
                    newState.push("wq")
                    break
                case 13:
                    newState.push("bq")
                    break
                default:
                    break
            }
        }
    }
    return newState
}

function viewPosToEngine(pos) {
    return (Math.floor(pos / 8) + 2) * 10 + pos % 8 + 1
}

function computerMove() {
    var computer = state.findmove(3)
    console.log('computer move', computer)
    state.move(computer[0], computer[1])
    items.state = simplifiedState(state['board'])
}

function moveTo(from, to) {
    console.log("moveTo", from, to)
    var result = state.move(from, to)
    console.log(result.ok)
    if(result.ok) {
        items.state = simplifiedState(state['board'])
    }
    items.from = -1;
    computerMove()
    return result
}
