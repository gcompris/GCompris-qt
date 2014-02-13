import QtQuick 2.1
import QtMultimedia 5.0
import "ballcatch.js" as Activity
import GCompris 1.0

Item {
    id: ball
    property Item main
    property Item bar
    property int radius: 130;

    Component.onCompleted: {
        x = main.width / 2 - radius
        y = main.height - 200
        circle.radius = radius
    }

    z: 3

    onRadiusChanged: {
        circle.radius=radius
    }

    Rectangle {
        id: circle
        width: radius
        height: width
        color: "red"
        border.color: "black"
        border.width: 5
    }
}
