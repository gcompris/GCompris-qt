/* gcompris - Ballcatch.qml

 SPDX-FileCopyrightText: 2014 Johnny Jazeix <jazeix@gmail.com>

 Bruno Coudoin: initial Gtk+ version

 SPDX-License-Identifier: GPL-3.0-or-later
*/
pragma ComponentBehavior: Bound

import QtQuick 2.12
import core 1.0

import "../../core"
import "../ballcatch"
import "ballcatch.js" as Activity

ActivityBase {
    id: activity

    onStart: {
        focus = true;
    }
    onStop: {}

    Keys.onPressed: (event) => {
        Activity.processKey(event);
    }

    pageComponent: Image {
        id: activityBackground
        signal start
        signal stop
        focus: true
        fillMode: Image.PreserveAspectCrop
        source: "qrc:/gcompris/src/activities/ballcatch/resource/beach1.svg"
        sourceSize.width: width
        sourceSize.height: height

        // Needed to get keyboard focus on IntroMessage
        Keys.forwardTo: [message]

        Component.onCompleted: {
            activity.start.connect(start);
            activity.stop.connect(stop);
        }
        QtObject {
            id: items
            property alias activityBackground: activityBackground
            property int currentLevel: activity.currentLevel
            property alias ball: ball
            property alias smudgeSound: smudgeSound
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

        GCSoundEffect {
            id: smudgeSound
            source: "qrc:/gcompris/src/core/resource/sounds/smudge.wav"
        }

        DialogHelp {
            id: dialogHelpLeftRight
            onClose: activity.home();
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: activity.displayDialog(dialogHelpLeftRight);
            onPreviousLevelClicked: if(!bonus.isPlaying) Activity.previousLevel();
            onNextLevelClicked: if(!bonus.isPlaying) Activity.nextLevel();
            onHomeClicked: activity.home();
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
            x: activityBackground.width * 0.5 - width * 0.5
            y: activityBackground.height * 0.6 - height
            sourceSize.height: Math.min(activityBackground.height * 0.3, 200 * ApplicationInfo.ratio)
            source: "qrc:/gcompris/src/activities/ballcatch/resource/tux.svg"
            Behavior on opacity { PropertyAnimation { easing.type: Easing.InQuad; duration: 250 } }
        }

        Image {
            id: leftHand
            x: Math.max(0, activityBackground.width * 0.5 - width * 2)
            y: activityBackground.height * 0.5
            z: 5
            sourceSize.height: Math.min(Math.min(activityBackground.width * 0.25, activityBackground.height * 0.25), 150 * ApplicationInfo.ratio)
            source: "qrc:/gcompris/src/activities/ballcatch/resource/hand.svg"

            NumberAnimation {
                id: leftHandAnimation
                target: leftHand; property: "x";
                to: activityBackground.width * 0.5 - leftHand.width - 5;
                duration: 1000
                easing.type: Easing.InOutQuad
            }

            function animate(newTime: int) {
                leftHandAnimation.duration = newTime;
                leftHandAnimation.start();
            }

            function reinitPosition() {
                leftHandAnimation.stop();
                leftHand.x = Math.max(0, activityBackground.width * 0.5 - width * 2);
                leftHand.y = activityBackground.height * 0.5;
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
            x: Math.min(activityBackground.width * 0.5 + width, activityBackground.width - width);
            y: activityBackground.height * 0.5
            z: 5
            sourceSize.height: leftHand.sourceSize.height
            source: "qrc:/gcompris/src/activities/ballcatch/resource/hand.svg"

            function animate(newTime: int) {
                rightHandAnimation.duration = newTime;
                rightHandAnimation.start();
            }

            function reinitPosition() {
                rightHandAnimation.stop();
                rightHand.x = Math.min(activityBackground.width * 0.5 + width, activityBackground.width - width);
                rightHand.y = activityBackground.height * 0.5;
            }

            NumberAnimation {
                id: rightHandAnimation
                target: rightHand; property: "x";
                to: activityBackground.width * 0.5 + 5;
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
            x: activityBackground.width * 0.2 - width * 0.5
            y: activityBackground.height * 0.5 - height
            source: "qrc:/gcompris/src/activities/ballcatch/resource/arrow_key.svg"
            sourceSize.width: Math.min(100 * ApplicationInfo.ratio, Math.min(activityBackground.height * 0.2, activityBackground.width * 0.2))
            opacity: items.leftPressed ? 1 : 0.5
            visible: !ApplicationInfo.isMobile
        }

        Image {
            id: rightShift
            z: 10
            mirror: true
            x: activityBackground.width * 0.8 - width * 0.5
            y: leftShift.y
            source: "qrc:/gcompris/src/activities/ballcatch/resource/arrow_key.svg"
            sourceSize.width: leftShift.sourceSize.width
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
            z: 10
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
