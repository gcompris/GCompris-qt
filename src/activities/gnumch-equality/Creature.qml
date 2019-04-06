/* GCompris - Creature.qml
*
* Copyright (C) 2014 Manuel Tondeur <manueltondeur@gmail.com>
*
* Authors:
*   Joe Neeman (spuzzzzzzz@gmail.com) (GTK+ version)
*   Manuel Tondeur <manueltondeur@gmail.com> (Qt Quick port)
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
import GCompris 1.0
import "../../core"

Item {
    id: creature

    property int index
    property string monsterType
    property bool movable
    property bool movingOn: false
    property bool eating: false
    property int frames
    property int frameW
    property real widthRatio
    property GCSfx audioEffects

    function moveTo(direction) {
        if (!movable)
            return true

        if (!hasReachLimit(direction)) {
            movementOn(direction)
            return true
        } else {

            return false
        }
    }

    function init() {
        index = 0
        x = 0
        y = 0
    }

    function hasReachLimit(direction) {
        switch (direction) {
        case 0:
            if ((index + 1) % 6 > 0)
                return false
            break
        case 1:
            if ((index % 6) > 0)
                return false
            break
        case 2:
            if (index < 30)
                return false
            break
        case 3:
            if (index > 5)
                return false
            break
        }
        return true
    }

    function movementOn(direction) {
        // Compute if the direction is vertical (1) or not (0)
        var vertical = Math.floor(direction / 2)
        var sign = Math.pow(-1, (direction))
        index += sign * (1 + 5 * vertical)
        var restIndex = index % 6
        y = ((index - restIndex) / 6) * grid.cellHeight
        x = restIndex * grid.cellWidth
    }

    function updatePosition() {
        var restIndex = index % 6
        y = ((index - restIndex) / 6) * grid.cellHeight
        x = restIndex * grid.cellWidth
    }

    index: 0
    z: 0
    movable: true
    width: grid.cellWidth
    height: grid.cellHeight

    onEatingChanged: {
        if (eating == true) {
            creatureImage.restart()
            creatureImage.resume()
            creature.audioEffects.play("qrc:/gcompris/src/activities/gnumch-equality/resource/eat.wav")
        }
    }

    AnimatedSprite {
        id: creatureImage

        property int turn: 0

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width / parent.height <= widthRatio ? parent.width * 0.85 : parent.height * 0.85 * widthRatio
        height: width * (1/widthRatio)
        source: "qrc:/gcompris/src/activities/gnumch-equality/resource/"
                + monsterType + ".png"

        frameCount: frames
        frameWidth: frameW
        frameDuration: 50
        currentFrame: 0
        running: false

        onCurrentFrameChanged: {
            if (currentFrame == frames - 1) {
                turn++
            }
        }

        onTurnChanged: {
            if (turn == 2) {
                eating = false
                turn = 0
                currentFrame = 0
                pause()
            }
        }
    }

    Behavior on x {
        NumberAnimation {
            id: xAnim
            duration: 300
            onRunningChanged: {
                movingOn = !movingOn
            }
        }
    }

    Behavior on y {
        NumberAnimation {
            id: yAnim
            duration: 300
            onRunningChanged: {
                movingOn = !movingOn
            }
        }
    }

    Behavior on opacity {
        NumberAnimation {
            duration: 500
        }
    }
}
