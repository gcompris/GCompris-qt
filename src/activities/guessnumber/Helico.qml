import QtQuick 2.0

Image {
    id: helico
    y: back.height/2
    source: "resource/tuxhelico.png"
    Behavior on x {
        PropertyAnimation {
            id: xAnim
            easing.type: Easing.OutQuad
            duration:  1000
            onRunningChanged: if(!xAnim.running && helico.state=="advancing")
                                  helico.state="horizontal"
        }
    }
    Behavior on y {
        PropertyAnimation {easing.type: Easing.OutQuad; duration:  1000}
    }

    transform: Rotation {
            id: helicoRotation;
            origin.x: helico.width/2;
            origin.y: helico.height/2;
            axis { x: 0; y: 0; z: 1 }
            Behavior on angle {
                animation: rotAnim
            }
    }

    states: [
        State {
            name: "horizontal"
            PropertyChanges {
                target: helicoRotation
                angle: 0
            }
        },
        State {
            name: "advancing"
            PropertyChanges {
                target: helicoRotation
                angle: 25
            }
        }
    ]

    RotationAnimation {
                id: rotAnim
                direction: helico.state == "horizontal" ?
                               RotationAnimation.Counterclockwise :
                               RotationAnimation.Clockwise
                duration: 500
    }
}


