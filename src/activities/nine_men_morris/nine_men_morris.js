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

var currentPiece
var currentPlayer
var currentLocation
var twoPlayer
var track = []      //For tracking moves
var stopper     //For stopping game when doing reset
//var dragPoints = []
//var firstPhase
var currentRepeater
var otherRepeater
//var items.pieceBeingRemoved
var numberOfFirstPieces
var numberOfSecondPieces
var chance

function start(items_, twoPlayer_) {

    items = items_
    currentLevel = 1
    currentPlayer = 1
    items.player1_score = 0
    items.player2_score = 0
    twoPlayer = twoPlayer_
    numberOfLevel = 6
    items.playSecond = false

    // First time Drag point creation
    var dragPointComponent = Qt.createComponent("qrc:/gcompris/src/activities/nine_men_morris/DragPoint.qml")
    if (dragPointComponent.status == dragPointComponent.Error) {
        // Error Handling
        console.log("Error loading component:", dragPointComponent.errorString());
    }
    var filename = url + "position.qml"
    items.positionSet.source = filename
    var positionData = items.positionSet.item
    var positionDataLength = positionData.positions.length
    for (var i = 0 ; i < positionDataLength ; i++) {
        /*dragPoints[i] = dragPointComponent.createObject(
                             items.board, {
                                "posX": positionData.positions[i].x,
                                "posY": positionData.positions[i].y,
                                "index": i
                             });*/
        items.dragPointsModel.append( {
            "posX": positionData.positions[i].x,
            "posY": positionData.positions[i].y,
            "myIndex": i
        } )
    }

    // For assigning left and right piece
    for (var i = 0 ; i < 24 ; i++) {
        if (i % 3)
            items.dragPoints.itemAt(i).leftPiece = items.dragPoints.itemAt(i - 1)
        else
            items.dragPoints.itemAt(i).leftPiece = null
        if ((i + 1) % 3)
            items.dragPoints.itemAt(i).rightPiece = items.dragPoints.itemAt(i + 1)
        else
            items.dragPoints.itemAt(i).rightPiece = null
    }

    // Start assigning upper and lower piece
    items.dragPoints.itemAt(0).upperPiece = items.dragPoints.itemAt(9)
    items.dragPoints.itemAt(0).lowerPiece = null
    items.dragPoints.itemAt(1).upperPiece = items.dragPoints.itemAt(4)
    items.dragPoints.itemAt(1).lowerPiece = null
    items.dragPoints.itemAt(2).upperPiece = items.dragPoints.itemAt(14)
    items.dragPoints.itemAt(2).lowerPiece = null
    items.dragPoints.itemAt(3).upperPiece = items.dragPoints.itemAt(10)
    items.dragPoints.itemAt(3).lowerPiece = null
    items.dragPoints.itemAt(4).upperPiece = items.dragPoints.itemAt(7)
    items.dragPoints.itemAt(4).lowerPiece = items.dragPoints.itemAt(1)
    items.dragPoints.itemAt(5).upperPiece = items.dragPoints.itemAt(13)
    items.dragPoints.itemAt(5).lowerPiece = null
    items.dragPoints.itemAt(6).upperPiece = items.dragPoints.itemAt(11)
    items.dragPoints.itemAt(6).lowerPiece = null
    items.dragPoints.itemAt(7).upperPiece = null
    items.dragPoints.itemAt(7).lowerPiece = items.dragPoints.itemAt(4)
    items.dragPoints.itemAt(8).upperPiece = items.dragPoints.itemAt(12)
    items.dragPoints.itemAt(8).lowerPiece = null
    items.dragPoints.itemAt(9).upperPiece = items.dragPoints.itemAt(21)
    items.dragPoints.itemAt(9).lowerPiece = items.dragPoints.itemAt(0)
    items.dragPoints.itemAt(10).upperPiece = items.dragPoints.itemAt(18)
    items.dragPoints.itemAt(10).lowerPiece = items.dragPoints.itemAt(3)
    items.dragPoints.itemAt(11).upperPiece = items.dragPoints.itemAt(15)
    items.dragPoints.itemAt(11).lowerPiece = items.dragPoints.itemAt(6)
    items.dragPoints.itemAt(12).upperPiece = items.dragPoints.itemAt(17)
    items.dragPoints.itemAt(12).lowerPiece = items.dragPoints.itemAt(8)
    items.dragPoints.itemAt(13).upperPiece = items.dragPoints.itemAt(20)
    items.dragPoints.itemAt(13).lowerPiece = items.dragPoints.itemAt(5)
    items.dragPoints.itemAt(14).upperPiece = items.dragPoints.itemAt(23)
    items.dragPoints.itemAt(14).lowerPiece = items.dragPoints.itemAt(2)
    items.dragPoints.itemAt(15).upperPiece = null
    items.dragPoints.itemAt(15).lowerPiece = items.dragPoints.itemAt(11)
    items.dragPoints.itemAt(16).upperPiece = items.dragPoints.itemAt(19)
    items.dragPoints.itemAt(16).lowerPiece = null
    items.dragPoints.itemAt(17).upperPiece = null
    items.dragPoints.itemAt(17).lowerPiece = items.dragPoints.itemAt(12)
    items.dragPoints.itemAt(18).upperPiece = null
    items.dragPoints.itemAt(18).lowerPiece = items.dragPoints.itemAt(10)
    items.dragPoints.itemAt(19).upperPiece = items.dragPoints.itemAt(22)
    items.dragPoints.itemAt(19).lowerPiece = items.dragPoints.itemAt(16)
    items.dragPoints.itemAt(20).upperPiece = null
    items.dragPoints.itemAt(20).lowerPiece = items.dragPoints.itemAt(13)
    items.dragPoints.itemAt(21).upperPiece = null
    items.dragPoints.itemAt(21).lowerPiece = items.dragPoints.itemAt(9)
    items.dragPoints.itemAt(22).upperPiece = null
    items.dragPoints.itemAt(22).lowerPiece = items.dragPoints.itemAt(19)
    items.dragPoints.itemAt(23).upperPiece = null
    items.dragPoints.itemAt(23).lowerPiece = items.dragPoints.itemAt(14)
    // End assigning upper and lower piece

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
    items.firstPhase = true
    //items.pieceBeingRemoved = false
    items.pieceBeingMoved = false
    numberOfFirstPieces = 0
    numberOfSecondPieces = 0
    items.firstPieceNumberCount = 9
    items.secondPieceNumberCount = 9
    items.instructionTxt = qsTr("Place a Piece")
    //items.board.sourceSize.width = 3.5 * Math.min(items.background.width / 4 , items.background.height / 6)
    //items.board.anchors.horizontalCenterOffset = -0.18 * items.board.width
    //items.pieces.clear()
    track = []
    /*for(var y = 0;  y < items.rows; y++) {
        for(var x = 0;  x < items.columns; x++) {
            items.pieces.append({'stateTemp': "invisible"})
        }
    }*/

    // Clear first and second player pieces, and initialize dragPoints
    items.firstPlayerPieces.model.clear()
    items.secondPlayerPieces.model.clear()
    for (var i = 0 ; i < 24 ; ++i)
            items.dragPoints.itemAt(i).state = "AVAILABLE"

    // Create first and second player pieces
    for (var i = 0 ; i < 9 ; ++i) {
        items.firstPlayerPiecesModel.append({})/* {
            //"state": items.playSecond % 2 ? "2": "1",
            "myIndex": i
            /*"sourceSize.height": Math.min(firstInitial.height*0.8,firstInitial.width*0.4),
            "x": firstInitial.width*0.06,
            "anchors.verticalCenter": firstInitial.verticalCenter
        })*/
        items.secondPlayerPiecesModel.append({})/* {
            //"state": items.playSecond % 2 ? "2": "1",
            "myIndex": i
            /*"sourceSize.height": Math.min(firstInitial.height*0.8,firstInitial.width*0.4),
            "x": firstInitial.width*0.06,
            "anchors.verticalCenter": firstInitial.verticalCenter
        })*/
    }
    if (items.playSecond) {
        currentRepeater = items.firstPlayerPieces
        otherRepeater = items.secondPlayerPieces
        initiatePlayer2()
    }
    else {
        currentRepeater = items.firstPlayerPieces
        otherRepeater = items.secondPlayerPieces
        initiatePlayer1()
    }
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
        items.playSecond = false
    else
        items.playSecond = true
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

    items.firstInitial.anchors.right = undefined
    items.firstInitial.anchors.top = items.player1.bottom
    items.firstInitial.anchors.left = items.player1.left

    items.secondInitial.anchors.left = undefined
    items.secondInitial.anchors.right = items.player2.right
    items.secondInitial.anchors.top = items.player2.bottom

    items.rotateKonqi.start()
}

