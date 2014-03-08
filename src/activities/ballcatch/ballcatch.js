/*
 gcompris - ballcatch.js

 Copyright (C)
 2003, 2014: Bruno Coudoin: initial version
 2014: Johnny Jazeix: Qt port

 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

var levelProperties = [
            {
                "timerInc": 900,
                "backgroundImage": 1
            },
            {
                "timerInc": 350,
                "backgroundImage": 1
            },
            {
                "timerInc": 300,
                "backgroundImage": 2
            },
            {
                "timerInc": 200,
                "backgroundImage": 2
            },
            {
                "timerInc": 150,
                "backgroundImage": 3
            },
            {
                "timerInc": 100,
                "backgroundImage": 3
            },
            {
                "timerInc": 60,
                "backgroundImage": 4
            },
            {
                "timerInc": 30,
                "backgroundImage": 4
            },
            {
                "timerInc": 15,
                "backgroundImage": 4
            },
        ]

// Store the time diff between left and right key
var timerDiff = 0
// The child has to press both key between this laps of time
var timerinc = 900

var currentLevel = 0

var background
var bar
var activity
var ball
var rightHand
var leftHand
var deltaPressedTimer

function start(background_, bar_, activity_, ball_, rightHand_,
               leftHand_, deltaPressedTimer_) {
    background = background_
    bar = bar_
    activity = activity_
    deltaPressedTimer = deltaPressedTimer_
    ball = ball_
    rightHand = rightHand_;
    leftHand = leftHand_;

    currentLevel = 0

    initLevel()

}

function stop() {
    // Nothing to do
}

function leftShiftPressed() {
    if(!deltaPressedTimer.running && !activity.rightPressed) {
        leftHand.animate(timerinc)
        deltaPressedTimer.start()
    }

    if(activity.rightPressed) {
        leftHand.animate(timerinc)
        background.playSound("brick")
    }
}

function rightShiftPressed() {
    if(!deltaPressedTimer.running && !activity.leftPressed) {
        deltaPressedTimer.start()
        rightHand.animate(timerinc)
    }
    if(activity.leftPressed) {
        rightHand.animate(timerinc)
        background.playSound("brick")
    }
}

function endTimer() {
    activity.gameWon = activity.rightPressed && activity.leftPressed
}

function initLevel() {
    bar.level = currentLevel + 1
    timerinc = levelProperties[currentLevel].timerInc

    timerDiff = 0
    deltaPressedTimer.interval = timerinc

    background.source = "qrc:/gcompris/src/activities/ballcatch/resource/beach" +
            levelProperties[currentLevel].backgroundImage + ".svgz"

    ball.reinitBall();

    activity.leftPressed = false
    activity.rightPressed = false

    activity.gameWon = false

    leftHand.reinitPosition()
    rightHand.reinitPosition()
}

function nextLevel() {
    if(levelProperties.length <= ++ currentLevel) {
        currentLevel = 0
    }
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = levelProperties.length - 1
    }
    initLevel();
}

function restartLevel() {
    initLevel();
}
