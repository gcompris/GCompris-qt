import QtQuick 2.1
import "activity.js" as Activity

AnimatedSprite {
    id: fish
    Component.onCompleted: x=900
    property int duration: 5000
    frameRate: 10
    interpolate: true

    transform: Rotation {
        id: rotate; origin.x: width / 2; origin.y: 0; axis { x: 0; y: 1; z: 0 } angle: 0
    }

    SequentialAnimation {
                id: rotateLeftAnimation
                loops: 1
                PropertyAnimation {
                    target: rotate
                    properties: "angle"
                    from: 0
                    to: 180
                    duration: 500
                }
    }

    SequentialAnimation {
                id: rotateRightAnimation
                loops: 1
                PropertyAnimation {
                    target: rotate
                    properties: "angle"
                    from: 180
                    to: 0
                    duration: 500
                }
    }
    onXChanged: {
        if(x > 600) {
            rotateLeftAnimation.start()
            x = 0
            y = Activity.getY(y)
        } else if(x < 100) {
            rotateRightAnimation.start()
            x = 800
        }
    }
    Behavior on x { PropertyAnimation { duration: fish.duration } }
    Behavior on y { PropertyAnimation { duration: fish.duration } }
    Behavior on opacity { PropertyAnimation { duration: 300 } }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            parent.opacity = 0
            enabled = false
            Activity.fishKilled()
        }
    }

}
