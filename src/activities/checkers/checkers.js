/* GCompris - checkers.js
 *
 * SPDX-FileCopyrightText: 2017 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.12 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core
.import "engine.js" as Engine

var url = "qrc:/gcompris/src/activities/checkers/resource/"

var numberOfLevel = 5
var items
var state

function start(items_) {
    items = items_
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    initLevel()
}

function stop() {
    items.trigComputerMove.stop();
    items.redoTimer.stop();
}

function initLevel() {
    state = new Engine.Draughts('W:W31-50:B1-20')
    state.resetGame()
    items.from = -1
    items.gameOver = false
    items.redo_stack = []
    refresh()
    items.positions = 0 // Force a model reload
    items.positions = simplifiedState(state.position())
    clearAcceptMove()
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function simplifiedState(position) {
    var newState = new Array()
    for(var i = 0; i < position.length; ++i) {
        var img = position[i] !== '0' && position[i] !== '?' ? position[i] : ''
        newState.push(
            {
                'pos': engineToViewPos(i),
                'img': img
            })
    }
    return newState
}

function updateMessage() {
    items.gameOver = false
    items.message = items.blackTurn ? qsTr("Black's turn") : qsTr("White's turn")

    if(state.gameOver()) {
        items.message = items.blackTurn ? qsTr("White wins") : qsTr("Black wins")
        items.gameOver = true
        if(!items.twoPlayer)
            if(items.blackTurn)
                items.bonus.good('gnu')
            else
                items.bonus.good('tux')
        else
            items.bonus.good('flower')
    }
}

function refresh() {
    items.blackTurn = (state.getTurn() == 'b')
    items.history = state.history()
    updateMessage()
    items.positions = 0 // Force a model reload
    items.positions = simplifiedState(state.position())
}

// Convert view position (QML) to the chess engine coordinate
//
// engine view:
// |  01  02  03  04  05|
// |06  07  08  09  10  |
// |  11  12  13  14  15|
// |16  17  18  19  20  |
// |  21  22  23  24  25|
// |26  27  28  29  30  |
// |  31  32  33  34  35|
// |36  37  38  39  40  |
// |  41  42  43  44  45|
// |46  47  48  49  50  |
//
// QML view:
// |  91  93  95  97  99|
// |80  82  84  86  88  |
// |  71  73  75  77  79|
// |60  62  64  66  68  |
// |  51  53  55  57  59|
// |40  42  44  46  48  |
// |  31  33  35  37  39|
// |20  22  24  26  28  |
// |  11  13  15  17  19|
// |00  02  04  06  08  |
//
function viewPosToEngine(pos) {
    var casesNumber = items.numberOfCases*items.numberOfCases
    var a = 10 * Math.floor((casesNumber - pos) / 10 + 1);
    var b = 20;
    if(pos % 10 !== 0) {
        b = (casesNumber - pos) % 10;
    }
    var newPos = (a - b + 1)
    newPos = Math.floor(newPos / 2 + 0.5)
    return newPos
}

// Convert chess engine coordinate to view position (QML)
function engineToViewPos(pos) {
    var newPos = 90-10*Math.floor((2*pos-1)/10)+2*((pos-1)%5)+1+((-1+Math.pow(-1, Math.floor((2*pos-1)/10)))/2)
    return newPos
}

// move is the result from the engine move
function visibleMove(move, from, to) {
    var piece = items.pieces.getPieceAt(from);
    items.pieces.moveTo(from, to, move)

    // promotion
    if (move.to <= 5 && piece.img === 'w')
        piece.promotion()
    else if (move.to >= 46 && piece.img === 'b')
        piece.promotion()
}

function findBestMove(currentState, depth, sign) {
    if(depth <= 0) {
        return getScore(currentState);
    }

    var moves = currentState.moves()
    if(moves.length === 0) {
        return [100, 0];
    }
    var bestScore = -1000;
    var bestScores;
    for(var move in moves) {
        currentState.move(moves[move]);
        var newScore = findBestMove(currentState, depth-1, -1.0*sign)
        currentState.undo()
        var score = sign*(newScore[0] - newScore[1])
        if(score > bestScore) {
            bestScore = score;
            bestScores = newScore;
        }
    }
    return bestScores
}

function computerMove() {
    var moves = state.moves()
    var bestScore = -1000
    var bestMoves = []
    var newState = new Engine.Draughts(state.fen())
    // 0 is b, 1 is b -> w, 2 is b -> w -> b guesses
    var depth = items.currentLevel === 5 ? 2 : 1;

    for(var move in moves) {
        newState.move(moves[move]);
        var newScore = findBestMove(newState, depth, 1)
        newState.undo()
        var score = newScore[1] - newScore[0]
        if(bestMoves.length == 0 || bestScore < score) {
            bestScore = score
            bestMoves = []
            bestMoves.push(moves[move])
        }
        else if(bestScore == score) {
            bestMoves.push(moves[move])
        }
    }
    bestMoves = Core.shuffle(bestMoves)

    var computer = bestMoves[0]
    var move = state.move({"from": computer.from, "to": computer.to})
    if(move) {
        visibleMove(move, engineToViewPos(computer.from), engineToViewPos(computer.to))
    }
    return move
}

function moveTo(from, to) {
    items.noPieceAnimation = false
    var move = state.move({"from": viewPosToEngine(from), "to": viewPosToEngine(to)})
    if(move) {
        visibleMove(move, from, to)
        clearAcceptMove()
        items.redo_stack = []
        if(!items.twoPlayer && !state.gameOver())
            items.trigComputerMove.start()
        items.from = -1;
    } else {
        // Probably a check makes the move is invalid
        updateMessage(move)
    }
    return move
}

function undo() {
    var move = state.undo();
    var redo_stack = items.redo_stack
    redo_stack.push(move)
    // In computer mode, the white always starts, take care
    // of undo after a mate which requires us to revert on
    // a white play
    if(!items.twoPlayer && state.getTurn() === 'b') {
        move = state.undo();
        redo_stack.push(move)
    }
    items.redo_stack = redo_stack
    refresh()
}

function moveByEngine(engineMove) {
    items.noPieceAnimation = false
    if(!engineMove)
        return
    var move = state.move(engineMove)
    visibleMove(move, engineToViewPos(engineMove.from), engineToViewPos(engineMove.to))
}

function redo() {
    var redo_stack = items.redo_stack
    var move = redo_stack.pop()
    moveByEngine(move)
   // In computer mode, the white always starts, take care
    // of undo after a mate which requires us to revert on
    // a white play
    if(!items.twoPlayer && state.getTurn() === 'b') {
        move = redo_stack.pop()
        moveByEngine(move)
    }

    // Force refresh
    items.redo_stack = []
    items.redo_stack = redo_stack
    clearAcceptMove()
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
    var score = getScore(state)
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
    var moves = state.moves()
    moves = Core.shuffle(moves)
    var move = state.move(moves[0])
    if(move) {
        visibleMove(move, engineToViewPos(moves[0].from), engineToViewPos(moves[0].to))
    } else {
        // Bad move, should not happen
        computerMove()
    }
}

// Clear all accept move marker from the chessboard
function clearAcceptMove() {
    for(var i=0; i < 50; ++i) {
        var square = items.squares.getSquareAt(engineToViewPos(i))
        if(square) {
            square['acceptMove'] = false
            square['jumpable'] = false
        }
    }
}

// Highlight the possible moves for the piece at position 'from'
function showPossibleMoves(from) {
    var fromEngine = viewPosToEngine(from)
    var result = state.moves();
    clearAcceptMove()
    for(var i=0; i < result.length; ++i) {
        if(fromEngine === result[i].from) {
            var pos = engineToViewPos(result[i].to)
            items.squares.getSquareAt(pos)['acceptMove'] = true
            for(var v = 1; v < result[i].jumps.length; ++ v) {
                items.squares.getSquareAt(engineToViewPos(result[i].jumps[v]))['jumpable'] = true
            }
        }
    }
}

// Calculate the score for black and white
// Count the number of pieces with each piece having a given weight
// Piece pawn queen
// Value 1    4
// @return [white, black]
function getScore(board) {
    var white = 0
    var black = 0
    var queenScore = 4
    var position = board.position()
    
    for(var i = 0; i < position.length; ++i) {
        var img = position[i] !== '0' && position[i] !== '?' ? position[i] : ''
        if(img === '')
            continue;
        else if(img === 'w') {
            white ++;
        }
        else if(img === 'W') {
            white += queenScore;
        }
        if(img === 'b') {
            black ++;
        }
        else if(img === 'B') {
            black += queenScore;
        }
    }
    return [white, black]
}
