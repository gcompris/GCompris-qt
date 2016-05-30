/* GCompris - nine_men_morris.js
 *
 * Copyright (C) 2016 Pulkit Gupta <pulkitnsit@gmail.com>
 *
 * Authors:
 *   Pulkit Gupta <pulkitnsit@gmail.com>
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

var url = "qrc:/gcompris/src/activities/nine_men_morris/resource/"

//var currentPiece
var currentPlayer
var currentLocation
var twoPlayer
var track = []      //For tracking moves
var stopper     //For stopping game when doing reset

function start(items_, twoPlayer_) {
    
    items = items_
    currentLevel = 1
    currentPlayer = 1
    items.player1_score = 0
    items.player2_score = 0
    twoPlayer = twoPlayer_
    numberOfLevel = 6
    items.playSecond = 0
    if (!twoPlayer)
		tutorial()
    else
		initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel
    items.counter = 0
    items.gameDone = false
    items.board.anchors.horizontalCenterOffset = -0.25*items.board.width
    items.board.sourceSize.width = 3 * Math.min(items.background.width / 4 , items.background.height / 6)
    //items.pieces.clear()
    track = []
    /*for(var y = 0;  y < items.rows; y++) {
        for(var x = 0;  x < items.columns; x++) {
            items.pieces.append({'stateTemp': "invisible"})
        }
    }*/
    if (items.playSecond) 
        initiatePlayer2()
    else 
        initiatePlayer1()
    stopper = 0
    if (items.playSecond)
        changePlayToSecond()
}

function tutorial() {
	items.isTutorial = true
	/*
	items.board.anchors.horizontalCenterOffset = -0.25*items.board.width
	//items.board.anchors.verticalCenterOffset = 0.25*items.board.height
	items.board.anchors.verticalCenter = undefined
	items.board.anchors.bottom = items.bar.top
	items.board.anchors.bottomMargin = 20
	items.board.sourceSize.width = 2 * Math.min(items.background.width / 4 , items.background.height / 6)	
	*/
	setTutorial(1)
}

function setTutorial(tutNum) {
	//var src = "tutorial" + tutNum + ".svg"
	//items.tutorialImage = url + src
	if (tutNum == 1) {
		items.tutorialTxt = qsTr("You and Tux starts with 9 pieces each, and take turns to place " +
								 "your pieces on to the empty spots (by clicking on the spots) on the board. ")
	}
	else if (tutNum == 2) {
		items.tutorialTxt = qsTr("If you form a mill (line of 3 pieces), then select a piece of Tux, and remove " +
								 "it. Pieces of formed mill can not be removed unless no other pieces are left on board.")
	}
	else if (tutNum == 3) {
		items.tutorialTxt = qsTr("After all the pieces are placed, you and Tux will take turns to move them. " +
								 "Click on one of your pieces, and then on the adjacent empty spot to move " +
								 "it there. Green color spot indicates where you can move.")
	}
	else if (tutNum == 4) {
		items.tutorialTxt = qsTr("If you are left with 3 pieces, your pieces will gain the ability to 'fly' " +
								 "and can be moved to any vacant spot on the board.") 
	}
	else if (tutNum == 5) {
		items.tutorialTxt = qsTr("If you immobilize the computer or leave it with less than 3 pieces, then " +
								 "you win the game.")
	}
	/*
	else {
		items.isTutorial = false
		initLevel()
	}*/
}

function tutorialNext() {
	setTutorial(++items.tutNum)
}

function tutorialPrevious() {
	setTutorial(--items.tutNum)
}

function tutorialSkip() {
	items.isTutorial = false
	initLevel()
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel ) {
        currentLevel = 1
    }
    reset();
}

function previousLevel() {
    if(--currentLevel < 1) {
        currentLevel = numberOfLevel - 1
    }
    reset();
}

function reset() {
    
    stopper = 1
    stopAnimations()
    items.player1image.rotation = 0
    items.player2image.rotation = 0
    if (items.playSecond)
        items.playSecond = 0
    else
        items.playSecond = 1
    initLevel()
}

function stopAnimations() {
    
    items.player1turn.stop()
    items.player2turn.stop()
    items.player1shrink.stop()
    items.player2shrink.stop()
    items.rotateKonqi.stop()
    items.rotateTux.stop()
}

//Initial values at the start of game when its player 1 turn
function initiatePlayer1() {
    
    items.changeScalePlayer1.scale = 1.4
    items.changeScalePlayer2.scale = 1.0
    items.player1.state = "first"
    items.player2.state = "second"
    items.rotateKonqi.start()
}

//Initial values at the start of game when its player 1 turn
function initiatePlayer2() {
    
    items.changeScalePlayer1.scale = 1.0
    items.changeScalePlayer2.scale = 1.4
    items.player1.state = "second"
    items.player2.state = "first"
    items.rotateTux.start()
}

//Change scale of score boxes according to turns
function changeScale() {
    
   if (items.playSecond) {
        if (items.counter%2 == 0)
            items.player2turn.start()
        else
            items.player1turn.start()
    }
    else {
        if (items.counter%2 == 0)
            items.player1turn.start()
        else
            items.player2turn.start()
    }
}

function changePlayToSecond() {
    if (items.playSecond == 0) {
        items.playSecond = 1
        reset()
        return 0
    }
    if (!twoPlayer) {
    }
}

//Changing play to second in single player mode
function changePlayToFirst() {
    items.playSecond = 0
    reset()
}

//Create the piece at given position
function handleCreate(parent) {
    
    items.firstInitial.visible = false
    items.secondInitial.visible = false
    items.board.anchors.horizontalCenterOffset = 0
    //items.board.anchors.verticalCenterOffset = -10
    items.board.sourceSize.width = 3.4 * Math.min(items.background.width / 4 , items.background.height / 6)
    
}

function setmove() {
}

function shouldComputerPlay() {
}
