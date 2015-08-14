/* GCompris - chess.js
 *
 * Copyright (C) 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
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
.import "qrc:/gcompris/src/core/core.js" as Core
.import "engine.js" as Engine

var url = "qrc:/gcompris/src/activities/chess/resource/"

var currentLevel = 0
var numberOfLevel = 5
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
    refresh()
    Engine.p4_prepare(state)
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
                    newState.push({'img': "", 'acceptMove': false})
                    break
                case 2:
                    newState.push({'img': "wp", 'acceptMove': false})
                    break
                case 3:
                    newState.push({'img': "bp", 'acceptMove': false})
                    break
                case 4:
                    newState.push({'img': "wr", 'acceptMove': false})
                    break
                case 5:
                    newState.push({'img': "br", 'acceptMove': false})
                    break
                case 6:
                    newState.push({'img': "wn", 'acceptMove': false})
                    break
                case 7:
                    newState.push({'img': "bn", 'acceptMove': false})
                    break
                case 8:
                    newState.push({'img': "wb", 'acceptMove': false})
                    break
                case 9:
                    newState.push({'img': "bb", 'acceptMove': false})
                    break
                case 10:
                    newState.push({'img': "wk", 'acceptMove': false})
                    break
                case 11:
                    newState.push({'img': "bk", 'acceptMove': false})
                    break
                case 12:
                    newState.push({'img': "wq", 'acceptMove': false})
                    break
                case 13:
                    newState.push({'img': "bq", 'acceptMove': false})
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
    items.viewstate = simplifiedState(state['board'])
}

// Convert view position (QML) to the chess engine coordinate
//
// The engine manages coordinate into a 120 element array, which is conceptually
// a 10x12 board, with the 8x8 board placed at the centre, thus:
//  + 0123456789
//  0 ##########
// 10 ##########
// 20 #RNBQKBNR#
// 30 #PPPPPPPP#
// 40 #........#
// 50 #........#
// 60 #........#
// 70 #........#
// 80 #pppppppp#
// 90 #rnbqkbnr#
//100 ##########
//110 ##########
//
// In QML each cell is in the regular range [0-63]
//
function viewPosToEngine(pos) {
    return (Math.floor(pos / 8) + 2) * 10 + pos % 8 + 1
}

// Convert chess engine coordinate to view position (QML)
function engineToViewPos(pos) {
    var newpos = pos - 21 - (Math.floor((pos - 20) / 10) * 2)
    if(items.whiteAtBottom)
        newpos = 63 - newpos
    return newpos
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
    if(items.whiteAtBottom) {
        from = 63 - from
        to = 63 - to
    }
    var move = state.move(viewPosToEngine(from), viewPosToEngine(to))
    if(move.ok) {
        refresh()
        if(!items.twoPlayer)
            randomMove()
    }
    items.from = -1;
    items.blackTurn = state.to_play // 0=w 1=b
}

function undo() {
    state.jump_to_moveno(state.moveno - 2)
    refresh()
}

function swap() {
    items.whiteAtBottom = !items.whiteAtBottom
    refresh()
}

function clearAcceptMove() {
    for(var i=0; i < items.viewstate.length; ++i)
        items.viewstate[i]['acceptMove'] = false
}


function showPossibleMoves(from) {
    var result = Engine.p4_parse(state, state.to_play, 0, 0)
    clearAcceptMove()
    if(items.whiteAtBottom)
        from = 63 - from
    for(var i=0; i<result.length; ++i)
        if(viewPosToEngine(from) == result[i][1]) {
            var pos = engineToViewPos(result[i][2])
            items.viewstate[pos]['acceptMove'] = true
        }
    // Refresh the model
    items.viewstate = items.viewstate
}

// Random move depending on the level
function randomMove() {
    // At level 2 we let the computer play 20% of the time
    // and 80% of the time we make a random move.
    if(Math.random() < currentLevel / (numberOfLevel - 1)) {
        computerMove()
        return
    }
    // Get all possible moves
    var moves = Engine.p4_parse(state, state.to_play, 0, 0)
    moves = Core.shuffle(moves)
    var move = state.move(moves[0][1], moves[0][2])
    if(move.ok) {
        refresh()
    } else {
        // Bad move, should not happens
        computerMove()
    }
}
