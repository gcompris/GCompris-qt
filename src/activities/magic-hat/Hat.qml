import QtQuick 2.1
import "magic-hat.js" as Activity

Item {
    id: hatItem
    width: parent.width
    height: parent.height
    property alias repeater : repeaterStars
    property alias imageX: hatImg.x
    property alias imageY: hatImg.y
    property alias imageZ: hatImg.z
    property alias imageWidth: hatImg.width
    property alias imageHeight: hatImg.height
    property alias state: hatImg.state
    property int nbStarsUnderHat : 0

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
            origin.x:hatImg.x - hatImg.width
            origin.y:hatImg.y + hatImg.height/2
            axis.x: 0
            axis.y: 0
            axis.z: 1
            Behavior on angle{
                animation: rotAnim
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
                    source: "qrc:/gcompris/src/activities/magic-hat/resource/magic-hat/hat-point.svg"
                }
                PropertyChanges {
                    target: rotate
                    angle: 0
                }
            }
        ]

     }

    RotationAnimation {
                id: rotAnim
                direction: if(hatImg.state=="Rotated"){
                               RotationAnimation.Counterclockwise
                           }
                           else RotationAnimation.Clockwise
                duration: 500
                onRunningChanged: if(!rotAnim.running){
                                      Activity.moveStars()
                                  }
    }

    MouseArea {
        id: hatMouseArea
        anchors.fill:parent
        onClicked: {
            hatImg.state="Rotated"
        }
    }

    Repeater {
        id: repeaterStars
        model: nbStarsUnderHat
        Star {
            starState: "on"
            height: hatItem.height/18
            width: hatItem.height/18
            x:hatImg.x + hatImg.width/2
            y:hatImg.y + hatImg.height - hatItem.height/18
            z: hatImg.z - 1
            displayBounds: false
            isClickable: false
        }
    }
}


