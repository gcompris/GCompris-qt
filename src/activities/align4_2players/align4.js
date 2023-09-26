/* GCompris - align4.js
 *
 * SPDX-FileCopyrightText: 2014 Bharath M S
 *
 * Authors:
 *   Laurent Lacheny <laurent.lacheny@wanadoo.fr> (GTK+ version)
 *   Bharath M S <brat.197@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.12 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var numberOfLevel;
var items;
var url = "qrc:/gcompris/src/activities/align4_2players/resource/";
var currentPiece;
var currentPlayer;
var currentLocation;
var twoPlayer;
var weight = [[100, 50, 20, 100, 50, 20],
              [100, 50, 20, 100, 50, 20],
              [110, 55, 20, 100, 50, 20],
              [100, 50, 20, 110, 55, 20],
              [100, 50, 20, 110, 55, 20],
              [100, 50, 20, 110, 55, 20]];
var nextColumn;
var depthMax;
var randomMiss;

function start(items_, twoPlayer_) {
    items = items_;
    twoPlayer = twoPlayer_;
    numberOfLevel = twoPlayer ? 1 : weight.length;
    items.currentLevel = Core.getInitialLevel(numberOfLevel);
    initLevel();
}

function stop() {
    items.trigTuxMove.stop();
    items.drop.stop();
    items.pieces.clear();
}

function initLevel() {

    items.counter = items.nextPlayerStart+1;

    if(items.nextPlayerStart === 1) {
        items.player2score.endTurn();
        items.player1score.beginTurn();
    }
    else {
        items.player1score.endTurn();
        items.player2score.beginTurn();
        if(!twoPlayer) {
            items.trigTuxMove.start();
        }
    }

    items.gameDone = false;
    items.pieces.clear();
    for(var y = 0;  y < items.rows; y++) {
        for(var x = 0;  x < items.columns; x++) {
            items.pieces.append({'stateTemp': "invisible"});
        }
    }

    nextColumn = 3;
    if(items.currentLevel < 2)
        depthMax = 2;
    else
        depthMax = 4;

    if(items.currentLevel < 2)
        randomMiss = 1;
    else if(items.currentLevel < 4)
        randomMiss = 0.5;
    else
        randomMiss = 1;

    setPieceLocationByIndex(3);
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function reset() {
    // If the previous game is not won, we switch the starting player
    // Else, the next player is the one who lost (set in continueGame())
    if(!items.gameDone) {
        items.nextPlayerStart = (items.nextPlayerStart == 1) ? 2 : 1;
    }
    items.trigTuxMove.stop();
    items.drop.stop();    // stop animation
    items.pieces.clear(); // Clear the board
    initLevel();
}

function whichColumn(mouseX, mouseY) {
    for(var i = 0; i < items.columns - 1; i++) {
        if(mouseX < items.repeater.itemAt(i + 1).x) {
            return i;
        }
    }
    return items.columns - 1;
}

/* To move the piece before a column is chosen */
function setPieceLocation(mouseX, mouseY) {
    currentLocation = whichColumn(mouseX, mouseY);
    items.fallingPiece.y = items.repeater.itemAt(0).y - items.cellSize;
    items.fallingPiece.x = items.repeater.itemAt(currentLocation).x;
}

function setPieceLocationByIndex(index) {
    setPieceLocation(items.repeater.itemAt(index).x,
                     items.repeater.itemAt(0).y);
}

function moveCurrentIndexRight() {
    if(currentLocation++ > items.columns)
        currentLocation = 0;
    setPieceLocationByIndex(currentLocation);
}

function moveCurrentIndexLeft() {
    if(currentLocation-- <= 0)
        currentLocation = items.columns - 1;
    setPieceLocationByIndex(currentLocation);
}

function isModelEmpty(model) {
    var state = model.stateTemp;
    return (state === "1" || state === "2") ? false : true;
}

function getPieceAt(col, row) {
    return items.pieces.get(row * items.columns + col);
}

function getNextFreeStop(col) {
    for(var row = items.rows - 1; row >= 0; row--) {
        if(isModelEmpty(getPieceAt(col, row)))
            return row;
    }
    // Full column
    return -1;
}

function handleDrop(column) {
    var singleDropSize = items.cellSize;
    var nextFreeStop = getNextFreeStop(column);

    if(nextFreeStop >= 0) {
        items.drop.to = items.repeater.itemAt(nextFreeStop * items.columns).y;
        currentPiece = nextFreeStop * items.columns + column;
        items.drop.start();
    }
}