//Initial values at the start of game when its player 1 turn
function initiatePlayer2() {

    items.changeScalePlayer1.scale = 1.0
    items.changeScalePlayer2.scale = 1.4
    items.player1.state = "second"
    items.player2.state = "first"

    items.secondInitial.anchors.right = undefined
    items.secondInitial.anchors.top = items.player1.bottom
    items.secondInitial.anchors.left = items.player1.left

    items.firstInitial.anchors.left = undefined
    items.firstInitial.anchors.right = items.player2.right
    items.firstInitial.anchors.top = items.player2.bottom

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
        items.playSecond = true
        reset()
        return 0
    }
    if (!twoPlayer) {
    }
}

//Changing play to second in single player mode
function changePlayToFirst() {
    items.playSecond = false
    reset()
}

//Create the piece at given position
function handleCreate(index) {
    items.pieceBeingMoved = true
    currentPiece = currentRepeater.itemAt(items.counter/2)
    //items.dragPoints.itemAt(index).state = currentPiece.state
    if(currentPiece.state == "2") {// && !items.playSecond || currentPiece.state == "1" && !items.playSecond) {
        items.secondPieceNumberCount--
        //items.dragPoints.itemAt(index).state = "2"
        numberOfSecondPieces++
    }
    else {
        items.firstPieceNumberCount--
        //items.dragPoints.itemAt(index).state = "1"
        numberOfFirstPieces++
    }
    //dragPoints[index].state = "UNAVAILABLE"
    //piece.itemAt(items.counter/2).parent = dragPoints[index]
    //piece.itemAt(items.counter/2).pieceParent = dragPoints[index]
    currentPiece.move(items.dragPoints.itemAt(index))
}

