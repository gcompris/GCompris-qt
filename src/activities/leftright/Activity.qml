import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import "../../lib"
import "activity.js" as Activity

Image {
    source: "qrc:///leftright/resource/back.svgz"
    fillMode: Image.PreserveAspectCrop
    Component.onCompleted: Activity.start();
    property Item main: parent;
    focus: true
    anchors.fill: parent

    Item {
        id: topBorder
        height: main.height * 0.1
    }

    Image {
        id: blackBoard
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: topBorder.bottom
        //width: main.width > 400 ? 400 : main.width - 10
        //width: Math.min(main.width / 410, main.height / 410)
        width: Math.min(main.width, main.height * 0.9)
        height: width * 3 / 4
        source: "resource/leftright/blackboard.svgz"
        //scale: main.width > 410 ? 1.0 : main.width / 410

        Image {
            id: handImage
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            fillMode: Image.PreserveAspectFit
            width: main.width > 200 ? 200 : parent.width - 10
            opacity: 0
        }

        Image {
            id: lightImage
            source: "resource/leftright/light.svgz"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 40
            width: parent.width
            height: parent.height
            opacity: 0
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

        Button {
            width: 100
            height: main.height * 0.15
            anchors.left: blackBoard.left
            anchors.top: blackBoard.bottom
            anchors.margins: 10
            action: Action {
                text: qsTr("Left hand")
                onTriggered: Activity.leftClick()
            }
            style: GCButtonStyle {}
        }

        Button {
            width: 100
            height: main.height * 0.15
            anchors.right: blackBoard.right
            anchors.top: blackBoard.bottom
            anchors.margins: 10
            action: Action {
                text: qsTr("Right hand")
                onTriggered: Activity.rightClick()
            }
            style: GCButtonStyle {}
        }
    }

    Keys.onLeftPressed: Activity.leftClick()
    Keys.onRightPressed: Activity.rightClick()
}
