/* GCompris - bargame.js
 *
 * Copyright (C) 2016 UTKARSH TIWARI <iamutkarshtiwari@kde.org >
 *
 * Authors:
 *   Yves Combe (GTK+ version)
 *   UTKARSH TIWARI <iamutkarshtiwari@kde.org > (Qt Quick port)
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
.import GCompris 1.0 as GCompris
.import QtQuick 2.0 as Quick

var levelsProperties = [
    {
        "minNumberOfBalls": 1,
        "maxNumberOfBalls": 4,
        "sampleBallsNumber": 4,
        "elementSizeFactor": 0,
        "boardSize": 15
    },
    {
        "minNumberOfBalls": 2,
        "maxNumberOfBalls": 6,
        "sampleBallsNumber": 6,
        "elementSizeFactor": 4,
        "boardSize": 19
    },
    {
        "minNumberOfBalls": 3,
        "maxNumberOfBalls": 6,
        "sampleBallsNumber": 6,
        "elementSizeFactor": 7,
        "boardSize": 29
    }
];

var moveCount = -1
var currentLevel = 1
var maxLevel = 4
var listWin = []
var items
var gameMode

var url= "qrc:/gcompris/src/activities/bargame/resource/";

function start(items_, gameMode_) {
    items = items_;
    gameMode = gameMode_;
    currentLevel = 1;
    initLevel();
}

function stop() {
}

function initLevel() {
    if (items.isPlayer1Beginning === true) {
        initiatePlayer1();
        items.isPlayer1Turn = true;
    } else {
        initiatePlayer2();
        items.isPlayer1Turn = false;
    }


    items.okArea.enabled = true;
    calculateWinPlaces();
    moveCount = -1;
    items.numberOfBalls = levelsProperties[items.mode - 1].minNumberOfBalls
    items.bar.level = currentLevel;

    // Hiding all visible balls
    for (var x = 0; x < items.answerBallsPlacement.columns; x++) {
        items.answerBallsPlacement.children[x].visible = false;
    }
}

function nextLevel() {
    currentLevel ++;
    if (currentLevel > maxLevel) {
        currentLevel = 1;
    }
    initLevel();
}

function previousLevel() {
    currentLevel--;
    if (currentLevel < 1) {
        currentLevel = maxLevel;
    }
    initLevel();
}

function restartLevel() {
    initLevel();
}

function calculateWinPlaces() {
    /* Calculates all the possible winning moves in the
    available board size. It generates a list all winning
    moves for the computer */
    var winners = [];
    var winnersList = [];
    var min = levelsProperties[items.mode - 1].minNumberOfBalls;
    var max = levelsProperties[items.mode - 1].maxNumberOfBalls;
    var boardSize = levelsProperties[items.mode - 1].boardSize;
    var period = (min + max);

    for (var x = 0; x < min; x++) {
        winnersList.push((boardSize - 1 - x) % period);
    }

    for (var x = 0; x < boardSize; x++ ) {
        if (winnersList.indexOf((x + 1) % period) >= 0) {
            winners.push(x);
        }
    }

    var levelWin = (currentLevel - 1) * min;

    if (levelWin == 0) {
        winners = [];
    } else {
        winners = winners.slice(-levelWin);
    }

    listWin = winners;
}

function machinePlay() {
    function accessible(x) {
        if (listWin.indexOf(x + moveCount) >= 0) {
            return true;
        } else {
            return false;
        }
    }

    function randomNumber(minimum, maximum){
        return Math.round( Math.random() * (maximum - minimum) + minimum);
    }

    var playable = [];

    var min = levelsProperties[items.mode - 1].minNumberOfBalls;
    var max = levelsProperties[items.mode - 1].maxNumberOfBalls + 1;
    for (var x = min; x < max; x++) {
        if (accessible(x)) {
                playable.push(x);
            }
    }
    var value;
    if (playable.length != 0) {
        value = playable[Math.floor(Math.random()*playable.length)];
    } else {
        value = randomNumber(min, max);
    }

    play(2, value);
}

function play(player, value) {
    for (var x = 0; x < value ; x++) {
        moveCount++;
        var boardSize = levelsProperties[items.mode - 1].boardSize;
        if (moveCount <= (boardSize - 1)) {
            items.answerBallsPlacement.children[moveCount].visible = true;
            if (player == 1) {
                items.answerBallsPlacement.children[moveCount].source = url + "green_ball.svg";
            } else {
                items.answerBallsPlacement.children[moveCount].source = url + "blue_ball.svg";
            }
        }
        // one of the players has win
        if (moveCount == (boardSize - 1)) {
            items.okArea.enabled = false;
            if (gameMode == 2) {
                items.isPlayer1Beginning = !items.isPlayer1Beginning;
            }
            if (player == 2) {
                items.player1.state = "win"
                items.bonus.good("flower");
                items.player1Score++;
            } else {
                items.player2.state = "win"
                items.bonus.bad("flower");
                items.player2Score++;
            }
            return;
        }
    }
    if (player == 1 && gameMode == 1) {
        items.player2turn.start();
        items.okArea.enabled = false;
        items.trigTuxMove.start();
    } else if (player == 2 && gameMode == 1) {
        items.okArea.enabled = true;
        items.player1turn.start();
    } else if (gameMode == 2) {
        items.isPlayer1Turn = !items.isPlayer1Turn;
        if (player == 1) {
            items.player2turn.start();
        } else {
            items.player1turn.start();
        }
    }
}

//Initial values at the start of game when its player 1 turn
function initiatePlayer1() {
    items.changeScalePlayer1.scale = 1.4
    items.changeScalePlayer2.scale = 1.0
    items.player1.state = "first"
    items.player2.state = "second"
    items.rotateKonqi.start()
}

//Initial values at the start of game when its player 2 turn
function initiatePlayer2() {
    items.changeScalePlayer1.scale = 1.0
    items.changeScalePlayer2.scale = 1.4
    items.player1.state = "second"
    items.player2.state = "first"
    items.rotateTux.start()
}
