import QtQuick 2.1
import GCompris 1.0
import QtMultimedia 5.4

import "../../core"
import "computer.js" as Activity

Rectangle {
    id : root
    height:parent
    width : parent

    Rectangle {
        id : monitor
        x : 600
        y : 150
        width: 150
        height: 100
        color: "white"
        border.color: Qt.lighter("black")
        border.width: 10
        radius: 10
        signal clicked
        Text{
             id : t1
             anchors.centerIn: parent
        }
        SoundEffect {
            id: monitorSound
            source: "qrc:/gcompris/src/activities/computer/resource/start.wav"
        }
         MouseArea {
         anchors.fill: parent
         hoverEnabled: true
         onClicked: monitorSound.play()
         onEntered: {
             d.x = 600
             d.y = 80
             d.visible = true
             des.text = "I am a monitor.I am used to display things."
         }
         onExited: d.visible = false
         }
         Image{
             anchors.centerIn: parent
             id : bird
             visible : false
             sourceSize.width: 50
             sourceSize.height: 50
             source: "qrc:/gcompris/src/activities/computer/resource/image.svgz"
         }
    }

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
         onEntered: {
             d.x = 780
             d.y = 500
             d.visible = true
             des.text = "I am a mouse.I am used for pointing things."
         }
         onExited: d.visible = false
         onClicked :
         {
             mouseSound.play()
             bird.visible = false
             image.visible = false
             t1.text = "I"
         }
         }
        }

    Image {
         id: keyboard
         x: 500
         y: 400
         sourceSize.width: 200
         sourceSize.height: 200
         source: "qrc:/gcompris/src/activities/computer/resource/keyboard.svgz"
         signal clicked
         SoundEffect {
             id: keyboardSound
             source: "qrc:/gcompris/src/activities/computer/resource/typing.wav"
         }
         MouseArea {
             id : mouseArea
             anchors.fill: parent
             hoverEnabled : true
             onEntered: {
                 d.x = 500
                 d.y = 500
                 d.visible = true
                 des.text = "I am a keyboard.I am used for typing things on screen."
             }
             onExited: d.visible = false
             onClicked : {
                 bird.visible = false
                 image.visible = false
                 keyboardSound.play()

              if(mouseArea.mouseX >=0 && mouseArea.mouseX <=14 && mouseArea.mouseY >=10 && mouseArea.mouseY <=20)
                  t1.text = "~,`"
              if(mouseArea.mouseX >=14 && mouseArea.mouseX <=28 && mouseArea.mouseY >=10 && mouseArea.mouseY <=20)
                  t1.text = "1"
              if(mouseArea.mouseX >=28 && mouseArea.mouseX <=42 && mouseArea.mouseY >=10 && mouseArea.mouseY <=20)
                  t1.text = "2"
              if(mouseArea.mouseX >=42 && mouseArea.mouseX <=56 && mouseArea.mouseY >=10 && mouseArea.mouseY <=20)
                  t1.text = "3"
              if(mouseArea.mouseX >=56 && mouseArea.mouseX <=70 && mouseArea.mouseY >=10 && mouseArea.mouseY <=20)
                  t1.text = "4"
              if(mouseArea.mouseX >=70 && mouseArea.mouseX <=84 && mouseArea.mouseY >=10 && mouseArea.mouseY <=20)
                  t1.text = "5"
              if(mouseArea.mouseX >=84 && mouseArea.mouseX <=98 && mouseArea.mouseY >=10 && mouseArea.mouseY <=20)
                  t1.text = "6"
              if(mouseArea.mouseX >=98 && mouseArea.mouseX <=112 && mouseArea.mouseY >=10 && mouseArea.mouseY <=20)
                  t1.text = "7"
              if(mouseArea.mouseX >=112 && mouseArea.mouseX <=126 && mouseArea.mouseY >=10 && mouseArea.mouseY <=20)
                  t1.text = "8"
              if(mouseArea.mouseX >=126 && mouseArea.mouseX <=140 && mouseArea.mouseY >=10 && mouseArea.mouseY <=20)
                  t1.text = "9"
              if(mouseArea.mouseX >=140 && mouseArea.mouseX <=154 && mouseArea.mouseY >=10 && mouseArea.mouseY <=20)
                  t1.text = "0"
              if(mouseArea.mouseX >=154 && mouseArea.mouseX <=168 && mouseArea.mouseY >=10 && mouseArea.mouseY <=20)
                  t1.text = "-,_"
              if(mouseArea.mouseX >=168 && mouseArea.mouseX <=182 && mouseArea.mouseY >=10 && mouseArea.mouseY <=20)
                  t1.text = "+,="
              if(mouseArea.mouseX >=182 && mouseArea.mouseX <=200 && mouseArea.mouseY >=10 && mouseArea.mouseY <=20)
                  t1.text = "Backspace"

              if(mouseArea.mouseX >=0 && mouseArea.mouseX <=14 && mouseArea.mouseY >=20 && mouseArea.mouseY <=30)
                  t1.text = "Tab"
              if(mouseArea.mouseX >=14 && mouseArea.mouseX <=28 && mouseArea.mouseY >=20 && mouseArea.mouseY <=30)
                  t1.text = "Q"
              if(mouseArea.mouseX >=28 && mouseArea.mouseX <=42 && mouseArea.mouseY >=20 && mouseArea.mouseY <=30)
                  t1.text = "W"
              if(mouseArea.mouseX >=42 && mouseArea.mouseX <=56 && mouseArea.mouseY >=20 && mouseArea.mouseY <=30)
                  t1.text = "E"
              if(mouseArea.mouseX >=56 && mouseArea.mouseX <=70 && mouseArea.mouseY >=20 && mouseArea.mouseY <=30)
                  t1.text = "R"
              if(mouseArea.mouseX >=70 && mouseArea.mouseX <=84 && mouseArea.mouseY >=20 && mouseArea.mouseY <=30)
                  t1.text = "T"
              if(mouseArea.mouseX >=84 && mouseArea.mouseX <=98 && mouseArea.mouseY >=20 && mouseArea.mouseY <=30)
                  t1.text = "Y"
              if(mouseArea.mouseX >=98 && mouseArea.mouseX <=112 && mouseArea.mouseY >=20 && mouseArea.mouseY <=30)
                  t1.text = "U"
              if(mouseArea.mouseX >=112 && mouseArea.mouseX <=126 && mouseArea.mouseY >=20 && mouseArea.mouseY <=30)
                  t1.text = "I"
              if(mouseArea.mouseX >=126 && mouseArea.mouseX <=140 && mouseArea.mouseY >=20 && mouseArea.mouseY <=30)
                  t1.text = "O"
              if(mouseArea.mouseX >=140 && mouseArea.mouseX <=154 && mouseArea.mouseY >=20 && mouseArea.mouseY <=30)
                  t1.text = "P"
              if(mouseArea.mouseX >=154 && mouseArea.mouseX <=168 && mouseArea.mouseY >=20 && mouseArea.mouseY <=30)
                  t1.text = "{,["
              if(mouseArea.mouseX >=168 && mouseArea.mouseX <=182 && mouseArea.mouseY >=20 && mouseArea.mouseY <=30)
                  t1.text = "},]"
              if(mouseArea.mouseX >=182 && mouseArea.mouseX <=200 && mouseArea.mouseY >=20 && mouseArea.mouseY <=30)
                  t1.text = "\,|"

              if(mouseArea.mouseX >=0 && mouseArea.mouseX <=18 && mouseArea.mouseY >=30 && mouseArea.mouseY <=40)
                  t1.text = "Caps Lock"
              if(mouseArea.mouseX >=18 && mouseArea.mouseX <=28 && mouseArea.mouseY >=30 && mouseArea.mouseY <=40)
                  t1.text = "A"
              if(mouseArea.mouseX >=28 && mouseArea.mouseX <=42 && mouseArea.mouseY >=30 && mouseArea.mouseY <=40)
                  t1.text = "S"
              if(mouseArea.mouseX >=42 && mouseArea.mouseX <=56 && mouseArea.mouseY >=30 && mouseArea.mouseY <=40)
                  t1.text = "D"
              if(mouseArea.mouseX >=56 && mouseArea.mouseX <=70 && mouseArea.mouseY >=30 && mouseArea.mouseY <=40)
                  t1.text = "F"
              if(mouseArea.mouseX >=70 && mouseArea.mouseX <=84 && mouseArea.mouseY >=30 && mouseArea.mouseY <=40)
                  t1.text = "G"
              if(mouseArea.mouseX >=84 && mouseArea.mouseX <=98 && mouseArea.mouseY >=30 && mouseArea.mouseY <=40)
                  t1.text = "H"
              if(mouseArea.mouseX >=98 && mouseArea.mouseX <=112 && mouseArea.mouseY >=30 && mouseArea.mouseY <=40)
                  t1.text = "J"
              if(mouseArea.mouseX >=112 && mouseArea.mouseX <=126 && mouseArea.mouseY >=30 && mouseArea.mouseY <=40)
                  t1.text = "K"
              if(mouseArea.mouseX >=126 && mouseArea.mouseX <=140 && mouseArea.mouseY >=30 && mouseArea.mouseY <=40)
                  t1.text = "L"
              if(mouseArea.mouseX >=140 && mouseArea.mouseX <=154 && mouseArea.mouseY >=30 && mouseArea.mouseY <=40)
                  t1.text = ":,;"
              if(mouseArea.mouseX >=154 && mouseArea.mouseX <=168 && mouseArea.mouseY >=30 && mouseArea.mouseY <=40)
                  t1.text = "'"
              if(mouseArea.mouseX >=170 && mouseArea.mouseX <=200 && mouseArea.mouseY >=30 && mouseArea.mouseY <=40)
                  t1.text = "Enter"

              if(mouseArea.mouseX >=0 && mouseArea.mouseX <=18 && mouseArea.mouseY >=40 && mouseArea.mouseY <=50)
                  t1.text = "Shift"
              if(mouseArea.mouseX >=18 && mouseArea.mouseX <=28 && mouseArea.mouseY >=40 && mouseArea.mouseY <=50)
                  t1.text = "Z"
              if(mouseArea.mouseX >=28 && mouseArea.mouseX <=42 && mouseArea.mouseY >=40 && mouseArea.mouseY <=50)
                  t1.text = "X"
              if(mouseArea.mouseX >=42 && mouseArea.mouseX <=56 && mouseArea.mouseY >=40 && mouseArea.mouseY <=50)
                  t1.text = "C"
              if(mouseArea.mouseX >=56 && mouseArea.mouseX <=70 && mouseArea.mouseY >=40 && mouseArea.mouseY <=50)
                  t1.text = "V"
              if(mouseArea.mouseX >=70 && mouseArea.mouseX <=84 && mouseArea.mouseY >=40 && mouseArea.mouseY <=50)
                  t1.text = "B"
              if(mouseArea.mouseX >=84 && mouseArea.mouseX <=98 && mouseArea.mouseY >=40 && mouseArea.mouseY <=50)
                  t1.text = "N"
              if(mouseArea.mouseX >=98 && mouseArea.mouseX <=112 && mouseArea.mouseY >=40 && mouseArea.mouseY <=50)
                  t1.text = "M"
              if(mouseArea.mouseX >=112 && mouseArea.mouseX <=126 && mouseArea.mouseY >=40 && mouseArea.mouseY <=50)
                  t1.text = "<,,"
              if(mouseArea.mouseX >=126 && mouseArea.mouseX <=140 && mouseArea.mouseY >=40 && mouseArea.mouseY <=50)
                  t1.text = ">,."
              if(mouseArea.mouseX >=140 && mouseArea.mouseX <=154 && mouseArea.mouseY >=40 && mouseArea.mouseY <=50)
                  t1.text = "?,/"
              if(mouseArea.mouseX >=154 && mouseArea.mouseX <=200 && mouseArea.mouseY >=40 && mouseArea.mouseY <=50)
                  t1.text = "Shift"

              if(mouseArea.mouseX >=0 && mouseArea.mouseX <=20 && mouseArea.mouseY >=50 && mouseArea.mouseY <=60)
                  t1.text = "Ctrl"
              if(mouseArea.mouseX >=20 && mouseArea.mouseX <=34 && mouseArea.mouseY >=50 && mouseArea.mouseY <=60)
                  t1.text = "Fn"
              if(mouseArea.mouseX >=34 && mouseArea.mouseX <=48 && mouseArea.mouseY >=50 && mouseArea.mouseY <=60)
                  t1.text = "Alt"
              if(mouseArea.mouseX >=48 && mouseArea.mouseX <=132 && mouseArea.mouseY >=50 && mouseArea.mouseY <=60)
                  t1.text = "Spacebar"
              if(mouseArea.mouseX >=132 && mouseArea.mouseX <=146 && mouseArea.mouseY >=50 && mouseArea.mouseY <=60)
                  t1.text = "Alt"
              if(mouseArea.mouseX >=146 && mouseArea.mouseX <=160 && mouseArea.mouseY >=50 && mouseArea.mouseY <=60)
                  t1.text = "Fn"
              if(mouseArea.mouseX >=160 && mouseArea.mouseX <=200 && mouseArea.mouseY >=50 && mouseArea.mouseY <=60)
                  t1.text = "Ctrl"
         }
       }
     }


