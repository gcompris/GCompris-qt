/* gcompris - Ballcatch.qml

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
import QtQuick 2.1
import QtQuick.Controls 1.0
import QtMultimedia 5.0
import GCompris 1.0

import "qrc:/gcompris/src/core"
import "qrc:/gcompris/src/activities/ballcatch"
import "ballcatch.js" as Activity

ActivityBase {
    id: activity

    onStart: {
        focus=true;

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
        case ApplicationInfo.MacOs:
            // keyEvent.nativeScanCode not filled in mac
        default: // Will it be played with keyboard on mobile/tablet ?
            supposedRightKeyCode = [-1];
            supposedLeftKeyCode = [-1];
        }
    }
    onStop: {}

    //Lists containing all possible values for the current platform for scanCode
    property var supposedRightKeyCode
    property var supposedLeftKeyCode

    // Real scanCode if found, -1 else
    property int rightKeyCode: -2
    property int leftKeyCode: -2

    /* when the corresponding shift key is pressed, the following boolean pass
       to true and is reseted at the end of the level */
    property bool leftPressed: false
    property bool rightPressed: false

    Keys.onPressed: {
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
            if(event.nativeScanCode == leftKeyCode) {
                // left
                if(!leftPressed) {
                    Activity.leftShiftPressed();
                    leftPressed = true
                }
            }
            else {
                // right
                if(!rightPressed) {
                    Activity.rightShiftPressed();
                    rightPressed = true
                }
            }
            event.accepted = true;
        }
    }

    property bool gameWon: false

    pageComponent: Image {
        id: background
        signal start
        signal stop
        focus: true
        fillMode: Image.PreserveAspectCrop
        source: "qrc:/gcompris/src/activities/ballcatch/resource/beach1.svgz"

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }
        onStart: {
            Activity.start(background, bar, activity, ball, deltaPressedTimer)
        }

        onStop: { Activity.stop() }

        onWidthChanged: { ball.reinitBall() }

        onHeightChanged: { ball.reinitBall() }

        DialogHelp {
            id: dialogHelpLeftRight
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | previous | next }
            onHelpClicked: {
                displayDialog(dialogHelpLeftRight)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: {
                win.connect(Activity.nextLevel)
                loose.connect(Activity.restartLevel)
            }
        }

        Image {
            id: tux
            x: main.width/2 - width/2
            y: main.height / 3
            source: "qrc:/gcompris/src/activities/ballcatch/resource/tux.svg"
        }

        Image {
            id: leftHand
            x: main.width/2 - width - 5
            y: main.height - 200
            z: 5
            source: "qrc:/gcompris/src/activities/ballcatch/resource/hand.svg"
        }

        Image {
            id: rightHand
            mirror: true
            x: main.width/2 + 5
            y: main.height - 200
            z: 5
            source: "qrc:/gcompris/src/activities/ballcatch/resource/hand.svg"
        }

        Image {
            id: leftShift
            x: main.width/2 - 240.0
            y: main.height - 150
            source: "qrc:/gcompris/src/activities/ballcatch/resource/shift_key.svg"
            opacity: leftPressed ? 1 : 0.5
            MultiPointTouchArea {

                id: mouseAreaLeftShift
                anchors.fill: parent
                onTouchUpdated: {
                    // left
                    if(!leftPressed) {
                        Activity.leftShiftPressed();
                        leftPressed = true
                    }
                }
            }
        }

        Image {
            id: rightShift
            mirror: true
            x: main.width/2 + 140.0
            y: main.height - 150
            source: "qrc:/gcompris/src/activities/ballcatch/resource/shift_key.svg"
            opacity: rightPressed ? 1 : 0.5
            MultiPointTouchArea {
                id: mouseAreaRightShift
                anchors.fill: parent
                onTouchUpdated: {
                    // right
                    if(!rightPressed) {
                        Activity.rightShiftPressed();
                        rightPressed = true
                    }
                }
            }
        }

        // Instructions
        TextEdit {
            id: instructions
            text: ApplicationInfo.isMobile ?
                      qsTr("Tap both side of the ball,
to make the ball go in a straight line.") :
                      qsTr("Press the two shift keys at the same time,
to make the ball go in a straight line.")
            x: main.width/2 + 120.0
            y: main.height/2
            width: main.width-x
            readOnly: true
            wrapMode: TextEdit.WordWrap
            horizontalAlignment: TextEdit.AlignHCenter
            verticalAlignment: TextEdit.AlignVCenter
            // Remove the text when both keys has been pressed
            visible: !(leftPressed && rightPressed)
        }

        function playSound(identifier) {
            if(identifier == "tuxok") {
                tuxok.play()
            }
            else if(identifier == "youcannot") {
                youcannot.play()
            }
            else if(identifier == "brick") {
                brick.play()
            }
        }

        Audio {
            id: brick
            source: "qrc:/gcompris/src/activities/ballcatch/resource/brick.wav"
            onError: console.log("brick play error: " + errorString)
        }

        Audio {
            id: tuxok
            source: "qrc:/gcompris/src/activities/ballcatch/resource/tuxok.wav"
            onError: console.log("tux play error: " + errorString)
        }

        Audio {
            id: youcannot
            source: "qrc:/gcompris/src/activities/ballcatch/resource/youcannot.wav"
            onError: console.log("youcannot play error: " + errorString)
        }

        /* Timer starting when user first presses a shift key.
           If still running when the user presses the other shift key, he wins !
        */
        Timer {
            id: deltaPressedTimer
            running: false; repeat: false
            onTriggered: {
                Activity.endTimer()
                ball.startAnimation()
            }
        }

        Ball {
            id: ball
        }

    }
}
