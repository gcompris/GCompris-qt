import QtQuick 2.1
import "magic-hat.js" as Activity


Item {
    id: mainItem
    property string starState: "off"
    property bool isClickable: false
    property bool displayBounds: true
    property string wantedColor: "yellow"

    width: 34
    height: 34

    MouseArea {
        id:mouseArea
        anchors.fill:parent
        enabled: isClickable
        onClicked: {
            if(starState=="on_yellow" || starState=="on_green" || starState=="on_blue") {
                 starState="off"
            }
            else starState="on_" + wantedColor
            Activity.verifyAnswer(starState,wantedColor)
        }
    }

    Rectangle {
            id: contour
            width: parent.width
            height: parent.height
            color: "black"
            opacity: displayBounds? 1.0:0.0

            Rectangle {
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
        opacity: 1
        states:[
            State {
                name: "on_yellow"
                PropertyChanges {
                    target: starImg
                    source: Activity.url + "star1.svgz"
                }
            },
            State {
                name: "on_green"
                PropertyChanges {
                    target: starImg
                    source: Activity.url + "star2.svgz"
                }
            },
            State {
                name: "on_blue"
                PropertyChanges {
                    target: starImg
                    source: Activity.url + "star3.svgz"
                }
            },
            State {
                name: "off"
                PropertyChanges {
                    target: starImg
                    source: Activity.url + "star-clear.svgz"
                }
            }
        ]
    }

    Behavior on x {
        NumberAnimation {
            id: movingAnimation
            duration: 1000
            onRunningChanged:
                        if(!movingAnimation.running) {
                             Activity.animationFinished()
                             starImg.opacity=0.0
                        }
        }
    }
    Behavior on y {
        animation: movingAnimation
    }
}
