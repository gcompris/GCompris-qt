import QtQuick 2.1
import QtQuick.Particles 2.0
import QtMultimedia 5.0
import "erase.js" as Activity
import GCompris 1.0

Image {
    id: block
    opacity: 0
    property Item main
    property Item bar
    property double ix
    property double iy
    property int nbx
    property int nby

    x: ix * main.width / nbx
    y: iy * (main.height - bar.height) / nby
    width: main.width / nbx
    height: (main.height - bar.height) / nby

    signal enter
    signal leave
    property string type
    property int counter: 0

    onEnter: {
        if(opacity == 1.0) {
            playSound()
            block.opacity = 0
        }
    }

    onLeave: {
        if(opacity != 0) {
            block.opacity = 1.0
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
        audioEraser.play()
    }

    Audio {
        id: audioEraser
        source: ix % 2 ? "qrc:/gcompris/src/activities/erase/resource/eraser1.wav" :
                         "qrc:/gcompris/src/activities/erase/resource/eraser2.wav"
    }
}
