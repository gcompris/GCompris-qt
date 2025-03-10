/* GCompris - Creature.qml
*
* SPDX-FileCopyrightText: 2014 Manuel Tondeur <manueltondeur@gmail.com>
* SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
*
* Authors:
*   Joe Neeman (spuzzzzzzz@gmail.com) (GTK+ version)
*   Manuel Tondeur <manueltondeur@gmail.com> (Qt Quick port)
*   Timothée Giet <animtim@gmail.com> (refactoring)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12

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
    readonly property int moveRight: 0
    readonly property int moveLeft: 1
    readonly property int moveDown: 2
    readonly property int moveUp: 3

    function moveTo(direction: int): bool {
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
        index = 0;
    }

    function hasReachLimit(direction: int): bool {
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

    function movementOn(direction: int) {
        // Compute if the direction is vertical (1) or not (0)
        var vertical = Math.floor(direction / 2)
        var sign = Math.pow(-1, (direction))
        index += sign * (1 + 5 * vertical)
    }

    z: 0
    movable: true
    x: width * (index % 6)
    y: height * Math.floor(index / 6)

    onEatingChanged: {
        if(eating == true) {
            creatureImage.restart()
            creatureImage.resume()
        }
    }

    AnimatedSprite {
        id: creatureImage

        property int turn: 0

        anchors.centerIn: parent
        width: Math.min(parent.width, parent.height)
        height: width
        source: "qrc:/gcompris/src/activities/gnumch-equality/resource/"
                + creature.monsterType + ".svg"

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
                creature.movingOn = !creature.movingOn
            }
        }
    }

    Behavior on y {
        NumberAnimation {
            id: yAnim
            duration: 300
            onRunningChanged: {
                creature.movingOn = !creature.movingOn
            }
        }
    }

    Behavior on opacity {
        NumberAnimation {
            duration: 500
        }
    }
}