Rectangle {
    id : paper
    x : 450
    y : 100
    height : 100
    width : 100
    visible: false
    color : "white"
    Image {
        id: image
        anchors.centerIn: parent
        sourceSize.width: 100
        sourceSize.height: 100
        visible: false
        source: "qrc:/gcompris/src/activities/computer/resource/image.svgz"
        signal clicked
            MouseArea {
            anchors.fill: parent
            }
    }
}

SequentialAnimation {
        id: animate
        PropertyAnimation {
            target: paper
            property: "width"
            duration: 300
            from: 0
            to: 100
            easing.type: Easing.InOutQuad
        }
    }


Image {
     id: printer
     x: 450
     y: 250
     sourceSize.width: 100
     sourceSize.height: 100
     source: "qrc:/gcompris/src/activities/computer/resource/printer.svgz"
     signal clicked
     SoundEffect {
         id: printerSound
         source: "qrc:/gcompris/src/activities/computer/resource/printer.wav"
     }
         MouseArea {
         anchors.fill: parent
         hoverEnabled: true
         onEntered: {
             d.x = 450
             d.y = 220
             d.visible = true
             des.text = "I am a printer.I am used to print things."
         }
         onExited: d.visible = false
         onClicked: {
             printerSound.play()
             paper.visible = true
             bird.visible = false
             image.visible = true
             animate.start()
         }
      }
}

Image {
     id: scanner
     x: 850
     y: 250
     sourceSize.width: 100
     sourceSize.height: 100
     source: "qrc:/gcompris/src/activities/computer/resource/scanner.svgz"
     signal clicked
     SoundEffect {
         id: scannerSound
         source: "qrc:/gcompris/src/activities/computer/resource/scanner.wav"
     }
         MouseArea {
         anchors.fill: parent
         hoverEnabled: true
         onEntered: {
             d.x = 850
             d.y = 200
             d.visible = true
             des.text = "I am a scanner.I am used to scan things and display them on screen."
         }
         onExited: d.visible = false
         onClicked:{
             scannerSound.play()
             paper.visible = false
             image.visible = false
             bird.visible = true
         }
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

