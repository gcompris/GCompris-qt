import QtQuick 2.1
import GCompris 1.0
import QtMultimedia 5.4

import "../../core"
import "computer.js" as Activity

Rectangle {
    id : root
    height:parent
    width : parent

    Image {
         id: ram
         x: 450
         y: 250
         sourceSize.width: 100
         sourceSize.height: 100
         source: "qrc:/gcompris/src/activities/computer/resource/ram.svgz"
         signal clicked
             MouseArea {
             anchors.fill: parent
             hoverEnabled: true
             onEntered: {
                 d.x = 450
                 d.y = 200
                 d.visible = true
                 des.text = "I am a Random Access Memory.I allow data items to be read and written."
             }
             onExited: d.visible = false
          }
    }

    Image {
         id: nic
         x: 800
         y: 250
         sourceSize.width: 100
         sourceSize.height: 100
         source: "qrc:/gcompris/src/activities/computer/resource/nic.svgz"
         signal clicked
             MouseArea {
             anchors.fill: parent
             hoverEnabled: true
             onEntered: {
                 d.x = 800
                 d.y = 200
                 d.visible = true
                 des.text = "I am a Network Interface Card.I am used to connect computer to computer network."
             }
             onExited: d.visible = false
          }
    }


    Image {
         id: motherboard
         x: 620
         y: 150
         sourceSize.width: 100
         sourceSize.height: 100
         source: "qrc:/gcompris/src/activities/computer/resource/motherboard.svgz"
         signal clicked
             MouseArea {
             anchors.fill: parent
             hoverEnabled: true
             onEntered: {
                 d.x = 600
                 d.y = 80
                 d.visible = true
                 des.text = "I am a motherboard.I contain computer's circuits and components."
             }
             onExited: d.visible = false
          }
    }

    Image {
         id: speaker
         x: 500
         y: 400
         sourceSize.width: 100
         sourceSize.height: 100
         source: "qrc:/gcompris/src/activities/computer/resource/speaker.svgz"
         signal clicked
         SoundEffect {
             id: playSound
             source: "qrc:/gcompris/src/activities/computer/resource/speaker.wav"
         }
             MouseArea {
             anchors.fill: parent
             onClicked:
             {
                 playSound.play()
                 //musicalnote.visible = true
             }
             hoverEnabled: true
             onEntered: {
                 d.x = 500
                 d.y = 350
                 d.visible = true
                 des.text = "I am a speaker.I am used for playing sounds."
             }
             onExited: d.visible = false
          }
    }

    Image {
         id: headset
         x: 830
         y: 400
         sourceSize.width: 100
         sourceSize.height: 100
         source: "qrc:/gcompris/src/activities/computer/resource/headset.svgz"
         signal clicked
         SoundEffect {
             id: headsetSound
             source: "qrc:/gcompris/src/activities/computer/resource/headset.wav"
         }
             MouseArea {
             anchors.fill: parent
             hoverEnabled: true
             onClicked: headsetSound.play()
             onEntered: {
                 d.x = 830
                 d.y = 350
                 d.visible = true
                 des.text = "I am a Head Set.I am used for listening things."
             }
             onExited: d.visible = false
          }
    }

    Image {
         id: microphone
         x: 650
         y: 450
         sourceSize.width: 100
         sourceSize.height: 100
         source: "qrc:/gcompris/src/activities/computer/resource/microphone.svgz"
         signal clicked
         SoundEffect {
             id: microphoneSound
             source: "qrc:/gcompris/src/activities/computer/resource/microphone.wav"
         }
             MouseArea {
             anchors.fill: parent
             hoverEnabled: true
             onClicked: microphoneSound.play()
             onEntered: {
                 d.x = 650
                 d.y = 550
                 d.visible = true
                 des.text = "I am a microphone.I am used for speaking things."
             }
             onExited: d.visible = false
          }
    }

   /* Image {
         visible: false
         id: musicalnote
         x: 100
         y: 100
         sourceSize.width: 50
         sourceSize.height: 50
         source: "qrc:/gcompris/src/activities/computer/resource/musicalnote.svgz"
         signal clicked
             MouseArea {
             anchors.fill: parent
             hoverEnabled: true
          }
    }*/

    Rectangle
         {
             id : d
             visible: false
             radius: 3
             color : "white"
             Text {
                 id : des

             }
         }
    Image{
        id : button
        x : 650
        y : 600
        height: 50
        width : 50
        source : "qrc:/gcompris/src/activities/computer/resource/back.svgz"
        Text
        {
            anchors.centerIn: parent
            text : "Back"
        }

        MouseArea{
            anchors.fill: parent
            onClicked:
            {
                root.visible = false
                column.visible = true
        }
    }
    }

}
