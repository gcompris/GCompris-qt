/* GCompris - TicTacToe.js
 *
 * Copyright (C) 2014 Pulkit Gupta
 *
 * Authors:
 *   Pulkit Gupta <pulkitgenius@gmail.com> (Qt Quick port)
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
var numberOfLevel = 5
var items

var url = "qrc:/gcompris/src/activities/tic_tac_toe/resource/"

var currentPiece
var currentPlayer
var currentLocation
var twoPlayer
var track = []		//For tracking moves
var hx		//x co-ordinate needed for creating first image when playSecond is enabled
var vy		//y co-ordinate needed for creating first image when playSecond is enabled
var stopper		//For stopping game when doing reset

function start(items_, twoPlayer_) {
    items = items_
    currentLevel = 0
    currentPlayer = 1
    items.player1_score = 0
    items.player2_score = 0
    twoPlayer = twoPlayer_
    numberOfLevel = twoPlayer ? 1 : 5
    items.playSecond = 0
	initLevel()
}

function stop() {
}

function initLevel() {
	items.bar.level = currentLevel
    items.counter = 0
	items.gameDone = false
    items.pieces.clear()
    track = []
    for(var y = 0;  y < items.rows; y++) {
        for(var x = 0;  x < items.columns; x++) {
            items.pieces.append({'stateTemp': "invisible"})
        }
    }
    if(twoPlayer) {
		items.instructionTxt.text = qsTr("Its Player 1 turn")
		items.playButton.visible = false
	}
	else {
		if (items.playSecond)
			items.instructionTxt.text = qsTr("Its Computer's turn")
		else
			items.instructionTxt.text = qsTr("Its Your Turn")
	}
	stopper = 0
	if (items.playSecond)
		changePlayToSecond()
}

function nextLevel() {
	if(numberOfLevel <= ++currentLevel ) {
        currentLevel = 0
    }
    reset();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    reset();
}

function reset() {
	stopper = 1
	hx = items.repeater.itemAt(1).x		
	vy = items.repeater.itemAt(3).y
	items.magnify.stop()    // stop animation
    items.pieces.clear() // Clear the board
    initLevel()
    
}

function changeText() {
	if(twoPlayer)
		items.instructionTxt.text = qsTr("Its Player " + ((items.counter + 1)%2 + 1) + " turn")
	else {
		if (items.playSecond) {
			if (items.counter%2 == 1)
				items.instructionTxt.text = qsTr("Its Computer's turn")
			else
				items.instructionTxt.text = qsTr("Its Your Turn")
		}
		else {
			if (items.counter%2 == 1)
				items.instructionTxt.text = qsTr("Its Your turn")
			else
				items.instructionTxt.text = qsTr("Its Computer's Turn")
		}
	}
}

function changePlayToSecond() {
	if (items.playSecond == 0) {
		items.playSecond = 1
		reset()
		return 0
	}
	var rand = Math.floor((Math.random() * 9))
	var y = parseInt(rand/3) * vy
	var x = parseInt(rand%3) * hx
	items.repeater.itemAt(rand).state = "DONE"
	currentPiece = rand
    items.createPiece.x=x
    items.createPiece.y=y
    items.demagnify.start()
    items.createPiece.opacity = 1
    items.magnify.start()
}

function changePlayToFirst() {
	items.playSecond = 0
	reset()
}

function getrowno(parentY) {
    for(var i = 0; i < items.rows - 1; i++) {
	if(parentY == items.repeater.itemAt(i*3).y) {
            return i
        }
    }
    return items.rows - 1
}

function getcolno(parentX) {
    for(var i = 0; i < items.columns - 1; i++) {
        if(parentX == items.repeater.itemAt(i).x) {
            return i
        }
    }
    return items.columns - 1
}

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

function getPieceState(col, row) {
    return items.pieces.get(row * items.columns + col).stateTemp
}

function setmove() {

	var playerState = items.playSecond ? "2" : "1"
	var computerState = items.playSecond ? "1" : "2"

	if (currentLevel > 0) {
		var value = evaluateBoard(computerState)
		if (value != -1){
			return value}
	}
	
	if (currentLevel > 1) {
		var value = evaluateBoard(playerState)
		if (value != -1){
			return value}
	}
	
	if (currentLevel > 3) {
		var value = applyLogic(playerState)
		if (value != -1)
			return value
	}
	
	var found = false
	while (!found) {
		var randno = Math.floor((Math.random() * 9));
		if (items.pieces.get(randno).stateTemp == "invisible")
			found = true
	}
	return randno
}

function giveNearest() {
	
	var currentRow = parseInt(currentPiece / items.columns)
	var currentCol = parseInt(currentPiece % items.columns)
	var temp = []
	
	if ( currentRow + 1 < 3 ) {
		if(getPieceState(currentCol, currentRow + 1) == "invisible")
			temp.push((currentRow + 1) * items.columns + currentCol)
	}
	if ( currentRow - 1 > 0 ) {
		if(getPieceState(currentCol, currentRow - 1) == "invisible")
			temp.push((currentRow - 1) * items.columns + currentCol)
	}
	if ( currentCol + 1 < 3 ) {
		if(getPieceState(currentCol + 1, currentRow) == "invisible")
			temp.push(currentRow * items.columns + currentCol + 1)
	}
	if ( currentCol - 1 > 0 ) {
		if(getPieceState(currentCol - 1, currentRow) == "invisible")
			temp.push(currentRow * items.columns + currentCol - 1)
	}
	if (temp.length != 0) {
		var randno = Math.floor((Math.random() * temp.length));
		return temp[randno]
	}
	
	return -1
}

function applyLogic( player ) {
	
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
		var value = giveNearest()
		if (value != -1)
			return value
		return -1
	}
}

function doMove() {
	
	var pos = setmove ()
    handleCreate(items.repeater.itemAt(pos))
}

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

function checkGameWon(currentPieceRow, currentPieceColumn) {

    currentPlayer = getPieceState(currentPieceColumn, currentPieceRow)
    
    // Horizontal
    var sameColor = 0
    for(var col = 0; col < items.columns; col++) {
        if(getPieceState(col, currentPieceRow) === currentPlayer) {
			if(++sameColor == 3) {
				items.repeater.itemAt(currentPieceRow * items.columns + col).visible = true
                items.repeater.itemAt(currentPieceRow * items.columns + col -1).visible = true
                items.repeater.itemAt(currentPieceRow * items.columns + col -2).visible = true
                items.repeater.itemAt(currentPieceRow * items.columns + col).border.color = "green"
                items.repeater.itemAt(currentPieceRow * items.columns + col - 1).border.color = "green"
                items.repeater.itemAt(currentPieceRow * items.columns + col - 2).border.color = "green"
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
                items.repeater.itemAt(row * items.columns + currentPieceColumn).border.color = "green"
                items.repeater.itemAt((row -1) * items.columns + currentPieceColumn).border.color = "green"
                items.repeater.itemAt((row -2) * items.columns + currentPieceColumn).border.color = "green"
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
        items.repeater.itemAt(0).border.color = "green"
        items.repeater.itemAt(4).border.color = "green"
        items.repeater.itemAt(8).border.color = "green"
        return true
    }

    // Diagonal top right / bottom left
    if(getPieceState(2,0) === currentPlayer && getPieceState(1,1) === currentPlayer && getPieceState(0,2) === currentPlayer) {
        items.repeater.itemAt(2).visible = true
        items.repeater.itemAt(4).visible = true
        items.repeater.itemAt(6).visible = true
        items.repeater.itemAt(2).border.color = "green"
        items.repeater.itemAt(4).border.color = "green"
        items.repeater.itemAt(6).border.color = "green"
        return true
    }
    return false
}

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
                items.instructionTxt.text = qsTr("Congratulation Player 1! You won")
                items.player1_score++
            } 
            else {
				items.instructionTxt.text = qsTr("Congratulation Player 2! You won")
                items.player2_score++
            }
            items.bonus.good("flower")
            items.bonus.isWin = false
        }

    } 
    else {
		if(checkGameWon(parseInt(currentPiece / items.columns),
                        parseInt(currentPiece % items.columns))) {
            items.gameDone = true
            if(currentPlayer == "1") {
				items.instructionTxt.text = qsTr("Congratulation! You won")
                items.player1_score++
                items.bonus.good("flower")
            } 
            else {
				items.instructionTxt.text = qsTr("You lost! Click on reload button to try again")
                items.player2_score++
                items.bonus.bad("tux")
            }
        }
        else if(items.counter % 2 && items.counter != 9 && items.playSecond == false && stopper == 0) {
            doMove()
        }
        else if((items.counter % 2 == 0) && items.counter != 9 && items.playSecond == true && stopper == 0) {
            doMove()
        }
    }
    if(items.counter == 9 && items.gameDone != true) {
		items.instructionTxt.text = qsTr("Its a Draw! Click on reload button to try again")
    }
}
