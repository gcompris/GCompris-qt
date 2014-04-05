import QtQuick 2.1
import "magic-hat.js" as ApplicationLogic

Item{
    id: hatItem
    width: parent.width
    height: parent.height
    property alias imageX: hatImg.x
    property alias imageY: hatImg.y
    property alias imageZ: hatImg.z
    property alias imageWidth: hatImg.width
    property alias imageHeight: hatImg.height
    property alias state: hatImg.state

    Image {
        id: hatImg
        width: hatItem.width/3
        height: hatItem.height/2
        source: "qrc:/gcompris/src/activities/magic-hat/resource/magic-hat/hat.svg"
        fillMode: Image.PreserveAspectFit
        anchors.centerIn: parent
        state: "NormalPosition"
        transform: Rotation{
            id: rotate
            origin.x:hatImg.x/2
            origin.y:hatImg.y
            axis.x: 0
            axis.y: 0
            axis.z: 1
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
                    source: "qrc:/gcompris/src/activities/magic-hat/resource/magic-hat/hat-point.svg"
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

    MouseArea{
        id: hatMouseArea
        anchors.fill:parent
        onClicked: {
            ApplicationLogic.moveStarsUnderTheHat()
            if(hatImg.state=="NormalPosition")
                hatImg.state="Rotated"
        }
    }
}


