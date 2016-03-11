/* GCompris - space-encounter.js
 *
 * Copyright (C) 2016 YOUR NAME <xx@yy.org>
 *
 * Authors:
 *   <THE GTK VERSION AUTHOR> (GTK+ version)
 *   "YOUR NAME" <YOUR EMAIL> (Qt Quick port)
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
var numberOfLevel = 1  /**************************************************/
var items
var gameWon = false

function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    //////////////////////////////////////////////////////////////////////////////
    items.flag = true
    items.timerRunning = false
    items.timerRepeat = true

    items.spacePresses = 0
    items.ticks = 0
    items.playerScore = 0

    items.textbuttText = "Press Space Bar to Start"
    items.displayCounterText = items.ticks + " Seconds"
    items.spaceBarButtonColor = "#ABCDEF"
    ///////////////////////////////////////////////////////////////////////////////////
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel ) {
        currentLevel = 0
    }
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel();
}



////////////////////////////////////////////////////////////////////////
var spaceButtonColor = true;

function increment() {
    if(items.flag == true) {
        items.spacePresses = items.spacePresses +1;
        items.textbuttText = "Your Score " + items.spacePresses;
        items.timerRunning = true;
        if(spaceButtonColor == true) {
            items.spaceBarButtonColor = "#F53D00"
            spaceButtonColor = false;
        }
        else {
            items.spaceBarButtonColor = "#00F53D"   // Initial state
            spaceButtonColor = true;
        }
    }
}

function incrementTicks() {
    if(items.ticks < 5) {
        items.ticks = items.ticks + 1;
        items.displayCounterText = items.ticks + " Seconds";
    }
    else {
        items.flag = false;
        items.timerRepeat = false; items.timerRunning = false;
        items.playerScore = items.spacePresses;
        if(items.playerScore > items.highScore) {
            items.highScore = items.playerScore;
            gameWon = true;
        }
        items.displayCounterText = "Time Up";
        gameOver();
    }
}

function gameOver() {
    //items.bonus.good("planet");
    if(gameWon == true) {
        items.bonus.good("planet");
    }
    else {
        items.bonus.bad("planet");
    }
    gameWon = false;
}

//////////////////////////////////////////////////////////////////////////
