import QtQuick 2.1
import QtQuick.Particles 2.0
import QtMultimedia 5.0
import "activity.js" as Activity
import GCompris 1.0

Image {
    id: block
    opacity: 0

    property Item main
    property string type
    property int counter: 0

    Behavior on opacity { PropertyAnimation { duration: 200 } }

    Timer {
        id: timerEnd
        interval: 3000; running: false; repeat: false
        onTriggered: {
            Activity.blockKilled()
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: block.type === "erase"
        onClicked: {
            if(block.type === "click") {
                enabled = false
                block.opacity = 0
                timerEnd.start()
                playSound()
            }
        }
        onDoubleClicked: {
            if(block.type === "double_click") {
                enabled = false
                block.opacity = 0
                timerEnd.start()
                playSound()
            }
        }
        onEntered: {
            if(block.type === "erase") {
                block.opacity = 0
                playSound()
            }
        }
        onExited: {
            if(block.type === "erase") {
                if(block.opacity == 0) {
                    enabled = false
                    hoverEnabled = false
                    timerEnd.start()
                    playSound()
                } else {
                    block.opacity = 1.0
                }
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
