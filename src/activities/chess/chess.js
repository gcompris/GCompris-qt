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

var currentLevel
var numberOfLevel
var items
var state

function start(items_) {
    items = items_
    currentLevel = 0
    numberOfLevel = items.fen.length
    items.whiteAtBottom = true
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    state = Engine.p4_fen2state(items.fen[currentLevel][1])
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

function updateMessage(move) {
    items.message = items.blackTurn ? qsTr("Black's turn") : qsTr("White's turn")
    if(!move)
        return
    if((move.flags & (Engine.P4_MOVE_FLAG_CHECK | Engine.P4_MOVE_FLAG_MATE))
            == (Engine.P4_MOVE_FLAG_CHECK | Engine.P4_MOVE_FLAG_MATE))
        items.message = items.blackTurn ? qsTr("Black mates") : qsTr("White mates")
    else if((move.flags & Engine.P4_MOVE_FLAG_MATE) == Engine.P4_MOVE_FLAG_MATE)
        items.message = qsTr("Drawn game")
    else if((move.flags & Engine.P4_MOVE_FLAG_CHECK) == Engine.P4_MOVE_FLAG_CHECK)
        items.message = items.blackTurn ? qsTr("Black checks") : qsTr("White checks")
}

function refresh(move) {
    items.viewstate = simplifiedState(state['board'])
    updateMessage(move)
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
    var computer = state.findmove(3)
    var move = state.move(computer[0], computer[1])
    if(move.ok) {
        refresh(move)
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
        refresh(move)
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
        refresh(move)
    } else {
        // Bad move, should not happens
        computerMove()
    }
}
