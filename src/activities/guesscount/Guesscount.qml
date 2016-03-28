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
            property var operators
            property int question_no
            property int total_questions
            property var data
            property int guesscount
            property alias row4:row4
            property alias row5:row5
            property alias row6:row6
            property GCAudio audioEffects: activity.audioEffects
            property var no_of_rows

        }



        onStart: {
            console.log(parent.width)
            Activity.start(items)
        }
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
            source: Activity.url+"background2.jpg"
            width:parent.width
            height:parent.height
        }
        //row 1

        Row {
            id:row1
            spacing: 460
            anchors{
                top:parent.top
                topMargin:30
                left:parent.left
                leftMargin: 34
            }
            Rectangle {
                id:question_no
                width:400;
                height: 100;
                radius: 20.0;
                color: "steelblue"
                GCText{
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    fontSize: mediumSize
                    text: qsTr("%1/%2").arg(items.question_no).arg(items.total_questions)
                }
            }
            Rectangle{
                width:350;
                height:100;
                radius:20;
                color:"orange"
                GCText{
                    id:guess
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    fontSize: mediumSize
                    text: qsTr("Guesscount : %1").arg(items.guesscount)
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
                    color: "#F70D1A"
                    GCText{
                        anchors.horizontalCenter: parent.horizontalCenter
                        fontSize: largeSize
                        text: qsTr("Operators")
                    }
                }
            }
            Repeater {
                model: items.operators
                Rectangle{
                    id:root
                    width:100
                    height:100
                    color: "#F70D1A"
                    MouseArea{
                        id:mousearea
                        anchors.fill:parent
                        //width: 100
                        //height: 100
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
                                AnchorChanges { target: rec; anchors.verticalCenter: root.anchors.verticalCenter; anchors.horizontalCenter: root.anchors.horizontalCenter }
                            }
                        }
                    }
                }
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
                    color: "#52D017"
                    GCText{
                        anchors.horizontalCenter: parent.horizontalCenter
                        fontSize: largeSize
                        text: qsTr("Numbers")
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
                        //anchors.fill:rec2
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
                            color:"#52D017"
                            property var datavalue: modelData
                            Drag.active: mousearea.drag.active
                            Drag.keys: [ "number" ]
                            Drag.hotSpot.x: 50
                            Drag.hotSpot.y: 50
                            GCText{
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.verticalCenter: parent.verticalCenter
                                text:Number(modelData).toString()
                                fontSize: mediumSize
                            }

                            radius: 20.0
                            states: State {
                                when: mousearea.drag.active
                                ParentChange { target: rec2; parent: root2 }
                                AnchorChanges { target: rec2; anchors.verticalCenter: root2.anchors.verticalCenter; anchors.horizontalCenter: root2.anchors.horizontalCenter }
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
            property bool locked
            property var calculated_value
            Repeater{
                id:repeat
                model:3
                DropArea {
                    id: dragTarget
                    width: 100
                    height: 100
                    property bool present
                    property var mousearea: dragTarget.children[1]




                    onDropped: {
                        dragTarget.present=Qt.binding(function() { return true })
                        dragTarget.keys="not_allowed"

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
                                row4.calculated_value=row4.children[0].children[1].obj.datavalue+row4.children[2].children[1].obj.datavalue
                                break;
                            case "-":
                                console.log(row4.children[0].children[1].obj.datavalue-row4.children[2].children[1].obj.datavalue);
                                row4.calculated_value=row4.children[0].children[1].obj.datavalue-row4.children[2].children[1].obj.datavalue
                                break;
                            case "/":
                                console.log(row4.children[0].children[1].obj.datavalue/row4.children[2].children[1].obj.datavalue);
                                row4.calculated_value=row4.children[0].children[1].obj.datavalue/row4.children[2].children[1].obj.datavalue
                                break;
                            default:
                                console.log(row4.children[0].children[1].obj.datavalue*row4.children[2].children[1].obj.datavalue);
                                row4.calculated_value=row4.children[0].children[1].obj.datavalue*row4.children[2].children[1].obj.datavalue


                            }
                            row4.children[5].children[0].text=Number(row4.calculated_value).toString()
                            if(Math.round(row4.calculated_value) == row4.calculated_value)
                            {
                                console.log("integer")
                            }
                            else

                            {
                                // not an integer
                                console.log(row4.calculated_value)
                                audioEffects.play("qrc:/gcompris/src/core/resource/sounds/crash.wav")
                                row4.children[5].children[0].text=" "
                            }

                            row5.enabled=true

                            if(row4.calculated_value==items.guesscount)
                            {

                                row4.children[5].children[0].text=Number(row4.calculated_value).toString()
                                if(items.question_no==3 && items.no_of_rows==1)
                                {

                                    items.bonus.good("smiley")

                                }
                                if(items.question_no<3 && !Activity.visibility(2))
                                {
                                    audioEffects.play("qrc:/gcompris/src/core/resource/sounds/win.wav")
                                    timer.start();
                                }



                            }
                            else if(items.no_of_rows==1)
                            {
                                audioEffects.play("qrc:/gcompris/src/core/resource/sounds/crash.wav")
                            }

                        }






                    }
                    onExited: {
                        //console.log("deleted")
                        dragTarget.present=Qt.binding(function() { return false })
                        dragTarget.keys=Activity.decidekeys(index,1)
                        result.children[0].text=" "
                        if(row4.children[0].present==false || row4.children[1].present==false || row4.children[2].present==false)
                        {
                            row5.enabled=false
                        }





                    }
                    onChildrenChanged: {
                        if(dragTarget.present==true)
                        {
                            //console.log("deleted")
                            dragTarget.present=Qt.binding(function() { return false })
                            dragTarget.keys=Activity.decidekeys(index,1)
                            result.children[0].text=" "
                            if(row4.children[0].present==false || row4.children[1].present==false || row4.children[2].present==false)
                            {
                                row5.enabled=false
                            }

                        }
                    }






                    Rectangle {
                        id:dropRectangle
                        width:100
                        height: 100
                        color:"transparent"
                        border.color: index==1 ? "#F70D1A" : "#52D017"
                        border.width: 5
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
                                    border.color:"white"
                                }

                            }
                        ]
                        Component.onCompleted: {
                            dragTarget.keys = Activity.decidekeys(index,1)
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
                border.color: "black"
                GCText{
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    fontSize: mediumSize
                    text:" "
                }

                radius: 20.0
            }

        }

        //row 5
        Row{
            id:row5
            spacing: 50
            visible:true
            anchors{
                top:row4.bottom
                topMargin:10
                left:parent.left
                leftMargin: 300
            }
            property var calculated_value
            Rectangle {
                id:row4_result
                width:100
                height: 100
                color:result.color
                border.color: "black"
                GCText{
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    fontSize: mediumSize
                    text:result.children[0].text
                }

                radius: 20.0
            }
            Repeater{
                id:row5repeat
                model:2
                DropArea {
                    id: row5dragTarget
                    width: 100
                    height: 100
                    property bool present
                    property var mousearea: row5dragTarget.children[1]

                    onDropped: {
                        row5dragTarget.present=Qt.binding(function() { return true })
                        row5dragTarget.keys="not_allowed"
                        if(index==1)
                        {
                            var p=row5dragTarget.children[1]
                            console.log(p.obj.datavalue)
                            row4.enabled=false
                        }
                        else
                        {
                            var p=row5dragTarget.children[1]
                            console.log(p.obj.operation)
                            row4.enabled=false

                        }
                        var m=row5.children[0]

                        if(row5.children[1].present && row5.children[2].present)
                        {
                            switch (row5.children[1].children[1].obj.operation) {
                            case "+":
                                console.log(row4.calculated_value+row5.children[2].children[1].obj.datavalue);
                                row5.calculated_value=row4.calculated_value+row5.children[2].children[1].obj.datavalue
                                break;
                            case "-":
                                console.log(row4.calculated_value-row5.children[2].children[1].obj.datavalue);
                                row5.calculated_value=row4.calculated_value-row5.children[2].children[1].obj.datavalue
                                break;
                            case "/":
                                console.log(row4.calculated_value/row5.children[2].children[1].obj.datavalue);
                                row5.calculated_value=row4.calculated_value/row5.children[2].children[1].obj.datavalue
                                break;
                            default:
                                console.log(row4.calculated_value*row5.children[2].children[1].obj.datavalue);
                                row5.calculated_value=row4.calculated_value*row5.children[2].children[1].obj.datavalue

                            }
                            row5.children[5].children[0].text=Number(row5.calculated_value).toString()
                            if(Math.round(row5.calculated_value) == row5.calculated_value)
                            {
                                console.log("integer")
                            }
                            else

                            {
                                // not an integer
                                console.log(row5.calculated_value)
                                audioEffects.play("qrc:/gcompris/src/core/resource/sounds/crash.wav")
                                row5.children[5].children[0].text=" "
                            }
                            row6.enabled=true
                            if(row5.calculated_value==items.guesscount)
                            {
                                row5.children[5].children[0].text=Number(row5.calculated_value).toString()
                                if(items.question_no==3 && items.no_of_rows==2)
                                {

                                    items.bonus.good("smiley")
                                }
                                if(items.question_no<3)
                                {
                                    audioEffects.play("qrc:/gcompris/src/core/resource/sounds/win.wav")
                                    timer.start();
                                }

                            }
                            else if(items.no_of_rows==2)
                            {
                                audioEffects.play("qrc:/gcompris/src/core/resource/sounds/crash.wav")
                            }


                        }






                    }
                    onExited: {
                        //console.log("deleted")
                        row5dragTarget.present=Qt.binding(function() { return false })
                        row5dragTarget.keys=Activity.decidekeys(index,2)
                        if(row5.children[1].present==false && row5.children[2].present==false)
                        {
                            row4.enabled=true

                        }
                        if(row5.children[1].present==false || row5.children[2].present==false)
                        {

                            row5result.children[0].text=" "
                        }
                        if(row5.children[1].present==false || row5.children[2].present==false)
                        {
                            row6.enabled=false

                        }



                    }
                    onChildrenChanged: {
                        if(row5dragTarget.present==true)
                        {
                            //console.log("deleted")
                            row5dragTarget.present=Qt.binding(function() { return false })
                            row5dragTarget.keys=Activity.decidekeys(index,2)
                            if(row5.children[1].present==false && row5.children[2].present==false)
                            {
                                row4.enabled=true
                            }
                            if(row5.children[1].present==false || row5.children[2].present==false)
                            {
                                row5result.children[0].text=" "
                            }
                            if(row5.children[1].present==false || row5.children[2].present==false)
                            {
                                row6.enabled=false

                            }
                        }
                    }






                    Rectangle {
                        id:row5dropRectangle
                        width:100
                        height: 100
                        color:"transparent"
                        border.color: index==0 ? "#F70D1A" : "#52D017"
                        border.width: 5
                        anchors.fill: parent
                        GCText{
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            fontSize: mediumSize
                        }

                        radius: 20.0

                        states: [
                            State {
                                when: row5dragTarget.containsDrag
                                PropertyChanges {
                                    target: row5dropRectangle
                                    border.color:"white"
                                }

                            }
                        ]
                        Component.onCompleted: {
                            row5dragTarget.keys = Activity.decidekeys(index,2)
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
                id:row5result
                width:100
                height: 100
                border.color: "black"
                GCText{
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    fontSize: mediumSize
                    text:" "
                }

                radius: 20.0
            }

        }

        //row 6
        Row{
            id:row6
            spacing: 50
            visible:true
            anchors{
                top:row5.bottom
                topMargin:10
                left:parent.left
                leftMargin: 300
            }
            property var calculated_value
            Rectangle {
                id:row5_result
                width:100
                height: 100
                color: row5result.color
                border.color: "black"
                GCText{
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    fontSize: mediumSize
                    text:row5result.children[0].text
                }

                radius: 20.0
            }
            Repeater{
                id:row6repeat
                model:2
                DropArea {
                    id: row6dragTarget
                    width: 100
                    height: 100
                    property bool present
                    property var mousearea: row6dragTarget.children[1]




                    onDropped: {
                        row6dragTarget.present=Qt.binding(function() { return true })
                        row6dragTarget.keys="not_allowed"
                        if(index==1)
                        {
                            var p=row6dragTarget.children[1]
                            console.log(p.obj.datavalue)
                            row5.enabled=false
                        }
                        else
                        {
                            var p=row6dragTarget.children[1]
                            console.log(p.obj.operation)
                            row5.enabled=false
                        }

                        var m=row6.children[0]

                        if(row6.children[1].present && row6.children[2].present)
                        {
                            switch (row6.children[1].children[1].obj.operation) {
                            case "+":
                                console.log(row5.calculated_value+row6.children[2].children[1].obj.datavalue);
                                row6.calculated_value=row5.calculated_value+row6.children[2].children[1].obj.datavalue
                                break;
                            case "-":
                                console.log(row5.calculated_value-row6.children[2].children[1].obj.datavalue);
                                row6.calculated_value=row5.calculated_value-row6.children[2].children[1].obj.datavalue
                                break;
                            case "/":
                                console.log(row5.calculated_value/row6.children[2].children[1].obj.datavalue);
                                row6.calculated_value=row5.calculated_value/row6.children[2].children[1].obj.datavalue
                                break;
                            default:
                                console.log(row5.calculated_value*row6.children[2].children[1].obj.datavalue);
                                row6.calculated_value=row5.calculated_value*row6.children[2].children[1].obj.datavalue;


                            }
                            row6.children[5].children[0].text=Number(row6.calculated_value).toString()
                            if(Math.round(row6.calculated_value) == row6.calculated_value)
                            {
                                console.log("integer")
                            }
                            else

                            {
                                // not an integer
                                console.log(row6.calculated_value)
                                audioEffects.play("qrc:/gcompris/src/core/resource/sounds/crash.wav")
                                row6.children[5].children[0].text=" "
                            }

                            if(row6.calculated_value==items.guesscount)
                            {
                                row6.children[5].children[0].text=Number(row6.calculated_value).toString()
                                if(items.question_no==3 && items.no_of_rows==3)
                                {

                                    items.bonus.good("smiley")
                                }
                                if(items.question_no<3)
                                {
                                    audioEffects.play("qrc:/gcompris/src/core/resource/sounds/win.wav")
                                    timer.start()
                                }

                            }
                            else if(items.no_of_rows==3)
                            {
                                audioEffects.play("qrc:/gcompris/src/core/resource/sounds/crash.wav")
                            }


                        }




                    }
                    onExited: {
                        //console.log("deleted")
                        row6dragTarget.present=Qt.binding(function() { return false })
                        row6dragTarget.keys=Activity.decidekeys(index,2)
                        if(row6.children[1].present==false && row6.children[2].present==false)
                        {
                            row5.enabled=true
                        }
                        if(row6.children[1].present==false || row6.children[2].present==false)
                        {
                            row6result.children[0].text=" "
                        }


                    }
                    onChildrenChanged: {
                        if(row6dragTarget.present==true)
                        {
                            //console.log("deleted")
                            row6dragTarget.present=Qt.binding(function() { return false })
                            row6dragTarget.keys=Activity.decidekeys(index,2)
                            if(row6.children[1].present==false && row6.children[2].present==false)
                            {
                                row5.enabled=true
                            }
                            if(row6.children[1].present==false || row6.children[2].present==false)
                            {
                                row6result.children[0].text=" "
                            }

                        }
                    }






                    Rectangle {
                        id:row6dropRectangle
                        width:100
                        height: 100
                        color:"transparent"
                        border.color: index==0 ? "#F70D1A" : "#52D017"
                        border.width: 5
                        anchors.fill: parent
                        GCText{
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            fontSize: mediumSize
                        }

                        radius: 20.0

                        states: [
                            State {
                                when: row6dragTarget.containsDrag
                                PropertyChanges {
                                    target: row6dropRectangle
                                    border.color:"white"
                                }

                            }
                        ]
                        Component.onCompleted: {
                            row6dragTarget.keys = Activity.decidekeys(index,2)
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
                id:row6result
                width:100
                height: 100
                border.color: "black"
                GCText{
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    fontSize: mediumSize
                    text:" "
                }

                radius: 20.0
            }

        }



        Timer {
            id:timer
            interval: 1500
            repeat: false
            onTriggered:{
                result.children[0].text=" "
                Activity.run()
            }

        }
    }


}
