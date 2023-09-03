/* GCompris - TicTacToe.js
 *
 * SPDX-FileCopyrightText: 2014 Pulkit Gupta <pulkitgenius@gmail.com>
 *
 * Authors:
 *   Pulkit Gupta <pulkitgenius@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.12 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var numberOfLevel = 5
var items

var url = "qrc:/gcompris/src/activities/tic_tac_toe/resource/"

var currentPiece
var currentPlayer
var currentLocation
var twoPlayer
var track = []      //For tracking moves
var hx      //x co-ordinate needed for creating first image when playSecond is enabled
var vy      //y co-ordinate needed for creating first image when playSecond is enabled
var stopper     //For stopping game when doing reset

function start(items_, twoPlayer_) {
    items = items_
    items.currentLevel = Core.getInitialLevel(numberOfLevel);
    currentPlayer = 1
    twoPlayer = twoPlayer_
    items.playSecond = 0

    initLevel()
}

function stop() {
}

function initLevel() {
    items.counter = 0
    items.gameDone = false
    items.pieces.clear()
    track = []
    for(var y = 0;  y < items.rows; y++) {
        for(var x = 0;  x < items.columns; x++) {
            items.pieces.append({'stateTemp': "invisible"})
        }
    }
    if (items.playSecond) 
        initiatePlayer2()
    else 
        initiatePlayer1()
    stopper = false
    if (items.playSecond)
        changePlayToSecond()
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    reset();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    reset();
}

function reset() {
    stopper = true
    hx = items.repeater.itemAt(1).x     
    vy = items.repeater.itemAt(3).y
    stopAnimations()
    items.pieces.clear() // Clear the board
    if (items.playSecond)
        items.playSecond = 0
    else
        items.playSecond = 1
    initLevel()
}

function stopAnimations() {
    items.magnify.stop();
    items.player1score.endTurn();
    items.player2score.endTurn();
}

//Initial values at the start of game when its player 1 turn
function initiatePlayer1() {
    items.player2score.endTurn();
    items.player1score.beginTurn();
}

//Initial values at the start of game when its player 2 turn
function initiatePlayer2() {
    items.player1score.endTurn();
    items.player2score.beginTurn();
}

//Change scale of score boxes according to turns
function changeScale() {
    if (items.playSecond) {
        if (items.counter%2 == 0) {
            initiatePlayer2()
            shouldComputerPlay()
        }
        else
            initiatePlayer1()
    }
    else {
        if (items.counter%2 == 0) {
            initiatePlayer1()
        }
        else {
            initiatePlayer2()
            shouldComputerPlay()
        }
    }
}

//Changing play to second in single player mode
function changePlayToSecond() {
    if (items.playSecond == 0) {
        items.playSecond = 1
        reset()
        return 0
    }
    if (!twoPlayer) {
        var rand = Math.floor((Math.random() * 9))
        var y = parseInt(rand/3) * vy
        var x = parseInt(rand%3) * hx
        items.repeater.itemAt(rand).state = "DONE"
        currentPiece = rand
        items.createPiece.x = x
        items.createPiece.y = y
        items.demagnify.start()
        items.createPiece.opacity = 1
        items.magnify.start()
    }
}

//Changing play to second in single player mode
function changePlayToFirst() {
    items.playSecond = 0
    reset()
}

//Get row of the corresponding square box (square boxes are defined in repeater)
function getrowno(parentY) {
    for(var i = 0; i < items.rows - 1; i++) {
        if(parentY == items.repeater.itemAt(i*3).y) {
            return i
        }
    }
    return items.rows - 1
}

//Get column of the corresponding square box (square boxes are defined in repeater)
function getcolno(parentX) {
    for(var i = 0; i < items.columns - 1; i++) {
        if(parentX == items.repeater.itemAt(i).x) {
            return i
        }
    }
    return items.columns - 1
}

//Create the piece (cross or circle) at given position
function handleCreate(parent) {
    parent.state = "DONE"
    var rowno = getrowno(parent.y)
    var colno = getcolno(parent.x)
    currentPiece = (rowno * items.columns) + colno
    items.createPiece.x=parent.x
    items.createPiece.y=parent.y
    items.demagnify.start()
    items.createPiece.opacity = 1
    items.magnify.start()
}

//Return the state of piece (1 or 2), 1 and 2 corresponds to Player 1 and Player 2 respectively
function getPieceState(col, row) {
    return items.pieces.get(row * items.columns + col).stateTemp
}

/* setMove() decides the move which is to be played by computer. It decides according to the current level of player:
 * At level 1 -> No if statements are parsed, and in the end, a random empty location is returned
 * At level 2 -> Only first 'if' statement is parsed, evaluateBoard(computerState) is called which checks if computer can 
 *               win in this turn, if there is an empty location in which computer can get three consecutive marks, then
 *               computer will play there, else computer will play on a random empty location. At level 2, computer will 
 *               not check if player can win in next turn or not, this increases the winning chance of player at level 2.
 * At level 3 -> First two 'if' statements are parsed, hence computer will first check if it can win in this turn by executing
 *               evaluateBoard(computerState). If not, then it will execute evaluateBoard(playerState) which will check if
 *               player can win in next turn or not, if player can win, then computer will play at that location to stop
 *               the player from winning. Else computer will play randomly. Therefore player can not win, unless he uses
 *               a double trick (Having two positions from where you can win).
 * At level 4 -> Same as level 3
 * At level 5 -> Along with evaluateBoard(computerState) and evaluateBoard(playerState), applyLogic(playerState) is called 
 *               which counters all the possibilities of double trick. Hence at level 5, player can not win, it will either
 *               be a draw or the player will lose.
 * setMove() returns the position where computer has to play its turn
*/
function setMove() {
    //Assigning States -> Which state "1" or "2" is used for identifying player and computer  
    var playerState = items.playSecond ? "2" : "1"
    var computerState = items.playSecond ? "1" : "2"

    if (items.currentLevel > 0) {
        var value = evaluateBoard(computerState)
        if (value != -1) {
            return value
        }
    }

    if (items.currentLevel > 1) {
        var value = evaluateBoard(playerState)
        if (value != -1) {
            return value
        }
    }

    if (items.currentLevel > 4) {
        var value = applyLogic(playerState)
        if (value != -1) {
            return value
        }
    }

    var found = false
    while (!found) {
        var randno = Math.floor((Math.random() * 9));
        if (items.pieces.get(randno).stateTemp == "invisible")
            found = true
    }
    return randno
}

