import QtQuick 2.2
import GCompris 1.0

Rectangle {
    border.color: "black"
    border.width: 2
    radius: 5

    Component {
        id: anArrow
        Image {
            source: "qrc:/gcompris/src/activities/gnumch-equality/resource/arrow.svg"

            anchors.fill:parent
            fillMode: Image.PreserveAspectFit
        }
    }

    Loader {
        id: bottom
        sourceComponent: anArrow

        width: parent.width/4
        height: parent.height/2

        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        MouseArea {
            anchors.fill: parent
            onClicked: muncher.moveTo(2)
        }
    }

    Loader {
        id: left
        sourceComponent: anArrow

        width: parent.width/4
        height: parent.height/2

        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        MouseArea {
            anchors.fill: parent
            onClicked: muncher.moveTo(1)
        }

        transform: Rotation {origin.x: left.width/2; origin.y: 0 ;angle: 90}
    }

    Loader {
        id: top
        sourceComponent: anArrow

        width: parent.width/4
        height: parent.height/2

        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        MouseArea {
            anchors.fill: parent
            onClicked: muncher.moveTo(3)
        }

        transform: Rotation {origin.x: left.width/2; origin.y: 0 ;angle: 180}
    }

    Loader {
        id: right
        sourceComponent: anArrow

        width: parent.width/4
        height: parent.height/2

        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        MouseArea {
            anchors.fill: parent
            onClicked: muncher.moveTo(0)
        }

        transform: Rotation {origin.x: left.width/2; origin.y: 0 ;angle: 270}
    }
}
 
