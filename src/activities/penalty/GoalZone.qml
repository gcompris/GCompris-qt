/* GCompris - GoalZone.qml
*
* Copyright (C) 2017 Rohit Das <rohit.das950@gmail.com>
*
*   This program is free software; you can redistribute it and/or modify
*   it under the terms of the GNU General Public License as published by
*   the Free Software Foundation; either version 3 of the License, or
*   (at your option) any later version.
*
*   This program is distributed in the hope that it will be useful,
*   but WITHOUT ANY WARRANTY; without even the implied warranty of
*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*   GNU General Public License for more details.
*
*   You should have received a copy of the GNU General Public License
*   along with this program; if not, see <https://www.gnu.org/licenses/>.
*/
import QtQuick 2.6
import './penalty.js' as Activity

Rectangle {
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    anchors.top: parent.top
    anchors.topMargin: parent.height * 0.07
    property var progress: undefined
    state: "INITIAL"
    color: "transparent"

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MidButton
        /* enabled if the current zone has been clicked on or if the ball is at the initial position */
        enabled: items.saveBallState === parent.state || (items.saveBallState === "INITIAL" && ball.x === items.ballX && ball.y === items.ballY)
        onClicked: changeBallState()
    }

    function changeBallState() {
        instruction.text = ""

        if(ball.state === "FAIL") {
            Activity.resetLevel()
            return
        }

        /* This is a shoot */
        if (items.saveBallState === "INITIAL") {
            items.saveBallState = state
        }

        if(progress.ratio > 0) {
            /* Second click, stop animation */
            progress.anim.running = false;

            /* Play sound */
            activity.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/brick.wav")

            /* Success or not */
            if(progress.ratio < 100) {
                /* Success */
                ball.state = state
            } else {
                /* failure */
                ball.state = "FAIL"
            }
            timerBonus.start()
        } else {
            /* First click, start animation*/
            progress.anim.running = true;

            /* Play sound */
            activity.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/flip.wav")
        }
    }
}
