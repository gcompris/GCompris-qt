/* GCompris - practice.qml
 *
 * Copyright (C) 2016 YOUR NAME <xx@yy.org>
 *
 * Authors:
 *  Rahul Yadav <rahulyadav170923@gmail.com>
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
import "practice.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: "#ABCDEF"
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
            property ListModel currentmodel: theModel
            property GCAudio audioEffects: activity.audioEffects
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }



        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home }
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
        Row {
            anchors.fill: parent
            spacing: 2

            Rectangle {
                color: "transparent"
                width: parent.width*0.65
                height: parent.height
                Image {
                    source: Activity.url+"background2.jpg"
                    width:parent.width
                    height:parent.height
                }
                Grid {
                    id:row1
                    anchors.top:parent.top
                    anchors.topMargin: 250
                    anchors.horizontalCenter:  parent.horizontalCenter
                    rows:1
                    spacing: 10
                    Rectangle{

                        height: 200
                        width: 150
                        color: "transparent"
                        Rectangle{
                            id:number1
                            height: 50
                            width: parent.width
                            color:"transparent"
                        GCText{
                            anchors.centerIn: parent
                            font.pointSize: 20
                            text:"1st number"
                        }
                        }
                    Rectangle {
                        anchors.top:number1.bottom
                        color: "white"
                        width: parent.width
                        height: 150
                        border.color: "black"
                        border.width: 5

                        TextInput {
                                id:firstop
                                    width: parent.width
                                    height: parent.height
                                    verticalAlignment: TextInput.AlignVCenter
                                    horizontalAlignment: TextInput.AlignHCenter
                                    cursorPosition: 0
                                    color: "black"
                                    text: ""
                                    focus: true
                                    font.pixelSize: 40
                                    font.bold: true
                                    //maximumLength:2
                                    validator: IntValidator{bottom: -1; top: 100;}


                                }
                        }
                    }
                    Rectangle{
                        height: 200
                        width: 150
                        color: "transparent"
                        Rectangle{
                            id:operator_
                            height: 50
                            width: parent.width
                            color:"transparent"
                        GCText{
                            anchors.centerIn: parent
                            font.pointSize: 20
                            text:"operator"
                        }
                        }
                    Rectangle {
                        anchors.top:operator_.bottom
                        color: "white"
                        width: 150
                        height: 150
                        border.color: "red"
                        border.width: 5
                            TextInput {
                                id:operator
                                    width: parent.width
                                    height: parent.height
                                    verticalAlignment: TextInput.AlignVCenter
                                    horizontalAlignment: TextInput.AlignHCenter
                                    cursorPosition: 0
                                    color: "black"
                                    text: ""
                                    focus: true
                                    font.pixelSize: 40
                                    font.bold: true
                                    maximumLength:1
                                    /*validator: RegExpValidator{
                                    regExp:/+/
                                    }*/

                                }
                        }
                    }
                    Rectangle{
                        height: 200
                        width: 150
                        color: "transparent"
                        Rectangle{
                            id:number2
                            height: 50
                            width: parent.width
                            color:"transparent"
                        GCText{
                            anchors.centerIn: parent
                            font.pointSize: 20
                            text:"2nd number"
                        }
                        }
                    Rectangle {
                        anchors.top:number2.bottom
                        color: "white"
                        width: 150
                        height: 150
                        border.color: "black"
                        border.width: 5
                        TextInput {
                            id:secondop
                            width: parent.width
                            height: parent.height
                            verticalAlignment: TextInput.AlignVCenter
                            horizontalAlignment: TextInput.AlignHCenter
                            cursorPosition: 0
                            color: "black"
                            text: ""
                            focus: true
                            font.pixelSize: 40
                            font.bold: true
                            //maximumLength:2
                            validator: IntValidator{bottom: -1; top: 100;}

                        }
                        }
                    }

                    Rectangle {
                        id:equalto
                        color: "transparent"
                        width: 150
                        height: 200
                        Image {
                            anchors.centerIn: parent
                            source: Activity.url+"equal.svg"
                        }
                        }
                    Rectangle{
                        height: 200
                        width: 150
                        color: "transparent"
                        Rectangle{
                            id:expected_result
                            height: 50
                            width: parent.width
                            color:"transparent"
                        GCText{
                            anchors.centerIn: parent
                            font.pointSize: 20
                            text:"calculation"
                        }
                        }
                    Rectangle {
                        anchors.top: expected_result.bottom
                        color: "white"
                        width: 150
                        height: 150
                        border.color: "black"
                        border.width: 5
                            TextInput {
                                id:result
                                    width: parent.width
                                    height: parent.height
                                    verticalAlignment: TextInput.AlignVCenter
                                    horizontalAlignment: TextInput.AlignHCenter
                                    cursorPosition: 0
                                    color: "black"
                                    text: ""
                                    focus: true
                                    font.pixelSize: 40
                                    font.bold: true
                                    //maximumLength:2
                                    validator: IntValidator{bottom: -1; top: 200;}

                                }
                        }
                    }


                }
                Rectangle {
                    id:evaluate
                    anchors.top: row1.bottom
                    anchors.right: parent.right
                    anchors.topMargin: 50
                    anchors.rightMargin: 50
                    width:200
                    height: 40
                    signal clicked
                    onClicked: NumberAnimation { target: evaluate; property: "opacity"; from: 0; to: 1; duration: 200 }

                    color: "#53d769"
                    border.color: Qt.lighter(color, 1.1)

                    GCText {
                        anchors.centerIn: parent
                        text: "Evaluate"
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onHoveredChanged: {
                             if(containsMouse)
                                {
                                 evaluate.scale=1.15
                             }
                             else{
                                 evaluate.scale=1
                             }

                        }
                        onClicked: {
                            evaluate.clicked()
                            if(firstop.text!="" && operator.text!="" && secondop.text!="" && result.text!="")
                            {
                            var input={"firstop":Number(firstop.text),"secondop":Number(secondop.text),"operator":operator.text,"expected_result":Number(result.text),"saved_calculation":false}
                            firstop.undo()
                                operator.undo()
                            secondop.undo()
                                result.undo()
                        if(Activity.calculate_result(input))
                        {
                            input["correct"]=Activity.calculate_result(input)
                            audioEffects.play("qrc:/gcompris/src/core/resource/sounds/win.wav")
                            theModel.insert(0,input);
                            correctquestions.insert(0,input)
                        }
                        else
                        {
                            input["correct"]=Activity.calculate_result(input)
                            audioEffects.play("qrc:/gcompris/src/core/resource/sounds/crash.wav")
                            theModel.insert(0,input);
                            wrongquestions.insert(0,input)
}
                            }
                            else
                                audioEffects.play("qrc:/gcompris/src/core/resource/sounds/crash.wav")

                        }


                    }

                }
                Rectangle {
                    id:correctanswers
                    anchors.top: evaluate.bottom
                    anchors.right: parent.right
                    anchors.topMargin: 50
                    anchors.rightMargin: 50
                    width:350
                    height: 50
                    signal clicked
                    onClicked: NumberAnimation { target: correctanswers; property: "opacity"; from: 0; to: 1; duration: 200 }

                    color: "#53d769"
                    border.color: Qt.lighter(color, 1.1)

                    GCText {
                        anchors.centerIn: parent
                        text: "Correct Answers"
                    }
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onHoveredChanged: {
                             if(containsMouse)
                                {
                                 correctanswers.scale=1.15
                             }
                             else{
                                 correctanswers.scale=1
                             }
                         }

                        onClicked: {
                            correctanswers.clicked()
                            items.currentmodel=correctquestions

                        }
                    }
                }
                Rectangle {
                    id:wronganswers
                    anchors.top: evaluate.bottom
                    anchors.right: correctanswers.left
                    anchors.topMargin: 50
                    anchors.rightMargin: 50
                    width:350
                    height: 50
                    signal clicked
                    onClicked: NumberAnimation { target: wronganswers; property: "opacity"; from: 0; to: 1; duration: 200 }

                    color: "red"
                    border.color: Qt.lighter(color, 1.1)

                    GCText {
                        anchors.centerIn: parent
                        text: "Wrong Answers"
                    }
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onHoveredChanged: {
                             if(containsMouse)
                                {
                                 wronganswers.scale=1.15
                             }
                             else{
                                 wronganswers.scale=1
                             }
                        }

                        onClicked: {
                            wronganswers.clicked()
                            items.currentmodel=wrongquestions

                        }
                    }
                }

            }
            Rectangle {
                width: parent.width*0.35
                height:parent.height
                //color: "lightgray"
                gradient: Gradient {
                                GradientStop { position: 0.0; color: "gray" }
                                GradientStop { position: 1.0; color: "white" }
                            }
                ListModel {
                    id: theModel
                }
                ListModel{
                    id:saveitems
                }
                ListModel{
                    id:correctquestions
                }
                ListModel{
                    id:wrongquestions
                }



                Rectangle{
                id:header
                height: 60
                width: parent.width
                color: "gray"
                GCText {
                    id:headertext
                    anchors.centerIn: parent
                    text: switch (items.currentmodel) {
                          case theModel:
                              return qsTr("Current Calculations")
                          case saveitems:
                              return qsTr("Saved Calculations")
                          case correctquestions:
                              return qsTr("Correct Answers")
                          default:
                             return qsTr("Wrong Answers")
                          }
                    //onTextChanged: NumberAnimation { target: headertext; property: "scale"; from: 0; to: 1; duration: 450; easing.type: Easing.InOutQuad }
                    onTextChanged: NumberAnimation { target: headertext; property: "opacity"; from: 0; to: 1; duration: 450}
                }

                }



                ListView {
                    id:list
                    width: parent.width
                    height: parent.height-header.height-footer.height
                    anchors.top:header.bottom
                    model: items.currentmodel

                    delegate: numberDelegate
                    spacing: 5
                    populate: Transition {
                            //NumberAnimation { property: "opacity";from:0; to: 1; duration: 1000 }
                        NumberAnimation { property: "scale"; from: 0; to: 1; duration: 250; easing.type: Easing.InOutQuad }
                        }
                }



                Component {
                    id: numberDelegate

                    Rectangle {
                        id: wrapper
                        //color: "blue"
                        width: parent.width
                        height: 80
                        color: correct ? "green":"red"

                        GCText {
                            anchors.margins: 10
                            fontSize: mediumSize
                            text: "  "+firstop+operator+secondop+"="+expected_result
                        }
                        Rectangle{
                            id:save
                            width: 80
                            height: 30
                            visible:!saved_calculation && items.currentmodel==theModel
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.rightMargin: 10
                            color: "yellow"
                            GCText {
                                anchors.centerIn: parent
                                font.pointSize: 20
                                text: qsTr("save")
                                                            }

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                var input={"firstop":firstop,"secondop":secondop,"operator":operator,"expected_result":expected_result,"saved_calculation":true,"correct":correct}
                                saveitems.insert(0,input);
                                theModel.setProperty(index, "saved_calculation", true)
                            }
                        }
                        }
                        Rectangle{
                            id:remove
                            width: 100
                            height: 30
                            visible: !(items.currentmodel==correctquestions || items.currentmodel==wrongquestions)
                            anchors.right: save.left
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.rightMargin: 10
                            //anchors.right: parent.right
                            //anchors.rightMargin: 15
                            color: "orange"
                            GCText {
                                anchors.centerIn: parent
                                font.pointSize: 20
                                text: qsTr("remove")
                            }

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                    items.currentmodel.remove(index);
                            }
                        }
                        }


                        ListView.onRemove: SequentialAnimation {
                            PropertyAction { target: wrapper; property: "ListView.delayRemove"; value: true }
                            NumberAnimation { target: wrapper; property: "scale"; to: 0; duration: 250; easing.type: Easing.InOutQuad }
                            PropertyAction { target: wrapper; property: "ListView.delayRemove"; value: false }
                        }

                        ListView.onAdd: SequentialAnimation {
                            NumberAnimation { target: wrapper; property: "scale"; from: 0; to: 1; duration: 250; easing.type: Easing.InOutQuad }
                        }


                    }
                }
                Rectangle{
                id:footer
                anchors.bottom: parent.bottom
                height: 60
                width: parent.width
                color: "gray"
                Rectangle{
                    id:clear_all
                    width: parent.width/2.75
                    height: parent.height/1.25
                    color: "orange"
                    border.color: "transparent"
                    border.width: 3
                    anchors{
                        left: parent.left
                        leftMargin: 20
                        verticalCenter: parent.verticalCenter
                    }
                    signal clicked
                    onClicked: NumberAnimation { target: clear_all; property: "opacity"; from: 0; to: 1; duration: 200 }

                GCText {
                    anchors.centerIn: parent
                    text: qsTr("clear all")
                }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onHoveredChanged: {
                        if(containsMouse)
                           clear_all.border.color="lightblue"
                        else
                            clear_all.border.color="transparent"

                    }

                    onClicked: {
                        clear_all.clicked()
                            items.currentmodel.clear()
                    }
                }
                }
                Rectangle{
                    id:saved_list
                    visible: true
                    width: parent.width/2
                    height: parent.height/1.25
                    color: "orange"
                    border.width:3
                    border.color: "transparent"
                    anchors{
                        right: parent.right
                        rightMargin: 20
                        verticalCenter: parent.verticalCenter
                    }
                    onVisibleChanged: NumberAnimation { target: saved_list; property: "scale"; from: 0; to: 1; duration: 450; easing.type: Easing.InOutQuad }
                GCText {
                    anchors.centerIn: parent
                    text: qsTr("saved list")
                }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onHoveredChanged: {
                        if(containsMouse)
                           { saved_list.border.color="lightblue";}
                        else
                            saved_list.border.color="transparent"

                    }

                    onClicked: {
                            items.currentmodel=saveitems
                        current_list.visible=true
                        parent.visible=false

                    }
                }
                }
                Rectangle{
                    id:current_list
                    visible: false
                    width: parent.width/2
                    height: parent.height/1.25
                    color: "orange"
                    border.width:3
                    border.color: "transparent"

                    anchors{
                        right: parent.right
                        rightMargin: 20
                        verticalCenter: parent.verticalCenter
                    }

                    onVisibleChanged: NumberAnimation { target: current_list; property: "scale"; from: 0; to: 1; duration: 450; easing.type: Easing.InOutQuad }
                GCText {
                    anchors.centerIn: parent
                    text: qsTr("current list")
                }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onHoveredChanged: {
                         if(containsMouse)
                            { current_list.border.color="lightblue";}
                         else
                             current_list.border.color="transparent"

                     }
                    onClicked: {
                            items.currentmodel=theModel
                        saved_list.visible=true
                        parent.visible=false
                    }

                }
                }

                }
            }

        }
    }

}
