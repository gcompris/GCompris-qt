import QtQuick 2.1
import QtQml.Models 2.1
import QtQuick.Controls 1.0
import QtQuick.Window 2.1
import QtMultimedia 5.0
import GCompris 1.0

Image {
    id: balloon

    x:parent.width/2;
    y:parent.height/2

    property bool moveFlag: false
    source: "qrc:/gcompris/src/core/resource/tuxballoon.png";
    width: (parent.width/2 > (balloon.sourceSize.width)) ? balloon.sourceSize.width : balloon.sourceSize.width * (2/3)
    height:(parent.height/2 > (balloon.sourceSize.height)) ? balloon.sourceSize.height : balloon.sourceSize.height * (2/3)

    function startMoving(durationIncoming)
    {
        move.duration = durationIncoming
        moveFlag = true
        move.stop()
        moveFlag = false
        move.start()
    }
    function stopMoving()
    {
        moveFlag = true
        move.stop()
    }

    NumberAnimation {
        id:move

        target:balloon

        properties:"y"
        from:parent.height/2
        to: (parent.height - balloon.height/1.25)

        onStopped: {
            if(!moveFlag){
                bonus.bad("smiley")
            }
        }
    }
}
