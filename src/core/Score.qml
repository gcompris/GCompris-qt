import QtQuick 2.1
import GCompris 1.0

Rectangle {
    id: score

    gradient: Gradient {
        GradientStop { position: 0.0; color: "#FFFFFF" }
        GradientStop { position: 0.9; color: "#FFFFFF" }
        GradientStop { position: 1.0; color: "#CECECE" }
    }
    width: background.width / 8
    height: background.height / 8
    radius: 10
    x: background.width - 80
    y: background.height - 30

    border.color: "black"
    border.width: 2

    z: 1000

    property int numberOfSubLevels
    property int currentSubLevel

    Text {
        id: subLevelText
        anchors.centerIn: parent
        font.pointSize: 16
        font.bold: true
        color: "black"
        text: score.currentSubLevel + "/" + score.numberOfSubLevels
    }
}
