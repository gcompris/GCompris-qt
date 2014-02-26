import QtQuick 2.1
import GCompris 1.0

import "qrc:/gcompris/src/core"
import "planegame.js" as Activity

ActivityBase {
    id: activity
    focus: true

    onStart: { focus = true; }
    onStop: { }

    readonly property int max_speed: 7
    property var cloudList
    property int currentLevel: 0
    readonly property int numberOfLevel: 2

    property bool upPressed: false
    property bool downPressed: false
    property bool leftPressed: false
    property bool rightPressed: false

    Keys.onPressed: {
        switch(event.key) {
        case Qt.Key_Right:
            rightPressed = true;
            event.accepted = true;
            break;
        case Qt.Key_Left:
            leftPressed = true;
            event.accepted = true;
            break;
        case Qt.Key_Up:
            upPressed = true;
            event.accepted = true;
            break;
        case Qt.Key_Down:
            downPressed = true;
            event.accepted = true;
        }
    }

    Keys.onReleased: {
        switch(event.key) {
        case Qt.Key_Right:
            rightPressed = false;
            event.accepted = true;
            break;
        case Qt.Key_Left:
            leftPressed = false;
            event.accepted = true;
            break;
        case Qt.Key_Up:
            upPressed = false;
            event.accepted = true;
            break;
        case Qt.Key_Down:
            downPressed = false;
            event.accepted = true;
        }
    }

    property int oldWidth: width

    onWidthChanged: {
        // Reposition helico and clouds, same for height
        if(Activity.plane != undefined) {
            Activity.repositionObjectsOnWidthChanged(width/oldWidth)
        }
        oldWidth = width
    }

    property int oldHeight: height
    onHeightChanged: {
        // Reposition helico and clouds, same for height
        if(Activity.plane != undefined) {
            Activity.repositionObjectsOnHeightChanged(height/oldHeight)
        }
        oldHeight = height
    }

    pageComponent: Image {
        id: background
        anchors.fill: parent
        signal start
        signal stop
        source: "qrc:/gcompris/src/activities/planegame/resource/background.svgz"

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }
        onStart: {
            Activity.start(main, background, bar, bonus, score, activity, plane)
            movePlaneTimer.start();
            cloudList = Activity.clouds
        }
        onStop: {
            Activity.stop();
            movePlaneTimer.stop()
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | previous | next }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }

        Score {
            id: score
            visible: (activity.currentLevel == 0) ? 1 : 0
        }

        Timer {
            id: movePlaneTimer
            running: true
            interval: 100+(40/(activity.currentLevel+1))
            repeat: true
            onTriggered: {
                plane.handleCollisionsWithCloud();
                plane.computeSpeed();
                plane.move();
            }
        }

        Timer {
            id: cloudCreation
            running: true
            interval: 10000-(activity.currentLevel*200)
            repeat: true
            onTriggered: {
                Activity.createCloud()
            }
        }

        Plane {
            id: plane
            background: background
            score: score
        }

        Item {
            id: multitouchFourArrowsOnSides
            anchors.fill: parent
            visible: ApplicationInfo.isMobile

            Arrow {
                id: leftArrow
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                mirror: true

                onButtonPressedChanged: {
                    leftPressed = buttonPressed;
                }
            }

            Arrow {
                id: rightArrow
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                onButtonPressedChanged: {
                    rightPressed = buttonPressed;
                }

            }
            Arrow {
                id: topArrow
                rotation: 270
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                onButtonPressedChanged: {
                    upPressed = buttonPressed;
                }
            }
            Arrow {
                id: downArrow
                rotation: 90
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                onButtonPressedChanged: {
                    downPressed = buttonPressed;
                }
            }
        }
    }
}
