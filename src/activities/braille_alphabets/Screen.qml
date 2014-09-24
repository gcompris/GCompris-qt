/* GCompris - brm.qml
 *
 * Copyright (C) 2014 <YOUR NAME HERE>
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
import QtQuick.Layouts 1.1
import "../../core"
import "braille_alphabets.js" as Activity


ActivityBase {
    id: activity



    onStart: focus = true
    onStop: {}

    property var dataset

    pageComponent: Image {
        id: background
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        source: "qrc:/gcompris/src/activities/braille_alphabets/resource/mosaic.svgz"
        sourceSize.width: parent.width
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
            property alias containerModel: containerModel
            property alias questionItem: questionItem
            property alias instructions: instructions
            property alias ans: ans

        }

        onStart: { Activity.start(items,dataset) }
        onStop: { Activity.stop() }


        ListModel {
            id: containerModel
        }

        Item{
            id:outer
            x:parent.width/2
            y:parent.height/15
            width:parent.width/1.06
            height: parent.height/3.7
            anchors.horizontalCenter: parent.horizontalCenter

            Row {
                spacing: 20
                anchors.centerIn: outer

                Repeater {
                    id: cardRepeater
                    model:containerModel

                    Item{
                        id:inner
                        height:outer.height
                        width:outer.width/12

                        Rectangle {
                            id:rect1
                            width: outer.width/12; height: outer.height/1.5
                            border.width: 3
                            border.color: "black"
                            color: "white"

                            Grid {
                                spacing: 1
                                id: grid
                                anchors.centerIn: rect1
                                columns: 2
                                rows: 3

                                Rectangle {
                                    id:circle1
                                    border.width: 3

                                    border.color: "black"
                                    width: rect1.height/3.1; height: rect1.height/3.1
                                    radius: width*0.5

                                    function col(){
                                        if(one=="on"){
                                            color="red"
                                        }
                                        else{
                                            color="white"
                                        }
                                    }
                                    color: col()
                                }


                                Rectangle {
                                    id:circle2
                                    border.width:3

                                    border.color: "black"
                                    width: rect1.height/3.1; height: rect1.height/3.1
                                    radius: width*0.5

                                    function col(){
                                        if(two=="on"){
                                            color="red"
                                        }
                                        else{
                                            color="white"
                                        }
                                    }
                                    color: col()
                                }



                                Rectangle {
                                    id:circle3
                                    border.width:3

                                    border.color: "black"
                                    width: rect1.height/3.1; height: rect1.height/3.1
                                    radius: width*0.5

                                    function col(){
                                        if(three=="on"){
                                            color="red"
                                        }
                                        else{
                                            color="white"
                                        }
                                    }
                                    color: col()
                                }



                                Rectangle {
                                    id:circle4
                                    border.width:3

                                    border.color: "black"
                                    width: rect1.height/3.1; height: rect1.height/3.1
                                    radius: width*0.5

                                    function col(){
                                        if(four=="on"){
                                            color="red"
                                        }
                                        else{
                                            color="white"
                                        }
                                    }
                                    color: col()
                                }




                                Rectangle {
                                    id:circle5
                                    border.width:3

                                    border.color: "black"
                                    width: rect1.height/3.1; height: rect1.height/3.1
                                    radius: width*0.5

                                    function col(){
                                        if(five=="on"){
                                            color="red"
                                        }
                                        else{
                                            color="white"
                                        }
                                    }
                                    color: col()
                                }




                                Rectangle {
                                    id:circle6
                                    border.width:3

                                    border.color: "black"
                                    width: rect1.height/3.1; height: rect1.height/3.1
                                    radius: width*0.5

                                    function col(){
                                        if(six=="on"){
                                            color="red"
                                        }
                                        else{
                                            color="white"
                                        }
                                    }
                                    color: col()
                                }

                            }
                        }


                        Text{
                            text:letter
                            scale: 2
                            y:parent.height/1.3
                            x:parent.width/2.2

                        }
                    }

                }
            }
        }


        Item{
            id:newit
            x:parent.width/5.4
            y:parent.height/1.9
            height:parent.height/3
            width:parent.width/3
            anchors.centerIn: parent.left


            Item {
                id:rect2
                width: newit.width/2; height: newit.height

                Grid {
                    spacing: 5
                    anchors.centerIn: parent
                    id: gridthree

                    columns: 2
                    rows: 3

                    Repeater{
                        id:circles
                        model:["1","4","2","5","3","6"]
                        delegate: Braille_cell{

                        }
                    }
                }
            }
        }



        Rectangle {
            id: instructionsArea
            height: parent.height/16
            width: parent.width/1.1
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: outer.bottom
            color: "#55333333"
            border.color: "black"
            border.width: 2
            radius: 5
            anchors.leftMargin: 10
            anchors.rightMargin: 10


            Text {
                id: questionItem
                anchors.top: outer.bottom
                anchors.leftMargin: 10
                x:parent.width/2
                y:parent.height/7
                anchors.centerIn: parent
                font.pointSize: instructionsArea.height/3
                horizontalAlignment: Text.AlignHCenter
                font.weight: Font.DemiBold
                style: Text.Outline
                styleColor: "white"
                color: "black"
                width:parent.width

                wrapMode: Text.WordWrap

                function initQuestion() {
                    text = Activity.getCurrentTextQuestion()

                    opacity = 1.0
                }

                onOpacityChanged: opacity == 0 ? initQuestion() : ""
                Behavior on opacity { PropertyAnimation { duration: 500 } }
            }

        }

        Text{
            id:instructions
            anchors.top: instructionsArea.bottom
            horizontalAlignment: Text.AlignHCenter
            width:parent.width
            wrapMode: Text.WordWrap
            color: "black"
            style: Text.Outline
            styleColor: "white"
            font.weight: Font.DemiBold
            font.pointSize: instructionsArea.height/3
            text:""

        }

        ParticleSystemStar {
            id: particles
            clip: false
        }


        Image{
            id:okbutton
            x:parent.width/2
            y:parent.height/1.5
            width: parent.height/10
            height: parent.height/10

            source: "qrc:/gcompris/src/activities/braille_alphabets/resource/transparent.png"



            MouseArea{

                function correct(){

                    if(circles.itemAt(0).state==Activity.getCurrentStateOne()&&circles.itemAt(1).state==Activity.getCurrentStateTwo()&&circles.itemAt(2).state==Activity.getCurrentStateThree()&&circles.itemAt(3).state==Activity.getCurrentStateFour()&&circles.itemAt(4).state==Activity.getCurrentStateFive()&&circles.itemAt(5).state==Activity.getCurrentStateSix())
                    {

                        particles.emitter.burst(100)
                        wrong.opacity=0
                        ans.opacity=1
                        circles.itemAt(0).state="off"
                        circles.itemAt(1).state="off"
                        circles.itemAt(2).state="off"
                        circles.itemAt(3).state="off"
                        circles.itemAt(4).state="off"
                        circles.itemAt(5).state="off"

                        ans.text=Activity.getCurrentAlphabet()
                        Activity.nextQuestion()

                    }
                    else{
                        ans.opacity=0
                        wrong.opacity=1
                        wrong.visible=true

                    }
                }

                anchors.fill: parent
                onClicked: correct()
                onPressed: okbutton.opacity=0.4
                onReleased: okbutton.opacity=1
            }
        }

        Image{
            id:wrong
            x:parent.width/1.23
            y:parent.height/1.70
            width:parent.height/7
            height:parent.height/7
            source:"qrc:/gcompris/src/activities/braille_alphabets/resource/wrong.png"
            visible: false
        }

        Text{
            id:ans
            scale:2
            x:parent.width/1.20
            y:parent.height/1.63
            font.pointSize: parent.height/20
            font.weight: Font.DemiBold
            style: Text.Outline

            Behavior on opacity { PropertyAnimation { duration: 1000} }
            styleColor: "white"
            color: "black"
            text:""

        }

        Image{
            id:first_screen
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            source: "qrc:/gcompris/src/activities/braille_alphabets/resource/braille_tux.jpg"
            sourceSize.width: parent.width

            Rectangle{
                id:tux_square
                anchors.bottom: parent.bottom
                radius: 10
                anchors.right: parent.right
                color:"transparent"
                width:parent.width/3
                height: parent.width/3


                MouseArea{
                    id:tux_click
                    anchors.fill: parent

                    function tux_onClicked(){
                        first_screen.visible=false

                    }
                    function tux_onHover(){
                        tux_square.color="#E41B2D"
                        tux_square.opacity=0.3
                    }
                    function tux_onExit(){
                        tux_square.color="transparent"
                        tux_square.opacity=1
                    }
                    hoverEnabled: true
                    onClicked: tux_onClicked()
                    onEntered: tux_onHover()
                    onExited: tux_onExit()
                }
            }

        }


        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | previous | next }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}

