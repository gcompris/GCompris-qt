/*GCompris :- intro_gravity.qml */
import QtQuick 2.1
import "intro_gravity.js" as Activity
import "../../core"
import GCompris 1.0

Image {
    id: asteroid

    property Item background
//    property real velocityAsteroid

    fillMode: Image.PreserveAspectFit

    sourceSize.height: 60 * ApplicationInfo.ratio
    x: 0
    y: 0
    z: 5


    signal done

    Component.onCompleted: {
        x= -asteroid.width - 1
        y= -asteroid.height - 1
    }

    onDone: {
        Activity.crash()
    }

    Behavior on y { PropertyAnimation{ duration: 1000 } }
}
