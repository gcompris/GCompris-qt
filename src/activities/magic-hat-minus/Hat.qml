import QtQuick 2.1
import "magic-hat.js" as Activity

Item {
    id: hatItem
    width: parent.width
    height: parent.height
    property alias state: hatImg.state
    property alias target: offStar
    property int starsSize

    function getTarget() {
        return offStar
    }

    Image {
        id: hatImg
        source: Activity.url + "hat.svgz"
        sourceSize.width: hatItem.width / 3
        fillMode: Image.PreserveAspectFit
        anchors.centerIn: parent
        state: "NormalPosition"

        transform: Rotation {
            id: rotate
            origin.x: 0
            origin.y: hatImg.height
            axis.x: 0
            axis.y: 0
            axis.z: 1
            Behavior on angle {
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
                    source: Activity.url + "hat-point.svgz"
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
                direction: hatImg.state == "Rotated" ?
                               RotationAnimation.Counterclockwise :
                               RotationAnimation.Clockwise
                duration: 500
                onRunningChanged: if(!rotAnim.running && hatImg.state == "Rotated") {
                                      Activity.moveStarsUnderHat()
                                  }
    }

    MouseArea {
        id: hatMouseArea
        anchors.fill:hatImg
        onClicked: {
            if(hatImg.state == "NormalPosition")
                hatImg.state = "Rotated"
        }
    }

    // The target for the moving stars
    Item {
        id: offStar
        height: hatItem.starsSize
        width: hatItem.starsSize
        y: hatImg.y + hatImg.paintedHeight - height
        anchors {
            horizontalCenter: parent.horizontalCenter
        }

        z: hatImg.z - 1
    }
}