function secondPhase() {
    items.firstPhase = false
    items.board.anchors.horizontalCenterOffset = 0
    //items.board.anchors.verticalCenterOffset = -10
    //items.board.sourceSize.width = 3.4 * Math.min(items.background.width / 4 , items.background.height / 6)
    //items.board.sourceSize.width = Math.min(items.background.height - 1.4*items.player1.height - 1.2*items.bar.height,
                                            //0.9*items.background.width)
    for (var i = 0 ; i < 24 ; ++i) {
        if (items.dragPoints.itemAt(i).state != "1" && items.dragPoints.itemAt(i).state != "2")
            items.dragPoints.itemAt(i).state = "EMPTY"
    }

    items.instructionTxt = qsTr("Move a Piece")
}

function pieceSelected(pieceIndex) {

    currentPiece.isSelected = false
    currentPiece = currentRepeater.itemAt(pieceIndex)
    currentPiece.isSelected = true

    if ((currentPiece.state == "1" && numberOfFirstPieces > 4) || (currentPiece.state == "2" && numberOfSecondPieces > 4)) {
        // Initialize values
        //console.log("If")
        for (var i = 0 ; i < 24 ; ++i) {
            if (items.dragPoints.itemAt(i).state == "EMPTY" || items.dragPoints.itemAt(i).state == "AVAILABLE")
                items.dragPoints.itemAt(i).state = "UNAVAILABLE"
        }

        // Now assign values
        var index = currentRepeater.itemAt(pieceIndex).parentIndex // Drag Point index

        if (items.dragPoints.itemAt(index).leftPiece) {
            if (items.dragPoints.itemAt(index).leftPiece.state == "UNAVAILABLE")
                items.dragPoints.itemAt(index).leftPiece.state = "AVAILABLE"
        }
        if (items.dragPoints.itemAt(index).upperPiece) {
            if (items.dragPoints.itemAt(index).upperPiece.state == "UNAVAILABLE")
                items.dragPoints.itemAt(index).upperPiece.state = "AVAILABLE"
        }
        if (items.dragPoints.itemAt(index).rightPiece) {
            if (items.dragPoints.itemAt(index).rightPiece.state == "UNAVAILABLE")
                items.dragPoints.itemAt(index).rightPiece.state = "AVAILABLE"
        }
        if (items.dragPoints.itemAt(index).lowerPiece) {
            if (items.dragPoints.itemAt(index).lowerPiece.state == "UNAVAILABLE")
                items.dragPoints.itemAt(index).lowerPiece.state = "AVAILABLE"
        }
    }
    else {
        //console.log("else")
        for (var i = 0 ; i < 24 ; ++i) {
            if (items.dragPoints.itemAt(i).state == "EMPTY" || items.dragPoints.itemAt(i).state == "UNAVAILABLE")
                items.dragPoints.itemAt(i).state = "AVAILABLE"
        }
    }
}

