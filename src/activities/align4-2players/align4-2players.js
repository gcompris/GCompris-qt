/* GCompris - align4-2players.js
 *
 * Copyright (C) 2014 Bharath M S
 *
 * Authors:
 *   Laurent Lacheny <laurent.lacheny@wanadoo.fr> (GTK+ version)
 *   Bharath M S <brat.197@gmail.com> (Qt Quick port)
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

var currentLevel = 0
var numberOfLevel = 1
var items
var url = "qrc:/gcompris/src/activities/align4-2players/resource/"
var numberOfRows = 6
var numberOfColumns = 7
var currentPiece
var counter
var currentPlayer
var twoPlayer
var weight = [[100, 50, 20, 100, 50, 20],
              [110, 55, 20, 100, 50, 20],
              [100, 50, 20, 110, 55, 20]];

function start(items_, twoPlayer_) {
    items = items_
    currentLevel = 0
    items.player1_score = 0
    items.player2_score = 0
    twoPlayer = twoPlayer_
    initLevel()
}

function stop() {
}

function initLevel() {

    if(!twoPlayer) {
        numberOfLevel = 3
    }

    items.bar.level = currentLevel + 1
    items.dynamic.enabled = true

    counter = 0

    items.pieces.clear()
    for(var y = 0;  y < numberOfRows; y++) {
        for(var x = 0;  x < numberOfColumns; x++) {
            items.pieces.append({'stateTemp': "invisible"})
        }
    }

    setPieceLocation(items.background.width * 0.4505, items.background.height * 0.5)
    items.fallingPiece.opacity = 1
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

function reset() {
    items.drop.stop()    // stop animation
    items.pieces.clear() // Clear the board
    items.fallingPiece.opacity = 0
    currentLevel = (currentLevel + 1) % 3
    initLevel()
}

function whichColumn(x, y) {
    if(x >= items.background.width * 0.1865 &&
            x < items.background.width * 0.274){ //column 1
        return 0
    } else if(x >= items.background.width * 0.274 &&
              x < items.background.width * 0.3615){ //column 2
        return 1
    } else if(x >= items.background.width * 0.3615 &&
              x < items.background.width * 0.449){ //column 3
        return 2
    } else if(x >= items.background.width * 0.449 &&
              x < items.background.width * 0.5365){ //column 4
        return 3
    } else if(x >= items.background.width * 0.5365 &&
              x < items.background.width * 0.624){ //column 5
        return 4
    } else if(x >= items.background.width * 0.624 &&
              x < items.background.width * 0.7115){ //column 6
        return 5
    } else if(x >= items.background.width * 0.7115 &&
              x < items.background.width * 0.799){ //column 7
        return 6
    }
}

/* To move the piece before a column is chosen */
function setPieceLocation(x, y) {
    var column = whichColumn(x, y)
    items.fallingPiece.y = - items.background.height * 0.019
    switch(column) {
    case 0:
        items.fallingPiece.x = items.background.width * 0.1865
        break;
    case 1:
        items.fallingPiece.x = items.background.width * 0.274
        break;
    case 2:
        items.fallingPiece.x = items.background.width * 0.3615
        break;
    case 3:
        items.fallingPiece.x = items.background.width * 0.449
        break;
    case 4:
        items.fallingPiece.x = items.background.width * 0.5365
        break;
    case 5:
        items.fallingPiece.x = items.background.width * 0.624
        break;
    case 6:
        items.fallingPiece.x = items.background.width * 0.7115
        break;
    }
    items.fallingPiece.state = counter % 2 ? "2": "1"
}

function isModelEmpty(model) {
    var state = model.stateTemp
    return (state == "1" || state == "2") ? false : true
}

function getPieceAt(col, row) {
    return items.pieces.get(row * 7 + col)
}

function getNextFreeStop(col) {
    for(var row = numberOfRows - 1; row >= 0; row--) {
        if(isModelEmpty(getPieceAt(col, row)))
            return row
    }
    // Full column
    return -1
}

var mutex = 1

function handleDrop(x, y) {

    if(mutex) {
        items.dynamic.enabled = false

        var singleDropSize = items.background.height * 0.1358
        var column = whichColumn(x, y)
        var nextFreeStop = getNextFreeStop(column)

        if(nextFreeStop === -1) {
            items.dynamic.enabled = true
            return
        }
        var destination = items.fallingPiece.y
                + singleDropSize * (nextFreeStop + 1)

        items.drop.to = destination
        items.drop.duration = 1500 * ((nextFreeStop + 1) / 6)
        currentPiece = nextFreeStop * 7 + column
        mutex = 0
        items.drop.start()

    }
}

