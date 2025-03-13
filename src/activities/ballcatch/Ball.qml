/* gcompris - Ball.qml

 SPDX-FileCopyrightText: 2014 Johnny Jazeix <jazeix@gmail.com>

 Bruno Coudoin: initial Gtk+ version

 SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12
import "ballcatch.js" as Activity
import core 1.0
import "../../core"

Image {
    id: ball
    source: "qrc:/gcompris/src/activities/ballcatch/resource/ball.svg"
    sourceSize.height: 100 * ApplicationInfo.ratio
    z: 3

    readonly property real initScale: 1.0

    // If won, ball goes on tux, if lose, depends on the side clicked first
    property int finishX

    readonly property int finishY: tux.y + tux.paintedHeight - height
    readonly property real finishScale: 0.5
    property int radius: initScale
    property bool levelChange: false    //needed in case of changing level while animation is running

    function stop() {
        levelChange = true;
        animation.stop();
    }

    GCSoundEffect {
        id: brickSound
        source: "qrc:/gcompris/src/core/resource/sounds/brick.wav"
    }

    GCSoundEffect {
        id: winSound
        source: "qrc:/gcompris/src/core/resource/sounds/completetask.wav"
    }

    ParallelAnimation {
        id: animation
        running: false

        NumberAnimation { target: ball; property: "x";
                          to: ball.finishX; duration: 1000
                          easing.type: Easing.InOutQuad }
        NumberAnimation { target: ball; property: "y";
                          to: ball.finishY; duration: 1000
                          easing.type: Easing.InOutQuad }
        NumberAnimation { target: ball; property: "scale";
                          to: ball.finishScale; duration: 1000
                          easing.type: Easing.InOutQuad }
        NumberAnimation { target: ball; property: "rotation";
                          to: 360; duration: 1000
                          easing.type: Easing.InOutQuad }
        onStarted: {
            brickSound.play();
        }

        onStopped: {
            // We are done with the ball move
            if(ball.levelChange) {
                return
            } else if(Activity.gameWon) {
                // This is a win
                winSound.play();
                bonus.good("tux");
            } else {
                // This is a lose
                bonus.bad("tux");
            }
        }
    }

    function startAnimation() {
        if(Activity.gameWon) {
            finishX = x;
        }
        else if(Activity.items.leftPressed) {
            finishX = tux.x + tux.paintedWidth;
        }
        else {
            finishX = tux.x - tux.paintedWidth;
        }
        /* Only start the timer if the game is at init state.
           In init state, radius is initScale */
        if(ball.radius == ball.initScale)
            animation.start();
    }

    function reinitBall() {
        x = activityBackground.width * 0.5 - width * 0.5;
        y = leftHand.y + leftHand.height * 0.5 - height * 0.5;
        ball.scale = initScale;
        ball.rotation = 0;
        levelChange = false;
    }
}
