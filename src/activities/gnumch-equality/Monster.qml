import QtQuick 2.2

import "gnumch-equality.js" as Activity

Creature {
    id: monster

    property int direction
    property var player

    function checkCell() {
        if (index == player.index) {
            player.getCaught(-1)
            player.opacity = 0
            eating = true
        }

        if (monsters.checkOtherMonster(index)) {
            eating = true
        }
    }

    opacity: 0

    onMovingOnChanged: {
        console.log("movingon change")
        if (movingOn == false) {
            checkCell()
        }
    }

    onOpacityChanged: {
        if (opacity == 1) {
            checkCell()
        }
    }

    Timer {
        id: timerMove
        interval: 2000
        running: true
        repeat: true

        onTriggered: {
            if (!moveTo(direction)) {
                var vertical = Math.floor(direction/2)
                var sign = Math.pow(-1,(direction))
                y = y + sign * grid.cellHeight * vertical
                x = x - sign * grid.cellWidth * (vertical - 1)
                opacity = 0
            }

        }
    }

    Behavior on opacity {
        NumberAnimation {
            id: animationEnd
            duration: 500

            onRunningChanged: {
                if (!animationEnd.running && monster.opacity == 0) {
                    monster.destroy()
                }
            }
        }
    }
}