function setPieceState(col, row, state) {
    items.pieces.set(row * 7 + col, {"stateTemp": state})
}

function getPieceState(col, row) {
    return items.pieces.get(row * 7 + col).stateTemp
}

function getBoardFromModel() {
    var board = new Array()
    var temp = new Array()

    for(var i = 0; i < numberOfRows; i++) {
        temp = []
        for(var j = 0; j < numberOfColumns; j++) {
            temp.push(getPieceState(j, i))
        }
        board.push(temp)
    }

    return board

}

function getFreeStopFromBoard(column, board) {
    for(var row = numberOfRows-1; row > -1; row--) {
        if(board[row][column] === "invisible") {
            return row
        }
    }
    return -1
}

var nextColumn = 3


function alphabeta(depth, alpha, beta, player, board) {

    var value = evaluateBoard(player, player % 2? 2: 1, board)


    if(depth === 0 || value === 100000 || value < -100000) {
        return value
    }

    if(player === 2) {

        var scores = [];

        for(var c = 0; c < numberOfColumns; c++) {
            var r = getFreeStopFromBoard(c, board)

            if(r === -1) continue;



            board[r][c] = "2"

            alpha = Math.max(alpha, alphabeta(depth - 1, alpha, beta, 1, board))

            board[r][c] = "invisible"
            scores[c] = alpha;

            if(beta <= alpha) break;
        }

        if(depth === 4) {
            var max = -10000;
            for(var i = 0; i < scores.length; i++) {
                if(scores[i] > max) {
                    max = scores[i]
                    nextColumn = i
                }
            }
        }

        return alpha;

    } else {
        for(var c = 0; c < numberOfColumns; c++) {

            var r = getFreeStopFromBoard(c, board)

            if(r === -1) continue;

            board[r][c] = "1"

            beta = Math.min(beta, alphabeta(depth - 1, alpha, beta, 2, board))

            board[r][c] = "invisible"

            if(beta <= alpha) break;
        }
        return beta;
    }
}

function doMove() {

    var board = getBoardFromModel()

    alphabeta(4, -10000, 10000, 2, board)

    setPieceLocation(items.background.width * 0.1865 + 20 +
                     nextColumn * (items.background.width * 0.0875),
                     items.background.height * 0.2)
    handleDrop(items.background.width * 0.1865 + 20 +
               nextColumn * (items.background.width * 0.0875),
               items.background.height * 0.1)
}

function checkLine() {
    var score = 0
    var count1, count2
    var player1 = arguments[0]
    var player2 = arguments[1]

    for(var i = 2; i < (arguments.length - 3); i++) {
        count1 = 0
        count2 = 0
        for(var j = 0; j < 4; j++) {
            if(arguments[i + j] === player1.toString()) {
                count1++
            } else if( arguments[i + j] === player2.toString()) {
                count2++
            }
        }

        if((count1 > 0) && (count2 === 0)) {
            if(count1 === 4) {
                return 10000
            }
            score += ((count1 / 3) * weight[currentLevel][0] +
                      (count1 / 2) * weight[currentLevel][1] +
                      count1 * weight[currentLevel][2])
        } else if((count1 === 0) && (count2 > 0)) {
            if(count2 === 4) {
                return -10000
            }
            score -= ((count2 / 3) * weight[currentLevel][3] +
                      (count2 / 2) * weight[currentLevel][4] +
                      count2 * weight[currentLevel][5])
        }
    }
    return score
}

function evaluateBoard(player1, player2, board) {
    var score = 0

    //Horizontal
    for(var i = 0; i < numberOfRows; i++) {
        score += checkLine(player1, player2, board[i][0],
                           board[i][1], board[i][2], board[i][3],
                           board[i][4], board[i][5], board[i][6]);
    }

    //Vertical
    for(var i = 0; i < numberOfColumns; i++) {
        score += checkLine(player1, player2, board[0][i],
                           board[1][i], board[2][i],
                           board[3][i], board[4][i], board[5][i])
    }

    //Diagonal Bottom-Right
    score += checkLine(player1, player2, board[0][3],
                       board[1][4], board[2][5], board[3][6]);
    score += checkLine(player1, player2, board[0][2], board[1][3],
                       board[2][4], board[3][5], board[4][6]);
    score += checkLine(player1, player2, board[0][1], board[1][2],
                       board[2][3], board[3][4], board[4][5], board[5][6]);
    score += checkLine(player1, player2, board[0][0], board[1][1],
                       board[2][2], board[3][3], board[4][4], board[5][5]);
    score += checkLine(player1, player2, board[1][0], board[2][1],
                       board[3][2], board[4][3], board[5][4]);
    score += checkLine(player1, player2, board[2][0],
                       board[3][1], board[4][2], board[5][3]);

    //Diagonal Top-Left
    score += checkLine(player1, player2, board[3][0],
                       board[2][1], board[1][2], board[0][3])
    score += checkLine(player1, player2, board[4][0], board[3][1],
                       board[2][2], board[1][3], board[0][4]);
    score += checkLine(player1, player2, board[5][0], board[4][1],
                       board[3][2], board[2][3], board[1][4], board[0][5]);
    score += checkLine(player1, player2, board[5][1], board[4][2],
                       board[3][3], board[2][4], board[1][5], board[0][6]);
    score += checkLine(player1, player2, board[5][2], board[4][3],
                       board[3][4], board[2][5], board[1][6]);
    score += checkLine(player1, player2, board[5][3], board[4][4],
                       board[3][5], board[2][6]);

    return score

}

