/* gcompris - Ball.qml

 Copyright (C) 2014 Johnny Jazeix <jazeix@gmail.com>

 Bruno Coudoin: initial Gtk+ version

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
import QtQuick 2.6
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
            items.background.playSound("brick")
        }

        onStopped: {
            // We are done with the ballon move
            if(Activity.gameWon) {
                // This is a win
                items.background.playSound("completetask")
                bonus.good("tux")
            }
            else {
                // This is a lose
                bonus.bad("tux")
            }
        }
    }

    function startAnimation() {
        if(Activity.gameWon) {
            finishX = x
        }
        else if(Activity.items.leftPressed) {
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
        y = leftHand.y - height / 3;
        ball.scale = initScale;
        ball.rotation = 0;
    }
}
