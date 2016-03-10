/* GCompris - practice.qml
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
                color: "gray"
                width: parent.width*0.65
                height: parent.height
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
                        Rectangle{
                            id:number1
                            height: 50
                            width: parent.width
                            color:"gray"
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
                        Rectangle{
                            id:operator_
                            height: 50
                            width: parent.width
                            color:"gray"
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

                                }
                        }
                    }
                    Rectangle{
                        height: 200
                        width: 150
                        Rectangle{
                            id:number2
                            height: 50
                            width: parent.width
                            color:"gray"
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
                        Rectangle{
                            id:expected_result
                            height: 50
                            width: parent.width
                            color:"gray"
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
                    anchors.top: row1.bottom
                    anchors.right: parent.right
                    anchors.topMargin: 50
                    anchors.rightMargin: 100
                    width:200
                    height: 40

                    color: "#53d769"
                    border.color: Qt.lighter(color, 1.1)

                    GCText {
                        anchors.centerIn: parent
                        text: "Evaluate"
                    }

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
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
                        }
                        else
                            audioEffects.play("qrc:/gcompris/src/core/resource/sounds/crash.wav")

                            }
                            else
                                audioEffects.play("qrc:/gcompris/src/core/resource/sounds/crash.wav")
                             theModel.insert(0,input);
                        }


                    }

                }

            }
            Rectangle {
                width: parent.width*0.35
                height:parent.height
                ListModel {
                    id: theModel
                }
                ListModel{
                    id:saveitems
                }

                Rectangle{
                id:header
                height: 60
                width: parent.width
                color: "lightblue"
                GCText {
                    anchors.centerIn: parent
                    text: qsTr("Calculation List")
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
                }


                Component {
                    id: numberDelegate

                    Rectangle {
                        id: wrapper
                        //color: "blue"
                        width: parent.width
                        height: 80
                        color: correct ? "green":"red"
                        /*gradient: Gradient {
                                        GradientStop { position: 0.0; color: "#f8306a" }
                                        GradientStop { position: 1.0; color: "#fb5b40" }
                                    }*/
                        GCText {
                            anchors.margins: 10
                            fontSize: mediumSize
                            text: "  "+firstop+operator+secondop+"="+expected_result
                        }
                        Rectangle{
                            id:save
                            width: 80
                            height: 30
                            visible:!saved_calculation
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
                color: "lightblue"
                Rectangle{
                    id:clear_all
                    width: parent.width/3
                    height: parent.height/1.5
                    color: "yellow"
                    anchors{
                        left: parent.left
                        leftMargin: 20
                        verticalCenter: parent.verticalCenter
                    }
                GCText {
                    anchors.centerIn: parent
                    text: qsTr("clear all")
                }
                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                            items.currentmodel.clear();
                    }
                }
                }
                Rectangle{
                    id:saved_list
                    visible: true
                    width: parent.width/2
                    height: parent.height/1.5
                    color: "yellow"
                    anchors{
                        right: parent.right
                        rightMargin: 20
                        verticalCenter: parent.verticalCenter
                    }
                GCText {
                    anchors.centerIn: parent
                    text: qsTr("saved list")
                }
                MouseArea {
                    anchors.fill: parent

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
                    width: parent.width/2.5
                    height: parent.height/1.5
                    color: "yellow"
                    anchors{
                        right: parent.right
                        rightMargin: 20
                        verticalCenter: parent.verticalCenter
                    }
                GCText {
                    anchors.centerIn: parent
                    text: qsTr("current list")
                }
                MouseArea {
                    anchors.fill: parent

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