function movePiece(index) {
    items.pieceBeingMoved = true
    currentPiece.parent.state = "EMPTY"
    currentPiece.isSelected = false
    for (var i = 0 ; i < 24 ; ++i) {
        if (items.dragPoints.itemAt(i).state != "1" && items.dragPoints.itemAt(i).state != "2")
            items.dragPoints.itemAt(i).state = "EMPTY"
    }
    currentPiece.move(items.dragPoints.itemAt(index))
    //currentPiece.parent.state = currentPiece.state
}

function setmove() {
}

function shouldComputerPlay() {
}

// continueGame() called by Piece when its animation stops and checkMill(piece) is false or
// called after removePiece(index) has removed a piece
function continueGame() {
    items.pieceBeingMoved = false
    items.counter++
    //console.log(items.counter)
    if(items.counter%2) {
        currentRepeater = items.secondPlayerPieces
        otherRepeater = items.firstPlayerPieces
    }
    else {
        currentRepeater = items.firstPlayerPieces
        otherRepeater = items.secondPlayerPieces
    }
    if(items.counter == 18)
        secondPhase()
    changeScale()
}

function checkMill(piece) {
    var index = piece.parentIndex
    var state = piece.state
    //var millFormed = false
    /*console.log(index)
    //console.log(index, state, dragPoints[1].state, dragPoints[2].state)
    if(!millFormed && index == 0) {
        if (dragPoints[1].state == dragPoints[2].state &&  dragPoints[2].state == state)
            //console.log("mill")
    }*/
    if (items.dragPoints.itemAt(index).leftPiece) {
        if (items.dragPoints.itemAt(index).leftPiece.leftPiece) {
            if (piece.state == items.dragPoints.itemAt(index).leftPiece.state &&
                piece.state == items.dragPoints.itemAt(index).leftPiece.leftPiece.state)
                    return true;
        }
    }
    if (items.dragPoints.itemAt(index).upperPiece) {
        if (items.dragPoints.itemAt(index).upperPiece.upperPiece) {
            if (piece.state == items.dragPoints.itemAt(index).upperPiece.state &&
                piece.state == items.dragPoints.itemAt(index).upperPiece.upperPiece.state)
                    return true;
        }
    }
    if (items.dragPoints.itemAt(index).rightPiece) {
        if (items.dragPoints.itemAt(index).rightPiece.rightPiece) {
            if (piece.state == items.dragPoints.itemAt(index).rightPiece.state &&
                piece.state == items.dragPoints.itemAt(index).rightPiece.rightPiece.state)
                    return true;
        }
    }
    if (items.dragPoints.itemAt(index).lowerPiece) {
        if (items.dragPoints.itemAt(index).lowerPiece.lowerPiece) {
            if (piece.state == items.dragPoints.itemAt(index).lowerPiece.state &&
                piece.state == items.dragPoints.itemAt(index).lowerPiece.lowerPiece.state)
                    return true;
        }
    }
    if (items.dragPoints.itemAt(index).lowerPiece) {
        if (items.dragPoints.itemAt(index).upperPiece) {
            if (piece.state == items.dragPoints.itemAt(index).lowerPiece.state &&
                piece.state == items.dragPoints.itemAt(index).upperPiece.state)
                    return true;
        }
    }
    if (items.dragPoints.itemAt(index).leftPiece) {
        if (items.dragPoints.itemAt(index).rightPiece) {
            if (piece.state == items.dragPoints.itemAt(index).leftPiece.state &&
                piece.state == items.dragPoints.itemAt(index).rightPiece.state)
                    return true;
        }
    }

    /*switch(index) {
        case 0:
        case 21:
            if (state == items.dragPoints.itemAt(index + 1).state && state == items.dragPoints.itemAt(index + 2).state)
                return true
            break;
        case 1:
            //code block
            break;
        //default:
            //default code block
    }*/
}

