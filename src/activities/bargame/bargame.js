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

var numberBalls = [[1, 4], [2, 6], [3, 6]]
var sampleBallsNumber = [4, 6, 6]
var tuxPositionFactor = [1.05, 1.4, 1.05]
var ballSizeFactor = [0, 4, 4]
var elementSizeFactor = [0, 4, 7]
var boardSize = [15, 19, 29]
var moveCount = -1
var level = 1
var maxlevel = 4
var numberOfsublevel = 3
var listWin = false
var items
var numberOfBalls = 1

var url= "qrc:/gcompris/src/activities/bargame/resource/";

function start(items_) {
    items = items_
    initLevel()
}

function stop() {
}

function initLevel() {
    calculateWinPlaces();
    items.tuxArea.enabled = true;
    items.tuxArea.hoverEnabled = true;
    moveCount = -1;
    items.numberLabel.text = "1";
    numberOfBalls = 1;

    items.bar.level = level;

    // Hiding all visible balls
    for (var x = 0; x < items.answerBallsPlacement.columns; x++) {
        items.answerBallsPlacement.children[x].opacity = 0.0;
    }
}

function nextLevel() {
    level++;
    if (level > 4) {
        level = 1;
    }
    initLevel();
}

function previousLevel() {
    level--;
    if (level < 1) {
        level = 4;
    }
    initLevel();
}

function calculateWinPlaces() {
    /* Calculates all the possible winning moves in the
    available board size. It generates a list all winning
    moves for the computer */
    var winners = [];
    var winnersList = [];
    var min = numberBalls[items.mode - 1][0];
    var max = numberBalls[items.mode - 1][1];
    var period = (min + max);

    for (var x = 0; x < min; x++) {
        winnersList.push((boardSize[items.mode - 1] - 1 - x) % period);
    }

    for (var x = 0; x < (boardSize[items.mode - 1]); x++ ) {
        if (winnersList.indexOf((x + 1) % period) >= 0) {
            winners.push(x);
        }
    }

    var level_win = (level - 1) * min;

    if (level_win == 0) {
        winners = [];
    } else {
        winners = winners.slice(-level_win);
    }

    listWin =  winners;
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

    for (var x = numberBalls[items.mode - 1][0]; x < numberBalls[items.mode - 1][1] + 1; x++) {
        if (accessible(x)) {
            playable.push(x);
        }
    }
    if (playable.length != 0) {
        var value = playable[Math.floor(Math.random()*playable.length)];
    } else {
        var value = randomNumber(numberBalls[items.mode - 1][0], numberBalls[items.mode - 1][1]);
    }

    play(2, value);
}

function play(player, value) {
    for (var x = 0; x < value ; x++) {
        moveCount++;
        if (moveCount <= (boardSize[items.mode - 1] - 1)) {
            if (player == 1) {
                items.answerBallsPlacement.children[moveCount].opacity = 1.0;
                items.answerBallsPlacement.children[moveCount].source = url + "green_ball.svg";
            } else {
                items.answerBallsPlacement.children[moveCount].opacity = 1.0;
                items.answerBallsPlacement.children[moveCount].source = url + "blue_ball.svg";
            }
        }
        if (moveCount == (boardSize[items.mode - 1] - 1)) {
            if (player == 2) {
                items.bonus.good("flower");
                items.score++;
            } else {
                items.bonus.bad("flower");
                items.score--;
            }
            return;
        }
    }
    if (player == 1) {
        machinePlay();
    }
}
