import QtQuick 2.3
import GCompris 1.0

Creature {
    function getCaught(index) {
        if (!movable) {
            return
        }

        caughted = true

        opacity = 0
        warningRect.setFault(index)
        warningRect.opacity = 0.9

        if (topPanel.life.opacity == 1) {
            topPanel.life.opacity = 0
            spawningMonsters.stop()
            movable = false
            monsters.setMovable(false)
        } else {
            bonus.bad("tux")
            monsters.destroyAll()
            spawningMonsters.restart()
            start()
        }
    }

    property bool caughted: false

    monsterType: "muncher"
    frames: 4
    frameW: 80
    widthRatio: 1.35
    Drag.active: ApplicationInfo.isMobile ? muncherArea.drag.active : false
    Drag.hotSpot.x: width / 2
    Drag.hotSpot.y: height / 2

    onMovingOnChanged: {
        if (movingOn == false && caughted) {
            init()
            caughted = false
        }
    }

    onIndexChanged: {
        moveSound.stop()
        moveSound.play()

        if (monsters.isThereAMonster(index)) {
            getCaught(-1)
        }
    }

    onOpacityChanged: {
        if (opacity == 0) {
            init()
        }
    }

    MouseArea {
        id: muncherArea

        anchors.fill: parent
        onClicked: {
            if (ApplicationInfo.isMobile) {
                background.checkAnswer()
            }
        }
    }

    MouseArea {
        id: left

        width: parent.width
        height: parent.height

        anchors.right: parent.left
        anchors.verticalCenter: parent.verticalCenter
        onClicked: {
            if (ApplicationInfo.isMobile) {
                moveTo(1)
            }
        }
    }

    MouseArea {
        id: right

        width: parent.width
        height: parent.height

        anchors.left: parent.right
        anchors.verticalCenter: parent.verticalCenter
        onClicked: {
            if (ApplicationInfo.isMobile) {
                moveTo(0)
            }
        }
    }

    MouseArea {
        id: bottom

        width: parent.width
        height: parent.height

        anchors.top: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {
            if (ApplicationInfo.isMobile) {
                moveTo(2)
            }
        }
    }


    MouseArea {
        id: top

        width: parent.width
        height: parent.height

        anchors.bottom: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {
            if (ApplicationInfo.isMobile) {
                moveTo(3)
            }
        }
    }
}
