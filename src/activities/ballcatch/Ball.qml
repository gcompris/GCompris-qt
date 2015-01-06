/* gcompris - Ball.qml

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
import "ballcatch.js" as Activity
import GCompris 1.0

Image {
    id: ball
    source: "qrc:/gcompris/src/activities/ballcatch/resource/ball.svgz"
    sourceSize.height: 100 * ApplicationInfo.ratio
    z: 3

    readonly property real initScale: 1.0

    // If won, ball goes on tux, if loose, depends on the side clicked first
    property int finishX

    readonly property int finishY: tux.y + tux.height / 2
    readonly property real finishScale: initScale / 2
    property int radius: initScale

    ParallelAnimation {
        id: animation
        running: false

        NumberAnimation { target: ball; property: "x";
                          to: finishX; duration: 1000 }
        NumberAnimation { target: ball; property: "y";
                          to: finishY; duration: 1000 }
        NumberAnimation { target: ball; property: "scale";
                          to: finishScale; duration: 1000 }
        NumberAnimation { target: ball; property: "rotation";
                          to: 360; duration: 1000 }

        onStopped: {
            // We are done with the ballon move
            if(Activity.gameWon) {
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

    function startAnimation() {
        if(Activity.gameWon) {
            finishX = x
        }
        else if(Activity.leftPressed) {
            finishX = tux.x + tux.width * 2
        }
        else {
            finishX = tux.x - tux.width * 2
        }
        /* Only start the timer if the game is at init state.
           In init state, radius is initScale */
        if(ball.radius == ball.initScale)
            animation.start()
    }

    function reinitBall() {
        x = background.width / 2 - width / 2;
        y = leftHand.y + 10;
        ball.scale = initScale;
        ball.rotation = 0;
    }
}
