/* GCompris - Creature.qml
*
* SPDX-FileCopyrightText: 2014 Manuel Tondeur <manueltondeur@gmail.com>
*
* Authors:
*   Joe Neeman (spuzzzzzzz@gmail.com) (GTK+ version)
*   Manuel Tondeur <manueltondeur@gmail.com> (Qt Quick port)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12
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
    property int frameSize: 320
    property int animCount: 0
    property GCSfx audioEffects
    readonly property int moveRight: 0
    readonly property int moveLeft: 1
    readonly property int moveDown: 2
    readonly property int moveUp: 3

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
        y = Math.floor(((index - restIndex) / 6) * grid.cellHeight)
        x = Math.floor(restIndex * grid.cellWidth)
    }

    function updatePosition() {
        var restIndex = index % 6
        y = Math.floor(((index - restIndex) / 6) * grid.cellHeight)
        x = Math.floor(restIndex * grid.cellWidth)
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
        width: Math.min(parent.width, parent.height)
        height: width
        source: "qrc:/gcompris/src/activities/gnumch-equality/resource/"
                + monsterType + ".svg"

        frameCount: creature.frames
        frameWidth: creature.frameSize
        frameHeight: creature.frameSize
        frameDuration: 50
        currentFrame: 0
        running: false
        interpolate: false

        onCurrentFrameChanged: {
            creature.animCount++
            if (creature.animCount == creature.frames) {
                creature.animCount = 0
                turn++
            }
        }

        onTurnChanged: {
            if (turn == 2) {
                creature.eating = false
                turn = 0
                currentFrame = 0
                creature.animCount = 0
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
