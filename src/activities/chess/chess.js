/* GCompris - chess.js
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.12 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core
.import "engine.js" as Engine

var url = "qrc:/gcompris/src/activities/chess/resource/"

var numberOfLevel
var items
var state

function start(items_) {
    items = items_
    numberOfLevel = items.fen.length
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    initLevel()
}

function stop() {
    items.trigComputerMove.stop();
    items.redoTimer.stop();
    items.timerSwap.stop();
}

function initLevel() {
    state = Engine.p4_fen2state(items.fen[items.currentLevel][1])
    items.from = -1
    items.gameOver = false
    items.redo_stack = []
    refresh()
    Engine.p4_prepare(state)
    items.positions = 0 // Force a model reload
    items.positions = simplifiedState(state['board'])
    clearAcceptMove()
    items.whiteTakenPieceModel.clear()
    items.blackTakenPieceModel.clear()
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function simplifiedState(state) {
    var newState = new Array()
    for(var i = state.length - 1; i >= 0; --i) {
        if(state[i] !== 16) {
            var img = ""
            switch(state[i]) {
                case 2:
                    img = "wp"
                    break
                case 3:
                    img = "bp"
                    break
                case 4:
                    img = "wr"
                    break
                case 5:
                    img = "br"
                    break
                case 6:
                    img = "wn"
                    break
                case 7:
                    img = "bn"
                    break
                case 8:
                    img = "wb"
                    break
                case 9:
                    img = "bb"
                    break
                case 10:
                    img = "wk"
                    break
                case 11:
                    img = "bk"
                    break
                case 12:
                    img = "wq"
                    break
                case 13:
                    img = "bq"
                    break
                default:
                    break
            }
            newState.push(
                        {
                            'pos': engineToViewPos(i),
                            'img': img
                        })
        }
    }
    return newState
}

function updateMessage(move) {
    items.isWarningMessage = false
    items.gameOver = false
    items.message = items.blackTurn ? qsTr("Black's turn") : qsTr("White's turn")
    if(!move)
        return
    if((move.flags & (Engine.P4_MOVE_FLAG_CHECK | Engine.P4_MOVE_FLAG_MATE))
            == (Engine.P4_MOVE_FLAG_CHECK | Engine.P4_MOVE_FLAG_MATE)) {
        items.message = items.blackTurn ? qsTr("White mates", "white wins") : qsTr("Black mates", "black wins")
        items.gameOver = true
        if(!items.twoPlayer)
            if(state.to_play !== 0)
                items.bonus.good('gnu')
            else
                items.bonus.good('tux')
        else
            items.bonus.good('flower')
    } else if((move.flags & Engine.P4_MOVE_FLAG_MATE) == Engine.P4_MOVE_FLAG_MATE) {
        items.message = qsTr("Drawn game")
        items.gameOver = true
        items.bonus.good('flower')
    } else if((move.flags & Engine.P4_MOVE_FLAG_CHECK) == Engine.P4_MOVE_FLAG_CHECK) {
        items.message = items.blackTurn ? qsTr("White checks", "black king is under attack") : qsTr("Black checks", "white king is under attack")
    } else if(move.flags === Engine.P4_MOVE_ILLEGAL) {
        items.isWarningMessage = true
        items.message = qsTr("Invalid, your king may be in check")
    }
}

function refresh(move) {
    items.blackTurn = state.to_play // 0=w 1=b
    items.history = state.history
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
    return newpos
}

// move is the result from the engine move
function visibleMove(move, from, to) {
    items.pieces.moveTo(from, to)
    // Castle move
    if(move.flags & Engine.P4_MOVE_FLAG_CASTLE_KING)
        items.pieces.moveTo(from + 3, to - 1)
    else if(move.flags & Engine.P4_MOVE_FLAG_CASTLE_QUEEN)
        items.pieces.moveTo(from - 4, to + 1)
    else if(items.pieces.getPieceAt(to).img === 'wp' && to > 55)
        items.pieces.promotion(to)
    else if(items.pieces.getPieceAt(to).img === 'bp' && to < 8)
        items.pieces.promotion(to)
}

function computerMove() {
    var computer = state.findmove(3)
    var move = state.move(computer[0], computer[1])
    if(move.ok) {
        visibleMove(move, engineToViewPos(computer[0]), engineToViewPos(computer[1]))
        refresh(move)
    }
    return move
}

function moveTo(from, to) {
    items.noPieceAnimation = false
    var move = state.move(viewPosToEngine(from), viewPosToEngine(to))
    if(move.ok) {
        visibleMove(move, from, to)
        refresh(move)
        clearAcceptMove()
        items.redo_stack = []
        if(!items.twoPlayer)
            items.trigComputerMove.start()
        items.from = -1;
    } else {
        // Probably a check makes the move is invalid
        updateMessage(move)
    }
    return move.ok
}

function undo() {
    var redo_stack = items.redo_stack
    redo_stack.push(state.history[state.moveno - 1])
    state.jump_to_moveno(state.moveno - 1)
    // In computer mode, the white always starts, take care
    // of undo after a mate which requires us to revert on
    // a white play
    if(!items.twoPlayer && state.to_play !== 0) {
        redo_stack.push(state.history[state.moveno - 1])
        state.jump_to_moveno(state.moveno - 1)
    }
    // without it, you can't move again the same piece
    Engine.p4_prepare(state)
    items.redo_stack = redo_stack
    refresh()
    items.positions = [] // Force a model reload
    items.positions = simplifiedState(state['board'])
}

function moveByEngine(engineMove) {
    items.noPieceAnimation = false
    if(!engineMove)
        return
    var move = state.move(engineMove[0], engineMove[1])
    visibleMove(move, engineToViewPos(engineMove[0]), engineToViewPos(engineMove[1]))
    refresh(move)
}

function redo() {
    var redo_stack = items.redo_stack
    moveByEngine(items.redo_stack.pop())
    // In computer mode, the white always starts, take care
    // of undo after a mate which requires us to revert on
    // a white play
    if(!items.twoPlayer && state.to_play !== 0) {
        items.redoTimer.moveByEngine(items.redo_stack.pop())
    }

    // Force refresh
    items.redo_stack = []
    items.redo_stack = redo_stack
}

// Random move depending on the level
function randomMove() {
    if(!items.difficultyByLevel) {
        computerMove()
        return
    }
    // Disable random move if the situation is too bad for the user
    // This avoid having the computer playing bad against a user
    // with too few pieces making the game last too long
    var score = getScore()
    if(score[0] / score[1] < 0.7) {
        computerMove()
        return
    }

    // At level 2 we let the computer play 20% of the time
    // and 80% of the time we make a random move.
    if(Math.random() < items.currentLevel / (numberOfLevel - 1)) {
        computerMove()
        return
    }
    // Get all possible moves
    var moves = Engine.p4_parse(state, state.to_play, state.enpassant, 0)
    moves = Core.shuffle(moves)
    var move = state.move(moves[0][1], moves[0][2])
    if(move.ok) {
        visibleMove(move, engineToViewPos(moves[0][1]), engineToViewPos(moves[0][2]))
        refresh(move)
    } else {
        // Bad move, should not happens
        computerMove()
    }
}

// Clear all accept move marker from the chessboard
function clearAcceptMove() {
    for(var i=0; i < items.positions.length; ++i)
        items.squares.getSquareAt(i)['acceptMove'] = false
}

// Highlight the possible moves for the piece at position 'from'
function showPossibleMoves(from) {
    var result = Engine.p4_parse(state, state.to_play, state.enpassant, 0)
    clearAcceptMove()
    var fromEngine = viewPosToEngine(from)
    for(var i=0; i < result.length; ++i) {
        if(fromEngine === result[i][1]) {
            // we don't want to display invalid moves
            var move = Engine.p4_make_move(state, result[i][1], result[i][2]);
            //is it check?
            if (Engine.p4_check_check(state, state.to_play)) {
                Engine.p4_unmake_move(state, move);
                continue;
            }
            Engine.p4_unmake_move(state, move);
            var pos = engineToViewPos(result[i][2])
            items.squares.getSquareAt(pos)['acceptMove'] = true
        }
    }
}

// Calculate the score for black and white
// Count the number of pieces with each piece having a given weight
// Piece pawn knight bishop rook queen
// Value 1    3 	 3      5    9
// @return [white, black]
function getScore() {
    var lut = {2: 1, 4: 5, 6: 3, 8: 3, 12: 9}
    var white = 0
    var black = 0
    for(var i=0; i < state['board'].length; ++i) {
        var score = lut[state['board'][i] & 0xFE]
        if(score)
            if(state['board'][i] & 0x01)
                black += score
            else
                white += score
    }
    return [white, black]
}

