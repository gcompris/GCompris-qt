/* gcompris - Ballcatch.qml

 SPDX-FileCopyrightText: 2014 Johnny Jazeix <jazeix@gmail.com>

 Bruno Coudoin: initial Gtk+ version

 SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12
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
        Activity.processKey(event);
    }

    pageComponent: Image {
        id: background
        signal start
        signal stop
        focus: true
        fillMode: Image.PreserveAspectCrop
        source: "qrc:/gcompris/src/activities/ballcatch/resource/beach1.svg"
        sourceSize.width: width
        sourceSize.height: height

        property bool isVertical: background.width <= background.height     // To check if in Vertical mode

        // Needed to get keyboard focus on IntroMessage
        Keys.forwardTo: message

        Component.onCompleted: {
            activity.start.connect(start);
            activity.stop.connect(stop);
        }
        QtObject {
            id: items
            property alias background: background
            property int currentLevel: activity.currentLevel
            property alias ball: ball
            property alias rightHand: rightHand
            property alias leftHand: leftHand
            property alias deltaPressedTimer: deltaPressedTimer
            /* when the corresponding arrow key is pressed, the following boolean pass
               to true and is reset at the end of the level */
            property bool leftPressed
            property bool rightPressed
        }

        onStart: Activity.start(items);

        onStop: Activity.stop();

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
            onClose: home();
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: displayDialog(dialogHelpLeftRight);
            onPreviousLevelClicked: if(!bonus.isPlaying) Activity.previousLevel();
            onNextLevelClicked: if(!bonus.isPlaying) Activity.nextLevel();
            onHomeClicked: home();
        }

        Bonus {
            id: bonus
            winSound: "qrc:/gcompris/src/activities/ballcatch/resource/tuxok.wav"
            looseSound: "qrc:/gcompris/src/activities/ballcatch/resource/youcannot.wav"
            Component.onCompleted: {
                win.connect(Activity.nextLevel);
                loose.connect(Activity.restartLevel);
            }
            onStart: tux.opacity = 0;
            onStop: tux.opacity = 1;
        }

        Image {
            id: tux
            x: background.width / 2 - width / 2
            y: leftHand.y - height / 3 - height / 2
            sourceSize.height: 200 * ApplicationInfo.ratio
            source: "qrc:/gcompris/src/activities/ballcatch/resource/tux.svg"
            Behavior on opacity { PropertyAnimation { easing.type: Easing.InQuad; duration: 250 } }
        }

        Image {
            id: leftHand
            y: background.height - 1.5 * height
            z: 5
            sourceSize.height: 150 * ApplicationInfo.ratio
            source: "qrc:/gcompris/src/activities/ballcatch/resource/hand.svg"

            NumberAnimation {
                id: leftHandAnimation
                target: leftHand; property: "x";
                to: background.width/2 - leftHand.width - 5;
                duration: 1000
                easing.type: Easing.InOutQuad
            }

            function animate(newTime) {
                leftHandAnimation.duration = newTime;
                leftHandAnimation.start();
            }

            function reinitPosition() {
                leftHandAnimation.stop();
                leftHand.x = background.width / 2 - width * 2;
                leftHand.y = background.height - 1.5 * height;
            }

            MultiPointTouchArea {

                id: mouseAreaLeftShift
                anchors.fill: parent
                onTouchUpdated: {
                    // left
                    if(!items.leftPressed && !Activity.gameFinished) {
                        Activity.leftShiftPressed();
                        items.leftPressed = true;
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
            source: "qrc:/gcompris/src/activities/ballcatch/resource/hand.svg"

            function animate(newTime) {
                rightHandAnimation.duration = newTime;
                rightHandAnimation.start();
            }

            function reinitPosition() {
                rightHandAnimation.stop();
                rightHand.x = background.width / 2 + width;
                rightHand.y = background.height - 1.5 * height;
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
                        items.rightPressed = true;
                    }
                }
            }
        }

        Image {
            id: leftShift
            z: 10
            x: background.width / 4 - width
            y: background.isVertical ? rightHand.y - height : rightHand.y - height / 2
            source: "qrc:/gcompris/src/activities/ballcatch/resource/arrow_key.svg"
            scale: background.isVertical ? 0.75 : 1.0
            smooth: true
            opacity: items.leftPressed ? 1 : 0.5
            visible: !ApplicationInfo.isMobile
        }

        Image {
            id: rightShift
            z: 10
            mirror: true
            x: background.width - background.width / 4
            y: background.isVertical ? rightHand.y - height : rightHand.y - height / 2
            source: "qrc:/gcompris/src/activities/ballcatch/resource/arrow_key.svg"
            scale: background.isVertical ? 0.75 : 1.0
            smooth: true
            opacity: items.rightPressed ? 1 : 0.5
            visible: !ApplicationInfo.isMobile
        }

        // Instructions
        IntroMessage {
            id: message
            intro: ApplicationInfo.isMobile ?
                       [qsTr("Tap both hands at the same time, " +
                            "to make the ball go in a straight line.")] :
                       [qsTr("Press left and right arrow keys at the same time, " +
                            "to make the ball go in a straight line.")]
            anchors {
                top: parent.top
                topMargin: 10
            }
            z: 10
        }

        function playSound(identifier) {
            activity.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/"+ identifier + ".wav");
        }

        /* Timer starting when user first presses a first key.
           If still running when the user presses the other key, he wins !
        */
        Timer {
            id: deltaPressedTimer
            running: false; repeat: false
            onTriggered: {
                Activity.endTimer();
                ball.startAnimation();
            }
        }

        Ball {
            id: ball
        }

    }
}