//Returns the position after analyzing such that no double trick is possible
function applyLogic(player) {
    if (items.pieces.get(4).stateTemp == "invisible")
        return 4
    if (!items.playSecond) {    
        if (items.counter == 1 && track[0] == 4) {
            var temp = [0,2,6,8]
            var randno = Math.floor((Math.random() * 4));
            return temp[randno]
        }
        if (items.counter == 3 && track[0] == 4) {
            var temp = [0,2,6,8]
            var found = false
            while (!found) {
                var randno = Math.floor((Math.random() * 4));
                if (items.pieces.get(temp[randno]).stateTemp == "invisible")
                    found = true
            }
            return temp[randno]
        }
        var value = giveNearest()
        if (value != -1)
            return value
        return -1
    }
    else {
        if (items.counter == 2 && track[1] == 4) {
            var temp = [0,2,6,8]
            var found = false
            while (!found) {
                var randno = Math.floor((Math.random() * 4));
                if (items.pieces.get(temp[randno]).stateTemp == "invisible")
                    found = true
            }
        }
        else {
            var value = giveNearest()
            if (value != -1)
                return value
            return -1
        }
    }
}

/* One of the function used by applyLogic, giveNearest() returns the immediate empty position (up, down, left or right) to the 
 * position at which player played his turn. The logic is, that in most cases if computer plays just immediate to where the 
 * player has played, then player wont be able to get three consecutive marks. 
 * Returns -1 if no immediate empty position is found
*/
function giveNearest() {
    var currentRow = parseInt(currentPiece / items.columns)
    var currentCol = parseInt(currentPiece % items.columns)
    var temp = []

    if (currentRow + 1 < 3) {
        if(getPieceState(currentCol, currentRow + 1) == "invisible")
            temp.push((currentRow + 1) * items.columns + currentCol)
    }
    if (currentRow - 1 > 0) {
        if(getPieceState(currentCol, currentRow - 1) == "invisible")
            temp.push((currentRow - 1) * items.columns + currentCol)
    }
    if (currentCol + 1 < 3) {
        if(getPieceState(currentCol + 1, currentRow) == "invisible")
            temp.push(currentRow * items.columns + currentCol + 1)
    }
    if (currentCol - 1 > 0) {
        if(getPieceState(currentCol - 1, currentRow) == "invisible")
            temp.push(currentRow * items.columns + currentCol - 1)
    }
    if (temp.length != 0) {
        var randno = Math.floor((Math.random() * temp.length));
        return temp[randno]
    }

    return -1
}

