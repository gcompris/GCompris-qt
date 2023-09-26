/* GCompris - nine_men_morris.js
 *
 * SPDX-FileCopyrightText: 2016 Pulkit Gupta <pulkitnsit@gmail.com>
 *
 * Authors:
 *   Pulkit Gupta <pulkitnsit@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.12 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var numberOfLevel = 5
var items
var url = "qrc:/gcompris/src/activities/nine_men_morris/resource/"
var currentPiece
var twoPlayer
var stopper     //For stopping game when doing reset
var currentRepeater
var otherRepeater
var numberOfFirstPieces
var numberOfSecondPieces
var numberOfPieces
var numberOfDragPoints
var depthMax
var tutorialInstructions = [
            {
                "instruction": qsTr("You and Tux start with 9 pieces each, and take turns to place your pieces on the empty spots of the board (by clicking on the spots)."),
                "instructionImage" : "qrc:/gcompris/src/activities/nine_men_morris/resource/tutorial1.svg"
            },
            {
                "instruction": qsTr("If you form a mill (line of 3 pieces), then select one of Tux's pieces to remove it. Pieces of formed mill can not be removed unless no other pieces are left on the board."),
                "instructionImage": "qrc:/gcompris/src/activities/nine_men_morris/resource/tutorial2.svg"
            },
            {
                "instruction": qsTr("After all the pieces are placed, you and Tux will take turns to move them. Click on one of your pieces, and then on an adjacent empty spot to move it there. Green color spots indicates where you can move."),
                "instructionImage": "qrc:/gcompris/src/activities/nine_men_morris/resource/tutorial3.svg"
            },
            {
                "instruction":  qsTr("If you are left with 3 pieces, they gain the ability to 'fly' and can be moved to any vacant spot on the board."),
                "instructionImage": "qrc:/gcompris/src/activities/nine_men_morris/resource/tutorial4.svg"
            },
            {
                "instruction": qsTr("If you immobilize the computer or leave it with less than 3 pieces, then you win the game."),
                "instructionImage": "qrc:/gcompris/src/activities/nine_men_morris/resource/tutorial5.svg"
            }
        ]

function start(items_, twoPlayer_) {
    items = items_
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    twoPlayer = twoPlayer_
    numberOfLevel = 6
    numberOfPieces = 9
    numberOfDragPoints = 24
    items.playSecond = false

    // Creating drag points
    items.dragPointsModel.append({
        "posX": 0.05,
        "posY": 0.95,
        "myIndex": 0
    })
    items.dragPointsModel.append({
        "posX": 0.5,
        "posY": 0.95,
        "myIndex": 1
    })
    items.dragPointsModel.append({
        "posX": 0.95,
        "posY": 0.95,
        "myIndex": 2
    })
    items.dragPointsModel.append({
        "posX": 0.2,
        "posY": 0.8,
        "myIndex": 3
    })
    items.dragPointsModel.append({
        "posX": 0.5,
        "posY": 0.8,
        "myIndex": 4
    })
    items.dragPointsModel.append({
        "posX": 0.8,
        "posY": 0.8,
        "myIndex": 5
    })
    items.dragPointsModel.append({
        "posX": 0.35,
        "posY": 0.65,
        "myIndex": 6
    })
    items.dragPointsModel.append({
        "posX": 0.5,
        "posY": 0.65,
        "myIndex": 7
    })
    items.dragPointsModel.append({
        "posX": 0.65,
        "posY": 0.65,
        "myIndex": 8
    })
    items.dragPointsModel.append({
        "posX": 0.05,
        "posY": 0.5,
        "myIndex": 9
    })
    items.dragPointsModel.append({
        "posX": 0.2,
        "posY": 0.5,
        "myIndex": 10
    })
    items.dragPointsModel.append({
        "posX": 0.35,
        "posY": 0.5,
        "myIndex": 11
    })
    items.dragPointsModel.append({
        "posX": 0.65,
        "posY": 0.5,
        "myIndex": 12
    })
    items.dragPointsModel.append({
        "posX": 0.8,
        "posY": 0.5,
        "myIndex": 13
    })
    items.dragPointsModel.append({
        "posX": 0.95,
        "posY": 0.5,
        "myIndex": 14
    })
    items.dragPointsModel.append({
        "posX": 0.35,
        "posY": 0.35,
        "myIndex": 15
    })
    items.dragPointsModel.append({
        "posX": 0.5,
        "posY": 0.35,
        "myIndex": 16
    })
    items.dragPointsModel.append({
        "posX": 0.65,
        "posY": 0.35,
        "myIndex": 17
    })
    items.dragPointsModel.append({
        "posX": 0.2,
        "posY": 0.2,
        "myIndex": 18
    })
    items.dragPointsModel.append({
        "posX": 0.500,
        "posY": 0.2,
        "myIndex": 19
    })
    items.dragPointsModel.append({
        "posX": 0.8,
        "posY": 0.2,
        "myIndex": 20
    })
    items.dragPointsModel.append({
        "posX": 0.05,
        "posY": 0.05,
        "myIndex": 21
    })
    items.dragPointsModel.append({
        "posX": 0.5,
        "posY": 0.05,
        "myIndex": 22
    })
    items.dragPointsModel.append({
        "posX": 0.95,
        "posY": 0.05,
        "myIndex": 23
    })
    // For assigning left and right point
    for (var i = 0 ; i < numberOfDragPoints ; i++) {
        if(i % 3)
            items.dragPoints.itemAt(i).leftPoint = items.dragPoints.itemAt(i - 1)
        else
            items.dragPoints.itemAt(i).leftPoint = null
        if((i + 1) % 3)
            items.dragPoints.itemAt(i).rightPoint = items.dragPoints.itemAt(i + 1)
        else
            items.dragPoints.itemAt(i).rightPoint = null
    }

    // Start assigning upper and lower point
    items.dragPoints.itemAt(0).upperPoint = items.dragPoints.itemAt(9)
    items.dragPoints.itemAt(0).lowerPoint = null
    items.dragPoints.itemAt(1).upperPoint = items.dragPoints.itemAt(4)
    items.dragPoints.itemAt(1).lowerPoint = null
    items.dragPoints.itemAt(2).upperPoint = items.dragPoints.itemAt(14)
    items.dragPoints.itemAt(2).lowerPoint = null
    items.dragPoints.itemAt(3).upperPoint = items.dragPoints.itemAt(10)
    items.dragPoints.itemAt(3).lowerPoint = null
    items.dragPoints.itemAt(4).upperPoint = items.dragPoints.itemAt(7)
    items.dragPoints.itemAt(4).lowerPoint = items.dragPoints.itemAt(1)
    items.dragPoints.itemAt(5).upperPoint = items.dragPoints.itemAt(13)
    items.dragPoints.itemAt(5).lowerPoint = null
    items.dragPoints.itemAt(6).upperPoint = items.dragPoints.itemAt(11)
    items.dragPoints.itemAt(6).lowerPoint = null
    items.dragPoints.itemAt(7).upperPoint = null
    items.dragPoints.itemAt(7).lowerPoint = items.dragPoints.itemAt(4)
    items.dragPoints.itemAt(8).upperPoint = items.dragPoints.itemAt(12)
    items.dragPoints.itemAt(8).lowerPoint = null
    items.dragPoints.itemAt(9).upperPoint = items.dragPoints.itemAt(21)
    items.dragPoints.itemAt(9).lowerPoint = items.dragPoints.itemAt(0)
    items.dragPoints.itemAt(10).upperPoint = items.dragPoints.itemAt(18)
    items.dragPoints.itemAt(10).lowerPoint = items.dragPoints.itemAt(3)
    items.dragPoints.itemAt(11).upperPoint = items.dragPoints.itemAt(15)
    items.dragPoints.itemAt(11).lowerPoint = items.dragPoints.itemAt(6)
    items.dragPoints.itemAt(12).upperPoint = items.dragPoints.itemAt(17)
    items.dragPoints.itemAt(12).lowerPoint = items.dragPoints.itemAt(8)
    items.dragPoints.itemAt(13).upperPoint = items.dragPoints.itemAt(20)
    items.dragPoints.itemAt(13).lowerPoint = items.dragPoints.itemAt(5)
    items.dragPoints.itemAt(14).upperPoint = items.dragPoints.itemAt(23)
    items.dragPoints.itemAt(14).lowerPoint = items.dragPoints.itemAt(2)
    items.dragPoints.itemAt(15).upperPoint = null
    items.dragPoints.itemAt(15).lowerPoint = items.dragPoints.itemAt(11)
    items.dragPoints.itemAt(16).upperPoint = items.dragPoints.itemAt(19)
    items.dragPoints.itemAt(16).lowerPoint = null
    items.dragPoints.itemAt(17).upperPoint = null
    items.dragPoints.itemAt(17).lowerPoint = items.dragPoints.itemAt(12)
    items.dragPoints.itemAt(18).upperPoint = null
    items.dragPoints.itemAt(18).lowerPoint = items.dragPoints.itemAt(10)
    items.dragPoints.itemAt(19).upperPoint = items.dragPoints.itemAt(22)
    items.dragPoints.itemAt(19).lowerPoint = items.dragPoints.itemAt(16)
    items.dragPoints.itemAt(20).upperPoint = null
    items.dragPoints.itemAt(20).lowerPoint = items.dragPoints.itemAt(13)
    items.dragPoints.itemAt(21).upperPoint = null
    items.dragPoints.itemAt(21).lowerPoint = items.dragPoints.itemAt(9)
    items.dragPoints.itemAt(22).upperPoint = null
    items.dragPoints.itemAt(22).lowerPoint = items.dragPoints.itemAt(19)
    items.dragPoints.itemAt(23).upperPoint = null
    items.dragPoints.itemAt(23).lowerPoint = items.dragPoints.itemAt(14)
    // End assigning upper and lower piece

    if(twoPlayer) {
	items.tutorialSection.visible = false
        initLevel()
    }
}

function stop() {
    items.trigTuxMove.stop();
}

function initLevel() {
    items.turn = 0
    items.gameDone = false
    items.firstPhase = true
    items.pieceBeingMoved = false
    numberOfFirstPieces = 0
    numberOfSecondPieces = 0
    items.firstPieceNumberCount = numberOfPieces
    items.secondPieceNumberCount = numberOfPieces
    items.instructionTxt = qsTr("Place a piece")
    depthMax = 2

    // Clear first and second player pieces, and initialize dragPoints
    items.firstPlayerPieces.model.clear()
    items.secondPlayerPieces.model.clear()
    for (var i = 0 ; i < numberOfDragPoints ; ++i)
            items.dragPoints.itemAt(i).state = "AVAILABLE"

    // Create first and second player pieces
    for (var i = 0 ; i < numberOfPieces ; ++i) {
        items.firstPlayerPiecesModel.append({})
        items.secondPlayerPiecesModel.append({})
    }

    currentRepeater = items.firstPlayerPieces
    otherRepeater = items.secondPlayerPieces

    stopper = false

    if(items.playSecond) {
        initiatePlayer2()
        if(!twoPlayer) {
            var rand = Math.floor((Math.random() * numberOfDragPoints))
            handleCreate(rand)
        }
    }
    else
        initiatePlayer1()
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
    items.trigTuxMove.stop();
    stopper = true;
    shouldComputerPlay();
    items.player2score.endTurn();
    items.player1score.beginTurn();
    items.playSecond = !items.playSecond
    initLevel()
}

//Initial values at the start of game when its player 1 turn
function initiatePlayer1() {
    items.player2score.endTurn();
    items.player1score.beginTurn();

    items.firstInitial.anchors.right = undefined
    items.firstInitial.anchors.top = items.player1score.bottom
    items.firstInitial.anchors.left = items.player1score.left

    items.secondInitial.anchors.left = undefined
    items.secondInitial.anchors.right = items.player2score.right
    items.secondInitial.anchors.top = items.player2score.bottom
}

//Initial values at the start of game when its player 1 turn
function initiatePlayer2() {

    items.player1score.endTurn();
    items.player2score.beginTurn();

    items.secondInitial.anchors.right = undefined
    items.secondInitial.anchors.top = items.player1score.bottom
    items.secondInitial.anchors.left = items.player1score.left

    items.firstInitial.anchors.left = undefined
    items.firstInitial.anchors.right = items.player2score.right
    items.firstInitial.anchors.top = items.player2score.bottom
}

//Change scale of score boxes according to turns
function changeScale() {
   if(items.playSecond) {
        if(items.turn % 2 == 0) {
            items.player2score.beginTurn();
            items.player1score.endTurn();
        }
        else {
            items.player1score.beginTurn();
            items.player2score.endTurn();
        }
    }
    else {
        if(items.turn % 2 == 0) {
            items.player1score.beginTurn();
            items.player2score.endTurn();
        }
        else {
            items.player2score.beginTurn();
            items.player1score.endTurn();
        }
    }
}

//Create the piece at given position
function handleCreate(index) {
    items.pieceBeingMoved = true
    currentPiece = currentRepeater.itemAt(items.turn / 2)
    if(currentPiece.state == "2") {
        items.secondPieceNumberCount--
        numberOfSecondPieces++
    }
    else {
        items.firstPieceNumberCount--
        numberOfFirstPieces++
    }
    currentPiece.move(items.dragPoints.itemAt(index))
}

function secondPhase() {
    items.firstPhase = false
    for (var i = 0 ; i < numberOfDragPoints ; ++i) {
        if(items.dragPoints.itemAt(i).state != "1" && items.dragPoints.itemAt(i).state != "2")
            items.dragPoints.itemAt(i).state = "EMPTY"
    }

    items.instructionTxt = qsTr("Move a piece")
}

function pieceSelected(pieceIndex) {
    currentPiece.isSelected = false
    currentPiece = currentRepeater.itemAt(pieceIndex)
    currentPiece.isSelected = true

    if((currentPiece.state == "1" && numberOfFirstPieces > 3) ||
       (currentPiece.state == "2" && numberOfSecondPieces > 3)) {

        for (var i = 0 ; i < numberOfDragPoints ; ++i) {
            if(items.dragPoints.itemAt(i).state == "EMPTY" || items.dragPoints.itemAt(i).state == "AVAILABLE")
                items.dragPoints.itemAt(i).state = "UNAVAILABLE"
        }

        // Now assign values
        var index = currentRepeater.itemAt(pieceIndex).parentIndex // Drag Point index
        var dragPoint = items.dragPoints.itemAt(index)

        if(dragPoint.leftPoint) {
            if(dragPoint.leftPoint.state == "UNAVAILABLE")
                dragPoint.leftPoint.state = "AVAILABLE"
        }
        if(dragPoint.upperPoint) {
            if(dragPoint.upperPoint.state == "UNAVAILABLE")
                dragPoint.upperPoint.state = "AVAILABLE"
        }
        if(dragPoint.rightPoint) {
            if(dragPoint.rightPoint.state == "UNAVAILABLE")
                dragPoint.rightPoint.state = "AVAILABLE"
        }
        if(dragPoint.lowerPoint) {
            if(dragPoint.lowerPoint.state == "UNAVAILABLE")
                dragPoint.lowerPoint.state = "AVAILABLE"
        }
    }
    else {
        for (var i = 0 ; i < numberOfDragPoints ; ++i) {
            if(items.dragPoints.itemAt(i).state == "EMPTY" || items.dragPoints.itemAt(i).state == "UNAVAILABLE")
                items.dragPoints.itemAt(i).state = "AVAILABLE"
        }
    }
}

function movePiece(index) {
    items.pieceBeingMoved = true
    currentPiece.pieceParent.state = "EMPTY"
    currentPiece.isSelected = false
    for (var i = 0 ; i < numberOfDragPoints ; ++i) {
        if(items.dragPoints.itemAt(i).state != "1" && items.dragPoints.itemAt(i).state != "2")
            items.dragPoints.itemAt(i).state = "EMPTY"
    }
    currentPiece.move(items.dragPoints.itemAt(index))
}

function shouldComputerPlay() {
    if(!twoPlayer) {
        if(items.turn % 2 && items.playSecond == false && stopper == false) {
            items.trigTuxMove.start()
        }
        else if((items.turn % 2 == 0) && items.playSecond && stopper == false) {
            items.trigTuxMove.start()
        }
        else
            items.pieceBeingMoved = false
    }
    else
        items.pieceBeingMoved = false
}

function doMove() {
    if(items.firstPhase) {
        if(items.currentLevel < 4)
            var index = setFirstPhaseMove()
        else {
            var boardPiecesLeft = items.firstPieceNumberCount + items.secondPieceNumberCount
            var board = getBoard()
            var index = alphabeta(depthMax, -9000, 9000, 2, board, boardPiecesLeft, false)
        }
        handleCreate(index)
    }
    else if(items.currentLevel < 4 && ((currentPiece.state == "2" && numberOfFirstPieces > 3) ||
           (currentPiece.state == "1" && numberOfSecondPieces > 3))) {
        var index = setSecondPhaseMove()
        currentPiece = currentRepeater.itemAt(index[0])
        movePiece(index[1])
    }
    else if(items.currentLevel < 4) {
        var index = setThirdPhaseMove()
        currentPiece = currentRepeater.itemAt(index[0])
        movePiece(index[1])
    }
    else {
        var noOfPlayerPieces = items.playSecond ? numberOfSecondPieces : numberOfFirstPieces
        var noOfComputerPieces = items.playSecond ? numberOfFirstPieces : numberOfSecondPieces
        var board = getBoard()
        var index = alphabeta(depthMax, -9000, 9000, 2, board, 0, false)
        currentPiece = currentRepeater.itemAt(items.dragPoints.itemAt(index[0]).pieceIndex)
        movePiece(index[1])
    }
}

function setFirstPhaseMove() {
    //Assigning States -> State "1" or "2" is used for identifying player and computer
    var playerState = items.playSecond ? "2" : "1"
    var computerState = items.playSecond ? "1" : "2"

    if(items.currentLevel > 0) {
        var value = evaluateBoard(computerState)
        if(value != -1)
            return value
    }

    if(items.currentLevel > 1) {
        var value = evaluateBoard(playerState)
        if(value != -1)
            return value
    }

    var found = false
    while (!found) {
        var randno = Math.floor((Math.random() * numberOfDragPoints))
        if(items.dragPoints.itemAt(randno).state == "EMPTY" || items.dragPoints.itemAt(randno).state == "AVAILABLE")
            found = true
    }
    return randno
}

function evaluateBoard(state) {
    for(var i = 0 ; i < numberOfDragPoints ; ++i) {
        if(items.dragPoints.itemAt(i).state == "EMPTY" || items.dragPoints.itemAt(i).state == "AVAILABLE") {
            if(checkMill(i,state))
                return i
        }
    }
    return -1
}

function setSecondPhaseMove() {
    var index = []
    var found = false

    if(items.currentLevel > 0) {
        for(var i = 0 ; i < numberOfPieces ; ++i) {
            var piece = currentRepeater.itemAt(i)
            if(piece.visible) {
                index[0] = i
                if(piece.pieceParent.leftPoint && piece.pieceParent.leftPoint.state == "EMPTY") {
                    if(checkMill(piece.pieceParent.leftPoint.index, piece.state, "left")) {
                        index[1] = piece.pieceParent.leftPoint.index
                        found = true
                        break
                    }
                }
                if(piece.pieceParent.rightPoint && piece.pieceParent.rightPoint.state == "EMPTY") {
                    if(checkMill(piece.pieceParent.rightPoint.index, piece.state, "right")) {
                        index[1] = piece.pieceParent.rightPoint.index
                        found = true
                        break
                    }
                }
                if(piece.pieceParent.upperPoint && piece.pieceParent.upperPoint.state == "EMPTY") {
                    if(checkMill(piece.pieceParent.upperPoint.index, piece.state, "upper")) {
                        index[1] = piece.pieceParent.upperPoint.index
                        found = true
                        break
                    }
                }
                if(piece.pieceParent.lowerPoint && piece.pieceParent.lowerPoint.state == "EMPTY") {
                    if(checkMill(piece.pieceParent.lowerPoint.index, piece.state, "lower")) {
                        index[1] = piece.pieceParent.lowerPoint.index
                        found = true
                        break
                    }
                }
            }
        }
        if(found)
            return index
    }

    var playerState = items.playSecond ? "2" : "1"
    if(items.currentLevel > 1) {
        for(var i = 0 ; i < numberOfPieces ; ++i) {
            var piece = currentRepeater.itemAt(i)
            if(piece.visible) {
                index[0] = i
                if(piece.pieceParent.leftPoint && piece.pieceParent.leftPoint.state == "EMPTY") {
                    if(checkMillPossible(piece.pieceParent.leftPoint.index, playerState)) {
                        index[1] = piece.pieceParent.leftPoint.index
                        found = true
                        break
                    }
                }
                if(piece.pieceParent.rightPoint && piece.pieceParent.rightPoint.state == "EMPTY") {
                    if(checkMillPossible(piece.pieceParent.rightPoint.index, playerState)) {
                        index[1] = piece.pieceParent.rightPoint.index
                        found = true
                        break
                    }
                }
                if(piece.pieceParent.upperPoint && piece.pieceParent.upperPoint.state == "EMPTY") {
                    if(checkMillPossible(piece.pieceParent.upperPoint.index, playerState)) {
                        index[1] = piece.pieceParent.upperPoint.index
                        found = true
                        break
                    }
                }
                if(piece.pieceParent.lowerPoint && piece.pieceParent.lowerPoint.state == "EMPTY") {
                    if(checkMillPossible(piece.pieceParent.lowerPoint.index, playerState)) {
                        index[1] = piece.pieceParent.lowerPoint.index
                        found = true
                        break
                    }
                }
            }
        }
        if(found)
            return index
    }

    var permittedPieceIndex = []
    for(var i = 0 ; i < numberOfPieces ; ++i) {
        if(currentRepeater.itemAt(i).visible) {
            if(checkMovablePieces(currentRepeater.itemAt(i).pieceParent.index))
                permittedPieceIndex.push(i)
        }
    }

    if(!permittedPieceIndex.length) {
        for(var i = 0 ; i < numberOfPieces ; ++i) {
            if(currentRepeater.itemAt(i).visible)
                permittedPieceIndex.push(i)
        }
    }

    var found = false
    while (!found) {
        var randno = Math.floor((Math.random() * permittedPieceIndex.length))
        index[0] = permittedPieceIndex[randno]
        var permittedPointIndex = []
        var dragPoint = currentRepeater.itemAt(index[0]).pieceParent

        if(dragPoint.leftPoint && dragPoint.leftPoint.state == "EMPTY") {
            permittedPointIndex.push(dragPoint.leftPoint.index)
        }
        if(dragPoint.rightPoint && dragPoint.rightPoint.state == "EMPTY") {
            permittedPointIndex.push(dragPoint.rightPoint.index)
        }
        if(dragPoint.upperPoint && dragPoint.upperPoint.state == "EMPTY") {
            permittedPointIndex.push(dragPoint.upperPoint.index)
        }
        if(dragPoint.lowerPoint && dragPoint.lowerPoint.state == "EMPTY") {
            permittedPointIndex.push(dragPoint.lowerPoint.index)
        }
        if(permittedPointIndex.length) {
            var randNo = Math.floor((Math.random() * permittedPointIndex.length))
            index[1] = permittedPointIndex[randNo]
            found = true
        }
    }
    return index
}

function checkMillPossible(index, state) {

   // thirdPhase is true if opponent can move its piece anywhere
   var thirdPhase = (items.playSecond && numberOfSecondPieces < 4) || (!items.playSecond && numberOfFirstPieces < 4)
   var dragPoint = items.dragPoints.itemAt(index)

   if(dragPoint.leftPoint && dragPoint.leftPoint.leftPoint) {
        if(state == dragPoint.leftPoint.state && state == dragPoint.leftPoint.leftPoint.state) {
            if((dragPoint.upperPoint && state == dragPoint.upperPoint.state) ||
               (dragPoint.lowerPoint && state == dragPoint.lowerPoint.state) || thirdPhase)
                return true;
        }
    }
    if(dragPoint.upperPoint && dragPoint.upperPoint.upperPoint) {
        if(state == dragPoint.upperPoint.state && state == dragPoint.upperPoint.upperPoint.state) {
            if((dragPoint.leftPoint && state == dragPoint.leftPoint.state) ||
               (dragPoint.rightPoint && state == dragPoint.rightPoint.state) || thirdPhase)
                return true;
        }
    }
    if(dragPoint.rightPoint && dragPoint.rightPoint.rightPoint) {
        if(state == dragPoint.rightPoint.state && state == dragPoint.rightPoint.rightPoint.state) {
            if((dragPoint.upperPoint && state == dragPoint.upperPoint.state) ||
               (dragPoint.lowerPoint && state == dragPoint.lowerPoint.state) || thirdPhase)
                return true;
        }
    }
    if(dragPoint.lowerPoint && dragPoint.lowerPoint.lowerPoint) {
        if(state == dragPoint.lowerPoint.state && state == dragPoint.lowerPoint.lowerPoint.state) {
            if((dragPoint.leftPoint && state == dragPoint.leftPoint.state) ||
               (dragPoint.rightPoint && state == dragPoint.rightPoint.state) || thirdPhase)
                return true;
        }
    }
    if(dragPoint.lowerPoint && dragPoint.upperPoint) {
        if(state == dragPoint.lowerPoint.state && state == dragPoint.upperPoint.state) {
            if((dragPoint.leftPoint && state == dragPoint.leftPoint.state) ||
               (dragPoint.rightPoint && state == dragPoint.rightPoint.state) || thirdPhase)
                return true;
        }
    }
    if(dragPoint.leftPoint && dragPoint.rightPoint) {
        if(state == dragPoint.leftPoint.state && state == dragPoint.rightPoint.state) {
            if((dragPoint.upperPoint && state == dragPoint.upperPoint.state) ||
               (dragPoint.lowerPoint && state == dragPoint.lowerPoint.state) || thirdPhase)
                return true;
        }
    }
    return false;
}

function setThirdPhaseMove() {

    //Assigning States -> State "1" or "2" is used for identifying player and computer
    var playerState = items.playSecond ? "2" : "1"
    var computerState = items.playSecond ? "1" : "2"
    var index = []

    if(items.currentLevel > 1) {
        for(var i = 0 ; i < numberOfDragPoints ; ++i) {
            if(items.dragPoints.itemAt(i).state == "EMPTY") {
                var value = checkMillThirdPhase(i, computerState)
                if(value != -1) {
                    index[0] = value
                    index[1] = i
                    return index
                }
            }
        }
    }

    var permittedPieceIndex = []
    for(var i = 0 ; i < numberOfPieces ; ++i) {
        if(currentRepeater.itemAt(i).visible) {
            if(!checkMillPossible(currentRepeater.itemAt(i).pieceParent.index, playerState)) {
                permittedPieceIndex.push(i)
            }
        }
    }

    if(!permittedPieceIndex.length) {
        for(var i = 0 ; i < numberOfPieces ; ++i) {
            if(currentRepeater.itemAt(i).visible)
                permittedPieceIndex.push(i)
        }
    }

    var randno = Math.floor((Math.random() * permittedPieceIndex.length))
    index[0] = permittedPieceIndex[randno]

    if(items.currentLevel > 2) {
        for(var i = 0 ; i < numberOfDragPoints ; ++i) {
            if(items.dragPoints.itemAt(i).state == "EMPTY") {
                if(checkMillPossible(i,playerState)) {
                    index[1] = i
                    return index
                }
            }
        }
    }

    for(var i = 0 ; i < numberOfDragPoints ; ++i) {
        var dragPoint = items.dragPoints.itemAt(i)

        if(dragPoint.state == "EMPTY" &&
          ((dragPoint.leftPoint && dragPoint.leftPoint.state == computerState
            && dragPoint.leftPoint.pieceIndex != index[0]) ||
           (dragPoint.rightPoint && dragPoint.rightPoint.state == computerState
            && dragPoint.rightPoint.pieceIndex != index[0]) ||
           (dragPoint.upperPoint && dragPoint.upperPoint.state == computerState
            && dragPoint.upperPoint.pieceIndex != index[0]) ||
           (dragPoint.lowerPoint && dragPoint.lowerPoint.state == computerState
            && dragPoint.lowerPoint.pieceIndex != index[0]))) {
                index[1] = i
                return index
        }
    }

    var permittedPointIndex = []
    for(var i = 0 ; i < numberOfDragPoints ; ++i) {
        if(items.dragPoints.itemAt(i).state == "EMPTY")
            permittedPointIndex.push(i)
    }
    randno = Math.floor((Math.random() * permittedPointIndex.length))
    index[1] = permittedPointIndex[randno]
    return index
}

function checkMillThirdPhase(index, state) {

    var dragPoint = items.dragPoints.itemAt(index)
    if(dragPoint.leftPoint && dragPoint.leftPoint.leftPoint) {
        if(state == dragPoint.leftPoint.state && state == dragPoint.leftPoint.leftPoint.state) {
            for(var i = 0 ; i < numberOfPieces ; ++i) {
                if(currentRepeater.itemAt(i).visible && i != dragPoint.leftPoint.pieceIndex
                   && i != dragPoint.leftPoint.leftPoint.pieceIndex) {
                    return i
                }
            }
        }
    }

    if(dragPoint.upperPoint && dragPoint.upperPoint.upperPoint) {
        if(state == dragPoint.upperPoint.state && state == dragPoint.upperPoint.upperPoint.state) {
            for(var i = 0 ; i < numberOfPieces ; ++i) {
                if(currentRepeater.itemAt(i).visible && i != dragPoint.upperPoint.pieceIndex
                   && i != dragPoint.upperPoint.upperPoint.pieceIndex) {
                       return i
                }
            }
        }
    }
    if(dragPoint.rightPoint && dragPoint.rightPoint.rightPoint) {
        if(state == dragPoint.rightPoint.state && state == dragPoint.rightPoint.rightPoint.state) {
            for(var i = 0 ; i < numberOfPieces ; ++i) {
                if(currentRepeater.itemAt(i).visible && i != dragPoint.rightPoint.pieceIndex
                   && i != dragPoint.rightPoint.rightPoint.pieceIndex) {
                       return i
                }
            }
        }
    }
    if(dragPoint.lowerPoint && dragPoint.lowerPoint.lowerPoint) {
        if(state == dragPoint.lowerPoint.state && state == dragPoint.lowerPoint.lowerPoint.state) {
            for(var i = 0 ; i < numberOfPieces ; ++i) {
                if(currentRepeater.itemAt(i).visible && i != dragPoint.lowerPoint.pieceIndex
                   && i != dragPoint.lowerPoint.lowerPoint.pieceIndex) {
                       return i
                }
            }
        }
    }
    if(dragPoint.lowerPoint && dragPoint.upperPoint) {
        if(state == dragPoint.lowerPoint.state && state == dragPoint.upperPoint.state) {
            for(var i = 0 ; i < numberOfPieces ; ++i) {
                if(currentRepeater.itemAt(i).visible && i != dragPoint.lowerPoint.pieceIndex
                   && i != dragPoint.upperPoint.pieceIndex) {
                       return i
                }
            }
        }
    }
    if(dragPoint.leftPoint && dragPoint.rightPoint) {
        if(state == dragPoint.leftPoint.state && state == dragPoint.rightPoint.state) {
            for(var i = 0 ; i < numberOfPieces ; ++i) {
                if(currentRepeater.itemAt(i).visible && i != dragPoint.leftPoint.pieceIndex
                   && i != dragPoint.rightPoint.pieceIndex) {
                       return i
                }
            }
        }
    }
    return -1
}

// continueGame() called by Piece when its animation stops and checkMill(piece) is false or
// called after removePiece(index) has removed a piece
function continueGame() {
    items.turn ++
    if(items.turn == (2 * numberOfPieces) && items.firstPhase) {
        secondPhase()
        items.turn --
        checkGameWon()
        return
    }
    if(items.turn % 2) {
        currentRepeater = items.secondPlayerPieces
        otherRepeater = items.firstPlayerPieces
    }
    else {
        currentRepeater = items.firstPlayerPieces
        otherRepeater = items.secondPlayerPieces
    }
    changeScale()
    shouldComputerPlay();
}

// position value is only used when checkMill is called by setSecondPhaseMove or getSecondPhaseRemoveIndex function
// Else it is declared as undefined by default
function checkMill(index, state, position) {

    var dragPoint = items.dragPoints.itemAt(index)
    if(dragPoint.leftPoint && dragPoint.leftPoint.leftPoint && position != "left" && position != "right") {
        if(state == dragPoint.leftPoint.state && state == dragPoint.leftPoint.leftPoint.state)
            return true;
    }
    if(dragPoint.upperPoint && dragPoint.upperPoint.upperPoint && position != "upper" && position != "lower") {
        if(state == dragPoint.upperPoint.state && state == dragPoint.upperPoint.upperPoint.state)
            return true;
    }
    if(dragPoint.rightPoint && dragPoint.rightPoint.rightPoint && position != "right" && position != "left") {
        if(state == dragPoint.rightPoint.state && state == dragPoint.rightPoint.rightPoint.state)
            return true;
    }
    if(dragPoint.lowerPoint && dragPoint.lowerPoint.lowerPoint && position != "lower" && position != "upper") {
        if(state == dragPoint.lowerPoint.state && state == dragPoint.lowerPoint.lowerPoint.state)
            return true;
    }
    if(dragPoint.lowerPoint && dragPoint.upperPoint && position != "lower" && position != "upper") {
        if(state == dragPoint.lowerPoint.state && state == dragPoint.upperPoint.state)
            return true;
    }
    if(dragPoint.leftPoint && dragPoint.rightPoint && position != "left" && position != "right") {
        if(state == dragPoint.leftPoint.state && state == dragPoint.rightPoint.state)
            return true;
    }
    return false;
}

//check movable pieces
function checkMovablePieces(index) {
    var dragPoint = items.dragPoints.itemAt(index)
    if(dragPoint.leftPoint && dragPoint.leftPoint.state == "EMPTY") {
        return true;
    }
    if(dragPoint.rightPoint && dragPoint.rightPoint.state == "EMPTY") {
        return true;
    }
    if(dragPoint.upperPoint && dragPoint.upperPoint.state == "EMPTY") {
        return true;
    }
    if(dragPoint.lowerPoint && dragPoint.lowerPoint.state == "EMPTY") {
        return true;
    }
    return false;
}

// updateRemovablePiece called by Piece when its animation stops and checkMill(piece) is true
function updateRemovablePiece() {

    if(twoPlayer || ((items.turn % 2) && items.playSecond) || (!(items.turn % 2) && !items.playSecond)) {
        var foundOne = false
        for(var i = 0 ; i < numberOfPieces ; ++i) {
            var piece = otherRepeater.itemAt(i)
            if(piece.parentIndex != -1) {
                if(!checkMill(piece.parentIndex, piece.state) && piece.visible) {
                    foundOne = true
                    piece.canBeRemoved = true // Mark pieces of other player for removal
                }
            }
        }
        if(!foundOne) {
            for(var i = 0 ; i < numberOfPieces ; ++i) {
                if(otherRepeater.itemAt(i).parentIndex != -1 && otherRepeater.itemAt(i).visible)
                    otherRepeater.itemAt(i).canBeRemoved = true
            }
        }
        items.instructionTxt = qsTr("Remove a piece")
    }
    else if(items.currentLevel < 4) {
        if(items.firstPhase)
            otherRepeater.itemAt(getFirstPhaseRemoveIndex()).remove()
        else
            otherRepeater.itemAt(getSecondPhaseRemoveIndex()).remove()
    }
    else {
        var board = getBoard()
        var boardPiecesLeft = items.firstPieceNumberCount + items.secondPieceNumberCount
        var index = alphabeta(depthMax, -9000, 9000, 2, board, boardPiecesLeft, true)
        var pieceIndex = items.dragPoints.itemAt(index).pieceIndex
        otherRepeater.itemAt(pieceIndex).remove()
    }
}

function getFirstPhaseRemoveIndex() {

    var playerState = items.playSecond ? "2" : "1"
    var permittedIndex = [];
    for(var i = 0 ; i < numberOfPieces ; ++i) {
        var piece = otherRepeater.itemAt(i)
        if(piece.parentIndex != -1) {
            if(!checkMill(piece.parentIndex, piece.state) && piece.visible)
                permittedIndex.push(i)
        }
    }
    if(permittedIndex.length == 0) {
        for(var i = 0 ; i < numberOfPieces ; ++i) {
            if((otherRepeater.itemAt(i).parentIndex != -1) && (otherRepeater.itemAt(i).visible))
                permittedIndex.push(i)
        }
    }

    if(items.currentLevel > 3) {
        var index = evaluateBoard(playerState)
        if(index != -1) {
            var value = -1
            var dragPoint = items.dragPoints.itemAt(index)
            if(dragPoint.leftPoint)
                value = checkRemovedIndex(playerState, dragPoint.leftPoint,
                                          dragPoint.leftPoint.leftPoint, permittedIndex)
            if(value != -1)
                return value

            if(dragPoint.upperPoint)
                value = checkRemovedIndex(playerState, dragPoint.upperPoint,
                                          dragPoint.upperPoint.upperPoint, permittedIndex)
            if(value != -1)
                return value

            if(dragPoint.rightPoint)
                value = checkRemovedIndex(playerState, dragPoint.rightPoint,
                                          dragPoint.rightPoint.rightPoint, permittedIndex)
            if(value != -1)
                return value

            if(dragPoint.lowerPoint)
                value = checkRemovedIndex(playerState, dragPoint.lowerPoint,
                                          dragPoint.lowerPoint.lowerPoint, permittedIndex)
            if(value != -1)
                return value

            if(dragPoint.lowerPoint)
                value = checkRemovedIndex(playerState, dragPoint.lowerPoint,
                                          dragPoint.upperPoint, permittedIndex)
            if(value != -1)
                return value

            if(dragPoint.leftPoint)
                value = checkRemovedIndex(playerState, dragPoint.leftPoint,
                                          dragPoint.rightPoint, permittedIndex)
            if(value != -1)
                return value
        }
    }

    var randno = Math.floor((Math.random() * permittedIndex.length))
    return permittedIndex[randno]
}

function checkRemovedIndex(state,first,second,permittedIndex) {

    if(second) {
        if(state == first.state && state == second.state) {
                if(Math.floor((Math.random() * 2))) {
                    for (var i = 0 ; i < permittedIndex.length ; ++ i) {
                        if(permittedIndex[i] == first.pieceIndex)
                            return first.pieceIndex
                    }
                    for (var i = 0 ; i < permittedIndex.length ; ++ i) {
                        if(permittedIndex[i] == second.pieceIndex)
                            return second.pieceIndex
                    }
                }
                else {
                    for (var i = 0 ; i < permittedIndex.length ; ++ i) {
                        if(permittedIndex[i] == second.pieceIndex)
                            return second.pieceIndex
                    }
                    for (var i = 0 ; i < permittedIndex.length ; ++ i) {
                        if(permittedIndex[i] == first.pieceIndex)
                            return first.pieceIndex
                    }
                }
        }
    }
    return -1
}

function getSecondPhaseRemoveIndex() {
    var permittedIndex = [];
    for(var i = 0 ; i < numberOfPieces ; ++i) {
        var piece = otherRepeater.itemAt(i)
        if(piece.parentIndex != -1) {
            if(piece.visible && !checkMill(piece.parentIndex, piece.state))
                permittedIndex.push(i)
        }
    }

    if(permittedIndex.length == 0) {
        for(var i = 0 ; i < numberOfPieces ; ++i) {
            if((otherRepeater.itemAt(i).parentIndex != -1) && (otherRepeater.itemAt(i).visible))
                permittedIndex.push(i)
        }
    }

    for(var index = 0 ; index < permittedIndex.length ; ++index) {
        var i = permittedIndex[index]
        var piece = otherRepeater.itemAt(i)

        if(piece.visible) {
            if(piece.pieceParent.leftPoint && piece.pieceParent.leftPoint.state == "EMPTY") {
                if(checkMill(piece.pieceParent.leftPoint.index, piece.state, "left")) {
                    return i
                }
            }
            if(piece.pieceParent.rightPoint && piece.pieceParent.rightPoint.state == "EMPTY") {
                if(checkMill(piece.pieceParent.rightPoint.index, piece.state, "right")) {
                    return i
                }
            }
            if(piece.pieceParent.upperPoint && piece.pieceParent.upperPoint.state == "EMPTY") {
                if(checkMill(piece.pieceParent.upperPoint.index, piece.state, "upper")) {
                    return i
                }
            }
            if(piece.pieceParent.lowerPoint && piece.pieceParent.lowerPoint.state == "EMPTY") {
                if(checkMill(piece.pieceParent.lowerPoint.index, piece.state, "lower")) {
                    return i
                }
            }
        }
    }

    return getFirstPhaseRemoveIndex()
}

// removePiece(index) called by Piece when items.pieceBeingRemoved is true
function removePiece(index) {
    otherRepeater.itemAt(index).visible = false
    // Decrease number of pieces of other player by 1
    if(items.turn % 2)
        numberOfFirstPieces --
    else
        numberOfSecondPieces --
    if(items.firstPhase) {
        items.instructionTxt = qsTr("Place a piece")
        continueGame()
    }
    else
        checkGameWon()
}

function removePieceSelected(index) {
    otherRepeater.itemAt(index).pieceParent.state = items.firstPhase ? "AVAILABLE" : "EMPTY"
    for(var i = 0 ; i < numberOfPieces ; ++i)
        otherRepeater.itemAt(i).canBeRemoved = false
}

function checkGameWon() {
    // Check if other player can mover or not
    var flag = true;
    for (var i = 0 ; i < numberOfPieces ; ++i) {
        var piece = otherRepeater.itemAt(i)
        if(piece.visible) {
            if((piece.pieceParent.leftPoint && piece.pieceParent.leftPoint.state == "EMPTY") ||
               (piece.pieceParent.rightPoint && piece.pieceParent.rightPoint.state == "EMPTY") ||
               (piece.pieceParent.upperPoint && piece.pieceParent.upperPoint.state == "EMPTY") ||
               (piece.pieceParent.lowerPoint && piece.pieceParent.lowerPoint.state == "EMPTY")) {
                    flag = false
                    break
            }
        }
    }

    if(((numberOfSecondPieces < 3 && !items.playSecond) || (numberOfFirstPieces < 3 && items.playSecond)) ||
       (flag && ((currentPiece.state == "1" && !items.playSecond && numberOfSecondPieces > 3) ||
       (currentPiece.state == "2" && items.playSecond && numberOfFirstPieces > 3)))) {
        items.gameDone = true
        items.player1score.win();
        items.player2score.endTurn();
        items.instructionTxt = qsTr("Congratulations")
        items.bonus.good("flower")
        if(twoPlayer) {
            items.instructionTxt = qsTr("Congratulations Player 1")
        }
    }
    else if(((numberOfFirstPieces < 3 && !items.playSecond) || (numberOfSecondPieces < 3 && items.playSecond)) ||
            (flag && ((currentPiece.state == "2" && !items.playSecond && numberOfFirstPieces > 3) ||
            (currentPiece.state == "1" && items.playSecond && numberOfSecondPieces > 3)))) {
        items.gameDone = true
        items.player2score.win();
        items.player1score.endTurn();
        if(twoPlayer) {
            items.bonus.good("flower")
            items.instructionTxt = qsTr("Congratulations Player 2")
        }
        else {
            items.instructionTxt = qsTr("Try again")
            items.bonus.bad("tux")
        }
    }
    else {
        // Continue the game
        items.instructionTxt = qsTr("Move a piece")
        continueGame()
    }
}

function getBoard() {
    var board = []
    for (var i = 0 ; i < numberOfDragPoints ; ++i) {
        if(items.dragPoints.itemAt(i).state == "1") {
            if(items.playSecond)
                board.push(2)
            else
                board.push(1)
        }
        else if(items.dragPoints.itemAt(i).state == "2") {
            if(items.playSecond)
                board.push(1)
            else
                board.push(2)
        }
        else
            board.push(0)
    }
    return board
}

function alphabeta(depth, alpha, beta, player, board, boardPiecesLeft, mill) {

    var firstPhase = boardPiecesLeft != 0
    var values = getValue(board, firstPhase, player)
    var value = values.value
    var myToBeMill = 0
    var oppToBeMill = 0

    if(value != 9000 && value != -9000 && depth == 0) {
        var lost = -8500
        var win = 8500
        var toBeMill = 1.8
        var myMillReachable = false
        var oppMillReachable = false
        var playerPieces = values.playerPieces
        var computerPieces = values.computerPieces

        for (var i = 0 ; i < numberOfDragPoints ; ++i) {
            if (board[i] == 0) {
                if(checkMillBoardPossible(board, i, 2, firstPhase, computerPieces)) {
                    myToBeMill++
                    if(positionReachable(board, i, 1, firstPhase, playerPieces))
                        myMillReachable = true
                }
                if(checkMillBoardPossible(board, i, 1, firstPhase, playerPieces)) {
                    oppToBeMill++
                    if(positionReachable(board, i, 2, firstPhase, computerPieces))
                        oppMillReachable = true
                }
            }
        }

        if(myToBeMill > 2 && playerPieces == 4 && !firstPhase && (mill == false || player == 2)){
            value: win - 50
        }
        else if(oppToBeMill > 2 && computerPieces == 4 && !firstPhase && (mill == false || player == 1)) {
            value: lost + 50
        }
        else {
            if(myToBeMill > 0 && myMillReachable && player == 1 && ((playerPieces != 3 &&
               !firstPhase) || firstPhase))
                myToBeMill--
            if(oppToBeMill > 0 && oppMillReachable && player == 2 && ((computerPieces != 3 &&
               !firstPhase) || firstPhase))
                oppToBeMill--

            if(myToBeMill > 0 && playerPieces == 3 && player == 2 && !firstPhase){
                value = win
            }
            else if(oppToBeMill > 0 && computerPieces == 3 && player == 1 && !firstPhase){
                value = lost
            }
            else if(myToBeMill > 1 && playerPieces == 3 && player == 1 && !firstPhase &&
                    !mill){
                value = win - 25
            }
            else if(oppToBeMill > 1 && computerPieces == 3 && player == 2 && !firstPhase &&
                    !mill){
                value = lost + 25
            }
            else
                value += toBeMill * (myToBeMill - oppToBeMill)
        }

        if(mill && depth == 0){// && value < 8000 && value > -8000) {
            if(player == 2 && playerPieces == 3 && !firstPhase)
                value = 9000
            else if(player == 1 && computerPieces == 3 && !firstPhase)
                value = -9000
            else if(player == 2) {
                if(oppToBeMill == 0)
                    value += 1.4
                else if(oppToBeMill == 1)
                    value += 3.2
                else
                    value += 4.8
            }
            else {
                if(myToBeMill == 0)
                    value -= 1.4
                else if(myToBeMill == 1)
                    value -= 3.2
                else
                    value -= 4.8
            }
        }

        if(mill && depth == 1 && !firstPhase && player == 2 && playerPieces == 4
           && oppToBeMill > 0)
           return value + 3.2

        value = Math.round(value * 1000) / 1000
    }

    if(depth == 0 || ((value == 9000 || value < -8000) && depth != depthMax)) {
        return value
    }

    if(player == 2) {
        var scores = []
        if(mill) {
            var removableIndex = getRemovableIndexFromBoard(board, 1)
            var found = false
            for(var i = 0 ; i < removableIndex.length ; ++i) {
                board[removableIndex[i]] = 0
                var newAlpha = alphabeta(depth - 1, alpha, beta, 1, board, boardPiecesLeft, false)
                board[removableIndex[i]] = 1
                if(newAlpha >= alpha) {
                    found = true
                    alpha = newAlpha
                    scores[i] = alpha
                }
                if(beta < alpha) break
            }
            if(depth == depthMax) {
                var max = -9000;
                for(var i = 0; i < scores.length; i++) {
                    if(scores[i] != undefined && scores[i] > max)
                        max = scores[i]
                }
                var index = []
                for(var i = 0; i < scores.length; i++) {
                    if(scores[i] != undefined && scores[i] == max)
                        index.push(i)
                }
                var randno = Math.floor((Math.random() * index.length))
                return removableIndex[index[randno]]
            }
            if(found)
                return alpha
            else
                return alpha - 1000
        }
        else if(firstPhase) {
            var scores = []
            var moves = generateMove(board, 2, 0, true)
            for(var i = 0 ; i < moves.length ; ++i) {
                var move = moves[i]
                board[move] = 2
                boardPiecesLeft--
                var newAlpha
                if(checkMillBoard(board, move) != 0)
                    newAlpha = alphabeta(depth - 1, alpha, beta, 2, board, boardPiecesLeft, true)
                else
                    newAlpha = alphabeta(depth - 1, alpha, beta, 1, board, boardPiecesLeft, false)
                boardPiecesLeft++
                board[move] = 0
                if(newAlpha >= alpha) {
                    alpha = newAlpha
                    scores[i] = alpha
                }
                if(beta < alpha) break
            }
            if(depth == depthMax) {
                var max = -9000;
                for(var i = 0; i < scores.length; i++) {
                    if(scores[i] != undefined && scores[i] > max)
                        max = scores[i]
                }
                var index = []
                for(var i = 0; i < scores.length; i++) {
                    if(scores[i] != undefined && scores[i] == max)
                        index.push(i)
                }
                var randno = Math.floor((Math.random() * index.length))
                return moves[index[randno]]
            }
            return alpha
        }
        else {
            var computerPointsIndex = []
            for (var i = 0 ; i < numberOfDragPoints ; ++i) {
                if(board[i] == 2)
                    computerPointsIndex.push(i)
            }
            var scores = []
            for (var i = 0 ; i < computerPointsIndex.length ; ++i) {
                var computerPoint = computerPointsIndex[i]
                var moves = generateMove(board, 2, computerPoint, false)
                scores[i] = []
                for(var j = 0 ; j < moves.length ; ++j) {
                    var move = moves[j]
                    board[computerPoint] = 0
                    board[move] = 2
                    var newAlpha
                    if(checkMillBoard(board, move) != 0)
                        newAlpha = alphabeta(depth - 1, alpha, beta, 2, board, boardPiecesLeft, true)
                    else
                        newAlpha = alphabeta(depth - 1, alpha, beta, 1, board, boardPiecesLeft, false)
                    board[computerPoint] = 2
                    board[move] = 0
                    if(newAlpha >= alpha) {
                        alpha = newAlpha
                        scores[i][move] = alpha
                    }
                    if(beta < alpha) break
                }
                if(beta < alpha) break
            }
            if(depth == depthMax) {
                var max = -9000;
                for(var i = 0; i < scores.length; i++) {
                    for(var j = 0 ; j < scores[i].length ; j++) {
                        if(scores[i][j] != undefined) {
                            if(scores[i][j] > max) {
                                max = scores[i][j]
                            }
                        }
                    }
                }
                var moveIndex = []
                for(var i = 0; i < scores.length; i++) {
                    for(var j = 0 ; j < scores[i].length ; j++) {
                        if(scores[i][j] != undefined && scores[i][j] == max) {
                            var index = []
                            index[0] = computerPointsIndex[i]
                            index[1] = j
                            moveIndex.push(index)
                        }
                    }
                }
                var randno = Math.floor((Math.random() * moveIndex.length))
                return moveIndex[randno]
            }
            return alpha
        }
    }
    else {
        if(mill) {
            var removableIndex = getRemovableIndexFromBoard(board, 2)
            for(var i = 0 ; i < removableIndex.length ; ++i) {
                board[removableIndex[i]] = 0
                if(playerPieces == 3 && computerPieces == 4 && !firstPhase)
                    beta = Math.min(beta, alphabeta(depth, alpha, beta, 2, board, boardPiecesLeft, false))
                board[removableIndex[i]] = 2
                if(beta < alpha) break
            }
            return beta
        }
        else if(boardPiecesLeft != 0) { // First Phase
            var moves = generateMove(board, 1, 0, true)
            for(var i = 0 ; i < moves.length ; ++i) {
                var move = moves[i]
                board[move] = 1
                boardPiecesLeft--
                if(checkMillBoard(board, move) != 0)
                    beta = Math.min(beta, alphabeta(depth - 1, alpha, beta, 1, board, boardPiecesLeft, true))
                else
                    beta = Math.min(beta, alphabeta(depth - 1, alpha, beta, 2, board, boardPiecesLeft, false))
                boardPiecesLeft++
                board[move] = 0
                if(beta < alpha) break
            }
            return beta
        }
        else {
            var playerPointsIndex = []
            for (var i = 0 ; i < numberOfDragPoints ; ++i) {
                if(board[i] == 1)
                    playerPointsIndex.push(i)
            }
            for (var i = 0 ; i < playerPointsIndex.length ; ++i) {
                var playerPoint = playerPointsIndex[i]
                var moves = generateMove(board, 1, playerPoint, false)
                for(var j = 0 ; j < moves.length ; ++j) {
                    var move = moves[j]
                    board[playerPoint] = 0
                    board[move] = 1
                    if(checkMillBoard(board, move) != 0)
                        beta = Math.min(beta, alphabeta(depth - 1, alpha, beta, 1, board, boardPiecesLeft, true))
                    else
                        beta = Math.min(beta, alphabeta(depth - 1, alpha, beta, 2, board, boardPiecesLeft, false))
                    board[playerPoint] = 1
                    board[move] = 0
                    if(beta < alpha) break
                }
                if(beta < alpha) break
            }
            return beta
        }
    }
}

function getRemovableIndexFromBoard(board, state) {

    var index = []
    for (var i = 0 ; i < numberOfDragPoints ; ++i) {
        if (board[i] == state && checkMillBoard(board, i) == 0)
            index.push(i)
    }
    if(index.length == 0) {
        for (var i = 0 ; i < numberOfDragPoints ; ++i) {
            if (board[i] == state)
                index.push(i)
        }
    }
    return index
}

function getValue(board, firstPhase, player) {

    var value = 0.0
    var material = 1.0
    var freedom = 0.2
    var mills = 0.8
    var lost = -8500
    var win = 8500
    var toBeMill = 1.8

    // ========== material ==========

    var computerPieces = getNumberOfPieces(board, 2)
    var playerPieces = getNumberOfPieces(board, 1)

    if (computerPieces < 3 && !firstPhase) {
        return {value: lost - 500}
    }

    if (playerPieces < 3 && !firstPhase) {
        return {value: win + 500}
    }

    value += material * (computerPieces - playerPieces)

    // ========== mills ==========

    var computerMills = 0
    var playerMills = 0
    var computerMillsIndex = []
    var playerMillsIndex = []

    for (var i = 0 ; i < numberOfDragPoints ; ++i) {
        if(computerMillsIndex.indexOf(i) == -1 && board[i] == 2) {
            computerMills += checkMillBoard(board, i, computerMillsIndex)
        }
        else if(playerMillsIndex.indexOf(i) == -1 && board[i] == 1) {
            playerMills += checkMillBoard(board, i, playerMillsIndex)
        }
    }
    value += mills * (computerMills - playerMills)

    // ========== freedom ==========
    if(playerPieces != 3 || computerPieces != 3 || firstPhase) {
        var myFreedom = 0
        var oppFreedom = 0
        for (var i = 0 ; i < numberOfDragPoints ; ++i) {
            if (board[i] == 2)
                myFreedom += positionAchievable(board, i, computerPieces, firstPhase)
            else if (board[i] == 1)
                oppFreedom += positionAchievable(board, i, playerPieces, firstPhase)
        }

        if (myFreedom == 0 && !firstPhase){
            return {value: lost, computerPieces: computerPieces, playerPieces: playerPieces}
        }
        if (oppFreedom == 0 && !firstPhase){
            return {value: win + 500, computerPieces: computerPieces, playerPieces: playerPieces}
        }

        if(((computerPieces > 3 && playerPieces == 3 && computerPieces < 6) ||
           (playerMills > 0 && playerPieces == 4)) && !firstPhase)
            freedom = 0
        value += freedom * (myFreedom - oppFreedom)
    }
    value = Math.round(value * 1000) / 1000

    return {value: value, computerPieces: computerPieces, playerPieces: playerPieces}
}

function getNumberOfPieces(board, state) {
    var no = 0
    for (var i = 0 ; i < numberOfDragPoints ; ++ i) {
            if (board[i] == state)
                no ++
    }
    return no
}

function positionAchievable(board, index, noOfBoardPieces, firstPhase) {
    var positions = 0
    if(noOfBoardPieces == 3 && !firstPhase) {
        for (var i = 0 ; i < numberOfDragPoints ; ++ i) {
            if (board[i] == 0)
                positions ++
        }
    }
    else {
        var point = items.dragPoints.itemAt(index)
        if(point.leftPoint && board[point.leftPoint.index] == 0)
            positions ++
        if(point.rightPoint && board[point.rightPoint.index] == 0)
            positions ++
        if(point.upperPoint && board[point.upperPoint.index] == 0)
            positions ++
        if(point.lowerPoint && board[point.lowerPoint.index] == 0)
            positions ++
    }
    return positions
}

function positionReachable(board, index, state, firstPhase, noOfBoardPieces) {
    if(noOfBoardPieces == 3 || firstPhase)
        return true
    else {
        var point = items.dragPoints.itemAt(index)
        if(point.leftPoint && board[point.leftPoint.index] == state)
            return true
        if(point.rightPoint && board[point.rightPoint.index] == state)
            return true
        if(point.upperPoint && board[point.upperPoint.index] == state)
            return true
        if(point.lowerPoint && board[point.lowerPoint.index] == state)
            return true
        return false
    }
}

function checkMillBoard(board, index, millsIndex) {
    var point = items.dragPoints.itemAt(index)
    var state = board[index]
    var mills = 0
    if (millsIndex == undefined)
        millsIndex = []

    if(point.leftPoint && point.leftPoint.leftPoint && state == board[point.leftPoint.index]
       && state == board[point.leftPoint.leftPoint.index]) {
        mills ++
        millsIndex.push(point.leftPoint.index)
        millsIndex.push(point.leftPoint.leftPoint.index)
    }
    if(point.upperPoint && point.upperPoint.upperPoint && state == board[point.upperPoint.index]
       && state == board[point.upperPoint.upperPoint.index]) {
        mills ++
        millsIndex.push(point.upperPoint.index)
        millsIndex.push(point.upperPoint.upperPoint.index)
    }
    if(point.rightPoint && point.rightPoint.rightPoint && state == board[point.rightPoint.index]
       && state == board[point.rightPoint.rightPoint.index]) {
        mills ++
        millsIndex.push(point.rightPoint.index)
        millsIndex.push(point.rightPoint.rightPoint.index)
    }
    if(point.lowerPoint && point.lowerPoint.lowerPoint && state == board[point.lowerPoint.index]
       && state == board[point.lowerPoint.lowerPoint.index]) {
        mills ++
        millsIndex.push(point.lowerPoint.index)
        millsIndex.push(point.lowerPoint.lowerPoint.index)
    }
    if(point.lowerPoint && point.upperPoint && state == board[point.lowerPoint.index]
       && state == board[point.upperPoint.index]) {
        mills ++
        millsIndex.push(point.lowerPoint.index)
        millsIndex.push(point.upperPoint.index)
    }
    if(point.leftPoint && point.rightPoint && state == board[point.leftPoint.index]
       && state == board[point.rightPoint.index]) {
        mills ++
        millsIndex.push(point.rightPoint.index)
        millsIndex.push(point.leftPoint.index)
    }
    return mills
}

function checkMillBoardPossible(board, index, state, firstPhase, pieces) {

   var freeMove = pieces == 3 || firstPhase
   var point = items.dragPoints.itemAt(index)

   if(point.leftPoint && point.leftPoint.leftPoint) {
        if(state == board[point.leftPoint.index] && state == board[point.leftPoint.leftPoint.index]) {
            if((point.upperPoint && state == board[point.upperPoint.index]) ||
               (point.lowerPoint && state == board[point.lowerPoint.index]) || freeMove)
                return true;
        }
    }
    if(point.upperPoint && point.upperPoint.upperPoint) {
        if(state == board[point.upperPoint.index] && state == board[point.upperPoint.upperPoint.index]) {
            if((point.leftPoint && state == board[point.leftPoint.index]) ||
               (point.rightPoint && state == board[point.rightPoint.index]) || freeMove)
                return true;
        }
    }
    if(point.rightPoint && point.rightPoint.rightPoint) {
        if(state == board[point.rightPoint.index] && state == board[point.rightPoint.rightPoint.index]) {
            if((point.upperPoint && state == board[point.upperPoint.index]) ||
               (point.lowerPoint && state == board[point.lowerPoint.index]) || freeMove)
                return true;
        }
    }
    if(point.lowerPoint && point.lowerPoint.lowerPoint) {
        if(state == board[point.lowerPoint.index] && state == board[point.lowerPoint.lowerPoint.index]) {
            if((point.leftPoint && state == board[point.leftPoint.index]) ||
               (point.rightPoint && state == board[point.rightPoint.index]) || freeMove)
                return true;
        }
    }
    if(point.lowerPoint && point.upperPoint) {
        if(state == board[point.lowerPoint.index] && state == board[point.upperPoint.index]) {
            if((point.leftPoint && state == board[point.leftPoint.index]) ||
               (point.rightPoint && state == board[point.rightPoint.index]) || freeMove)
                return true;
        }
    }
    if(point.leftPoint && point.rightPoint) {
        if(state == board[point.leftPoint.index] && state == board[point.rightPoint.index]) {
            if((point.upperPoint && state == board[point.upperPoint.index]) ||
               (point.lowerPoint && state == board[point.lowerPoint.index]) || freeMove)
                return true;
        }
    }
    return false;
}

function generateMove(board, state, index, firstPhase) {
    var moves = []
    if(firstPhase || getNumberOfPieces(board, state) == 3) {
        for (var i = 0 ; i < numberOfDragPoints ; ++i) {
            if (board[i] == 0)
                moves.push(i)
        }
    }
    else {
        var point = items.dragPoints.itemAt(index)
        if(point.leftPoint && board[point.leftPoint.index] == 0)
            moves.push(point.leftPoint.index)
        if(point.rightPoint && board[point.rightPoint.index] == 0)
            moves.push(point.rightPoint.index)
        if(point.upperPoint && board[point.upperPoint.index] == 0)
            moves.push(point.upperPoint.index)
        if(point.lowerPoint && board[point.lowerPoint.index] == 0)
            moves.push(point.lowerPoint.index)
    }
    return moves
}


