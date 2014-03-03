import QtQuick 2.1
import GCompris 1.0
import "qrc:/gcompris/src/core"
import "leftright.js" as Activity

ActivityBase {
    id: activity
    focus: true

    onStart: {}
    onStop: {}

    pageComponent: Image {
        source: "qrc:/gcompris/src/activities/leftright/resource/back.svgz"
        focus: true
        signal start
        signal stop
        fillMode: Image.PreserveAspectCrop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }
        onStart: { Activity.start(bar, bonus, imageAnimOff,
                                  leftButton, rightButton) }
        onStop: { Activity.stop() }

        // FIXME It's not working
        Keys.onLeftPressed: Activity.leftClick()
        Keys.onRightPressed: Activity.rightClick()

        Item {
            id: topBorder
            height: main.height * 0.1
        }

        Image {
            id: blackBoard
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: topBorder.bottom
            width: Math.min(main.width, main.height * 0.7)
            height: width * 3 / 4
            source: "qrc:/gcompris/src/activities/leftright/resource/blackboard.svgz"

            Image {
                id: handImage
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                fillMode: Image.PreserveAspectFit
                opacity: 0
                sourceSize.height: blackBoard.height * 0.5
            }

            Image {
                id: lightImage
                source: "qrc:/gcompris/src/activities/leftright/resource/light.svgz"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 40
                width: parent.width
                height: parent.height
                opacity: 0
                scale: 1 * ApplicationInfo.ratio
            }

            ParallelAnimation {
                id: imageAnimOff
                onRunningChanged: {
                    if (!imageAnimOff.running) {
                        handImage.source = Activity.getCurrentHandImage()
                        handImage.rotation = Activity.getCurrentHandRotation()
                        imageAnimOn.start()
                    }
                }
                NumberAnimation {
                    target: handImage
                    property: "opacity"
                    from: 1; to: 0
                    duration: 300
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    target: lightImage
                    property: "opacity"
                    from: 0.2; to: 0
                    duration: 300
                    easing.type: Easing.InOutQuad
                }
            }
            ParallelAnimation {
                id: imageAnimOn
                NumberAnimation {
                    target: handImage
                    property: "opacity"
                    from: 0; to: 1.0
                    duration: 300
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    target: lightImage
                    property: "opacity"
                    from: 0; to: 0.2
                    duration: 300
                    easing.type: Easing.InOutQuad
                }
            }

            AnswerButton {
                id: leftButton
                width: blackBoard.width * 0.45
                height: main.height * 0.15
                anchors.left: blackBoard.left
                anchors.top: blackBoard.bottom
                anchors.margins: 10
                textLabel: qsTr("Left hand")
                onCorrectlyPressed: Activity.leftClick();
            }

            AnswerButton {
                id: rightButton
                width: blackBoard.width * 0.45
                height: main.height * 0.15
                anchors.right: blackBoard.right
                anchors.top: blackBoard.bottom
                anchors.margins: 10
                textLabel: qsTr("Right hand")
                onCorrectlyPressed: Activity.rightClick();
            }
        }

        DialogHelp {
            id: dialogHelpLeftRight
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | previous | next }
            onHelpClicked: {
                displayDialog(dialogHelpLeftRight)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: home()
        }

        Bonus {
            id: bonus
        }
    }
}
