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
import GCompris 1.0

import "../../core"
import "../ballcatch"
import "ballcatch.js" as Activity

ActivityBase {
    id: activity

    onStart: {
        focus = true;
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
        sourceSize.width: parent.width

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
            /* when the corresponding arrow key is pressed, the following boolean pass
               to true and is reseted at the end of the level */
            property bool leftPressed
            property bool rightPressed
        }

        onStart: {
            Activity.start(items)
        }

        onStop: { Activity.stop() }

        onWidthChanged: {
            leftHand.reinitPosition();
            rightHand.reinitPosition();
            ball.reinitBall();
        }

        onHeightChanged: {
            leftHand.reinitPosition();
            rightHand.reinitPosition();
            ball.reinitBall();
        }

        DialogHelp {
            id: dialogHelpLeftRight
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: {
                displayDialog(dialogHelpLeftRight)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: home()
        }

        Bonus {
            id: bonus
            winSound: "qrc:/gcompris/src/activities/ballcatch/resource/tuxok.wav"
            looseSound: "qrc:/gcompris/src/activities/ballcatch/resource/youcannot.wav"
            Component.onCompleted: {
                win.connect(Activity.nextLevel)
                loose.connect(Activity.restartLevel)
            }
        }

        Image {
            id: tux
            x: background.width / 2 - width / 2
            y: background.height / 3
            sourceSize.height: 100 * ApplicationInfo.ratio
            source: "qrc:/gcompris/src/activities/ballcatch/resource/tux.svgz"
        }

        Image {
            id: leftHand
            y: background.height - 1.5 * height
            z: 5
            sourceSize.height: 150 * ApplicationInfo.ratio
            source: "qrc:/gcompris/src/activities/ballcatch/resource/hand.svgz"

            NumberAnimation {
                id: leftHandAnimation
                target: leftHand; property: "x";
                to: background.width/2 - leftHand.width - 5;
                duration: 1000
                easing.type: Easing.InOutQuad
            }

            function animate(newTime) {
                leftHandAnimation.duration = newTime
                leftHandAnimation.start();
            }

            function reinitPosition() {
                leftHand.x = background.width / 2 - width * 2
                leftHand.y = background.height - 1.5 * height
            }

            MultiPointTouchArea {

                id: mouseAreaLeftShift
                anchors.fill: parent
                onTouchUpdated: {
                    // left
                    if(!items.leftPressed && !Activity.gameFinished) {
                        Activity.leftShiftPressed();
                        items.leftPressed = true
                    }
                }
            }
        }

        Image {
            id: rightHand
            mirror: true
            y: background.height - 1.5 * height
            z: 5
            sourceSize.height: 150 * ApplicationInfo.ratio
            source: "qrc:/gcompris/src/activities/ballcatch/resource/hand.svgz"

            function animate(newTime) {
                rightHandAnimation.duration = newTime
                rightHandAnimation.start();
            }

            function reinitPosition() {
                rightHand.x = background.width / 2 + width
                rightHand.y = background.height - 1.5 * height
            }

            NumberAnimation {
                id: rightHandAnimation
                target: rightHand; property: "x";
                to: background.width / 2 + 5;
                duration: 1000;
                easing.type: Easing.InOutQuad
            }

            MultiPointTouchArea {
                id: mouseAreaRightShift
                anchors.fill: parent
                onTouchUpdated: {
                    // right
                    if(!items.rightPressed && !Activity.gameFinished) {
                        Activity.rightShiftPressed();
                        items.rightPressed = true
                    }
                }
            }
        }

        Image {
            id: leftShift
            x: 10
            y: rightHand.y
            source: "qrc:/gcompris/src/activities/ballcatch/resource/arrow_key.svgz"
            opacity: items.leftPressed ? 1 : 0.5
            visible: !ApplicationInfo.isMobile
        }

        Image {
            id: rightShift
            mirror: true
            x: background.width - width - 10
            y: rightHand.y
            source: "qrc:/gcompris/src/activities/ballcatch/resource/arrow_key.svgz"
            opacity: items.rightPressed ? 1 : 0.5
            visible: !ApplicationInfo.isMobile
        }

        // Instructions
        BorderImage {
            id: bubble
            x: 10.0
            y: tux.y
            border.left: 3 * ApplicationInfo.ratio
            border.top: 3 * ApplicationInfo.ratio
            border.right: 20 * ApplicationInfo.ratio
            border.bottom: 3 * ApplicationInfo.ratio
            source: "qrc:/gcompris/src/activities/ballcatch/resource/bubble.svg"
            width: tux.x - 10
            height: instructions.height + 20 * ApplicationInfo.ratio
            // Remove the instructions when both keys has been pressed
            opacity: bar.level === 1 &&
                     !(items.leftPressed && items.rightPressed) ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 120 } }

            GCText {
                id: instructions
                anchors {
                    left: parent.left
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    leftMargin: 10 * ApplicationInfo.ratio
                    rightMargin: 20 * ApplicationInfo.ratio
                }
                text: ApplicationInfo.isMobile ?
                          qsTr("Tap both hands at the same time, " +
                               "to make the ball go in a straight line.") :
                          qsTr("Press left and right arrow keys at the same time, " +
                               "to make the ball go in a straight line.")
                wrapMode: TextEdit.WordWrap
                horizontalAlignment: TextEdit.AlignHCenter
                verticalAlignment: TextEdit.AlignVCenter
                fontSize: regularSize
            }
        }

        function playSound(identifier) {
            activity.audioEffects.play("qrc:/gcompris/src/activities/ballcatch/resource/"+ identifier + ".wav")
        }

        /* Timer starting when user first presses a first key.
           If still running when the user presses the other key, he wins !
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
