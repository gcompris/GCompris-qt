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
var stopper     //For stopping game when doing reset
//var dragPoints = []
//var firstPhase
var currentRepeater
var otherRepeater
//var items.pieceBeingRemoved
var numberOfFirstPieces
var numberOfSecondPieces
var numberOfPieces
var numberOfDragPoints
var chance

function start(items_, twoPlayer_) {

    items = items_
    currentLevel = 1
    currentPlayer = 1
    items.player1_score = 0
    items.player2_score = 0
    twoPlayer = twoPlayer_
    numberOfLevel = 6
    numberOfPieces = 9
    numberOfDragPoints = 24
    items.playSecond = false

    // First time Drag point creation
    var dragPointComponent = Qt.createComponent("qrc:/gcompris/src/activities/nine_men_morris/DragPoint.qml")
    if(dragPointComponent.status == dragPointComponent.Error) {
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

    if(!twoPlayer)
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
    items.firstPieceNumberCount = numberOfPieces
    items.secondPieceNumberCount = numberOfPieces
    items.instructionTxt = qsTr("Place a Piece")
    //items.board.sourceSize.width = 3.5 * Math.min(items.background.width / 4 , items.background.height / 6)
    //items.board.anchors.horizontalCenterOffset = -0.18 * items.board.width
    //items.pieces.clear()
    /*for(var y = 0;  y < items.rows; y++) {
        for(var x = 0;  x < items.columns; x++) {
            items.pieces.append({'stateTemp': "invisible"})
        }
    }*/

    // Clear first and second player pieces, and initialize dragPoints
    items.firstPlayerPieces.model.clear()
    items.secondPlayerPieces.model.clear()
    for (var i = 0 ; i < numberOfDragPoints ; ++i)
            items.dragPoints.itemAt(i).state = "AVAILABLE"

    // Create first and second player pieces
    for (var i = 0 ; i < numberOfPieces ; ++i) {
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
    if(items.playSecond) {
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
    if(items.playSecond)
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
    if(tutNum == 1) {
        items.tutorialTxt = qsTr("You and Tux starts with 9 pieces each, and take turns to place " +
                                 "your pieces on to the empty spots (by clicking on the spots) on the board.")
    }
    else if(tutNum == 2) {
        items.tutorialTxt = qsTr("If you form a mill (line of 3 pieces), then select a piece of Tux, and remove " +
                                 "it. Pieces of formed mill can not be removed unless no other pieces are left on board.")
    }
    else if(tutNum == 3) {
        items.tutorialTxt = qsTr("After all the pieces are placed, you and Tux will take turns to move them. " +
                                 "Click on one of your pieces, and then on the adjacent empty spot to move " +
                                 "it there. Green color spot indicates where you can move.")
    }
    else if(tutNum == 4) {
        items.tutorialTxt = qsTr("If you are left with 3 pieces, your pieces will gain the ability to 'fly' " +
                                 "and can be moved to any vacant spot on the board.")
    }
    else if(tutNum == 5) {
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
    if(numberOfLevel <= ++currentLevel) {
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
    if(items.playSecond)
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

   if(items.playSecond) {
        if(items.counter % 2 == 0)
            items.player2turn.start()
        else
            items.player1turn.start()
    }
    else {
        if(items.counter % 2 == 0)
            items.player1turn.start()
        else
            items.player2turn.start()
    }
}

function changePlayToSecond() {

    if(items.playSecond == 0) {
        items.playSecond = true
        reset()
        return 0
    }
    if(!twoPlayer) {
        var rand = Math.floor((Math.random() * numberOfDragPoints))
        handleCreate(rand)
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
    //items.board.anchors.horizontalCenterOffset = 0
    //items.board.anchors.verticalCenterOffset = -10
    //items.board.sourceSize.width = 3.4 * Math.min(items.background.width / 4 , items.background.height / 6)
    //items.board.sourceSize.width = Math.min(items.background.height - 1.4*items.player1.height - 1.2*items.bar.height,
                                            //0.9*items.background.width)
    for (var i = 0 ; i < numberOfDragPoints ; ++i) {
        if(items.dragPoints.itemAt(i).state != "1" && items.dragPoints.itemAt(i).state != "2")
            items.dragPoints.itemAt(i).state = "EMPTY"
    }

    items.instructionTxt = qsTr("Move a Piece")
}

function pieceSelected(pieceIndex) {

    currentPiece.isSelected = false
    currentPiece = currentRepeater.itemAt(pieceIndex)
    currentPiece.isSelected = true

    if((currentPiece.state == "1" && numberOfFirstPieces > 3) ||
       (currentPiece.state == "2" && numberOfSecondPieces > 3)) {

        // Initialize values
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
    currentPiece.parent.state = "EMPTY"
    currentPiece.isSelected = false
    for (var i = 0 ; i < numberOfDragPoints ; ++i) {
        if(items.dragPoints.itemAt(i).state != "1" && items.dragPoints.itemAt(i).state != "2")
            items.dragPoints.itemAt(i).state = "EMPTY"
    }
    currentPiece.move(items.dragPoints.itemAt(index))
    //currentPiece.parent.state = currentPiece.state
}

function shouldComputerPlay() {

    console.log("shouldComputerPlay")
    if(!twoPlayer) {
        if(items.counter % 2 && items.playSecond == false && stopper == 0)
            doMove()
        else if((items.counter % 2 == 0) && items.playSecond && stopper == 0)
            doMove()
        else
            items.pieceBeingMoved = false
    }
    else
        items.pieceBeingMoved = false
}

function doMove() {

    console.log("doMove()", currentPiece.state)
    if(items.firstPhase) {
        var index = setFirstPhaseMove()
        handleCreate(index)
    }
    else if((currentPiece.state == "2" && numberOfFirstPieces > 3) ||
            (currentPiece.state == "1" && numberOfSecondPieces > 3)) {
        console.log("else if")
        var index = setSecondPhaseMove()
        console.log(index[0],index[1])
        currentPiece = currentRepeater.itemAt(index[0])
        movePiece(index[1])
    }
    else {
        console.log("3rd state")
        var index = setThirdPhaseMove()
        console.log(index[0],index[1])
        currentPiece = currentRepeater.itemAt(index[0])
        movePiece(index[1])
    }
}

function setFirstPhaseMove() {

    //Assigning States -> State "1" or "2" is used for identifying player and computer
    var playerState = items.playSecond ? "2" : "1"
    var computerState = items.playSecond ? "1" : "2"

    if(currentLevel > 1) {
        var value = evaluateBoard(computerState)
        if(value != -1)
            return value
    }

    if(currentLevel > 2) {
        var value = evaluateBoard(playerState)
        if(value != -1)
            return value
    }

    var found = false
    while (!found) {
        var randno = Math.floor((Math.random() * numberOfDragPoints))
        //console.log(randno)
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

    console.log("setSecondPhaseMove()")
    var index = []
    var found = false

    if(currentLevel > 1) {
        for(var i = 0 ; i < numberOfPieces ; ++i) {
            var piece = currentRepeater.itemAt(i)
            if(piece.visible) {
                index[0] = i
                if(piece.pieceParent.leftPoint && piece.pieceParent.leftPoint.state == "EMPTY") {
                    if(checkMill(piece.pieceParent.leftPoint.index, piece.state, "left")) {
                        index[1] = piece.pieceParent.leftPoint.index
                        found = true
                        console.log("leftPoint")
                        break
                    }
                }
                if(piece.pieceParent.rightPoint && piece.pieceParent.rightPoint.state == "EMPTY") {
                    if(checkMill(piece.pieceParent.rightPoint.index, piece.state, "right")) {
                        index[1] = piece.pieceParent.rightPoint.index
                        found = true
                        console.log("rightPoint")
                        break
                    }
                }
                if(piece.pieceParent.upperPoint && piece.pieceParent.upperPoint.state == "EMPTY") {
                    if(checkMill(piece.pieceParent.upperPoint.index, piece.state, "upper")) {
                        index[1] = piece.pieceParent.upperPoint.index
                        found = true
                        console.log("upperPoint")
                        break
                    }
                }
                if(piece.pieceParent.lowerPoint && piece.pieceParent.lowerPoint.state == "EMPTY") {
                    if(checkMill(piece.pieceParent.lowerPoint.index, piece.state, "lower")) {
                        index[1] = piece.pieceParent.lowerPoint.index
                        found = true
                        console.log("lowerPoint")
                        break
                    }
                }
            }
        }
        if(found) {
            console.log("1 found=",found," 0=",index[0]," 1=",index[1])
            return index
        }
    }

    var playerState = items.playSecond ? "2" : "1"
    if(currentLevel > 2) {
        for(var i = 0 ; i < numberOfPieces ; ++i) {
            var piece = currentRepeater.itemAt(i)
            if(piece.visible) {
                index[0] = i
                if(piece.pieceParent.leftPoint && piece.pieceParent.leftPoint.state == "EMPTY") {
                    if(checkMillPossible(piece.pieceParent.leftPoint.index, playerState)) {
                        index[1] = piece.pieceParent.leftPoint.index
                        found = true
                        console.log("leftPoint")
                        break
                    }
                }
                if(piece.pieceParent.rightPoint && piece.pieceParent.rightPoint.state == "EMPTY") {
                    if(checkMillPossible(piece.pieceParent.rightPoint.index, playerState)) {
                        index[1] = piece.pieceParent.rightPoint.index
                        found = true
                        console.log("rightPoint")
                        break
                    }
                }
                if(piece.pieceParent.upperPoint && piece.pieceParent.upperPoint.state == "EMPTY") {
                    if(checkMillPossible(piece.pieceParent.upperPoint.index, playerState)) {
                        index[1] = piece.pieceParent.upperPoint.index
                        found = true
                        console.log("upperPoint")
                        break
                    }
                }
                if(piece.pieceParent.lowerPoint && piece.pieceParent.lowerPoint.state == "EMPTY") {
                    if(checkMillPossible(piece.pieceParent.lowerPoint.index, playerState)) {
                        index[1] = piece.pieceParent.lowerPoint.index
                        found = true
                        console.log("lowerPoint")
                        break
                    }
                }
            }
        }
        if(found) {
            console.log("2 found=",found," 0=",index[0]," 1=",index[1])
            return index
        }
    }

    console.log("permittedPieceIndex")
    var permittedPieceIndex = []
    for(var i = 0 ; i < numberOfPieces ; ++i) {
        if(currentRepeater.itemAt(i).visible) {
            //console.log("ppi=",i)
            if(!checkMill(currentRepeater.itemAt(i).pieceParent.index, playerState))
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
    console.log("3 0=",index[0]," 1=",index[1])
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
                return true
        }
    }
    if(dragPoint.upperPoint && dragPoint.upperPoint.upperPoint) {
        if(state == dragPoint.upperPoint.state && state == dragPoint.upperPoint.upperPoint.state) {
            if((dragPoint.leftPoint && state == dragPoint.leftPoint.state) ||
               (dragPoint.rightPoint && state == dragPoint.rightPoint.state) || thirdPhase)
                return true
        }
    }
    if(dragPoint.rightPoint && dragPoint.rightPoint.rightPoint) {
        if(state == dragPoint.rightPoint.state && state == dragPoint.rightPoint.rightPoint.state) {
            if((dragPoint.upperPoint && state == dragPoint.upperPoint.state) ||
               (dragPoint.lowerPoint && state == dragPoint.lowerPoint.state) || thirdPhase)
                return true
        }
    }
    if(dragPoint.lowerPoint && dragPoint.lowerPoint.lowerPoint) {
        if(state == dragPoint.lowerPoint.state && state == dragPoint.lowerPoint.lowerPoint.state) {
            if((dragPoint.leftPoint && state == dragPoint.leftPoint.state) ||
               (dragPoint.rightPoint && state == dragPoint.rightPoint.state) || thirdPhase)
                return true
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
}

/*
function positionAchievable(index, state) {

    if((items.playSecond && numberOfSecondPieces < 4) || (!items.playSecond && numberOfFirstPieces < 4))
        return true

    var count = 0
    if(items.dragPoints.itemAt(index).leftPoint &&
        items.dragPoints.itemAt(index).leftPoint.state == state)
            count++
    if(items.dragPoints.itemAt(index).rightPoint &&
        items.dragPoints.itemAt(index).rightPoint.state == state)
            count++
    if(items.dragPoints.itemAt(index).upperPoint &&
        items.dragPoints.itemAt(index).upperPoint.state == state)
            count++
    if(items.dragPoints.itemAt(index).lowerPoint &&
        items.dragPoints.itemAt(index).lowerPoint.state == state)
            count++

    if(count > 1)
            return true
        else
            return false
}
*/

function setThirdPhaseMove() {

    //Assigning States -> State "1" or "2" is used for identifying player and computer
    var playerState = items.playSecond ? "2" : "1"
    var computerState = items.playSecond ? "1" : "2"
    var index = []

    if(currentLevel > 2) {
        for(var i = 0 ; i < numberOfDragPoints ; ++i) {
            if(items.dragPoints.itemAt(i).state == "EMPTY") {
                var value = checkMillThirdPhase(i, computerState)
                if(value != -1) {
                    index[0] = value
                    index[1] = i
                    console.log("3 1=",index[0],index[1])
                    return index
                }
            }
        }
    }

    var permittedPieceIndex = []
    for(var i = 0 ; i < numberOfPieces ; ++i) {
        if(currentRepeater.itemAt(i).visible) {
            console.log("ppi=")
            if(!checkMillPossible(currentRepeater.itemAt(i).pieceParent.index, playerState)) {
                console.log("ppi=",i)
                permittedPieceIndex.push(i)
            }
        }
    }

    if(!permittedPieceIndex.length) {
        console.log("!permittedPieceIndex.length")
        for(var i = 0 ; i < numberOfPieces ; ++i) {
            if(currentRepeater.itemAt(i).visible)
                permittedPieceIndex.push(i)
        }
    }

    var randno = Math.floor((Math.random() * permittedPieceIndex.length))
    index[0] = permittedPieceIndex[randno]

    if(currentLevel > 3) {
        for(var i = 0 ; i < numberOfDragPoints ; ++i) {
            if(items.dragPoints.itemAt(i).state == "EMPTY") {
                if(checkMillPossible(i,playerState)) {
                    index[1] = i
                    console.log("3 2=",index[0],index[1])
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
                console.log("3 3=",index[0],index[1])
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

    items.counter++
    //console.log(items.counter)
    if(items.counter % 2) {
        currentRepeater = items.secondPlayerPieces
        otherRepeater = items.firstPlayerPieces
    }
    else {
        currentRepeater = items.firstPlayerPieces
        otherRepeater = items.secondPlayerPieces
    }
    if(items.counter == (2 * numberOfPieces))
        secondPhase()
    changeScale()
    //items.pieceBeingMoved = false
}

// position value is only used when checkMill is called by setSecondPhaseMove or getSecondPhaseRemoveIndex function
// Else it is declared as undefined by default
function checkMill(index, state, position) {

    //var index = piece.parentIndex
    //var state = piece.state
    //var millFormed = false
    /*console.log(index)
    //console.log(index, state, dragPoints[1].state, dragPoints[2].state)
    if(!millFormed && index == 0) {
        if(dragPoints[1].state == dragPoints[2].state &&  dragPoints[2].state == state)
            //console.log("mill")
    }*/
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
}

// UpdateRemovablePiece called by Piece when its animation stops and checkMill(piece) is true
function UpdateRemovablePiece() {

    //items.pieceBeingRemoved = true
    if(twoPlayer || ((items.counter % 2) && items.playSecond) || (!(items.counter % 2) && !items.playSecond)) {
        var foundOne = false
        for(var i = 0 ; i < numberOfPieces ; ++i) {
            //console.log(i)
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
        items.instructionTxt = qsTr("Remove a Piece")
    }
    else if(items.firstPhase)
        otherRepeater.itemAt(getFirstPhaseRemoveIndex()).remove()
    else {
        otherRepeater.itemAt(getSecondPhaseRemoveIndex()).remove()
    }
}

function getFirstPhaseRemoveIndex() {

    var playerState = items.playSecond ? "2" : "1"
    var permittedIndex = [];
    for(var i = 0 ; i < numberOfPieces ; ++i) {
        //console.log(i)
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

    if(currentLevel > 4) {
        var index = evaluateBoard(playerState)
        if(index != -1) {
            //console.log(index)
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
                //console.log("leftleft",first.pieceIndex)
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
        //console.log(i)
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
                    console.log("getSecondPhaseRemoveIndex","left",piece.pieceParent.index)
                    return i
                }
            }
            if(piece.pieceParent.rightPoint && piece.pieceParent.rightPoint.state == "EMPTY") {
                if(checkMill(piece.pieceParent.rightPoint.index, piece.state, "right")) {
                    console.log("getSecondPhaseRemoveIndex","right",piece.pieceParent.index)
                    return i
                }
            }
            if(piece.pieceParent.upperPoint && piece.pieceParent.upperPoint.state == "EMPTY") {
                if(checkMill(piece.pieceParent.upperPoint.index, piece.state, "upper")) {
                    console.log("getSecondPhaseRemoveIndex","upper",piece.pieceParent.index)
                    return i
                }
            }
            if(piece.pieceParent.lowerPoint && piece.pieceParent.lowerPoint.state == "EMPTY") {
                if(checkMill(piece.pieceParent.lowerPoint.index, piece.state, "lower")) {
                    console.log("getSecondPhaseRemoveIndex","lower",piece.pieceParent.index)
                    return i
                }
            }
        }
    }

    console.log("getSecondPhaseRemoveIndex getFirstPhaseRemoveIndex")
    return getFirstPhaseRemoveIndex()
}

// removePiece(index) called by Piece when items.pieceBeingRemoved is true
function removePiece(index) {

    //console.log(index)
    otherRepeater.itemAt(index).visible = false
    //items.pieceBeingRemoved = false

    // Decrease number of pieces of other player by 1
    if(items.counter % 2)
        numberOfFirstPieces--
    else
        numberOfSecondPieces--
    if(items.firstPhase) {
        items.instructionTxt = qsTr("Place a Piece")
        continueGame()
    }
    else
        checkGameWon()
}

function removePieceSelected(index) {

    otherRepeater.itemAt(index).parent.state = items.firstPhase ? "AVAILABLE" : "EMPTY"
    for(var i = 0 ; i < numberOfPieces ; ++i)
        otherRepeater.itemAt(i).canBeRemoved = false
}

function checkGameWon() {

    // Check if other player can mover or not
    var flag = true;
    for (var i = 0 ; i < numberOfPieces ; ++i) {
        //console.log("otherRepeater.itemAt(i).visible",otherRepeater.itemAt(i).visible)
        var piece = otherRepeater.itemAt(i)
        if(piece.visible) {
            //console.log("left",piece.parent.leftPoint ? piece.parent.leftPoint.state : "Null")
            //console.log("right",piece.parent.rightPoint ? piece.parent.rightPoint.state : "Null")
            //console.log("upper",piece.parent.upperPoint ? piece.parent.upperPoint.state : "Null")
            //console.log("lower",piece.parent.lowerPoint ? piece.parent.lowerPoint.state : "Null")
            if((piece.parent.leftPoint && piece.parent.leftPoint.state == "EMPTY") ||
               (piece.parent.rightPoint && piece.parent.rightPoint.state == "EMPTY") ||
               (piece.parent.upperPoint && piece.parent.upperPoint.state == "EMPTY") ||
               (piece.parent.lowerPoint && piece.parent.lowerPoint.state == "EMPTY")) {
                    flag = false
                    break
            }
        }
    }
    //console.log("flag", flag)
    //console.log("currentPiece.state",currentPiece.state)
    if(((numberOfSecondPieces < 3 && !items.playSecond) || (numberOfFirstPieces < 3 && items.playSecond)) ||
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
    else if(((numberOfFirstPieces < 3 && !items.playSecond) || (numberOfSecondPieces < 3 && items.playSecond)) ||
            (flag && ((currentPiece.state == "2" && !items.playSecond) ||
            (currentPiece.state == "1" && items.playSecond)))) {
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
