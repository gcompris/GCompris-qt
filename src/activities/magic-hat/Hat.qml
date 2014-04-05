import QtQuick 2.1
import "magic-hat.js" as ApplicationLogic

Image {
    id: hatImg
    width: 100
    height: 200
    source: "qrc:/gcompris/src/activities/magic_hat_plus/resource/magic_hat/hat.svg"
    fillMode: Image.PreserveAspectFit
    state: "NormalPosition"
    transform: Rotation{
        id: rotate
        origin.x:hatImg.x/2
        origin.y:hatImg.y + hatImg.height/2
        axis.x: 0
        axis.y: 0
        axis.z: 1
    }

    MouseArea{
        id: hatMouseArea
        anchors.fill:parent
        onClicked: {
            ApplicationLogic.moveStarsUnderTheHat()
            if(hatImg.state=="NormalPosition")
                hatImg.state="Rotated"
        }
    }


    states: [
        State{
            name: "NormalPosition"
            PropertyChanges {
                target: rotate
                angle: 0
            }
        },
        State{
            name: "Rotated"
            PropertyChanges {
                target: rotate
                angle: -45
            }
        },
        State{
            name: "GuessNumber"
            PropertyChanges{
                target: hatImg
                source: "qrc:/gcompris/src/activities/magic_hat_plus/resource/magic_hat/hat-point.svg"
            }
            PropertyChanges {
                target: rotate
                angle: 0
            }
        }
    ]

    transitions:[
        Transition{
                RotationAnimation {
                            id: rotAnim
                            direction: if(hatImg.state=="Rotated"){
                                           RotationAnimation.Counterclockwise
                                       }
                                       else RotationAnimation.Clockwise
                            duration: 500
                }
        }
    ]
}
