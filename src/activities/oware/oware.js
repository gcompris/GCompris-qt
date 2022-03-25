/* GCompris - oware.js
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 */
.pragma library
.import QtQuick 2.12 as Quick

var items
var url = "qrc:/gcompris/src/activities/oware/resource/";

// true if two players mode enabled
var twoPlayers

// Player.PLAYER1, Player.PLAYER2
var turn

// Enum for player
var Player = {
    PLAYER1: 1,
    PLAYER2: 2
}

// properties: player, index
var lastPos, basePos

function start(items_, twoPlayers_) {
    items = items_
    twoPlayers = twoPlayers_
    initLevel()
}

function stop() {
}

function initLevel() {
    items.board.init()
     items.player1score.playerScore = 0
    items.player2score.playerScore = 0
    items.hand1.seeds = items.hand2.seeds = 0
    items.isDistributionAnimationPlaying = false

    if (items.playerWithFirstMove === Player.PLAYER1) {
        items.player2score.beginTurn()
        items.player1score.endTurn()
        items.playerWithFirstMove = Player.PLAYER2
    }
    else {
        items.player1score.beginTurn()
        items.player2score.endTurn()
        items.playerWithFirstMove = Player.PLAYER1
    }

    turn = items.playerWithFirstMove
    items.gameOver = false

    if(!twoPlayers) {
        for(var i = 0; i < items.board.numberOfPitsInOneRow; ++i)
            items.board.pitRepeater2.itemAt(i).responsive = false

        if(turn === Player.PLAYER2) {
            playRandomMove()
            return
        }
    }
}

function countSeedsInRow(pitRepeater) {
    var count = 0
    for(var i = 0; i < items.board.numberOfPitsInOneRow; ++i)
        count += pitRepeater.itemAt(i).seeds
    return count
}

function isValidMove(pit) {
    if(pit.seeds === 0)
        return false

    var opponentSeeds
    var seedsTransferrable

    if(pit.player === 1) {
        opponentSeeds = countSeedsInRow(items.board.pitRepeater2)
        seedsTransferrable = Math.max(pit.seeds - pit.index, 0)
    }
    else {
        opponentSeeds = countSeedsInRow(items.board.pitRepeater1)
        seedsTransferrable = Math.max(pit.seeds - (5 - pit.index), 0)
    }

    if(opponentSeeds > 0)
        return true

    return seedsTransferrable > 0
}

function processMove(player, ind) {
    if(turn !== player || items.isDistributionAnimationPlaying || items.gameOver)
        return

    var pit = (turn === Player.PLAYER1) ? items.board.pitRepeater1.itemAt(ind) :
        items.board.pitRepeater2.itemAt(ind)

    if(!isValidMove(pit)) {
        items.invalidMoveAnimation.start(pit)
        items.instructionArea.start(qsTr("Invalid Move!"))
        return
    }

    lastPos = {
        player: turn,
        index: ind
    }
    basePos = {
        player: turn,
        index: ind
    }

    items.isDistributionAnimationPlaying = true
    items.teleportAnimation.start(pit, (turn === Player.PLAYER1 ? items.hand1 : items.hand2))
}

function checkWin() {
    if(items.player1score.playerScore >= 25) {
        items.gameOver = true
        // to counter extra score by win() method
        items.player1score.playerScore--
        items.player1score.win()
        items.bonus.good("smiley")
        return true
    }
    else if(items.player2score.playerScore >= 25) {
        items.gameOver = true
        // to counter extra score by win() method
        items.player2score.playerScore--
        items.player2score.win()
        items.bonus.good("tux")
        return true
    }
    else if(items.player1score.playerScore === 24 && items.player2score.playerScore === 24) {
        items.gameOver = true
        items.bonus.good("lion")
        return true
    }
}

function captureAll() {
    for(var i = 0; i < items.board.numberOfPitsInOneRow; ++i) {
        items.player1score.playerScore += items.board.pitRepeater1.itemAt(i).seeds
        items.board.pitRepeater1.itemAt(i).seeds = 0
        items.player2score.playerScore += items.board.pitRepeater2.itemAt(i).seeds
        items.board.pitRepeater2.itemAt(i).seeds = 0
    }
    checkWin()
}

