import QtQuick 2.1
import GCompris 1.0

Rectangle {
    id: iamReady
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    border.color: "black"
    visible: true
    radius: 4
    smooth: true
    border.width: 2
    gradient: Gradient {
        GradientStop { position: 0.0; color: "#FFFFFF" }
        GradientStop { position: 0.9; color: "#FFFFFF" }
        GradientStop { position: 1.0; color: "#CECECE" }
    }

    signal clickTheBox

    Text {
        id: iamReadyText

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        font.bold: true
        font.pointSize: 18
        text: qsTr("I am Ready!")
        visible: iamReady.visible

        Component.onCompleted: {
            parent.width = width + 20
            parent.height = height + 10
        }
    }

    MouseArea {
        anchors.fill: parent

        onClicked:
            clickTheBox()
    }
}
