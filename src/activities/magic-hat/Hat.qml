import QtQuick 2.1
import "magic-hat.js" as Activity

Item {
    id: hatItem
    width: parent.width
    height: parent.height
    property alias state: hatImg.state
    property int targetX
    property int targetY
    property int nbStarsUnderHat : 0
    property double starsOpacity : 1.0

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
            State {
                name: "NormalPosition"
                PropertyChanges {
                    target: rotate
                    angle: 0
                }
            },
            State {
                name: "Rotated"
                PropertyChanges {
                    target: rotate
                    angle: -45
                }
            },
            State {
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
                onRunningChanged: if(!rotAnim.running && hatImg.state=="Rotated"){
                                      Activity.moveStarsUnderHat()
                                  }

    }

    MouseArea {
        id: hatMouseArea
        anchors.fill:hatImg
        onClicked: {
            if(hatImg.state=="NormalPosition")
                hatImg.state="Rotated"
        }
    }

    Repeater {
        id: repeaterStars
        model: nbStarsUnderHat
        Star {
            starState: "on_yellow"
            height: hatItem.height/18
            width: hatItem.height/18
            anchors.centerIn: parent
            anchors.verticalCenterOffset: hatImg.height/2 - hatImg.height/6
            displayBounds: false
            isClickable: false
            z: hatImg.z - 1
            opacity: starsOpacity
        }
    }

    Star{
        id: offStar
        starState: "off"
        height: hatItem.height/18
        width: hatItem.height/18
        anchors.centerIn: parent
        anchors.verticalCenterOffset: hatImg.height/2 - hatImg.height/6
        displayBounds: false
        isClickable: false
        z: hatImg.z - 1
    }

    function moveStars() {
        for(var i=0;i<nbStarsUnderHat;i++){
            repeaterStars.itemAt(i).anchors.centerIn= undefined
            repeaterStars.itemAt(i).x=targetX + i*(hatItem.height/18 + 5)
            repeaterStars.itemAt(i).y=targetY
            repeaterStars.itemAt(i).z+=2
        }
    }
}
