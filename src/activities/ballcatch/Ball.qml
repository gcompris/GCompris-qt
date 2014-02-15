/* gcompris - Ball.qml

 Copyright (C) 2003, 2014 Bruno Coudoin and Johnny Jazeix

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
    property int initX: background.width / 2 - 65
    property int initY: leftHand.y
    property int initRadius: 130

    property int finishX // If won, ball goes on tux, if loose, depends on the side clicked first
    property int finishY: tux.y+tux.height/2
    property int finishRadius: initRadius/3

    property int radius: initRadius
    x: initX
    y: initY
    z: 3

    onRadiusChanged: {
        circle.radius=radius
    }

    Rectangle {
        id: circle
        width: radius
        height: width
        color: "red"
        border.color: "black"
        border.width: 5
    }

    ParallelAnimation {
        id: animation

        running: false

        NumberAnimation { target: ball; property: "x"; from: ball.initX; to: ball.finishX; duration: 1000 }
        NumberAnimation { target: ball; property: "y"; from: ball.initY; to: ball.finishY; duration: 1000 }
        NumberAnimation { target: ball; property: "radius"; to: ball.finishRadius; duration: 1000 }

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
            finishX = ball.finishRadius
        }
        else {
            finishX = background.width - 2*ball.finishRadius
        }
        // Only start the timer if the game is at init state. In init state, radius is initRadius
        if(ball.radius == ball.initRadius)
            animation.start()
    }

    function reinitBall() {
        x = initX;
        y = initY;
        radius = initRadius;
    }
}
