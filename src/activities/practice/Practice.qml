/* GCompris - practice.qml
 *
 * Copyright (C) 2016 Rahul Yadav <rahulyadav170923@gmail.com>
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

        onStart: {
            Activity.start(items)
            console.log(parent.width)
        }
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
            spacing: 0
            Rectangle {
                id:row1
                color: "transparent"
                width: background.width*0.65
                height: background.height
                Grid {
                    id:grid
                    anchors.top:parent.top
                    anchors.topMargin: row1.height/3.2
                    anchors.horizontalCenter:  parent.horizontalCenter
                    rows:1
                    spacing: 5
                    Rectangle{
                        height: row1.height/4
                        width: row1.width*0.1875
                        color: "transparent"
                        Rectangle{
                            id:number1
                            height: parent.height/4
                            width: parent.width
                            color:"transparent"
                            GCText{
                                anchors.centerIn: parent
                                font.pointSize: smallSize
                                font.bold: true
                                text:qsTr("number 1")
                            }
                        }
                        Rectangle {
                            anchors.top:number1.bottom
                            color: "white"
                            width: parent.width
                            height: parent.width
                            border.color: "black"
                            border.width: parent.height/40
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
                                font.pixelSize: parent.parent.height/6
                                font.bold: true
                                maximumLength:2
                                validator: IntValidator{bottom: -1; top: 100;}
                                KeyNavigation.right: operator
                                //KeyNavigation.down: evaluate
                            }
                        }
                    }
                    Rectangle{
                        height: row1.height/4
                        width: row1.width*0.1875
                        color: "transparent"
                        Rectangle{
                            id:operator_
                            height: parent.height/4
                            width: parent.width
                            color:"transparent"
                            GCText{
                                anchors.centerIn: parent
                                fontSize: smallSize
                                font.bold: true
                                text:qsTr("operator")
                            }
                        }
                        Rectangle {
                            anchors.top:operator_.bottom
                            color: "white"
                            width: parent.width
                            height: parent.width
                            border.color: "red"
                            border.width: parent.height/40
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
                                font.pixelSize: parent.parent.height/6
                                font.bold: true
                                validator: RegExpValidator { regExp: /[+-*/]/ }
                                maximumLength:1
                                KeyNavigation.right: secondop
                                KeyNavigation.left: firstop
                                //KeyNavigation.down: evaluate
                            }
                        }
                    }
                    Rectangle{
                        height: row1.height/4
                        width: row1.width*0.1875
                        color: "transparent"
                        Rectangle{
                            id:number2
                            height: parent.height/4
                            width: parent.width
                            color:"transparent"
                            GCText{
                                anchors.centerIn: parent
                                font.pointSize: smallSize
                                font.bold: true
                                text:qsTr("number 2")
                            }
                        }
                        Rectangle {
                            anchors.top:number2.bottom
                            color: "white"
                            width: parent.width
                            height: parent.width
                            border.color: "black"
                            border.width: parent.height/40
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
                                font.pixelSize: parent.parent.height/6
                                font.bold: true
                                maximumLength:2
                                validator: IntValidator{bottom: -1; top: 100;}
                                KeyNavigation.right: result
                                KeyNavigation.left: operator
                                //KeyNavigation.down: evaluate
                            }
                        }
                    }
                    Rectangle {
                        id:equalto
                        color: "transparent"
                        height: row1.height/4
                        width: row1.width*0.1875
                        Image {
                            anchors.centerIn: parent
                            width: parent.width
                            source: Activity.url+"equal.svg"
                        }
                    }
                    Rectangle{
                        height: row1.height/4
                        width: row1.width*0.1875
                        color: "transparent"
                        Rectangle{
                            id:expected_result
                            height: parent.height/4
                            width: parent.width
                            color:"transparent"
                            GCText{
                                anchors.centerIn: parent
                                font.pointSize: smallSize
                                font.bold: true
                                text:qsTr("calculation")
                            }
                        }
                        Rectangle {
                            anchors.top: expected_result.bottom
                            color: "white"
                            width: parent.width
                            height: parent.width
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
                                font.pixelSize: parent.parent.height/6
                                font.bold: true
                                maximumLength:3
                                validator: IntValidator{bottom: -1; top: 200;}
                                KeyNavigation.left: secondop
                                //KeyNavigation.down: evaluate
                            }
                        }
                    }
                }
                Rectangle {
                    id:evaluate
                    anchors.top: grid.bottom
                    anchors.right: parent.right
                    anchors.topMargin: row1.height/16
                    anchors.rightMargin: row1.height/16
                    width:row1.width/4
                    height: row1.height/20
                    signal clicked
                    onClicked: NumberAnimation { target: evaluate; property: "opacity"; from: 0; to: 1; duration: 200 }
                    //onActiveFocusChanged: {evaluate.scale= activeFocus ? 1.05 : 1 }
                    //Keys.onEnterPressed: { evaluate.children[1].clicked()}
                    color: "#53d769"
                    border.color: Qt.lighter(color, 1.1)
                    GCText {
                        anchors.centerIn: parent
                        fontSize: smallSize
                        font.bold: true
                        text: qsTr("Evaluate")
                    }
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onHoveredChanged: {
                            if(containsMouse)
                            {
                                evaluate.scale=1.05
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
                                if(Activity.calculate_result(input)[0])
                                {
                                    input["correct"]=Activity.calculate_result(input)[0]
                                    input["calculated_value"]=Activity.calculate_result(input)[1]
                                    audioEffects.play("qrc:/gcompris/src/core/resource/sounds/win.wav")
                                    theModel.insert(0,input)
                                    correctquestions.insert(0,input)
                                }
                                else
                                {
                                    input["correct"]=Activity.calculate_result(input)[0]
                                    input["calculated_value"]=Activity.calculate_result(input)[1]
                                    audioEffects.play("qrc:/gcompris/src/core/resource/sounds/crash.wav")
                                    theModel.insert(0,input)
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
                    anchors.topMargin: row1.height/16
                    anchors.rightMargin: row1.height/16
                    width:(row1.width/16)*7
                    height: row1.height/16
                    signal clicked
                    onClicked: NumberAnimation { target: correctanswers; property: "opacity"; from: 0; to: 1; duration: 200 }
                    color: "#53d769"
                    border.color: Qt.lighter(color, 1.1)
                    GCText {
                        anchors.centerIn: parent
                        fontSize: smallSize
                        font.bold: true
                        text: qsTr("Correct Answers")
                    }
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onHoveredChanged: {
                            if(containsMouse)
                            {
                                correctanswers.scale=1.05
                            }
                            else
                            {
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
                    anchors.right:correctanswers.left
                    anchors.rightMargin: 5
                    anchors.left:parent.left
                    anchors.topMargin: row1.height/16
                    anchors.leftMargin: row1.width/20
                    width:(row1.width/16)*7
                    height: row1.height/16
                    signal clicked
                    onClicked: NumberAnimation { target: wronganswers; property: "opacity"; from: 0; to: 1; duration: 200 }
                    color: "red"
                    border.color: Qt.lighter(color, 1.1)
                    GCText {
                        anchors.centerIn: parent
                        fontSize: smallSize
                        font.bold: true
                        text: qsTr("Wrong Answers")
                    }
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onHoveredChanged: {
                            if(containsMouse)
                            {
                                wronganswers.scale=1.05
                            }
                            else
                            {
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
                id:row2
                width: parent.width*0.35
                height:parent.height
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
                    height: (parent.height/40)*3
                    width: parent.width
                    color: "gray"
                    GCText {
                        id:headertext
                        anchors.centerIn: parent
                        font.bold: true
                        fontSize: 13
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
                    spacing: parent.height/160
                    populate: Transition {
                        NumberAnimation { property: "scale"; from: 0; to: 1; duration: 250; easing.type: Easing.InOutQuad }
                    }
                }
                Component {
                    id: numberDelegate
                    Rectangle {
                        id: wrapper
                        width: parent.width
                        height: (row2.height/20)*3
                        color: correct ? "green":"red"
                        Flipable{
                            id:flipable
                            width: parent.width
                            height: (parent.height/16)*7
                            property bool flipped: false
                            front: Rectangle{
                                id:component_text
                                width:parent.width
                                height:parent.height
                                color: "transparent"
                                anchors.horizontalCenter: parent.horizontalCenter
                                GCText {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.margins: parent.height/7
                                    font.bold: true
                                    fontSize: mediumSize
                                    text: "  "+firstop+operator+secondop+"="+expected_result
                                }
                            }
                            back:Rectangle{
                                id:component_text2
                                width:parent.width
                                height:(parent.height/16)*7
                                color: "transparent"
                                anchors.horizontalCenter: parent.horizontalCenter
                                GCText {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.margins: parent.height/7
                                    fontSize: smallSize
                                    font.bold: true
                                    text: calculated_value
                                }
                            }
                            transform: Rotation {
                                id: rotation
                                origin.x: flipable.width/2
                                origin.y: flipable.height/2
                                axis.x: 0; axis.y: 1; axis.z: 0     // set axis.y to 1 to rotate around y-axis
                                angle: 0    // the default angle
                            }
                            states: State {
                                name: "back"
                                PropertyChanges { target: rotation; angle: 180 }
                                when: flipable.flipped
                            }
                            transitions: Transition {
                                NumberAnimation { target: rotation; property: "angle"; duration: 500 }
                            }
                        }
                        Grid {
                            anchors.top:flipable.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter:parent.verticalCenter
                            rows:1
                            spacing: 5
                            Rectangle{
                                id:check_answer
                                width:row2.width*0.467
                                height: (row2.height/80)*3
                                visible:!correct
                                color: "lightblue"
                                GCText {
                                    anchors.centerIn: parent
                                    font.pointSize: smallSize
                                    font.bold: true
                                    text: flipable.flipped ? qsTr("back") : qsTr("check answer")
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        flipable.flipped = !flipable.flipped
                                    }
                                }
                            }
                            Rectangle{
                                id:save
                                width: row2.width*0.187
                                height: (row2.height/80)*3
                                visible:!saved_calculation && items.currentmodel==theModel
                                color: "yellow"
                                GCText {
                                    anchors.centerIn: parent
                                    font.pointSize: smallSize
                                    font.bold: true
                                    text: qsTr("save")
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        var input={"firstop":firstop,"secondop":secondop,"operator":operator,"expected_result":expected_result,"saved_calculation":true,"correct":correct,"calculated_value":calculated_value}
                                        saveitems.insert(0,input);
                                        theModel.setProperty(index, "saved_calculation", true)
                                    }
                                }
                            }
                            Rectangle{
                                id:remove
                                width: row2.width*0.25
                                height: (row2.height/80)*3
                                visible: !(items.currentmodel==correctquestions || items.currentmodel==wrongquestions)
                                color: "orange"
                                GCText {
                                    anchors.centerIn: parent
                                    font.pointSize: smallSize
                                    font.bold: true
                                    text: qsTr("remove")
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        items.currentmodel.remove(index);
                                    }
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
                    height: (row2.height/40)*3
                    width: parent.width
                    color: "gray"
                    Rectangle{
                        id:clear_all
                        width: parent.width/2.85
                        height: parent.height/1.25
                        color: "orange"
                        border.color: "transparent"
                        border.width: 3
                        anchors{
                            left: parent.left
                            right:saved_list.left
                            rightMargin: 7
                            leftMargin: (row2.height/80)*1.5
                            verticalCenter: parent.verticalCenter
                        }
                        signal clicked
                        onClicked: NumberAnimation { target: clear_all; property: "opacity"; from: 0; to: 1; duration: 200 }
                        GCText {
                            anchors.centerIn: parent
                            fontSize: smallSize
                            font.bold: true
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
                            rightMargin: (row2.height/80)*1.5
                            verticalCenter: parent.verticalCenter
                        }
                        onVisibleChanged: NumberAnimation { target: saved_list; property: "scale"; from: 0; to: 1; duration: 450; easing.type: Easing.InOutQuad }
                        GCText {
                            anchors.centerIn: parent
                            fontSize: smallSize
                            font.bold: true
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
                            rightMargin: row2.height/40
                            verticalCenter: parent.verticalCenter
                        }
                        onVisibleChanged: NumberAnimation { target: current_list; property: "scale"; from: 0; to: 1; duration: 450; easing.type: Easing.InOutQuad }
                        GCText {
                            anchors.centerIn: parent
                            fontSize: smallSize
                            font.bold: true
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