function setPieceState(col, row, state) {
    items.pieces.set(row * items.columns + col, {"stateTemp": state});
}

function getPieceState(col, row) {
    return items.pieces.get(row * items.columns + col).stateTemp;
}

function getBoardFromModel() {
    var board = [];
    var temp;

    for(var i = 0; i < items.rows; i++) {
        temp = [];
        for(var j = 0; j < items.columns; j++) {
            temp.push(getPieceState(j, i));
        }
        board.push(temp);
    }
    return board;
}

function getFreeStopFromBoard(column, board) {
    for(var row = items.rows-1; row > -1; row--) {
        if(board[row][column] === "invisible") {
            return row;
        }
    }
    return -1;
}


function alphabeta(depth, alpha, beta, player, board) {
    var value = evaluateBoard(player, player % 2 ? 2 : 1, board);

    if(depth === 0 || value === 100000 || value < -100000) {
        return value;
    }

    if(player === 2) {
        var scores = [];

        for(var c = 0; c < items.columns; c++) {
            var r = getFreeStopFromBoard(c, board);

            if(r === -1) continue;

            board[r][c] = "2";

            alpha = Math.max(alpha, alphabeta(depth - 1, alpha, beta, 1, board));

            board[r][c] = "invisible";
            scores[c] = alpha;

            if(beta <= alpha) break;
        }

        if(depth === depthMax) {
            var max = -10000;
            for(var i = 0; i < scores.length; i++) {
                if(scores[i] > max) {
                    max = scores[i];
                    nextColumn = i;
                }
            }
        }

        return alpha;
    } else {
        for(var c = 0; c < items.columns; c++) {

            var r = getFreeStopFromBoard(c, board);

            if(r === -1) continue;

            board[r][c] = "1";

            beta = Math.min(beta, alphabeta(depth - 1, alpha, beta, 2, board));

            board[r][c] = "invisible";

            if(beta <= alpha) break;
        }
        return beta;
    }
}

function doMove() {
    var board = getBoardFromModel();

    alphabeta(depthMax, -10000, 10000, 2, board);

    setPieceLocation(items.repeater.itemAt(nextColumn).x,
                     items.repeater.itemAt(0).y);

    handleDrop(nextColumn);
}

function checkLine() {
    var score = 0;
    var count1, count2;

    // Make the game easier, forget to analyse some line depending on the level
    if(Math.random() > randomMiss)
        return 0;

    // Performance improvement, do not enter the processing loop
    // if there is nothing to look at.
    var gotOne = false;
    for(var i = 2; i < (arguments.length - 1); i++) {
        if(arguments[i] !== "invisible") {
            gotOne = true;
            break;
        }
    }

    if(!gotOne)
        return 0;

    var player1 = arguments[0].toString();
    var player2 = arguments[1].toString();

    for(var i = 2; i < (arguments.length - 3); i++) {
        count1 = 0;
        count2 = 0;
        for(var j = 0; j < 4; j++) {
            if(arguments[i + j] === player1) {
                count1++;
            } else if( arguments[i + j] === player2) {
                count2++;
            }
        }

        if((count1 > 0) && (count2 === 0)) {
            if(count1 === 4) {
                return 10000;
            }
            score += ((count1 / 3) * weight[items.currentLevel][0] +
                      (count1 / 2) * weight[items.currentLevel][1] +
                      count1 * weight[items.currentLevel][2]);
        } else if((count1 === 0) && (count2 > 0)) {
            if(count2 === 4) {
                return -10000;
            }
            score -= ((count2 / 3) * weight[items.currentLevel][3] +
                      (count2 / 2) * weight[items.currentLevel][4] +
                      count2 * weight[items.currentLevel][5]);
        }
    }
    return score;
}

function evaluateBoard(player1, player2, board) {
    var score = 0;

    //Horizontal
    for(var i = 0; i < items.rows; i++) {
        score += checkLine(player1, player2, board[i][0],
                           board[i][1], board[i][2], board[i][3],
                           board[i][4], board[i][5], board[i][6]);
    }

    //Vertical
    for(var i = 0; i < items.columns; i++) {
        score += checkLine(player1, player2, board[0][i],
                           board[1][i], board[2][i],
                           board[3][i], board[4][i], board[5][i]);
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
                       board[2][1], board[1][2], board[0][3]);
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

    return score;
}

