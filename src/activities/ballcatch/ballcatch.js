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

// Lists containing all possible values for the current platform for scanCode
var supposedRightKeyCode
var supposedLeftKeyCode

// Real scanCode if found, -1 else
var rightKeyCode = -2
var leftKeyCode = -2

/* when the corresponding shift key is pressed, the following boolean pass
   to true and is reseted at the end of the level */
var leftPressed = false
var rightPressed = false

var gameWon = false

// Store the time diff between left and right key
var timerDiff = 0
// The child has to press both key between this laps of time
var timerinc = 900

var currentLevel = 0

var items

function start(items_) {
    items = items_
    currentLevel = 0

    initLevel()

}

function stop() {
    // Nothing to do
}

function leftShiftPressed() {
    if(!items.deltaPressedTimer.running && !rightPressed) {
        items.leftHand.animate(timerinc)
        items.deltaPressedTimer.start()
    }

    if(rightPressed) {
        items.leftHand.animate(timerinc)
        items.background.playSound("brick")
    }
}

function rightShiftPressed() {
    if(!items.deltaPressedTimer.running && !leftPressed) {
        items.deltaPressedTimer.start()
        items.rightHand.animate(timerinc)
    }
    if(leftPressed) {
        items.rightHand.animate(timerinc)
        items.background.playSound("brick")
    }
}

function endTimer() {
    gameWon = rightPressed && leftPressed
}

function initLevel() {
    items.bar.level = currentLevel + 1
    timerinc = levelProperties[currentLevel].timerInc

    timerDiff = 0
    items.deltaPressedTimer.interval = timerinc

    items.background.source = "qrc:/gcompris/src/activities/ballcatch/resource/beach" +
            levelProperties[currentLevel].backgroundImage + ".svgz"

    items.ball.reinitBall();

    leftPressed = false
    rightPressed = false

    gameWon = false

    items.leftHand.reinitPosition()
    items.rightHand.reinitPosition()
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

function initKey() {
    /* You cannot dissociate left shift and right shift easily
       on Qt so we put all possibilities for scanCode here */
    switch(ApplicationInfo.platform) {
    case ApplicationInfo.Linux: // todo find existing enum for those values?
        // Do not know if it is the same for all linux ?
        supposedRightKeyCode = [62];
        supposedLeftKeyCode = [50];
        break;
    case ApplicationInfo.Windows:
        // VK_RSHIFT in WinUser.h is 0xA1, but does not work in my win8...
        supposedRightKeyCode = [0xA1, 54];
        // VK_LSHIFT in WinUser.h, but does not work in my win8...
        supposedLeftKeyCode = [0xA0, 42];
        break;
    case ApplicationInfo.MacOSX:
        // keyEvent.nativeScanCode not filled in mac
    default: // Will it be played with keyboard on mobile/tablet ?
        supposedRightKeyCode = [-1];
        supposedLeftKeyCode = [-1];
    }
}

function processKey(event) {
    if(event.key == Qt.Key_Shift) {
        // Default values, look for real values
        if(leftKeyCode == -2 || rightKeyCode == -2) {
            // Look if it is a left key
            var isLeft = false;
            var i = 0;
            for(i = 0 ; i < supposedLeftKeyCode.length ; ++ i) {
                if(event.nativeScanCode == supposedLeftKeyCode[i]) {
                    leftKeyCode = event.nativeScanCode;
                    isLeft = true;
                    break;
                }
            }

            var isRight = false;
            if(!isLeft) { // If not left look if it is a right
                for(i = 0 ; i < supposedRightKeyCode.length ; ++ i) {
                    if(event.nativeScanCode == supposedRightKeyCode[i]) {
                        rightKeyCode = event.nativeScanCode;
                        isRight = true;
                        break;
                    }
                }
            }

            if(!(isLeft || isRight)) {
                /*
             Not existing :(
             Print a log because if the person is a developer
             he could give us the values :)
            */
                print("You pressed key_shift with nativeScanCode=" +
                      event.nativeScanCode + " not handled")

                // Randomly put the key in left or right...
                if(leftKeyCode == -2 && rightKeyCode == -2) {
                    if(Math.random()%2 == 0)
                        leftKeyCode = event.nativeScanCode;
                    else
                        rightKeyCode = event.nativeScanCode;
                }
                else if(leftKeyCode == -2) {
                    leftKeyCode = event.nativeScanCode;
                }
                else {
                    rightKeyCode = event.nativeScanCode;
                }
            }
        }

        // Look for the key !
        if(event.nativeScanCode === leftKeyCode) {
            // left
            if(!leftPressed) {
                leftShiftPressed();
                leftPressed = true
            }
        }
        else {
            // right
            if(!rightPressed) {
                rightShiftPressed();
                rightPressed = true
            }
        }
        event.accepted = true;
    }
}
