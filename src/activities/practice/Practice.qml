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
import GCompris 1.0

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
            property alias calculationResult: result.text
            property var problemData
            property int sublevel
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
            content: BarEnumContent { value: help | home | level | hint }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onHintClicked: {
                calculator.visible = !calculator.visible
            }

            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextSublevel)
        }

        Rectangle {
            id: workspace
            color: "transparent"
            height: parent.height
            width: parent.width*0.65

            // questions
            Rectangle {
                id: questionWrapper
                width: parent.width
                height: question.height
                color: "#d8ffffff"
                border.color: "#2a2a2a"
                border.width: 2
                radius: 8
                anchors {
                    top: parent.top
                    topMargin: 10
                    left: parent.left
                    leftMargin: 10
                    right: parent.right
                    rightMargin: 10
                }
                GCText {
                    id: question
                    fontSize: largeSize
                    font.weight: Font.DemiBold
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width
                    wrapMode: Text.WordWrap
                    text: qsTr(items.problemData[0])
                }

            }

            Column {
                id: problems
                spacing: 10
                anchors {
                    top: questionWrapper.bottom
                    topMargin: 20
                }
                width: parent.width
                Repeater {
                    id: problemReapeater
                    model: items.problemData[1]
                    Rectangle {
                        id: problemWrapper
                        width: parent.width
                        height: problemText.height > answerWrapper.height ? problemText.height : answerWrapper.height
                        color: "transparent"
                        radius: 8
                        anchors {
                            left: parent.left
                            leftMargin: 10
                            right: parent.right
                            rightMargin: 10
                        }
                        property alias correct: answer.correct
                        Rectangle {
                            id: problem
                            width: parent.width*0.75
                            height: problemText.height
                            color: "#d8ffffff"
                            border.color: "#2a2a2a"
                            border.width: 2
                            radius: 8
                            anchors {
                                verticalCenter: parent.verticalCenter
                            }

                            GCText {
                                id: problemText
                                width: parent.width
                                fontSize: regularSize
                                font.weight: Font.DemiBold
                                horizontalAlignment: Text.AlignHCenter
                                wrapMode: Text.WordWrap
                                text: qsTr(modelData[0])
                            }
                        }
                        Rectangle {
                            id: answerWrapper
                            color: "white"
                            width: 80
                            height: 80
                            anchors {
                                verticalCenter: parent.verticalCenter
                            }
                            border.color: "black"
                            border.width: 5
                            anchors.right: image.left
                            anchors.rightMargin: 20
                            TextInput {
                                id: answer
                                width: parent.width
                                height: parent.height
                                property bool correct: false
                                verticalAlignment: TextInput.AlignVCenter
                                horizontalAlignment: TextInput.AlignHCenter
                                cursorPosition: 0
                                color: "black"
                                text: ""
                                focus: true
                                font.pixelSize: 30
                                font.bold: true
                                maximumLength:2
                                validator: IntValidator{bottom: -1; top: 100;}
                                onTextChanged: {
                                    answer.correct = Number(text) == modelData[1] ? true : false
                                    if(Activity.check(problemReapeater)){
                                        timer.start()
                                        if(items.sublevel+1 < Activity.problemDataset[Activity.currentLevel].length) {
                                            bonus.good("flower")
                                        }
                                        else {
                                            bonus.good("smiley")
                                        }
                                    }

                                }
                            }
                        }
                        Image {
                            id: image
                            width: 50
                            height: 50
                            visible: answer.text == "" ? false : true
                            anchors {
                                right: parent.right
                                rightMargin: 10
                                verticalCenter: parent.verticalCenter
                            }
                            source: answer.correct ? Activity.url + 'right.svg' : Activity.url + 'wrong.svg'
                        }
                    }
                }
            }


            //calculator
            Row {
                id: calculator
                visible: false
                anchors {
                    top: problems.bottom
                    topMargin: 20
                    horizontalCenter: parent.horizontalCenter
                }
                spacing: 10
                Rectangle {
                    width: 100
                    height: 200
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
                            onTextChanged: Activity.calculate_result(firstop.text,operator.text,secondop.text)
                            //KeyNavigation.down: evaluate
                        }
                    }
                }
                Rectangle{
                    width: 100
                    height: 200
                    color: "transparent"
                    Rectangle{
                        id:operator_
                        height: parent.height/4
                        width: parent.width
                        color:"transparent"
                        GCText{
                            anchors.centerIn: parent
                            font.pointSize: smallSize
                            font.bold: true
                            text:qsTr("operator")
                        }
                    }
                    Rectangle {
                        anchors.top:operator_.bottom
                        color: "white"
                        width: parent.width
                        height: parent.width
                        border.color: "black"
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
                            onTextChanged: Activity.calculate_result(firstop.text,operator.text,secondop.text)
                            //KeyNavigation.down: evaluate
                        }
                    }
                }
                Rectangle{
                    width: 100
                    height: 200
                    color: "transparent"
                    Rectangle{
                        id:number2
                        height: parent.height/4
                        width: parent.width
                        color:"transparent"
                        GCText {
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
                            KeyNavigation.left: operator
                            onTextChanged: Activity.calculate_result(firstop.text,operator.text,secondop.text)
                            //KeyNavigation.down: evaluate
                        }
                    }
                }
                Rectangle {
                    id:equalto
                    color: "transparent"
                    width: 100
                    height: 200
                    Image {
                        anchors.centerIn: parent
                        width: parent.width
                        source: Activity.url+"equal.svg"
                    }
                }

                Rectangle {
                    width: 100
                    height: 200
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
                        GCText{
                            id: result
                            anchors.centerIn: parent
                            font.pixelSize: parent.parent.height/6
                            font.bold: true
                            text: ""
                        }
                    }
                }
                Rectangle {
                    id:evaluate
                    width: 150
                    height: 50
                    anchors {
                        verticalCenter: parent.verticalCenter
                    }
                    signal clicked
                    onClicked: NumberAnimation { target: evaluate; property: "opacity"; from: 0; to: 1; duration: 200 }
                    onActiveFocusChanged: {evaluate.scale= activeFocus ? 1.05 : 1 }
                    //                    Keys.onEnterPressed: { evaluate.children[1].clicked()}
                    color: "#53d769"
                    border.color: Qt.lighter(color, 1.1)
                    GCText {
                        anchors.centerIn: parent
                        fontSize: smallSize
                        font.bold: true
                        text: qsTr("Save")
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
                            var input={"firstop":Number(firstop.text),"secondop":Number(secondop.text),"operator":operator.text,"result":Number(result.text)}
                            //                            firstop.undo()
                            //                            operator.undo()
                            //                            secondop.undo()
                            //                            result.undo()
                            theModel.insert(0,input)
                        }

                    }
                }
            }
        }

        Rectangle {
            id:row2
            width: parent.width*0.35
            height:parent.height
            anchors.right: parent.right
            gradient: Gradient {
                GradientStop { position: 0.0; color: "gray" }
                GradientStop { position: 1.0; color: "transparent" }
            }
            ListModel {
                id: theModel
            }
            //            ListModel{
            //                id:saveitems
            //            }
            //            ListModel{
            //                id:correctquestions
            //            }
            //            ListModel{
            //                id:wrongquestions
            //            }
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
                    text: qsTr("Saved Calculations")
                    onTextChanged: NumberAnimation { target: headertext; property: "opacity"; from: 0; to: 1; duration: 450}
                }
            }
            ListView {
                id:list
                width: parent.width
                height: parent.height-header.height-footer.height
                anchors.top:header.bottom
                model: theModel
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
                    color: "white"
                    Flipable{
                        id:flipable
                        width: parent.width
                        height: (parent.height/16)*7
                        property bool flipped: false
                        front: Rectangle {
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
                                text: "  " + firstop + operator + secondop
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
                                fontSize: mediumSize
                                font.bold: true
                                text: result
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
                            visible: true
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
                            id:remove
                            width: row2.width*0.25
                            height: (row2.height/80)*3
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
                                    items.theModel.remove(index);
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
                        centerIn: parent
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
                            theModel.clear()
                        }
                    }
                }
            }
        }
        Timer {
            id: timer
            interval: 1500
            repeat: false
//            onTriggered: {
//                items.solved = true
//            }
        }
    }
}

