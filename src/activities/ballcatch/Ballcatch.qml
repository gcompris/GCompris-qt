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
        focus = true;
        Activity.initKey()
    }
    onStop: {}

    Keys.onPressed: {
        Activity.processKey(event)
    }

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
        QtObject {
            id: items
            property alias background: background
            property alias bar: bar
            property alias ball: ball
            property alias rightHand: rightHand
            property alias leftHand: leftHand
            property alias deltaPressedTimer: deltaPressedTimer
        }

        onStart: {
            Activity.start(items)
        }

        onStop: { Activity.stop() }

        onWidthChanged: {
            ball.reinitBall();
            leftHand.reinitPosition();
            rightHand.reinitPosition();
        }

        onHeightChanged: {
            ball.reinitBall();
            leftHand.reinitPosition();
            rightHand.reinitPosition();
        }

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
            x: main.width / 2 - width / 2
            y: main.height / 3
            sourceSize.height: 100 * ApplicationInfo.ratio
            source: "qrc:/gcompris/src/activities/ballcatch/resource/tux.svgz"
        }

        Image {
            id: leftHand
            y: main.height - 1.5 * height
            z: 5
            sourceSize.height: 150 * ApplicationInfo.ratio
            source: "qrc:/gcompris/src/activities/ballcatch/resource/hand.svgz"

            NumberAnimation {
                id: leftHandAnimation
                target: leftHand; property: "x";
                to: main.width/2 - leftHand.width - 5;
                duration: 1000; easing.type: Easing.InQuad
            }

            function animate(newTime) {
                leftHandAnimation.duration = newTime
                leftHandAnimation.start();
            }

            function reinitPosition() {
                leftHand.x = main.width / 2 - width * 2
            }

            MultiPointTouchArea {

                id: mouseAreaLeftShift
                anchors.fill: parent
                onTouchUpdated: {
                    // left
                    if(!Activity.leftPressed) {
                        Activity.leftShiftPressed();
                        Activity.leftPressed = true
                    }
                }
            }
        }

        Image {
            id: rightHand
            mirror: true
            y: main.height - 1.5 * height
            z: 5
            sourceSize.height: 150 * ApplicationInfo.ratio
            source: "qrc:/gcompris/src/activities/ballcatch/resource/hand.svgz"

            function animate(newTime) {
                rightHandAnimation.duration = newTime
                rightHandAnimation.start();
            }

            function reinitPosition() {
                rightHand.x = main.width / 2 + width
            }

            NumberAnimation {
                id: rightHandAnimation
                target: rightHand; property: "x";
                to: main.width / 2 + 5;
                duration: 1000;
                easing.type: Easing.InQuad
            }

            MultiPointTouchArea {
                id: mouseAreaRightShift
                anchors.fill: parent
                onTouchUpdated: {
                    // right
                    if(!Activity.rightPressed) {
                        Activity.rightShiftPressed();
                        Activity.rightPressed = true
                    }
                }
            }
        }

        Image {
            id: leftShift
            x: 10
            y: rightHand.y + rightHand.height / 2
            source: "qrc:/gcompris/src/activities/ballcatch/resource/shift_key.svgz"
            opacity: Activity.leftPressed ? 1 : 0.5
            visible: !ApplicationInfo.isMobile
        }

        Image {
            id: rightShift
            mirror: true
            x: main.width - width - 10
            y: rightHand.y + rightHand.height / 2
            source: "qrc:/gcompris/src/activities/ballcatch/resource/shift_key.svgz"
            opacity: Activity.rightPressed ? 1 : 0.5
            visible: !ApplicationInfo.isMobile
        }

        // Instructions
        Text {
            id: instructions
            text: ApplicationInfo.isMobile ?
                      qsTr("Tap both hands at the same time,
to make the ball go in a straight line.") :
                      qsTr("Press the two shift keys at the same time,
to make the ball go in a straight line.")
            x: 10.0
            y: tux.y
            width: tux.x - 10
            wrapMode: TextEdit.WordWrap
            horizontalAlignment: TextEdit.AlignHCenter
            verticalAlignment: TextEdit.AlignVCenter
            font.pointSize: 16
            // Remove the text when both keys has been pressed
            visible: !(Activity.leftPressed && Activity.rightPressed)
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