function checkGameWon(currentPieceRow, currentPieceColumn) {

    currentPlayer = getPieceState(currentPieceColumn, currentPieceRow);
    var crossed = "crossed" + currentPlayer;

    // Horizontal
    var sameColor = 0;
    for(var col = 0; col < items.columns; col++) {
        if(getPieceState(col, currentPieceRow) === currentPlayer) {
            if(++sameColor == 4) {
                setPieceState(col, currentPieceRow, crossed);
                setPieceState(col - 1, currentPieceRow, crossed);
                setPieceState(col - 2, currentPieceRow, crossed);
                setPieceState(col - 3, currentPieceRow, crossed);
                return true;
            }
        } else {
            sameColor = 0;
        }
    }

    // Vertical
    sameColor = 0;
    for(var row = 0; row < items.rows; row++) {
        if(getPieceState(currentPieceColumn, row) === currentPlayer) {
            if(++sameColor == 4) {
                setPieceState(currentPieceColumn, row, crossed);
                setPieceState(currentPieceColumn, row - 1, crossed);
                setPieceState(currentPieceColumn, row - 2, crossed);
                setPieceState(currentPieceColumn, row - 3, crossed);
                return true;
            }
        } else {
            sameColor = 0;
        }
    }

    // Diagonal top left / bottom right
    sameColor = 0;
    var row = 0;
    for(var col = currentPieceColumn - currentPieceRow;
        col < items.columns; col++) {
        row++;
        if(col < 0)
            continue;

        if(row > items.rows)
            break;

        if(getPieceState(col, row-1) === currentPlayer) {
            if(++sameColor == 4) {
                setPieceState(col, row - 1, crossed);
                setPieceState(col - 1, row - 2, crossed);
                setPieceState(col - 2, row - 3, crossed);
                setPieceState(col - 3, row - 4, crossed);
                return true;
            }
        } else {
            sameColor = 0;
        }
    }

    // Diagonal top right / bottom left
    sameColor = 0;
    var row = 0;
    for(var col = currentPieceColumn + currentPieceRow;
        col >= 0; col--) {
        row++;
        if(col >= items.columns)
            continue;

        if(row > items.rows)
            break;

        if(getPieceState(col, row-1) === currentPlayer) {
            if(++sameColor == 4) {
                setPieceState(col, row - 1, crossed);
                setPieceState(col + 1, row - 2, crossed);
                setPieceState(col + 2, row - 3, crossed);
                setPieceState(col + 3, row - 4, crossed);
                return true;
            }
        } else {
            sameColor = 0;
        }
    }
}

function continueGame() {
    items.pieces.set(currentPiece, {"stateTemp": items.counter++ % 2 ? "2": "1"});

    /* Update score if game won */
    if(twoPlayer) {
        if(checkGameWon(parseInt(currentPiece / items.columns),
                        parseInt(currentPiece % items.columns))) {
            items.gameDone = true;
            if(currentPlayer === "1") {
                items.player1score.win();
                items.player2score.endTurn();
                items.nextPlayerStart = 2;
            } else {
                items.player2score.win();
                items.player1score.endTurn();
                items.nextPlayerStart = 1;
            }
            items.bonus.good("flower");
        }
        else {
            if(currentPlayer === "2") {
                items.player1score.beginTurn();
                items.player2score.endTurn();
            } else {
                items.player2score.beginTurn();
                items.player1score.endTurn();
            }
        }
    } else {
        if(checkGameWon(parseInt(currentPiece / items.columns),
                        parseInt(currentPiece % items.columns))) {
            items.gameDone = true;
            if(currentPlayer === "1") {
                items.player1score.win();
                items.player2score.endTurn();
                items.bonus.good("flower");
                items.counter--;
                items.nextPlayerStart = 2;
            } else {
                items.player2score.win();
                items.player1score.endTurn();
                items.bonus.bad("flower");
                items.nextPlayerStart = 1;
            }
        }
        if(items.counter % 2) {
            items.player1score.endTurn();
            items.player2score.beginTurn();
            items.trigTuxMove.start();
        }
    }
    if(items.counter === 42) {
        items.player1score.endTurn();
        items.player2score.endTurn();
        items.bonus.bad("flower");
        items.nextPlayerStart = (items.nextPlayerStart == 1) ? 2 : 1;
    }
}
