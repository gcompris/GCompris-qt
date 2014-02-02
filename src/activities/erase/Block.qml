import QtQuick 2.1
import QtQuick.Particles 2.0
import QtMultimedia 5.0
import "activity.js" as Activity
import GCompris 1.0

Image {
    id: block
    opacity: 0

    signal enter
    signal leave
    property string type
    property int counter: 0

    onEnter: {
        if(opacity == 1.0) {
            console.log("onEnter")
            playSound()
            block.opacity = 0
        }
    }

    onLeave: {
        if(opacity != 0) {
            console.log("onLeave")
            block.opacity = 1.0
            playSound()
        }
    }

    Behavior on opacity { PropertyAnimation { duration: 200 } }

    onOpacityChanged: {
        if (opacity == 0) {
            mouseArea.enabled = false
            mouseArea.hoverEnabled = false
            Activity.blockKilled()
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: block.type !== "erase" || !ApplicationInfo.isMobile
        hoverEnabled: block.type === "erase" && !ApplicationInfo.isMobile
        onClicked: {
            if(block.type === "click") {
                enabled = false
                block.enter()
            }
        }
        onDoubleClicked: {
            if(block.type === "double_click") {
                enabled = false
                block.enter()
            }
        }
        onEntered: {
            if(block.type === "erase") {
                block.enter()
            }
        }
        onExited: {
            if(block.type === "erase") {
                block.leave()
            }
        }
    }

    function playSound()
    {
        if(counter++ % 2) {
            audioEraser1.play()
        } else {
            audioEraser2.play()
        }
    }

    Audio {
        id: audioEraser1
        source: "qrc:/gcompris/src/activities/erase/resource/eraser1.wav"
    }

    Audio {
        id: audioEraser2
        source: "qrc:/gcompris/src/activities/erase/resource/eraser2.wav"
    }
}
