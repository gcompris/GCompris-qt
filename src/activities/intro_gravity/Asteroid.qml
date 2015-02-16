/*GCompris :- intro_gravity.qml */
import QtQuick 2.1
import "intro_gravity.js" as Activity
import "../../core"
import GCompris 1.0

Image {
    id: asteroid

    property Item background
    property Item items
    property real fallDuration

    fillMode: Image.PreserveAspectFit

    sourceSize.height: 60 * ApplicationInfo.ratio
    x: 0
    y: 5
    z: 5


    signal done

    Component.onCompleted: {
        x =  Math.floor(Math.random() * (background.width-200) )
        y =  5
    }

    onDone: {
        Activity.crash()
    }

    function startMoving(dur){
        down.duration = dur
        down.restart()
    }


    NumberAnimation {
        id: down
        target: asteroid
        property: "y"
        to: parent.height
        duration: 10000

    }
}
