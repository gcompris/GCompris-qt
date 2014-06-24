/* GCompris - align4-2players.js
 *
 * Copyright (C) 2014 <YOUR NAME HERE>
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
var rowStatus = [0, 0, 0, 0, 0, 0]
var columnStatus = [0, 0, 0, 0, 0, 0, 0]
var column
var row
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

var flag = 0

function initLevel() {

    items.bar.level = currentLevel + 1
    rowStatus = [0, 0, 0, 0, 0, 0]
    columnStatus = [0, 0, 0, 0, 0, 0, 0]

    var initialY = items.background.height * 0.12
    var initialX = items.background.width * 0.188
    var dx = items.background.width * 0.0875
    var dy = items.background.height * 0.1358
    var i = 0
    var data
    var tiles
    var tempX
    var tempY

    board = [[0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0],
             [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0]]
    counter = 0

    if(!flag) {
        for(var y = 0;  y < numberOfRows; y++) {
            for(var x = 0;  x < numberOfColumns; x++) {
                data = {'stateTemp': "invisible"}
                items.pieces.append(data)
            }
            flag = 1
        }
    } else {
        for(var y = 0;  y < numberOfRows; y++) {
            for(var x = 0;  x < numberOfColumns; x++) {
                data = {'stateTemp': "invisible"}
                items.pieces.set(i++, data)
            }
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
function setPieceLocation(x, y){
    column = whichColumn(x, y)
    items.piece1.y = - items.background.height * 0.019
    switch(column) {
    case 0:
        items.piece1.x = items.background.width * 0.1865
        break;
    case 1:
        items.piece1.x = items.background.width * 0.274
        break;
    case 2:
        items.piece1.x = items.background.width * 0.3615
        break;
    case 3:
        items.piece1.x = items.background.width * 0.449
        break;
    case 4:
        items.piece1.x = items.background.width * 0.5365
        break;
    case 5:
        items.piece1.x = items.background.width * 0.624
        break;
    case 6:
        items.piece1.x = items.background.width * 0.7115
        break;
    }
    items.piece1.state = counter % 2 ? "red": "green"
}

function handleDrop(x, y) {

    var singleDropSize = items.background.height * 0.1358
    column = whichColumn(x, y)
    columnStatus[column]++;
    var destination = items.piece1.y + singleDropSize * (7 - columnStatus[column])
    if(destination == items.piece1.y) {
        items.dynamic.hoverEnabled = "true"
        columnStatus[column]--;
        return;
    }

    items.drop.to = destination
    items.drop.duration = 1500 * ((7 - columnStatus[column]) / 6)
    currentPiece = (6 - columnStatus[column]) * 7 + column
    board[(6 - columnStatus[column])][column] = counter % 2 ? 1: 2
    items.drop.start()
}

var currentPieceValue

function checkGameWon(currentPieceRow, currentPieceColumn) {

    currentPieceValue = board[currentPieceRow][currentPieceColumn]

    // Horizontal
    var sameColor = 0
    for(var col = 0; col < numberOfColumns; col++) {
        if(board[currentPieceRow][col] === currentPieceValue) {
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
        if(board[row][currentPieceColumn] === currentPieceValue) {
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

        if(board[row-1][col] === currentPieceValue) {
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

        if(board[row-1][col] === currentPieceValue) {
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

    items.pieces.set(currentPiece, {"stateTemp": counter++ % 2? "red": "green"})

    items.piece1.state = "invisible"
    items.dynamic.hoverEnabled = "true"

    setPieceLocation(items.piece1.x, items.piece1.y)
    /* Update score if game won */
    if(checkGameWon(parseInt(currentPiece/7), parseInt(currentPiece % 7))) {
        if(currentPieceValue === 2) {
            score1++
            items.player1_score.text = score1.toString()
        } else if (currentPieceValue === 1){
            score2++
            items.player2_score.text = score2.toString()
        }
        items.bonus.good("flower")
    }

    if(counter == 42) {
        items.bonus.bad("flower")
    }
}
