/* GCompris - mirrorgame.qml
 *
 * Copyright (C) 2016 YOUR NAME <xx@yy.org>
 *
 * Authors:
 *   <THE GTK VERSION AUTHOR> (GTK+ version)
 *   YOUR NAME <YOUR EMAIL> (Qt Quick port)
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.1

import "../../core"
import "mirrorgame.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        Image{anchors.fill: parent;source:"background.svg"}
        signal start
        signal stop

       Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }
    Loader{id:lvl2}
       Rectangle {
           id:lvl1
           anchors.fill: parent
           color:"transparent"

        Canvas{
            id:solution
            width:parent.width
            height:parent.height
            opacity: 0
            onPaint:{
               var context = getContext("2d")
                context.beginPath();
                context.lineWidth = 2;
                context.strokeStyle = "yellow"
                context.moveTo(torch.x+30,torch.y+60);
                context.lineTo(mirror2.x+50,mirror2.y+50);
                context.stroke();
                context.moveTo(mirror2.x+50,mirror2.y+50);
                context.lineTo(mirror3.x+50,mirror3.y+50);
                context.stroke();
                context.moveTo(mirror3.x+50,mirror3.y+50);
                context.lineTo(mirror4.x+50,mirror4.y+50);
                context.stroke();
                context.moveTo(mirror4.x+50,mirror4.y+50);
                context.lineTo(mirror1.x+50,mirror1.y+50);
                context.stroke();
                context.moveTo(mirror1.x+50,mirror1.y+50);
                context.lineTo(torch.x+20,torch.y-70);
                context.stroke();}


            }


        Image {
            id: bulboff
            source:"bulbOFF.svg"
            fillMode: Image.PreserveAspectFit
            x:torch.x-20
            y:torch.y-140
            width:75
            height:75
          }
        Image {
            id: bulbon
            source:"bulbON.svg"
            visible: false
            fillMode: Image.PreserveAspectFit
            x:torch.x-30
            y:torch.y-155
            width:100
            height:100

          }

        Image {
            id: ok
            opacity: 0
            source:"qrc:/gcompris/src/core/resource/bar_ok.svg"
            fillMode: Image.PreserveAspectFit
            anchors.horizontalCenter: parent.horizontalCenter
            PropertyAnimation {
                id: showOk
                target: ok
                properties: "opacity"
                from: 0
                to: 1
                duration: 600
                }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    Activity.win();
                    lvl1.visible = false;
                    lvl2.source = "Level2.qml";



                }
            }
        }

        Canvas{
        id:wire
        width:parent.width
        height:parent.height
        onPaint:{
            var context = getContext("2d")
             context.beginPath();
             context.lineWidth = 4;
             context.strokeStyle = "black"
             context.moveTo(off.x+60,off.y+40);
             context.lineTo(torch.x+80,torch.y+10);
             context.stroke();

        }
        Image {
            id: off
            source:"off.svg"
            fillMode: Image.PreserveAspectFit
            x:1180
            y:180
            width:100
            height:100
            MouseArea {
                anchors.fill: parent
                onClicked: {
                            lvl1.checkAnswer()}
            }
        }
        Image {
            id: on
            visible: false
            source:"on.svg"
            fillMode: Image.PreserveAspectFit
            x:1180
            y:180
            width:100
            height:100

        }
        }
      function checkAnswer() {

          off.visible=false;
          on.visible=true;
           if( mirror1.placed && mirror2.placed && mirror3.placed && mirror4.placed )
           {solution.opacity=1;
            bulboff.visible=false;
            bulbon.visible=true;
           showOk.start();}
           else
           {    on.visible=false;
               off.visible=true;
           if(!mirror1.placed)wrongAnswer1.visible=true;
           if(!mirror2.placed)wrongAnswer2.visible=true;
           if(!mirror3.placed)wrongAnswer3.visible=true;
           if(!mirror4.placed)wrongAnswer4.visible=true;
           }
            return
        }

        Image {
            id:mirror1
            property int currangle:0
            property int  nxtangle:45
            property int id:1
            property bool placed:false
            source:"mirror1.svg"
            x:400
            y:350
            width:100
            height:100
            fillMode: Image.PreserveAspectFit
            RotationAnimation {
                id: rotate1
                target:mirror1
                property: "rotation"
                from: mirror1.currangle
                to: mirror1.nxtangle
                duration: 250
                direction: RotationAnimation.Clockwise
            }
            Image {
                id: wrongAnswer1
                anchors.centerIn: parent
                height: parent.height * 0.3
                width: parent.width * 0.3
                fillMode: Image.PreserveAspectFit
                z: 10
                source:"error.svg"
                visible: false
            }
             MouseArea {
                anchors.fill: parent
                onClicked: {
                    wrongAnswer1.visible=false;
                    wrongAnswer2.visible=false;
                    wrongAnswer3.visible=false;
                    wrongAnswer4.visible=false;
                    rotate1.start();
                    mirror1.currangle+=45;
                    mirror1.nxtangle+=45;
                    mirror1.id=mirror1.id+1;
                    if(mirror1.id%8==1)mirror1.id=1;
                    if(mirror1.id%8==2)
                        mirror1.placed=true;
                    else mirror1.placed=false;
                }
            }
            }
        Image {
            id:mirror2
            property int currangle:0
            property int  nxtangle:45
            property int id:1
            property bool placed:false
            source:"mirror1.svg"
            fillMode: Image.PreserveAspectFit
            x:400
            y:500
            width:100
            height:100
            RotationAnimation {
                id: rotate2
                target:mirror2
                property: "rotation"
                from: mirror2.currangle
                to: mirror2.nxtangle
                duration: 250
                direction: RotationAnimation.Clockwise
            }
            Image {
                id: wrongAnswer2
                anchors.centerIn: parent
                height: parent.height * 0.3
                width: parent.width * 0.3
                fillMode: Image.PreserveAspectFit
                z: 10
                source:"error.svg"
                visible: false
            }
             MouseArea {
                anchors.fill: parent
                onClicked: {
                    wrongAnswer1.visible=false;
                    wrongAnswer2.visible=false;
                    wrongAnswer3.visible=false;
                    wrongAnswer4.visible=false;
                    rotate2.start();
                    mirror2.currangle+=45;
                    mirror2.nxtangle+=45;
                    mirror2.id=mirror2.id+1;
                    if(mirror2.id%8==1)mirror2.id=1;
                    if(mirror2.id%8==2)
                        mirror2.placed=true;
                    else mirror2.placed=false;
                }
            }
            }
        Image {
            id:mirror3
            property int currangle:0
            property int  nxtangle:45
            property int id:1
            property bool placed:false
            source:"mirror1.svg"
            fillMode: Image.PreserveAspectFit
            x:650
            y:600
            width:100
            height:100
            RotationAnimation {
                id: rotate3
                target:mirror3
                property: "rotation"
                from: mirror3.currangle
                to: mirror3.nxtangle
                duration: 250
                direction: RotationAnimation.Clockwise
            }
            Image {
                id: wrongAnswer3
                anchors.centerIn: parent
                height: parent.height * 0.3
                width: parent.width * 0.3
                fillMode: Image.PreserveAspectFit
                z: 10
                source:"error.svg"
                visible: false
            }
             MouseArea {
                anchors.fill: parent
                onClicked: {
                    wrongAnswer1.visible=false;
                    wrongAnswer2.visible=false;
                    wrongAnswer3.visible=false;
                    wrongAnswer4.visible=false;
                    rotate3.start();
                    mirror3.currangle+=45;
                    mirror3.nxtangle+=45;
                    mirror3.id=mirror3.id+1;
                    if(mirror3.id%8==1)mirror3.id=1;
                    if(mirror3.id%8==0)
                        mirror3.placed=true;
                    else mirror3.placed=false;
                }
            }
            }
        Image {
            id:mirror4
            property int currangle:0
            property int  nxtangle:45
            property int id:1
            property bool placed:false
            source:"mirror1.svg"
            fillMode: Image.PreserveAspectFit
            x:750
            y:500
            width:100
            height:100
            RotationAnimation {
                id: rotate4
                target:mirror4
                property: "rotation"
                from: mirror4.currangle
                to: mirror4.nxtangle
                duration: 250
                direction: RotationAnimation.Clockwise
            }
            Image {
                id: wrongAnswer4
                anchors.centerIn: parent
                height: parent.height * 0.3
                width: parent.width * 0.3
                fillMode: Image.PreserveAspectFit
                z: 10
                source:"error.svg"
                visible: false
            }
             MouseArea {
                anchors.fill: parent
                onClicked: {
                    wrongAnswer1.visible=false;
                    wrongAnswer2.visible=false;
                    wrongAnswer3.visible=false;
                    wrongAnswer4.visible=false;
                    rotate4.start();
                    mirror4.currangle+=45;
                    mirror4.nxtangle+=45;
                    mirror4.id=mirror4.id+1;
                    if(mirror4.id%8==1)mirror4.id=1;
                    if(mirror4.id%8==6)
                        mirror4.placed=true;
                    else mirror4.placed=false;
                }
            }
            }

        Rectangle {
            id: instruction
            anchors.fill: instructionTxt
            opacity: 0.8
            radius: 10
            z: 3
            border.width: 2
            border.color: "black"
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#000" }
                GradientStop { position: 0.9; color: "#666" }
                GradientStop { position: 1.0; color: "#AAA" }
            }
            property alias text: instructionTxt.text

            Behavior on opacity { PropertyAnimation { duration: 200 } }

            function show() {
                if(text)
                    opacity = 1
            }
            function hide() {
                opacity = 0
            }
        }

        GCText {
            id: instructionTxt
            anchors {
                top:lvl1.top
                topMargin: -10
                left: lvl1.left
            }
            opacity: instruction.opacity
            z: instruction.z
            fontSize: regularSize
            color: "white"
            style: Text.Outline
            styleColor: "black"
            horizontalAlignment: Text.AlignHCenter
            width: parent.width * 0.4
            wrapMode: TextEdit.WordWrap
            text:qsTr("By clicking on the mirrors, Rotate the mirrors")+
                 " to reflect the light, such that the light from"+
                 " the torch should reach the bulb"
        }

        Image{
            id:torch
            source:"torch.svg"
            height:100
            width :100
            x:850
            y:180
            transform: Rotation { origin.x: 25; origin.y: 25; angle: -10}
        }
    }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: {win.connect(Activity.nextLevel);
                }
        }

    }

}
