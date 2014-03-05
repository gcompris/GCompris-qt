import QtQuick 2.1
import GCompris 1.0

Rectangle {
    id: score

    gradient: Gradient {
        GradientStop { position: 0.0; color: "#FFFFFF" }
        GradientStop { position: 1.0; color: "#0e1B20" }
    }
    width: background.width/8
    height: background.height/8
    radius: 10
    anchors.bottom: background.bottom
    anchors.right: background.right

    border.color: "black"
    border.width: 2

    z: 1000

    property int numberOfSublevels
    property int currentSubLevel

    Text{
        id: subLevelText
        anchors.centerIn: parent
        font.pixelSize: parent.width/8
        font.bold: true
        //font.pointSize: main.width == 0 ? 20 : main.width/40
        color: "black"
        text: score.currentSubLevel + "/" + score.numberOfSubLevels
    }
}
