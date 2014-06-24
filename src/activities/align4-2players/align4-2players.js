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
var columnStatus = [0, 0, 0, 0, 0, 0, 0]
var currentPiece
var counter = 0
var board
var score1 = 0, score2 = 0

function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {
}

function initLevel() {

    items.bar.level = currentLevel + 1
    columnStatus = [0, 0, 0, 0, 0, 0, 0]


    board = [[0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0],
             [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0]]
    counter = 0

    items.pieces.clear()
    for(var y = 0;  y < numberOfRows; y++) {
        for(var x = 0;  x < numberOfColumns; x++) {
            var data = {'stateTemp': "invisible"}
            items.pieces.append(data)
        }
    }
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

function whichColumn(x,y) {
    if(x > items.background.width * 0.1865 && x < items.background.width * 0.274){//column 1
        return 0
    } else if(x > items.background.width * 0.274 && x < items.background.width * 0.3615){//column 2
        return 1
    } else if(x > items.background.width * 0.3615 && x < items.background.width * 0.449){//column 3
        return 2
    } else if(x > items.background.width * 0.449 && x < items.background.width * 0.5365){//column 4
        return 3
    } else if(x > items.background.width * 0.5365 && x < items.background.width * 0.624){//column 5
        return 4
    } else if(x > items.background.width * 0.624 && x < items.background.width * 0.7115){//column 6
        return 5
    } else if(x > items.background.width * 0.7115 && x < items.background.width * 0.799){//column 7
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
    items.fallingPiece.state = counter % 2 ? "red": "green"
}

function handleDrop(x, y) {

    var singleDropSize = items.background.height * 0.1358
    var column = whichColumn(x, y)
    columnStatus[column]++;
    var destination = items.fallingPiece.y + singleDropSize * (7 - columnStatus[column])
    if(destination == items.fallingPiece.y) {
        columnStatus[column]--;
        return;
    }

    items.drop.to = destination
    items.drop.duration = 1500 * ((7 - columnStatus[column]) / 6)
    currentPiece = (6 - columnStatus[column]) * 7 + column
    board[(6 - columnStatus[column])][column] = counter % 2 ? 1: 2
    items.drop.start()
}

var currentPlayer

function checkGameWon(currentPieceRow, currentPieceColumn) {

    currentPlayer = board[currentPieceRow][currentPieceColumn]

    // Horizontal
    var sameColor = 0
    for(var col = 0; col < numberOfColumns; col++) {
        if(board[currentPieceRow][col] === currentPlayer) {
            if(++sameColor == 4) {
                items.pieces.set(currentPieceRow * 7 + col, {"stateTemp":"crossed"})
                items.pieces.set(currentPieceRow * 7 + col - 1, {"stateTemp":"crossed"})
                items.pieces.set(currentPieceRow * 7 + col - 2, {"stateTemp":"crossed"})
                items.pieces.set(currentPieceRow * 7 + col - 3, {"stateTemp":"crossed"})
                return true
            }
        } else {
            sameColor = 0
        }
    }

    // Vertical
    sameColor = 0
    for(var row = 0; row < numberOfRows; row++) {
        if(board[row][currentPieceColumn] === currentPlayer) {
            if(++sameColor == 4) {
                items.pieces.set(row * 7 + currentPieceColumn, {"stateTemp":"crossed"})
                items.pieces.set((row - 1) * 7 + currentPieceColumn, {"stateTemp":"crossed"})
                items.pieces.set((row - 2) * 7 + currentPieceColumn, {"stateTemp":"crossed"})
                items.pieces.set((row - 3) * 7 + currentPieceColumn, {"stateTemp":"crossed"})
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

        if(board[row-1][col] === currentPlayer) {
            if(++sameColor == 4) {
                items.pieces.set((row - 1)  * 7 + col, {"stateTemp":"crossed"})
                items.pieces.set((row - 2) * 7 + col - 1, {"stateTemp":"crossed"})
                items.pieces.set((row - 3) * 7 + col - 2, {"stateTemp":"crossed"})
                items.pieces.set((row - 4) * 7 + col - 3, {"stateTemp":"crossed"})
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

        if(board[row-1][col] === currentPlayer) {
            if(++sameColor == 4) {
                items.pieces.set((row - 1)  * 7 + col, {"stateTemp":"crossed"})
                items.pieces.set((row - 2) * 7 + col + 1, {"stateTemp":"crossed"})
                items.pieces.set((row - 3) * 7 + col + 2, {"stateTemp":"crossed"})
                items.pieces.set((row - 4) * 7 + col + 3, {"stateTemp":"crossed"})
                return true
            }
        } else {
            sameColor = 0
        }
    }
}

function continueGame() {

    items.pieces.set(currentPiece, {"stateTemp": counter++ % 2 ? "red": "green"})

    setPieceLocation(items.fallingPiece.x, items.fallingPiece.y)

    /* Update score if game won */
    if(checkGameWon(parseInt(currentPiece/7), parseInt(currentPiece % 7))) {
        if(currentPlayer === 2) {
            score1++
            items.player1_score.text = score1.toString()
        } else if (currentPlayer === 1){
            score2++
            items.player2_score.text = score2.toString()
        }
        items.bonus.good("flower")
    }

    if(counter == 42) {
        items.bonus.bad("flower")
    }
}
