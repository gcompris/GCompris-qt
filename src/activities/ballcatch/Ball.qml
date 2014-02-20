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
import QtMultimedia 5.0
import "ballcatch.js" as Activity
import GCompris 1.0

Item {
    readonly property int initRadius: 130

    // If won, ball goes on tux, if loose, depends on the side clicked first
    property int finishX

    readonly property int finishY: tux.y+tux.height/2
    readonly property int finishRadius: initRadius/3

    property int radius: initRadius

    z: 3

    Image {
        id: circle
        source: "qrc:/gcompris/src/activities/ballcatch/resource/ball.svg"
        width: radius
        height: width
    }

    ParallelAnimation {
        id: animation

        running: false

        NumberAnimation { target: ball; property: "x";
                          to: ball.finishX; duration: 1000 }
        NumberAnimation { target: ball; property: "y";
                          to: ball.finishY; duration: 1000 }
        NumberAnimation { target: circle; property: "width";
                          to: ball.finishRadius; duration: 1000 }
        NumberAnimation { target: circle; property: "rotation";
                          to: 360; duration: 1000 }

        onStopped: {
            // We are done with the ballon move
            if(gameWon) {
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
        if(gameWon) {
            finishX = tux.x+tux.width/2-ball.finishRadius/2
        }
        else if(activity.leftPressed) {
            finishX = background.width - 2*ball.finishRadius
        }
        else {
            finishX = ball.finishRadius
        }
        /* Only start the timer if the game is at init state.
           In init state, radius is initRadius */
        if(ball.radius == ball.initRadius)
            animation.start()
    }

    function reinitBall() {
        x = background.width / 2 - 65;
        y = leftHand.y;
        circle.width = initRadius;
        circle.rotation = 0;
    }
}
