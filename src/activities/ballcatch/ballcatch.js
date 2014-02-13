 /*
 gcompris - ballcatch.js

 Copyright (C) 2003, 2014 Bruno Coudoin

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

var ballComponent
var ballData

var gamewon

var currentLevel = 0

var main
var background
var bar
var bonus
var activity
var ballTimer
var deltaPressedTimer

function start(_main, _background, _bar, _bonus, _activity, _ballTimer, _deltaPressedTimer) {
    main = _main
    background = _background
    bar = _bar
    bonus = _bonus
    activity = _activity
    ballTimer = _ballTimer
    deltaPressedTimer = _deltaPressedTimer
    currentLevel = 0

    createBall()

    initLevel()

}

function stop() {
    ballData.destroy()
}

function createBall() {

    if (ballComponent == null)
        ballComponent = Qt.createComponent("qrc:/gcompris/src/activities/ballcatch/Ball.qml");

    var dynamicObject = ballComponent.createObject(
                background,
                {
                    "main": main,
                    "bar": bar,
                });

    if (dynamicObject == null) {
        console.log("error creating ball");
        return false;
    }

    ballData = dynamicObject;

    return true;
}

function leftShiftPressed() {
    if(!deltaPressedTimer.running)
        deltaPressedTimer.start()

    if(activity.rightPressed) {
        background.playSound("brick")
    }
}

function rightShiftPressed() {
    if(!deltaPressedTimer.running)
        deltaPressedTimer.start()
    if(activity.leftPressed) {
        background.playSound("brick")
    }
}

function endTimer() {
    if(activity.rightPressed)
        timerDiff += 10
    if(activity.leftPressed)
        timerDiff -= 10

    gamewon = (timerDiff == 0)
}

var nbAnims = 30
var curAnim = 0
function moveBall() {
    // The move simulation
    /*
      main.height - 200 -> main.height / 3

      0       ==> main.height/3 - (main.height-200)
      30 anim ==> ieme anim = (main.height-200) + i*(main.height/3 - (main.height-200)) / 30
      radius : 130 ==> 48 en 30 anim ==> step = (130-48) / 30 ~= 2.7
    */

    var ballStepMoving = (130-48) / nbAnims
    ballData.radius -= ballStepMoving
    ballData.x += timerDiff + ballStepMoving/2 // Recenter the ball
    ballData.y += (main.height/3+74/2 - (main.height-200)) / nbAnims // TODO +74 for tux.height

    if(ballData.width > 1.0) {
        ballData.width-= 0.5
    }

    // print(curAnim ++)
    curAnim ++

    // Play with ballData.y and main.height / 3
    if(curAnim >= nbAnims) {
    //if(ballData.radius <= 48) {
        ballTimer.stop()
        deltaPressedTimer.stop()
        // We are done with the ballon move
        if(gamewon) {
            // This is a win
            background.playSound("tuxok")
            bonus.good("tux")
        }
        else {
            // This is a loose
            background.playSound("youcannot")
            bonus.bad("tux")
        }
    }
}

function initLevel() {
    bar.level = currentLevel + 1
    timerinc = levelProperties[currentLevel].timerInc

    timerDiff = 0
    deltaPressedTimer.interval = timerinc

    ballTimer.stop()

    background.source = "qrc:/gcompris/src/activities/ballcatch/resource/beach" +
            levelProperties[currentLevel].backgroundImage + ".svgz"

    gamewon = false

    curAnim = 0

    ballData.radius = 130
    ballData.x = main.width / 2 - 65
    ballData.y = main.height - 200

    activity.leftPressed = false
    activity.rightPressed = false
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
