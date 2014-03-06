import QtQuick 2.1
import GCompris 1.0

Rectangle{
    id: iamReady
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    width: parent.width / 8
    height: parent.height / 8
    border.color: "black"
    visible: true
    radius: 4
    smooth: true
    border.width: 2
    gradient: Gradient {
        GradientStop { position: 0.0; color: "#FFFFFF" }
        GradientStop { position: 1.0; color: "#0e1B20" }
    }

    signal clickTheBox

    Text{
        id: iamReadyText

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        font.bold: true
        font.pixelSize: parent.width/8
        text: qsTr("I am Ready!")
        visible: iamReady.visible
    }

    MouseArea{
        anchors.fill: parent

        onClicked:
            clickTheBox()
    }
}