//Starts the process of computer turn
function doMove() {
    var pos = setMove()
    handleCreate(items.repeater.itemAt(pos))
}

/* evaluateBoard(player) checks if the player has marked two consecutive places and if third place is empty or not, if found
 * such a place, then return that place, else return -1
*/
function evaluateBoard(player) {
    var countp, counti, invisibleX, invisibleY
    //Horizontal
    for(var i = 0; i < 3; i++) {
        countp=0
        counti=0
        for(var j=0; j<3; j++) {
            if(getPieceState(j,i) == player)
                countp++
            else if(getPieceState(j,i) == "invisible") {
                counti++
                invisibleX=i
                invisibleY=j
            }
        }
        if(countp==2 && counti==1) {
            return (invisibleX * items.columns + invisibleY)
        }
    }
    //Vertical
    for(var i = 0; i < 3; i++) {
        countp=0
        counti=0
        for(var j=0; j<3; j++) {
            if(getPieceState(i,j) == player)
                countp++
            else if(getPieceState(i,j) == "invisible") {
                counti++
                invisibleX=j
                invisibleY=i
            }
        }
        if(countp==2 && counti==1) {
            return (invisibleX * items.columns + invisibleY)
        }
    }

    // Diagonal top left / bottom right
    countp=0
    counti=0
    for(var i=0; i<3; i++) {
        if(getPieceState(i,i) == player)
            countp++
        else if(getPieceState(i,i) == "invisible") {
            counti++
            invisibleX=i
            invisibleY=i
        }
    }
    if(countp==2 && counti==1) {
        return (invisibleX * items.columns + invisibleY)
    }

    // Diagonal top right / bottom left
    countp=0
    counti=0
    var j=2
    for(var i=0; i<3; i++) {
        if(getPieceState(j,i) == player)
            countp++
        else if(getPieceState(j,i) == "invisible") {
            counti++
            invisibleX=i
            invisibleY=j
        }
        j--
    }
    if(countp==2 && counti==1) {
        return (invisibleX * items.columns + invisibleY)
    }
    return -1
}

