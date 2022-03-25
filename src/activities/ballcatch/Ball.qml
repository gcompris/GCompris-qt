/* gcompris - Ball.qml

 SPDX-FileCopyrightText: 2014 Johnny Jazeix <jazeix@gmail.com>

 Bruno Coudoin: initial Gtk+ version

 SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12
import "ballcatch.js" as Activity
import GCompris 1.0

Image {
    id: ball

    property bool isVertical: background.width <= background.height    // To check if in Vertical mode

    source: "qrc:/gcompris/src/activities/ballcatch/resource/ball.svg"
    sourceSize.height: background.isVertical ? 175 * Application.ratio : 200 * ApplicationInfo.ratio
    z: 3

    readonly property real initScale: 1.0

    // If won, ball goes on tux, if lose, depends on the side clicked first
    property int finishX

    readonly property int finishY: tux.y + tux.height / 4
    readonly property real finishScale: initScale / 2
    property int radius: initScale
    property bool levelChange: false    //needed in case of changing level while animation is running

    function stop() {
        levelChange = true;
        animation.stop();
    }

    ParallelAnimation {
        id: animation
        running: false

        NumberAnimation { target: ball; property: "x";
                          to: finishX; duration: 1000
                          easing.type: Easing.InOutQuad }
        NumberAnimation { target: ball; property: "y";
                          to: finishY; duration: 1000
                          easing.type: Easing.InOutQuad }
        NumberAnimation { target: ball; property: "scale";
                          to: finishScale; duration: 1000
                          easing.type: Easing.InOutQuad }
        NumberAnimation { target: ball; property: "rotation";
                          to: 360; duration: 1000
                          easing.type: Easing.InOutQuad }
        onStarted: {
            items.background.playSound("brick");
        }

        onStopped: {
            // We are done with the ballon move
            if(levelChange) {
                return
            } else if(Activity.gameWon) {
                // This is a win
                items.background.playSound("completetask");
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
            finishX = tux.x + tux.width * 2;
        }
        else {
            finishX = tux.x - tux.width * 2;
        }
        /* Only start the timer if the game is at init state.
           In init state, radius is initScale */
        if(ball.radius == ball.initScale)
            animation.start();
    }

    function reinitBall() {
        x = background.width / 2 - width / 2;
        y = leftHand.y - height / 3;
        ball.scale = initScale;
        ball.rotation = 0;
        levelChange = false;
    }
}
