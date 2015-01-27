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
         id: cdwriter
         x: 450
         y: 250
         sourceSize.width: 100
         sourceSize.height: 100
         source: "qrc:/gcompris/src/activities/computer/resource/cdwriter.svgz"
         signal clicked
             MouseArea {
             anchors.fill: parent
             hoverEnabled: true
             onClicked: {
                 d.x = 450
                 d.y = 200
                 d.visible = true
                 des.text = "I am a CD Writer.
                             I am used for reading CDs and DVDs."
             }
             onExited: d.visible = false
          }
    }


    Image {
         id: pendrive
         x: 780
         y: 400
         sourceSize.width: 100
         sourceSize.height: 100
         source: "qrc:/gcompris/src/activities/computer/resource/pendrive.svgz"
         signal clicked
             MouseArea {
             anchors.fill: parent
             hoverEnabled: true
             onClicked: {
                 d.x = 780
                 d.y = 500
                 d.visible = true
                 des.text = "I am a Pen Drive.
                             I am thin,small and rectangular in shape.
                             I store data inside me."
             }
             onExited: d.visible = false
          }
    }


    Image {
         id: cd
         x: 500
         y: 400
         sourceSize.width: 100
         sourceSize.height: 100
         source: "qrc:/gcompris/src/activities/computer/resource/cd.svgz"
         signal clicked
         SoundEffect {
             id: cdSound
             source: "qrc:/gcompris/src/activities/computer/resource/cd.wav"
         }
             MouseArea {
             anchors.fill: parent
             hoverEnabled: true
             onClicked:{
                 cdSound.play()

                 d.x = 500
                 d.y = 500
                 d.visible = true
                 des.text = "I am a Compact Disk(CD).
                             I am round in shape and store data."
             }
             onExited: d.visible = false
          }
    }


    Image {
         id: floppy
         x: 850
         y: 250
         sourceSize.width: 100
         sourceSize.height: 100
         source: "qrc:/gcompris/src/activities/computer/resource/floppy.svgz"
         signal clicked
             MouseArea {
             anchors.fill: parent
             hoverEnabled: true
             onClicked: {
                 d.x = 850
                 d.y = 200
                 d.visible = true
                 des.text = "I am a floppy.
                             I am thin and rectangular in shape.
                             I store data in me."
             }
             onExited: d.visible = false
          }
    }


    Image {
         id: harddisk
         x: 650
         y: 150
         sourceSize.width: 100
         sourceSize.height: 100
         source: "qrc:/gcompris/src/activities/computer/resource/harddisk.svgz"
         signal clicked
         SoundEffect {
             id: diskSound
             source: "qrc:/gcompris/src/activities/computer/resource/harddrive.wav"
         }
             MouseArea {
             anchors.fill: parent
             hoverEnabled: true
             onClicked: {
                 diskSound.play()
                 d.x = 600
                 d.y = 80
                 d.visible = true
                 des.text = "I am a Hard Disk.
                             I am used for storing data."
             }
             onExited: d.visible = false
          }
    }

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