function switchTurn() {
    items.selectedPit.selected = false
    if(checkWin())
        return
    if(turn === Player.PLAYER1) {
        turn = Player.PLAYER2

        items.player1score.endTurn()
        items.player2score.beginTurn()

        if(!twoPlayers) {
            playRandomMove()
            return
        }

        var valid = false
        for(var i = 0; i < items.board.numberOfPitsInOneRow; ++i)
            valid = valid | isValidMove(items.board.pitRepeater2.itemAt(i))
        if(!valid)
            captureAll()
    }
    else {
        turn = Player.PLAYER1
        items.player2score.endTurn()
        items.player1score.beginTurn()

        var valid = false
        for(var i = 0; i < items.board.numberOfPitsInOneRow; ++i)
            valid = valid | isValidMove(items.board.pitRepeater1.itemAt(i))
        if(!valid)
            captureAll()
    }
}

function nextAntiClockwise(lastPos) {
    // lastPos.player, lastPos.index
    if(lastPos.player === 1) {
        if(lastPos.index === 0)
            lastPos.player++
        else
            lastPos.index--
    }
    else {
        if(lastPos.index === 5)
            lastPos.player--
        else
            lastPos.index++
    }
}

function nextClockwise(lastPos) {
    // lastPos.player, lastPos.index
    if(lastPos.player === 1) {
        if(lastPos.index === 5)
            lastPos.player++
        else
            lastPos.index++
    }
    else {
        if(lastPos.index === 0)
            lastPos.player--
        else
            lastPos.index--
    }
}

function getGlobalPos(component) {
    if(!component || component.id === "background")
        return [0, 0]

    var pos = getGlobalPos(component.parent)
    return [pos[0] + component.x, pos[1] + component.y]
}

function getPit(player, index) {
    return (player === Player.PLAYER1 ? items.board.pitRepeater1.itemAt(index) : items.board.pitRepeater2.itemAt(index))
}

function isCaptureAllowed() {
    if(lastPos.player === turn)
        return false
    var pos = {
        player: lastPos.player,
        index: lastPos.index
    }
    var pit = getPit(pos.player, pos.index)
    var remaining = 0

    while((pit.seeds === 2 || pit.seeds === 3) && pit.player !== turn) {
        nextClockwise(pos);
        pit = getPit(pos.player, pos.index)
    }

    while(pit.player !== turn) {
        remaining += pit.seeds
        nextClockwise(pos);
        pit = getPit(pos.player, pos.index)
    }

    pos = {
        player: lastPos.player,
        index: lastPos.index
    }
    nextAntiClockwise(pos)
    pit = getPit(pos.player, pos.index)

    while(pit.player !== turn) {
        remaining += pit.seeds
        nextAntiClockwise(pos);
        pit = getPit(pos.player, pos.index)
    }
    return remaining > 0;
}

function checkCapture() {
    var pit = getPit(lastPos.player, lastPos.index)

    // end if back to original pit
    if((pit.seeds !== 2 && pit.seeds !== 3) || pit.player === turn) {
        // base case, end recursion
        switchTurn()
        items.isDistributionAnimationPlaying = false
        return
    }

    if(turn === Player.PLAYER1)
        items.captureAnimation.start(pit, items.player1score)
    else
        items.captureAnimation.start(pit, items.player2score)

    nextClockwise(lastPos)
}

function redistribute() {
    if(!items.hand1.seeds && !items.hand2.seeds) {
        if(isCaptureAllowed())
            checkCapture()
        else {
            // base case, end recursion
            // this base is otherwise handled by checkCapture function
            switchTurn()
            items.isDistributionAnimationPlaying = false
        }
        return
    }

    nextAntiClockwise(lastPos)

    // skip if back to original pit
    if(lastPos.player === basePos.player && lastPos.index === basePos.index)
        nextAntiClockwise(lastPos)

    // incremement count of seeds in corresponding pit
    var fromPit = (items.hand1.seeds ? items.hand1 : items.hand2)
    var toPit = (lastPos.player == 1 ? items.board.pitRepeater1.itemAt(lastPos.index) : items.board.pitRepeater2.itemAt(lastPos.index))

    items.animationSeed.startAnimation(fromPit, toPit)
}

function playRandomMove() {
    var validMoves = []
    for(var i = 0; i < items.board.numberOfPitsInOneRow; ++i) {
        if(isValidMove(items.board.pitRepeater2.itemAt(i)))
            validMoves.push([turn, i])
    }
    if(validMoves.length === 0) {
        captureAll()
        return
    }
    var randomIndex = Math.floor(Math.random() * validMoves.length)

    items.delayAnimation.start(validMoves[randomIndex][0], validMoves[randomIndex][1])
}