// UpdateRemovablePiece called by Piece when its animation stops and checkMill(piece) is true
function UpdateRemovablePiece() {
    //items.pieceBeingRemoved = true
    var foundOne = false
    for(var i = 0 ; i < 9 ; ++i) {
        //console.log(i)
        if (otherRepeater.itemAt(i).parentIndex != -1) {
            if (!checkMill(otherRepeater.itemAt(i)) && otherRepeater.itemAt(i).visible == true) {
                foundOne = true
                otherRepeater.itemAt(i).canBeRemoved = true // Mark pieces of other player for removal
            }
        }
    }
    if (!foundOne) {
        for(var i = 0 ; i < 9 ; ++i) {
            if ((otherRepeater.itemAt(i).parentIndex != -1) && (otherRepeater.itemAt(i).visible == true))
                otherRepeater.itemAt(i).canBeRemoved = true
        }
    }
    items.instructionTxt = qsTr("Remove a Piece")
}

// removePiece(index) called by Piece when items.pieceBeingRemoved is true
function removePiece(index) {
    //console.log(index)
    otherRepeater.itemAt(index).visible = false
    otherRepeater.itemAt(index).parent.state = items.firstPhase ? "AVAILABLE" : "EMPTY"
    for(var i = 0 ; i < 9 ; ++i)
        otherRepeater.itemAt(i).canBeRemoved = false
    //items.pieceBeingRemoved = false

    // Decrease number of pieces of other player by 1
    if (items.counter%2)
        numberOfFirstPieces--
    else
        numberOfSecondPieces--
    if (items.firstPhase) {
        items.instructionTxt = qsTr("Place a Piece")
        continueGame()
    }
    else
        checkGameWon()
}

function checkGameWon() {

    // Check if other player can mover or not
    var flag = true;
    for (var i = 0 ; i < 9 ; ++i) {
        //console.log("otherRepeater.itemAt(i).visible",otherRepeater.itemAt(i).visible)
        if (otherRepeater.itemAt(i).visible) {
            //console.log("left",otherRepeater.itemAt(i).parent.leftPiece ? otherRepeater.itemAt(i).parent.leftPiece.state : "Null")
            //console.log("right",otherRepeater.itemAt(i).parent.rightPiece ? otherRepeater.itemAt(i).parent.rightPiece.state : "Null")
            //console.log("upper",otherRepeater.itemAt(i).parent.upperPiece ? otherRepeater.itemAt(i).parent.upperPiece.state : "Null")
            //console.log("lower",otherRepeater.itemAt(i).parent.lowerPiece ? otherRepeater.itemAt(i).parent.lowerPiece.state : "Null")
            if ((otherRepeater.itemAt(i).parent.leftPiece &&
                 otherRepeater.itemAt(i).parent.leftPiece.state == "EMPTY") ||
                (otherRepeater.itemAt(i).parent.rightPiece &&
                 otherRepeater.itemAt(i).parent.rightPiece.state == "EMPTY") ||
                (otherRepeater.itemAt(i).parent.upperPiece &&
                 otherRepeater.itemAt(i).parent.upperPiece.state == "EMPTY") ||
                (otherRepeater.itemAt(i).parent.lowerPiece &&
                 otherRepeater.itemAt(i).parent.lowerPiece.state == "EMPTY")) {
                    flag = false
                    break
            }
        }
    }
    //console.log("flag", flag)
    //console.log("currentPiece.state",currentPiece.state)
    if (((numberOfSecondPieces < 3 && !items.playSecond) || (numberOfFirstPieces < 3 && items.playSecond)) ||
        (flag && ((currentPiece.state == "1" && !items.playSecond) || (currentPiece.state == "2" && items.playSecond)))) {
        items.gameDone = true
        items.player1_score++
        items.player1.state = "win"
        items.instructionTxt = qsTr("Congratulations")
        items.bonus.good("flower")
        if(twoPlayer) {
            items.instructionTxt = qsTr("Congratulation Player 1")
            items.bonus.isWin = false
        }
    }
    else if (((numberOfFirstPieces < 3 && !items.playSecond) || (numberOfSecondPieces < 3 && items.playSecond)) ||
             (flag && ((currentPiece.state == "2" && !items.playSecond) || (currentPiece.state == "1" && items.playSecond)))) {
        items.gameDone = true
        items.player2_score++
        items.player2.state = "win"
        if(twoPlayer) {
            items.bonus.good("flower")
            items.instructionTxt = qsTr("Congratulation Player 2")
            items.bonus.isWin = false
        }
        else {
            items.instructionTxt = qsTr("Try Again")
            items.bonus.bad("tux")
        }
    }
    else {
        // Continue the game
        items.instructionTxt = items.firstPhase ? qsTr("Place a Piece") : qsTr("Move a Piece")
        continueGame()
    }
}
