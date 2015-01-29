import QtQuick 2.1
import GCompris 1.0
import QtMultimedia 5.4



Image {
     id: mouse
     x: 780
     y: 400
     sourceSize.width: 100
     sourceSize.height: 100
     source: "qrc:/gcompris/src/activities/computer/resource/mouse.svgz"
     signal clicked
     SoundEffect {
         id: mouseSound
         source: "qrc:/gcompris/src/activities/computer/resource/click.wav"
     }
     MouseArea {
     anchors.fill: parent
     hoverEnabled: true
     onExited: d.visible = false
     onClicked :
     {
         d.x = 780
         d.y = 500
         d.visible = true
         des.text = "I am a mouse.
                     I am used for pointing things."
         mouseSound.play()
         t1.text = "I"
     }
     }
    }