//Checks the condition if game is won or not
function checkGameWon(currentPieceRow, currentPieceColumn) {
    currentPlayer = getPieceState(currentPieceColumn, currentPieceRow)

    // Horizontal
    var sameColor = 0
    for(var col = 0; col < items.columns; col++) {
        if(getPieceState(col, currentPieceRow) === currentPlayer) {
            if(++sameColor == 3) {
                items.repeater.itemAt(currentPieceRow * items.columns + col).visible = true
                items.repeater.itemAt(currentPieceRow * items.columns + col - 1).visible = true
                items.repeater.itemAt(currentPieceRow * items.columns + col - 2).visible = true
                items.repeater.itemAt(currentPieceRow * items.columns + col).border.color = "#62db53"
                items.repeater.itemAt(currentPieceRow * items.columns + col - 1).border.color = "#62db53"
                items.repeater.itemAt(currentPieceRow * items.columns + col - 2).border.color = "#62db53"
                return true
            }
        } 
        else {
            sameColor = 0
        }
    }

    // Vertical
    sameColor = 0
    for(var row = 0; row < items.rows; row++) {
        if(getPieceState(currentPieceColumn, row) === currentPlayer) {
            if(++sameColor == 3) {
                items.repeater.itemAt(row * items.columns + currentPieceColumn).visible = true
                items.repeater.itemAt((row - 1) * items.columns + currentPieceColumn).visible = true
                items.repeater.itemAt((row -2) * items.columns + currentPieceColumn).visible = true
                items.repeater.itemAt(row * items.columns + currentPieceColumn).border.color = "#62db53"
                items.repeater.itemAt((row - 1) * items.columns + currentPieceColumn).border.color = "#62db53"
                items.repeater.itemAt((row - 2) * items.columns + currentPieceColumn).border.color = "#62db53"
                return true
            }
        } 
        else {
            sameColor = 0
        }
    }

    // Diagonal top left / bottom right
    if(getPieceState(0,0) === currentPlayer && getPieceState(1,1) === currentPlayer && getPieceState(2,2) === currentPlayer) {
        items.repeater.itemAt(0).visible = true
        items.repeater.itemAt(4).visible = true
        items.repeater.itemAt(8).visible = true
        items.repeater.itemAt(0).border.color = "#62db53"
        items.repeater.itemAt(4).border.color = "#62db53"
        items.repeater.itemAt(8).border.color = "#62db53"
        return true
    }

    // Diagonal top right / bottom left
    if(getPieceState(2,0) === currentPlayer && getPieceState(1,1) === currentPlayer && getPieceState(0,2) === currentPlayer) {
        items.repeater.itemAt(2).visible = true
        items.repeater.itemAt(4).visible = true
        items.repeater.itemAt(6).visible = true
        items.repeater.itemAt(2).border.color = "#62db53"
        items.repeater.itemAt(4).border.color = "#62db53"
        items.repeater.itemAt(6).border.color = "#62db53"
        return true
    }
    return false
}

//Checks if its Computer's turn or not, if its Computer's turn, then call doMove()
function shouldComputerPlay() {
    if(!twoPlayer) {
        if(items.counter % 2 && items.playSecond == false && stopper == false) {
            doMove()
        }
        else if((items.counter % 2 == 0) && items.playSecond == true && stopper == false) {
            doMove()
        }
    }
}

//This function is called after every turn to proceed the game
function continueGame() {
    items.createPiece.opacity = 0
    if (!items.playSecond)
        items.pieces.set(currentPiece, {"stateTemp": items.counter++ % 2 ? "2": "1"})
    else {
        if (items.counter++ % 2 == 0)
            items.pieces.set(currentPiece, {"stateTemp": "2"})
        else
            items.pieces.set(currentPiece, {"stateTemp": "1"})
    }
    track.push(currentPiece)
    /* Update score if game won */
    if(twoPlayer) {
        if(checkGameWon(parseInt(currentPiece / items.columns),
                        parseInt(currentPiece % items.columns))) {
            items.gameDone = true
            if(currentPlayer === "1") {
                items.player1score.win()
            } 
            else {
                items.player2score.win()
            }
            items.bonus.good("flower")
        }
        else if(items.counter == 9) {
            items.player1score.endTurn();
            items.player2score.endTurn();
            items.bonus.bad("flower")
        }
        else
            changeScale()
    } 
    else {
        if(checkGameWon(parseInt(currentPiece / items.columns),
                        parseInt(currentPiece % items.columns))) {
            items.gameDone = true
            if(currentPlayer == "1") {
                items.player1score.win()
                items.bonus.good("flower")
            } 
            else {
                items.player2score.win()
                items.bonus.bad("flower")
            }
        }
        else if(items.counter == 9) {
            items.player1score.endTurn();
            items.player2score.endTurn();
            items.bonus.bad("flower")
        }
        else 
            changeScale()
    }
}
