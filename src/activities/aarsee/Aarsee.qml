import QtQuick 2.1

import "../../core"

import "aarsee.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: "#ABCDEF"
        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Image {
            id: image
            anchors.horizontalCenter: parent.horizontalCenter
            //anchors.top: topBorder.bottom
            fillMode: Image.PreserveAspectFit
            source: "qrc:/gcompris/src/activities/aarsee/resource/hat.svgz"

            state: "NormalPosition"

            transform: Rotation {
                id: rotate
                origin.x: 0
                origin.y: image.height
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
                        angle: -90
                    }
                }
            ]

         }

        RotationAnimation {
                    id: rotAnim
                    direction: image.state == "Rotated" ?
                                   RotationAnimation.Counterclockwise :
                                   RotationAnimation.Clockwise
                    duration: 500

        }

        MouseArea {
            id: hatMouseArea
            anchors.fill:image
            onClicked: {
                if(image.state == "NormalPosition")
                    image.state = "Rotated"

            }
        }




        Rectangle {
            id: button
            width: 150; height: 75

            anchors.left: image.left
            anchors.top: image.bottom
            anchors.margins: 20
            Text {
                id: buttonLabel
                anchors.centerIn: parent
                text: "click"
            }
            property color buttonColor:"red"
            property color onHoverColor:"black"
            property color borderColor:"white"
            signal buttonClick()
            onButtonClick:
            {
                console.log("clicked")
            }

            MouseArea {
               id: buttonMouseArea

                // Anchor all sides of the mouse area to the rectangle's anchors
              anchors.fill: parent
                // onClicked handles valid mouse button clicks
                onClicked: button.buttonClick()
                hoverEnabled: true
                onEntered: parent.border.color=button.onHoverColor
                onExited: parent.border.color=button.borderColor


            }
            color:buttonMouseArea.pressed? Qt.darker(buttonColor,1.5) :buttonColor
        }


        Text {
            anchors.centerIn: parent
            text: "Welcome to my new activity"
            font.pointSize: 24
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | previous | next }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
}

}
