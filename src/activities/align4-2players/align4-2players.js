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
    console.log("start")
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {
    console.log("stop")
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
    console.log(x, y)
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
    currentPiece = (6 - columnStatus[column]) * 7 + column
    board[(6 - columnStatus[column])][column] = counter % 2 ? 1: 2
    console.log(board)
    items.drop.start()
}

var currentPieceValue

function checkGameWon(currentPieceRow, currentPieceColumn){

    var gameWon = true;
    var tempCurrentPieceColumn;
    var edgePieceColumn, edgePieceRow;
    var i;
    currentPieceValue = board[currentPieceRow][currentPieceColumn];

    var possibleWinRightWards = false, possibleWinLeftWards = false,
            possibleWinUpWards = false, possibleWinDownWards = false,
            possibleWinTopRightDiagonal = false, possibleWinBottomRightDiagonal = false,
            possibleWinTopLeftDiagonal = false, possibleWinBottomLeftDiagonal = false;

    console.log("  ROW: " + currentPieceRow + "  COL: " + currentPieceColumn)

    if(currentPieceRow <=2){

        switch(currentPieceColumn){
        case 0:
        case 1:
        case 2:
            possibleWinRightWards = true;
            possibleWinDownWards = true;
            possibleWinBottomRightDiagonal = true;
            possibleWinBottomLeftDiagonal = true;
            break;
        case 3:
            possibleWinRightWards = true;
            possibleWinDownWards = true;
            possibleWinLeftWards = true;
            possibleWinBottomLeftDiagonal = true;
            possibleWinBottomRightDiagonal = true;
            break;
        case 4:
        case 5:
        case 6:
            possibleWinDownWards = true;
            possibleWinLeftWards = true;
            possibleWinBottomRightDiagonal = true;
            possibleWinBottomLeftDiagonal = true;
        }
    }
    else if(currentPieceRow >= 3){

        switch(currentPieceColumn){
        case 0:
        case 1:
        case 2:
            possibleWinRightWards = true;
            possibleWinUpWards = true;
            possibleWinTopRightDiagonal = true;
            possibleWinTopLeftDiagonal = true
            break;
        case 3:
            possibleWinRightWards = true;
            possibleWinUpWards = true;
            possibleWinLeftWards = true;
            possibleWinTopLeftDiagonal = true;
            possibleWinTopRightDiagonal = true;
            break;
        case 4:
        case 5:
        case 6:
            possibleWinUpWards = true;
            possibleWinLeftWards = true;
            possibleWinTopLeftDiagonal = true;
            possibleWinTopRightDiagonal = true;
        }
    }

    if(possibleWinLeftWards){
        gameWon = true;

        //Check rightwards to determine the edge piece.
        //Only check till column 0 - 5 because if column number is 6, that
        //is automatically the edge piece.
        for(i=currentPieceColumn; i< 6; i++){
            if(board[currentPieceRow][i+1] != currentPieceValue){
                break;
            }
        }

        edgePieceColumn = i;
        edgePieceRow = currentPieceRow;

        console.log("L " + edgePieceRow + "  " + edgePieceColumn)

        //Check leftwards to determine if game won
        for(i=edgePieceColumn; i> edgePieceColumn - 4; i--){
            if(board[edgePieceRow][i] != currentPieceValue){
                gameWon = false;
                break;
            }
        }

        if(gameWon){
            console.log("Left");
            items.pieces.set(edgePieceRow * 7 + edgePieceColumn, {"stateTemp":"crossed"})
            items.pieces.set(edgePieceRow * 7 + edgePieceColumn - 1, {"stateTemp":"crossed"})
            items.pieces.set(edgePieceRow * 7 + edgePieceColumn - 2, {"stateTemp":"crossed"})
            items.pieces.set(edgePieceRow * 7 + edgePieceColumn - 3, {"stateTemp":"crossed"})
            return gameWon
        }
    }

    if(possibleWinRightWards){
        gameWon = true;

        //Check leftwards to determine the edge piece.
        //Only check till column 1 because if column number is 0, that
        //is automatically the edge piece.
        for(i=currentPieceColumn; i > 0; i--){
            if(board[currentPieceRow][i-1] != currentPieceValue){
                break;
            }
        }

        edgePieceColumn = i;
        edgePieceRow = currentPieceRow;

        console.log(" R " + edgePieceRow + "  " + edgePieceColumn)

        //Check to see if game is won.
        for(i=edgePieceColumn; i< edgePieceColumn + 4; i++){
            if(board[edgePieceRow][i] != currentPieceValue){
                gameWon = false;
                break;
            }
        }



        if(gameWon){
            console.log("Right");
            items.pieces.set(edgePieceRow * 7 + edgePieceColumn, {"stateTemp":"crossed"})
            items.pieces.set(edgePieceRow * 7 + edgePieceColumn + 1, {"stateTemp":"crossed"})
            items.pieces.set(edgePieceRow * 7 + edgePieceColumn + 2, {"stateTemp":"crossed"})
            items.pieces.set(edgePieceRow * 7 + edgePieceColumn + 3, {"stateTemp":"crossed"})
            return gameWon
        }
    }

    if(possibleWinUpWards){
        gameWon = true;

        //Check downwards to determine the edge piece.
        //Only check till row 4 because if row number is 5, that
        //is automatically the edge piece.
        for(i=currentPieceRow; i < 5; i++){
            if(board[i + 1][currentPieceColumn] != currentPieceValue){
                break;
            }
        }

        edgePieceRow = i;
        edgePieceColumn = currentPieceColumn;

        console.log(" U " + edgePieceRow + "  " + edgePieceColumn)

        //Check upwards for win
        for(i=edgePieceRow; i> edgePieceRow - 4; i--){
            if(board[i][edgePieceColumn] != currentPieceValue){
                gameWon = false;
                break;
            }
        }

        if(gameWon){
            console.log("Up");
            items.pieces.set(edgePieceRow * 7 + edgePieceColumn, {"stateTemp":"crossed"})
            items.pieces.set(edgePieceRow * 7 + edgePieceColumn - 7, {"stateTemp":"crossed"})
            items.pieces.set(edgePieceRow * 7 + edgePieceColumn - 14, {"stateTemp":"crossed"})
            items.pieces.set(edgePieceRow * 7 + edgePieceColumn - 21, {"stateTemp":"crossed"})
            return gameWon
        }
    }


    if(possibleWinDownWards){
        gameWon = true;

        //Check upwards to determine the edge piece.
        //Only check till row 1 because if row number is 0, that
        //is automatically the edge piece.
        for(i=currentPieceRow; i > 0; i--){
            if(board[i - 1][currentPieceColumn] != currentPieceValue){
                break;
            }
        }

        edgePieceRow = i;
        edgePieceColumn = currentPieceColumn;

        console.log(" D " + edgePieceRow + "  " + edgePieceColumn)

        //Check downwards for win.
        for(i=edgePieceRow; i < edgePieceRow + 4; i++){
            if(board[i][edgePieceColumn] != currentPieceValue){
                gameWon = false;
                break;
            }
        }

        if(gameWon){
            console.log("Down");
            items.pieces.set(edgePieceRow * 7 + edgePieceColumn, {"stateTemp":"crossed"})
            items.pieces.set(edgePieceRow * 7 + edgePieceColumn + 7, {"stateTemp":"crossed"})
            items.pieces.set(edgePieceRow * 7 + edgePieceColumn + 14, {"stateTemp":"crossed"})
            items.pieces.set(edgePieceRow * 7 + edgePieceColumn + 21, {"stateTemp":"crossed"})
            return gameWon
        }
    }

    if(possibleWinBottomRightDiagonal){
        gameWon = true;
        tempCurrentPieceColumn = currentPieceColumn;

        //Check top left diagonal to determine the edge piece.
        //Only check till row 1 because if row number is 0, that
        //is automatically the edge piece.
        for(i=currentPieceRow; i> 0;i--){
            if(board[i - 1][tempCurrentPieceColumn - 1] != currentPieceValue){
                break;
            }
            tempCurrentPieceColumn--;
        }

        edgePieceRow = i;
        edgePieceColumn = tempCurrentPieceColumn;

        console.log(" BRD " +edgePieceRow + "  " + edgePieceColumn, currentPieceValue)

        //Check bottom right diagonal for a win.
        for(i=edgePieceRow ; i<edgePieceRow + 4;i++){
            if(board[i][edgePieceColumn] != currentPieceValue){
                gameWon = false;
                break;
            }
            edgePieceColumn++;
        }

        if(gameWon){
            console.log("Bottom right diagonal", edgePieceRow * 7 + edgePieceColumn);
            items.pieces.set(edgePieceRow * 7 + tempCurrentPieceColumn, {"stateTemp":"crossed"})
            items.pieces.set(edgePieceRow * 7 + tempCurrentPieceColumn + 7 + 1, {"stateTemp":"crossed"})
            items.pieces.set(edgePieceRow * 7 + tempCurrentPieceColumn + 14 + 2, {"stateTemp":"crossed"})
            items.pieces.set(edgePieceRow * 7 + tempCurrentPieceColumn + 21 + 3, {"stateTemp":"crossed"})
            return gameWon
        }
    }


    if(possibleWinBottomLeftDiagonal){
        gameWon = true;
        tempCurrentPieceColumn = currentPieceColumn;

        //Check top right diagonal to determine the edge piece.
        //Only check till row 1 because if row number is 0, that
        //is automatically the edge piece.
        for(i=currentPieceRow; i> 0;i--){
            if(board[i - 1][tempCurrentPieceColumn + 1] != currentPieceValue){
                break;
            }
            tempCurrentPieceColumn++;
        }

        edgePieceRow = i;
        edgePieceColumn = tempCurrentPieceColumn;

        console.log(" BLD " +edgePieceRow + "  " + edgePieceColumn)

        //Check bottom left diagonal for a win
        for(i=edgePieceRow; i< edgePieceRow + 4;i++){
            if(board[i][edgePieceColumn] != currentPieceValue){
                gameWon = false;
                break;
            }
            edgePieceColumn--;
        }

        if(gameWon){
            console.log("Bottom left diagonal");
            items.pieces.set(edgePieceRow * 7 + tempCurrentPieceColumn, {"stateTemp":"crossed"})
            items.pieces.set(edgePieceRow * 7 + tempCurrentPieceColumn + 7 - 1, {"stateTemp":"crossed"})
            items.pieces.set(edgePieceRow * 7 + tempCurrentPieceColumn + 14 - 2, {"stateTemp":"crossed"})
            items.pieces.set(edgePieceRow * 7 + tempCurrentPieceColumn + 21 - 3, {"stateTemp":"crossed"})
            return gameWon
        }
    }

    if(possibleWinTopLeftDiagonal){
        gameWon = true;
        tempCurrentPieceColumn = currentPieceColumn;

        //Check bottom right diagonal to determine the edge piece.
        //Only check till row 4 because if row number is 5, that
        //is automatically the edge piece.
        for(i=currentPieceRow; i<5;i++){
            if(board[i + 1][edgePieceColumn + 1] != currentPieceValue){
                break;
            }
            tempCurrentPieceColumn++;
        }

        edgePieceRow = i;
        edgePieceColumn = tempCurrentPieceColumn;

        console.log(" TLD " +edgePieceRow + "  " + edgePieceColumn)

        //Check top left diagonal for win.
        for(i=edgePieceRow; i>edgePieceRow - 4;i--){
            if(board[i][edgePieceColumn] != currentPieceValue){
                gameWon = false;
                break;
            }
            edgePieceColumn--;
        }

        if(gameWon){
            console.log("Top left diagonal");
            items.pieces.set(edgePieceRow * 7 + tempCurrentPieceColumn, {"stateTemp":"crossed"})
            items.pieces.set(edgePieceRow * 7 + tempCurrentPieceColumn - 7 - 1, {"stateTemp":"crossed"})
            items.pieces.set(edgePieceRow * 7 + tempCurrentPieceColumn - 14 - 2, {"stateTemp":"crossed"})
            items.pieces.set(edgePieceRow * 7 + tempCurrentPieceColumn - 21 - 3, {"stateTemp":"crossed"})
            return gameWon
        }
    }

    if(possibleWinTopRightDiagonal){
        gameWon = true;
        tempCurrentPieceColumn = currentPieceColumn;

        //Check bottom left diagonal to determine the edge piece.
        //Only check till row 4 because if row number is 5, that
        //is automatically the edge piece.
        for(i=currentPieceRow; i< 5;i++){
            if(board[i + 1][tempCurrentPieceColumn - 1] != currentPieceValue){
                break;
            }
            tempCurrentPieceColumn--;
        }

        edgePieceRow = i;
        edgePieceColumn = tempCurrentPieceColumn;

        console.log(" TRD " + edgePieceRow + "  " + edgePieceColumn)

        //Check top right diagonal for win
        for(i=edgePieceRow; i>edgePieceRow - 4;i--){
            if(board[i][edgePieceColumn] != currentPieceValue){
                gameWon = false;
                break;
            }
            edgePieceColumn++;
        }

        if(gameWon){
            console.log("Top right diagonal");
            items.pieces.set(edgePieceRow * 7 + tempCurrentPieceColumn, {"stateTemp":"crossed"})
            items.pieces.set(edgePieceRow * 7 + tempCurrentPieceColumn - 7 + 1, {"stateTemp":"crossed"})
            items.pieces.set(edgePieceRow * 7 + tempCurrentPieceColumn - 14 + 2, {"stateTemp":"crossed"})
            items.pieces.set(edgePieceRow * 7 + tempCurrentPieceColumn - 21 + 3, {"stateTemp":"crossed"})
            return gameWon
        }
    }

    return false;
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
