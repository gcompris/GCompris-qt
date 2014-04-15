import QtQuick 2.1
import "magic-hat.js" as Activity


Item{
    id: mainItem
    property string starState: "off"
    property bool isClickable: false
    property bool displayBounds: true

    width: 34
    height: 34

    MouseArea {
        id:mouseArea
        anchors.fill:parent
        enabled: isClickable
        hoverEnabled: true
        onClicked: {
            if(starState=="on"){
                 starState="off"
            }
            else starState="on"
            Activity.verifyAnswer(starState)
        }
    }

    Rectangle{
            id: contour
            width: parent.width
            height: parent.height
            color: "black"
            opacity: displayBounds? 1.0:0.0

            Rectangle{
                id: innerRect
                width: contour.width - 2
                height: contour.height - 2
                anchors.centerIn: contour
                color: "grey"
                opacity: displayBounds? 1.0:0.0
            }
    }

    Image {
        id: starImg
        width: innerRect.width - 4
        height: innerRect.height - 4
        anchors.centerIn: contour
        state: starState
        fillMode: Image.PreserveAspectFit

        states:[
            State{
                name: "on"
                PropertyChanges {
                    target: starImg
                    source: "qrc:/gcompris/src/activities/magic-hat/resource/magic-hat/star1.svgz"
                }
            },
            State{
                name: "on_difficult"
                PropertyChanges {
                    target: starImg
                    source: "qrc:/gcompris/src/activities/magic-hat/resource/magic-hat/star2.svgz"
                }
            },
            State{
                name: "off"
                PropertyChanges {
                    target: starImg
                    source: "qrc:/gcompris/src/activities/magic-hat/resource/magic-hat/star-clear.svgz"
                }
            }
        ]
    }

    Behavior on x{
        NumberAnimation{
            id: movingAnimation
            duration: 1000
            onRunningChanged: if(!movingAnimation.running){
                                  Activity.changeHatState()
                              }
        }
    }
    Behavior on y{
        animation: movingAnimation
    }
}


