import QtQuick 2.1
import "magic_hat_plus.js" as ApplicationLogic


Item{
    id: mainItem
    property string starState: "off"
    property bool isClickable: false

    width: 34
    height: 34

    MouseArea{
        id:mouseArea
        anchors.fill:parent
        enabled: isClickable
        hoverEnabled: true
        onClicked: {
            if(starState=="on"){
                 starState="off"
            }
            else starState="on"
            ApplicationLogic.verifyAnswer(starState)
        }
    }

    Rectangle{
            id: contour
            width: parent.width
            height: parent.height
            color: "black"
    }

    Rectangle{
        id: innerRect
        width: contour.width - 2
        height: contour.height - 2
        anchors.centerIn: contour
        color: "grey"


        Image {
            id: starImg
            width: innerRect.width - 4
            height: innerRect.height - 4
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            state: starState
            fillMode: Image.PreserveAspectFit

            states:[
                State{
                    name: "on"
                    PropertyChanges {
                        target: starImg
                        source: "qrc:/gcompris/src/activities/magic_hat_plus/resource/magic_hat/star1.svgz"
                    }
                },
                State{
                    name: "off"
                    PropertyChanges {
                        target: starImg
                        source: "qrc:/gcompris/src/activities/magic_hat_plus/resource/magic_hat/star-clear.svgz"
                    }
                }
            ]
        }
    }

    Behavior on x{
        NumberAnimation{
            id: movingAnimation
            duration: 1000
        }
    }
    Behavior on y{
        animation: movingAnimation
    }
}