function checkGameWon(currentPieceRow, currentPieceColumn) {

    currentPlayer = getPieceState(currentPieceColumn, currentPieceRow)

    // Horizontal
    var sameColor = 0
    for(var col = 0; col < numberOfColumns; col++) {
        if(getPieceState(col, currentPieceRow) === currentPlayer) {
            if(++sameColor == 4) {
                setPieceState(col, currentPieceRow, "crossed")
                setPieceState(col - 1, currentPieceRow, "crossed")
                setPieceState(col - 2, currentPieceRow, "crossed")
                setPieceState(col - 3, currentPieceRow, "crossed")
                return true
            }
        } else {
            sameColor = 0
        }
    }

    // Vertical
    sameColor = 0
    for(var row = 0; row < numberOfRows; row++) {
        if(getPieceState(currentPieceColumn, row) === currentPlayer) {
            if(++sameColor == 4) {
                setPieceState(currentPieceColumn, row, "crossed")
                setPieceState(currentPieceColumn, row - 1, "crossed")
                setPieceState(currentPieceColumn, row - 2, "crossed")
                setPieceState(currentPieceColumn, row - 3, "crossed")
                return true
            }
        } else {
            sameColor = 0
        }
    }

    // Diagonal top left / bottom right
    sameColor = 0
    var row = 0
    for(var col = currentPieceColumn - currentPieceRow;
        col < numberOfColumns; col++) {
        row++
        if(col < 0)
            continue

        if(row > numberOfRows)
            break

        if(getPieceState(col, row-1) === currentPlayer) {
            if(++sameColor == 4) {
                setPieceState(col, row - 1, "crossed")
                setPieceState(col - 1, row - 2, "crossed")
                setPieceState(col - 2, row - 3, "crossed")
                setPieceState(col - 3, row - 4, "crossed")
                return true
            }
        } else {
            sameColor = 0
        }
    }

    // Diagonal top right / bottom left
    sameColor = 0
    var row = 0
    for(var col = currentPieceColumn + currentPieceRow;
        col >= 0; col--) {
        row++
        if(col >= numberOfColumns)
            continue

        if(row > numberOfRows)
            break

        if(getPieceState(col, row-1) === currentPlayer) {
            if(++sameColor == 4) {
                setPieceState(col, row - 1, "crossed")
                setPieceState(col + 1, row - 2, "crossed")
                setPieceState(col + 2, row - 3, "crossed")
                setPieceState(col + 3, row - 4, "crossed")
                return true
            }
        } else {
            sameColor = 0
        }
    }
}

function continueGame() {

    items.pieces.set(currentPiece, {"stateTemp": counter++ % 2 ? "2": "1"})

    /* Update score if game won */
    if(twoPlayer) {
        mutex = 1
        items.dynamic.enabled = true
        if(checkGameWon(parseInt(currentPiece/7), parseInt(currentPiece % 7))) {
            items.dynamic.enabled = false
            items.fallingPiece.opacity = 0
            if(currentPlayer === "1") {
                items.player1_score++
            } else {
                items.player2_score++
            }
            items.bonus.good("flower")
            items.bonus.isWin = false
        }

    } else {
        mutex = 1
        items.dynamic.enabled = true
        if(checkGameWon(parseInt(currentPiece/7), parseInt(currentPiece % 7))) {
            items.fallingPiece.opacity = 0
            items.dynamic.enabled = false
            if(currentPlayer === "1") {
                items.player1_score++
                items.bonus.good("flower")
                items.bonus.isWin = false
                counter--
            } else {
                items.player2_score++
                items.bonus.bad("flower")
            }
        }
        if(counter % 2) {
            doMove()
        }
    }
    if(counter === 42) {
        items.bonus.bad("flower")
    }
}
