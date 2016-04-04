/* GCompris - guesscount.qml
 *
 * Copyright (C) 2016 RAHUL YADAV <rahulyadav170923@gmail.com>
 *
 * Authors:
 *   <PASCAL GEORGES> (V13.11)
 *   RAHUL YADAV <rahulyadav170923@gmail.com> (Qt Quick port)
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
import QtQuick.Dialogs 1.2
import "../../core"
import "guesscount.js" as Activity

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
            property var operators
            property int question_no
            property int total_questions
            property var data
            property int guesscount
            property alias row4: row4
            property alias row5: row5
            property alias row6: row6
            property GCAudio audioEffects: activity.audioEffects
            property var no_of_rows
            property alias timer: timer
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        GCText {
            anchors.centerIn: parent
            text: "guesscount1 activity"
            fontSize: largeSize
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
            Component.onCompleted: win.connect(Activity.nextLevel)
        }

        Image {
            source: Activity.url+"blackboard-2400px.png"
            width: parent.width
            height: parent.height
        }

        Rectangle {
            id: row1
            width: parent.width
            height: parent.height/8
            anchors{
                top: parent.top
                topMargin: (parent.height/80)*3
            }
            color: "transparent"
            Rectangle {
                id: question_no
                width: parent.width*0.328;
                height: parent.height;
                radius: 20.0;
                color: "steelblue"
                anchors{
                    left: parent.left
                    leftMargin: parent.width*0.028
                }
                GCText{
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    fontSize: mediumSize
                    text: qsTr("%1/%2").arg(items.question_no).arg(items.total_questions)
                }
            }
            Rectangle{
                width: parent.width*0.35;
                height: parent.height;
                radius: 20
                color: "orange"
                anchors{
                    right: parent.right
                    rightMargin: parent.width*0.028
                }
                GCText{
                    id: guess
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    fontSize: mediumSize
                    text: qsTr("Guesscount : %1").arg(items.guesscount)
                }
            }
        }

        Row {
            id: row2
            spacing: parent.width*0.041
            width: parent.width
            height: parent.height/8
            anchors{
                top: row1.bottom
                topMargin: (parent.height/80)*3
                left: parent.left
                leftMargin: parent.width*0.082
            }
            Rectangle{
                id: operator
                width: parent.width*0.328;
                height: parent.height
                radius: 20.0;
                color: "red"
                GCText{
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    fontSize: mediumSize
                    text: qsTr("Operators")
                }
            }
            Repeater {
                model: items.operators
                delegate: DragTile{
                    type: "operators"
                    width: background.width*0.082
                    height: background.height/8
                }
            }
        }
        // row 3
        Row {
            id: row3
            spacing: parent.width*0.041
            width: parent.width
            height: parent.height/8
            anchors{
                top: row2.bottom
                topMargin: (parent.height/80)*3
                left: parent.left
                leftMargin: parent.width*0.082
            }
            Rectangle{
                id: operands
                width: parent.width*0.328;
                height: parent.height
                radius: 20.0;
                color: "green"
                GCText{
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    fontSize: mediumSize
                    text: qsTr("Numbers")
                }
            }

            Repeater {
                model: items.data
                delegate: DragTile{
                    type: "operands"
                    width: background.width*0.082
                    height: background.height/8
                }
            }
        }
        //operation row 1
        Row{
            id: row4
            spacing: parent.width*0.041
            width: parent.width
            height: parent.height/8
            anchors{
                top: row3.bottom
                topMargin: parent.height/80
                left: parent.left
                leftMargin: parent.height*0.247
            }
            property var calculated_value
            Repeater{
                id: repeat
                model: 3
                delegate: DropTile {
                    id: dragTarget
                    property int count: 0
                    width: parent.width*0.082
                    height: parent.height
                    type: modelData%2==0 ? "operands" : "operators"
                    onDropped: {
                        if(dragTarget.count==1)
                        {
                            row4.children[modelData].children[1].tile.opacity=1
                            row4.children[modelData].children[1].parent= row4.children[modelData].children[1].reparent
                        }
                        else
                            dragTarget.count+=1
                        console.log(row4.children[modelData].children[1].tile.datavalue)
                        if(row4.children[0].count==1 && row4.children[1].count==1 && row4.children[2].count==1)
                        {
                            row4.calculated_value=Activity.calculate(row4,1)
                            console.log(row4.calculated_value)
                            row4.children[5].children[0].text=Number(row4.calculated_value).toString()
                            // check if integer
                            if(Activity.check_if_not_integer(row4))
                            {
                                dialog.visible=true
                                audioEffects.play("qrc:/gcompris/src/core/resource/sounds/crash.wav")
                                row4.children[5].children[0].text=" "
                            }
                            row5.enabled=true
                            Activity.check_answer(row4,items,1)
                        }
                    }
                    onChildrenChanged: {
                        if(!row4.children[modelData].children[1])
                            dragTarget.count-=1
                        if(row4.children[0].count==0 || row4.children[1].count==0 || row4.children[2].count==0)
                        {
                            row4.children[5].children[0].text=" "
                            row5.enabled=false
                        }
                    }
                }
            }
            Rectangle {
                width: parent.width*0.082
                height: parent.height
                color: "transparent"
                Image {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    source: Activity.url+"equal.svg"
                }
                radius: 20.0
            }
            Rectangle {
                id: result
                width: parent.width*0.082
                height: parent.height
                border.color: "black"
                GCText{
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    fontSize: mediumSize
                    text: " "
                }
                radius: 20.0
            }
        }

        Row{
            id: row5
            spacing: parent.width*0.041
            width: parent.width
            height: parent.height/8
            anchors{
                top: row4.bottom
                topMargin: parent.height/80
                left: parent.left
                leftMargin: parent.height*0.247
            }
            property var calculated_value
            Rectangle {
                id: row4_result
                width: parent.width*0.082
                height: parent.height
                color: result.color
                border.color: "black"
                GCText{
                    id: tile
                    property alias tile: tile
                    property var datavalue: row4.calculated_value
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    fontSize: mediumSize
                    text: result.children[0].text
                }
                radius: 20.0
            }
            Repeater{
                id: row5repeat
                model: 2
                delegate: DropTile {
                    id: dragTarget
                    property int count: 0
                    width: parent.width*0.082
                    height: parent.height
                    type: modelData%2==0 ? "operators" : "operands"
                    onDropped: {
                        if(dragTarget.count==1)
                            row5.children[modelData+1].children[1].parent= row5.children[modelData+1].children[1].reparent
                        else
                            dragTarget.count+=1
                        row4.enabled=false
                        console.log(row5.children[modelData+1].children[1].tile.datavalue)
                        if(row5.children[0].children[0].tile.datavalue && row5.children[1].count==1 && row5.children[2].count==1)
                        {
                            row5.calculated_value=Activity.calculate(row5,0)
                            console.log(row5.calculated_value)
                            row5.children[5].children[0].text=Number(row5.calculated_value).toString()
                            // check if integer
                            if(Activity.check_if_not_integer(row5))
                            {
                                dialog.visible=true
                                audioEffects.play("qrc:/gcompris/src/core/resource/sounds/crash.wav")
                                row5.children[5].children[0].text=" "

                            }
                            row6.enabled=true
                            Activity.check_answer(row5,items,2)
                        }
                    }
                    onChildrenChanged: {
                        if(!row5.children[modelData+1].children[1])
                            dragTarget.count-=1
                        if( row5.children[1].count==0 || row5.children[2].count==0)
                        {
                            row5.children[5].children[0].text=" "
                            row6.enabled=false
                        }
                        if(row5.children[1].count==0 && row5.children[2].count==0)
                        {
                            row4.enabled=true
                        }
                    }
                }
            }
            Rectangle {
                width: parent.width*0.082
                height: parent.height
                color: "transparent"
                Image {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    source: Activity.url+"equal.svg"
                }
                radius: 20.0
            }
            Rectangle {
                id: row5result
                width: parent.width*0.082
                height: parent.height
                border.color: "black"
                GCText{
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    fontSize: mediumSize
                    text: " "
                }
                radius: 20.0
            }
        }

        Row{
            id: row6
            spacing: parent.width*0.041
            width: parent.width
            height: parent.height/8
            anchors{
                top: row5.bottom
                topMargin: parent.height/80
                left: parent.left
                leftMargin: parent.height*0.247
            }
            property var calculated_value
            Rectangle {
                id: row5_result
                width: parent.width*0.082
                height: parent.height
                color: result.color
                border.color: "black"
                GCText{
                    id: tile2
                    property alias tile: tile2
                    property var datavalue: row5.calculated_value
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    fontSize: mediumSize
                    text: row5result.children[0].text
                }
                radius: 20.0
            }
            Repeater{
                id: row6repeat
                model: 2
                delegate: DropTile {
                    id:dragTarget
                    property int count: 0
                    width: parent.width*0.082
                    height: parent.height
                    type: modelData%2==0 ? "operators" : "operands"
                    onDropped: {
                        if(dragTarget.count==1)
                            row6.children[modelData+1].children[1].parent= row6.children[modelData+1].children[1].reparent
                        else
                            dragTarget.count+=1
                        row5.enabled=false
                        console.log(row6.children[modelData+1].children[1].tile.datavalue)
                        if(row6.children[0] && row6.children[1].count==1 && row6.children[2].count==1)
                        {
                            row6.calculated_value=Activity.calculate(row6,0)
                            console.log(row6.calculated_value)
                            row6.children[5].children[0].text=Number(row6.calculated_value).toString()
                            // check if integer
                            if(Activity.check_if_not_integer(row6))
                            {
                                dialog.visible=true
                                audioEffects.play("qrc:/gcompris/src/core/resource/sounds/crash.wav")
                                row6.children[5].children[0].text=" "
                            }
                            Activity.check_answer(row6,items,3)
                        }
                    }
                    onChildrenChanged: {
                        if(!row6.children[modelData+1].children[1])
                            dragTarget.count-=1
                        if(row6.children[1].count==0 || row6.children[2].count==0)
                        {
                            row5.enabled=true
                        }
                        if(row6.children[0].count==0 || row6.children[1].count==0 || row6.children[2].count==0)
                        {
                            row6.children[5].children[0].text=" "
                        }
                    }
                }
            }
            Rectangle {
                width: parent.width*0.082
                height: parent.height
                color: "transparent"
                Image {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    source: Activity.url+"equal.svg"
                }
                radius: 20.0
            }
            Rectangle {
                id: row6result
                width: parent.width*0.082
                height: parent.height
                border.color: "black"
                GCText{
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    fontSize: mediumSize
                    text: " "
                }
                radius: 20.0
            }
        }
        // next question
        Timer {
            id: timer
            interval: 1500
            repeat: false
            onTriggered: {
                result.children[0].text=" "
                Activity.run()
            }
        }
        // dialog
        Rectangle {
            id: dialog
            width: parent.width*0.49
            height: parent.height/8
            visible: false
            color: "steelblue"
            radius: 30
            anchors.centerIn: parent
            GCText{
                anchors.centerIn: parent
                fontSize: mediumSize
                text: qsTr("result is not an integer")
            }
            onVisibleChanged:SequentialAnimation{
                PropertyAnimation { target: dialog; property: "opacity";from : 1 ; to: 0 ;duration: 3000 }
                PropertyAnimation { target: dialog; property: "visible";to: false }
            }
        }
    }
}
