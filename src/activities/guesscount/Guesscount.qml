/* GCompris - guesscount.qml
 *
 * Copyright (C) 2015 YOUR NAME <xx@yy.org>
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
import "guesscount.js" as Activity

ActivityBase {
    id: activity
    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
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
            property var operators: Activity.images
            property var question_no:1
            property int total_questions:Activity.dataset[0]["data"]["questions"]
            property var data: Activity.dataset[0]["data"]["numbers"][items.question_no-1][0]
            property var guesscount:Activity.dataset[0]["data"]["numbers"][items.question_no-1][1]

        }



        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }


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
            source: Activity.url+"tiger1_RS.jpg"
            width:parent.width
            height:parent.height
        }
        //row 1

        Row {
            id:row1
            spacing: 800
            anchors{
                top:parent.top
                topMargin:10
            }
            Rectangle {
                id:question_no
                width:200;
                height: 50;
                radius: 20.0;
                color: "steelblue"
                anchors.margins: 5
                GCText{
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    fontSize: mediumSize
                    text: items.question_no+"/"+items.total_questions
                }
            }
            Rectangle{
                width:guess.width;
                height:50;
                radius:20;
                color:"orange"
                GCText{
                    id:guess
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    fontSize: mediumSize
                    text: "Guesscount : "+items.guesscount
                }
            }
        }
        // row 2
        Row {
            id:row2
            spacing: 50
            width:parent.width
            anchors{
                top:row1.bottom
                topMargin: 30
            }
            Rectangle{
                id:operator
                width:parent.width/2
                height:100
                color:"transparent"
                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width:400;
                    height: 100;
                    radius: 20.0;
                    color: "#024c1c"
                    GCText{
                        anchors.horizontalCenter: parent.horizontalCenter
                        fontSize: largeSize
                        text: "Operators"
                    }
                }
            }
            Repeater {
                model: items.operators
                Item{
                    id:root
                    width:100
                    height:100
                    MouseArea{
                        id:mousearea
                        width: 100
                        height: 100
                        property Rectangle obj: rec
                        drag.target: rec
                        onReleased: {


                            parent = rec.Drag.target !== null ? rec.Drag.target : root

                            //var p=parent.children[1]
                            //console.log(p.obj.operation)
                            rec.Drag.drop()
                        }

                        Rectangle {
                            id:rec
                            width:100
                            height: 100
                            color:"transparent"
                            property var operation:modelData[1]
                            Drag.active: mousearea.drag.active
                            Drag.keys: [ "operator" ]
                            Drag.hotSpot.x: 50
                            Drag.hotSpot.y: 50
                            Image {
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.verticalCenter: parent.verticalCenter
                                source: Activity.url+modelData[0]
                            }

                            radius: 20.0
                            states: State {
                                when: mousearea.drag.active
                                ParentChange { target: rec; parent: root }
                                AnchorChanges { target: rec; anchors.verticalCenter: root; anchors.horizontalCenter: root }
                            }
                        }
                    }}
            }
        }
        // row 3
        Row {
            id:row3
            spacing: 50
            width:parent.width
            anchors{
                top:row2.bottom
                topMargin:10
            }
            Rectangle{
                width:parent.width/2
                height:100
                color:"transparent"
                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width:400;
                    height: 100;
                    radius: 20.0;
                    color: "#024c1c"
                    GCText{
                        anchors.horizontalCenter: parent.horizontalCenter
                        fontSize: largeSize
                        text: "Numbers"
                    }
                }
            }

            Repeater{
                model: items.data
                Item{
                    id:root2
                    width:100
                    height:100
                    MouseArea{
                        id:mousearea
                        width: 100
                        height: 100
                        property Rectangle obj: rec2
                        drag.target: rec2
                        onReleased: {
                            parent = rec2.Drag.target !== null ? rec2.Drag.target : root2
                            rec2.Drag.drop()
                        }

                        Rectangle {
                            id:rec2
                            width:100
                            height: 100
                            color:"green"
                            property int datavalue: modelData
                            Drag.active: mousearea.drag.active
                            Drag.keys: [ "number" ]
                            Drag.hotSpot.x: 50
                            Drag.hotSpot.y: 50
                            GCText{
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.verticalCenter: parent.verticalCenter
                                text: modelData
                                fontSize: mediumSize
                            }

                            radius: 20.0
                            states: State {
                                when: mousearea.drag.active
                                ParentChange { target: rec2; parent: root2 }
                                AnchorChanges { target: rec2; anchors.verticalCenter: root2; anchors.horizontalCenter: root2 }
                            }
                        }
                    }
                }
            }

        }

        // operation row
        Row{
            id:row4
            spacing: 50
            anchors{
                top:row3.bottom
                topMargin:10
                left:parent.left
                leftMargin: 300
            }
            Repeater{
                id:repeat
                model:3
                DropArea {
                    id: dragTarget
                    width: 100
                    height: 100
                    property bool present
                    property var mousearea: dragTarget.children[1]
                    property var calculated_value



                    onDropped: {
                        dragTarget.present=Qt.binding(function() { return true })
                        //dragTarget.visible=Qt.binding(function() { return false })
                        dragTarget.keys="not_allowed"

                        //console.log(dragTarget.present)
                        if(index==1)
                        {
                            var p=dragTarget.children[1]
                            console.log(p.obj.operation)
                        }
                        else
                        {
                            var p=dragTarget.children[1]
                            console.log(p.obj.datavalue)
                        }
                        var m=row4.children[0]

                        if(row4.children[0].present && row4.children[1].present && row4.children[2].present)
                        {
                            switch (row4.children[1].children[1].obj.operation) {
                            case "+":
                                console.log(row4.children[0].children[1].obj.datavalue+row4.children[2].children[1].obj.datavalue);
                                dragTarget.calculated_value=Qt.binding(function() { return row4.children[0].children[1].obj.datavalue+row4.children[2].children[1].obj.datavalue })
                                break;
                            case "-":
                                console.log(row4.children[0].children[1].obj.datavalue-row4.children[2].children[1].obj.datavalue);
                                dragTarget.calculated_value=Qt.binding(function() { return row4.children[0].children[1].obj.datavalue-row4.children[2].children[1].obj.datavalue })
                                break;
                            case "/":
                                console.log(row4.children[0].children[1].obj.datavalue/row4.children[2].children[1].obj.datavalue);
                                dragTarget.calculated_value=Qt.binding(function() { return row4.children[0].children[1].obj.datavalue/row4.children[2].children[1].obj.datavalue })
                                break;
                            default:
                                console.log(row4.children[0].children[1].obj.datavalue*row4.children[2].children[1].obj.datavalue);
                                dragTarget.calculated_value=Qt.binding(function() { return row4.children[0].children[1].obj.datavalue*row4.children[2].children[1].obj.datavalue })

                            }
                            row4.children[5].children[0].text=dragTarget.calculated_value
                            if(dragTarget.calculated_value==items.guesscount)
                            {

                                row4.children[5].children[0].text=dragTarget.calculated_value;
                                if(items.question_no==3){
                                    items.bonus.good("smiley");}
                                if(items.question_no<4)
                                {
                                    timer.start();

                                    //items.question_no= Qt.binding(function() { return items.question_no+1 });
                                }
                                //activity.start.connect(start)


                                //items.operators=Qt.binding(function() { return Activity.images })
                                //row4.children[1].children[1].obj.operation
                            }

                        }




                    }
                    onExited: {
                        //console.log("deleted")
                        dragTarget.present=Qt.binding(function() { return false })
                        dragTarget.keys=Activity.decidekeys(index)


                    }
                    onChildrenChanged: {
                        if(dragTarget.present==true)
                        {//console.log("deleted")
                            dragTarget.present=Qt.binding(function() { return false })
                            dragTarget.keys=Activity.decidekeys(index)
                        }
                    }






                    Rectangle {
                        id:dropRectangle
                        width:100
                        height: 100
                        color:"transparent"
                        border.color: "black"
                        anchors.fill: parent
                        GCText{
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            fontSize: mediumSize
                        }

                        radius: 20.0

                        states: [
                            State {
                                when: dragTarget.containsDrag
                                PropertyChanges {
                                    target: dropRectangle
                                    border.color:"red"
                                }

                            }
                        ]
                        Component.onCompleted: {
                            dragTarget.keys = Activity.decidekeys(index)
                        }



                    }

                }
            }

            Rectangle {
                width:100
                height: 100
                color:"transparent"
                Image {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    source: Activity.url+"equal.svg"
                }
                radius: 20.0
            }
            Rectangle {
                id:result
                width:100
                height: 100
                color:"white"
                border.color: "black"
                GCText{
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    fontSize: mediumSize
                    text:""
                }

                radius: 20.0
            }

        }


            Timer {
                id:timer
                interval: 1500
                repeat: false
                onTriggered: {
                    items.question_no= Qt.binding(function() { return items.question_no+1 })
                    items.operators=Activity.images
                    result.children[0].text=" "
            }

    }
}


}
