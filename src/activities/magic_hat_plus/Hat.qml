import QtQuick 2.1
import "magic_hat_plus.js" as ApplicationLogic

Image {
    id: hatImg
    width: parent.width/4
    height: parent.height/2.5
    source: "qrc:/gcompris/src/activities/magic_hat_plus/resource/magic_hat/hat.svg"
    fillMode: Image.PreserveAspectFit
    state: "NormalPosition"

    MouseArea{
        id: hatMouseArea
        anchors.fill:parent
        onClicked: {
            ApplicationLogic.moveStarsUnderTheHat()
            if(hatImg.state=="NormalPosition")
                hatImg.state="Rotated"
            else {
                 if(hatImg.state=="Rotated"){
                    hatImg.state="GuessNumber"
                 }
            }
        }
    }

    states: [
        State{
            name: "NormalPosition"
            PropertyChanges {
                target: hatImg
                rotation: 0
            }
        },
        State{
            name: "Rotated"
            PropertyChanges {
                target: hatImg
                rotation: -30
            }
        },
        State{
            name: "GuessNumber"
            PropertyChanges{
                target: hatImg
                rotation: 0
                source: "qrc:/gcompris/src/activities/magic_hat_plus/resource/magic_hat/hat-point.svg"
            }
        }
    ]

    transitions:[
        Transition{
                RotationAnimation {
                            direction: if(hatImg.state=="Rotated"){
                                           RotationAnimation.Counterclockwise
                                       }
                                       else RotationAnimation.Clockwise
                            duration: 500
                }
        }
    ]
}
