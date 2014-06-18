import QtQuick 2.2
import QtMultimedia 5.0

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
            eatSound.play()
        }
    }

    onWidthChanged: updatePosition()

    AnimatedSprite {
        id: creatureImage

        property int turn: 0

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width / parent.height < widthRatio ? parent.width * 0.85 : parent.height * 0.85 * widthRatio
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
