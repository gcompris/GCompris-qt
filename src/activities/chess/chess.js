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

var FEN = [
    ["initial state", "rnbkqbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBKQBNR w KQkq - 1 1"],
    ["initial state", "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 1 1"],
    ["checkmate in 6", "8/8/8/8/8/4K3/5Q2/7k w - - 11 56"],
    ["checkmate in 1", "8/8/8/8/8/6K1/4Q3/6k1 w - - 21 61"],
    ["mate in 1", "5k2/8/5K2/4Q3/5P2/8/8/8 w - - 3 61"],
    ["zugzwang", "8/8/p1p5/1p5p/1P5p/8/PPP2K1p/4R1rk w - - 0 1"],
    ["earlyish", "rnq1nrk1/pp3pbp/6p1/3p4/3P4/5N2/PP2BPPP/R1BQK2R w KQ -"],
    ["checkmate in 2", "4kb2/3r1p2/2R3p1/6B1/p6P/P3p1P1/P7/5K2 w - - 0 36"],
    ["“leonid's position”", "q2k2q1/2nqn2b/1n1P1n1b/2rnr2Q/1NQ1QN1Q/3Q3B/2RQR2B/Q2K2Q1 w - -"],
    ["sufficient material - knight", "8/7K/8/5n2/8/8/N7/7k w - - 40 40"],
    ["sufficient material - opposing bishops", "8/6BK/7B/6b1/7B/8/B7/7k w - - 40 40"],
    ["sufficient material", "8/7K/8/8/7B/8/N7/7k w - - 40 40"]
]

function start(items_) {
    items = items_
    currentLevel = 0
    items.whiteAtBottom = true
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    state = Engine. p4_fen2state(FEN[0][1])
    items.from = -1
    items.blackTurn = state.to_play // 0=w 1=b
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

function isWhite(piece) {
    if(piece.length != 2)
        return undefined

    if(piece[0] == 'w')
        return true

    return false
}

function simplifiedState(state) {
    var newState = new Array()
    var i = 0
    var end = state.length
    var step = 1
    if(items.whiteAtBottom) {
        i = state.length
        end = 0
        step = -1
    }
    while(i != end) {
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
        i += step
    }
    return newState
}

function refresh() {
    items.state = simplifiedState(state['board'])
}

function viewPosToEngine(pos) {
    return (Math.floor(pos / 8) + 2) * 10 + pos % 8 + 1
}

function computerMove() {
    var computer = state.findmove(1)
    var move = state.move(computer[0], computer[1])
    if(move.ok) {
        refresh()
    }
    return move
}

function moveTo(from, to) {
    console.log("moveTo 1:", from, to)
    console.log("moveTo 2:", viewPosToEngine(from), viewPosToEngine(to))
    if(items.whiteAtBottom) {
        from = 63 - from
        to = 63 - to
    }

    console.log("moveTo 3:", from, to)
    console.log("moveTo 4:", viewPosToEngine(from), viewPosToEngine(to))
    var move = state.move(viewPosToEngine(from), viewPosToEngine(to))
    if(move.ok) {
        refresh()
        console.log("to_play=", state.to_play)
        computerMove()
        console.log("after computer to_play=", state.to_play)
    }
    items.from = -1;
}

function undo() {
    state.jump_to_moveno(state.moveno - 2)
    refresh()
}

function swap() {
    items.whiteAtBottom = !items.whiteAtBottom
    refresh()
}
