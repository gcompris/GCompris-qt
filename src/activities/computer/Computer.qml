/* GCompris - computer.qml
 *
 * Copyright (C) 2015 <atomsagar@gmail.com>
 *
 * Authors:
 *
 *   "Sagar Chand Agarwal" <atomsagar@gmail.com> (Qt Quick)
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
import "computer.js" as Activity
import "computer-data.js" as Dataset
import "qrc:/gcompris/src/core/core.js" as Core


ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Item {
        id: background
        anchors.fill: parent

        PinchArea {
            anchors.fill:parent
            pinch.target: room
            pinch.minimumScale: 1
            pinch.maximumScale: 3
        }

        MouseArea {
            id:dragarea
            hoverEnabled:true
            anchors.fill:parent
            drag.target:background
            onWheel:{
                var scaleBefore = background.scale
                background.scale += background.scale * wheel.angleDelta.y / 120 / 10
            }

        }

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
            property int count: 0
            property var dataset: Dataset.dataset
            property GCAudio audioEffects: activity.audioEffects
        }

        onStart: { Activity.start(items,message) }
        onStop: { Activity.stop() }

        Message {
            id: message
            z: 20
            anchors {
                top: parent.top
                topMargin: 10
                right: parent.right
                left: parent.left
                leftMargin: 5
            }
        }


        Image {
            id: room
            source: "resource/background.svg"
            width: parent.width
            height: parent.height
        }

        Rectangle{
            id:switchboard
            radius:10
            color:"yellow"
            height: parent.width*0.05
            width: switchboard.height
            anchors {
                bottom: table.top
                right: table.right
                rightMargin: 0.1*parent.width
                bottomMargin: 0.1*parent.height
            }

            Image {
                id: poweron
                source: "resource/poweron.svg"
                anchors.fill: switchboard
                visible: false
            }

            Image {
                id: poweroff
                source: "resource/poweroff.svg"
                anchors.fill: switchboard
                visible: true
                MouseArea
                {
                    anchors.fill: poweroff
                    onClicked: poweroff.visible=false,
                               poweron.visible=true
                }

            }
        }

        Image {
            id: table
            source: "resource/table.svg"
            sourceSize.height: parent.height/2
            sourceSize.width: parent.width/2
            scale: 1
            anchors {
                left: parent.left
                leftMargin: parent.width*0.1*ApplicationInfo.ratio
                bottom: parent.bottom
                bottomMargin: 0.3*parent.height*ApplicationInfo.ratio
            }

            Image {
                id:monitor
                source:"resource/images/monitor.svg"
                sourceSize.height: parent.height/2
                sourceSize.width :parent.width/2
                opacity:0.1
                anchors {
                    bottom: table.bottom
                    left: table.left
                    leftMargin: table.width *0.2
                    bottomMargin: table.height*0.9

                }
                Image {
                    id: cursor
                    source: "resource/cursor.svg"
                    height: monitor.height*0.2
                    width: monitor.width*0.2
                    visible: true
                }

                Flickable {
                    id: flick
                    width:monitor.width*0.65
                    height:monitor.height*0.8
                    contentWidth: edit.paintedWidth
                    contentHeight: edit.paintedHeight
                    clip: true
                    anchors {
                        left:monitor.left
                        leftMargin:monitor.width*0.1
                        top:monitor.top
                        topMargin:monitor.height*0.1
                    }

                    function ensureVisible(r)
                    {
                        if (contentX >= r.x)
                            contentX = r.x;
                        else if (contentX+width <= r.x+r.width)
                            contentX = r.x+r.width-width;
                        if (contentY >= r.y)
                            contentY = r.y;
                        else if (contentY+height <= r.y+r.height)
                            contentY = r.y+r.height-height;
                    }

                    TextEdit {
                        id: edit
                        color:"white"
                        width: flick.width
                        height: flick.height
                        focus: true
                        wrapMode: TextEdit.Wrap
                        onCursorRectangleChanged: flick.ensureVisible(cursorRectangle)
                    }
                }

                MouseArea{
                    anchors.fill: monitor
                    onEntered:
                    {
                        cursor.visible=true
                    }
                    onPressed:{
                        cursor.x= mouseX
                        cursor.y= mouseY
                    }
                    onExited: {cursor.visible=false}
                }
                visible: true

            }
            Image {
                id:cpu
                source:"resource/images/cpu.svg"
                sourceSize.height: parent.height*0.60
                sourceSize.width :parent.width/2

                anchors {
                    bottom: table.bottom
                    left: monitor.right
                    leftMargin: table.width *0.1
                    bottomMargin: table.height*0.8

                }
                visible: true
                opacity: 0.1
            }
            Image {
                id:keyboard
                source:"resource/images/keyboard.svg"
                sourceSize.height: parent.height/4
                sourceSize.width : parent.width/3

                anchors {
                    top: monitor.bottom
                    left: table.left
                    leftMargin: table.width *0.3
                }
                visible: true
                opacity: 0.1

            }
            Image {
                id:mouse
                source:"resource/images/mouse.svg"
                sourceSize.height: parent.height/3
                sourceSize.width :parent.width/3

                anchors {
                    bottom: table.bottom
                    left: keyboard.right
                    leftMargin: table.width *0.1
                    bottomMargin :table.height*0.6
                }
                visible: true
                opacity: 0.1
            }



        }


        Image {
            id: boxclosed
            source: "resource/closebox.svg"
            visible: true
            sourceSize.height: parent.width/4
            sourceSize.width: parent.height/4
            anchors {
                right :parent.right
                rightMargin: parent.width*0.1*ApplicationInfo.ratio
                bottom: parent.bottom
                bottomMargin: parent.height*0.1*ApplicationInfo.ratio
            }
            MouseArea {
                anchors.fill :boxclosed
                onClicked: {
                    boxclosed.visible=false,
                            boxopened.visible=true,
                            showpart()
                }
            }
        }


        Image {
            id: boxopened
            source: "resource/openbox.svg"
            sourceSize.height: boxclosed.height
            sourceSize.width: boxclosed.width
            anchors {
                right: parent.right
                rightMargin: parent.width*0.1*ApplicationInfo.ratio
                bottom: parent.bottom
                bottomMargin: parent.height*0.1*ApplicationInfo.ratio

            }
            visible: false
        }

        function showpart() {
            if(boxopened.visible=true)
            {
                previous.visible=true
                next.visible= true
                info_rect.visible=true
                img.visible=true
                name_rect.visible=true

            }
        }


        Keys.onRightPressed: background.next()
        Keys.onLeftPressed: background.previous()

        function previous() {
            if(items.count == 0)
                items.count = items.dataset.length - 1
            else
                items.count--
        }

        function next() {
            if(items.count == items.dataset.length - 1) {
                items.count = 0
            } else {
                items.count++
            }
        }


        Image {
            id: previous
            anchors.right: boxopened.left
            anchors.rightMargin: 10 * ApplicationInfo.ratio
            anchors.verticalCenter: boxopened.verticalCenter
            source: "qrc:/gcompris/src/core/resource/bar_previous.svg"
            sourceSize.height: 40 * ApplicationInfo.ratio
            Behavior on scale { PropertyAnimation { duration: 100} }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: previous.scale = 1.1
                onExited: previous.scale = 1
                onClicked: background.previous()
            }
            visible: false
        }

        Rectangle {
            id: info_rect
            visible: false
            border.color: "blue"
            border.width: 2 * ApplicationInfo.ratio
            radius: 8*ApplicationInfo.ratio
            color: "red"
            height: parent.height*1.1
            width: parent.width*1.1
            anchors.top :table.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.leftMargin: 0.1*parent.width*ApplicationInfo.ratio
            anchors.right: boxopened.left
            anchors.rightMargin: 50*ApplicationInfo.ratio

            GCText {
                id:info
                color: "yellow"
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                width: info_rect.width*0.9
                wrapMode: Text.WordWrap
                fontSize: regularSize
                text: items.dataset[items.count].text
            }
        }

        Image {
            id: img
            visible: false
            anchors.bottom: boxclosed.top
            anchors.bottomMargin: 40 * ApplicationInfo.ratio
            anchors.right : parent.right
            anchors.rightMargin: parent.width*0.1*ApplicationInfo.ratio
            sourceSize.height: boxopened*0.5*ApplicationInfo.ratio
            sourceSize.width: boxopened*0.5*ApplicationInfo.ratio
            source: items.dataset[items.count].img
            fillMode: Image.PreserveAspectFit

            property bool mouseEnabled : true

            MouseArea{
                anchors.fill: img
                onClicked: {showImage()}
            }

            //            MouseArea {
            //                id: drag
            //                enabled:parent.mouseEnabled
            //                drag.target: img
            //                drag.axis: Drag.XandYAxis
            //                hoverEnabled: true
            //                anchors.fill: parent
            //                onPressed: {
            //                    img.anchors.right=undefined
            //                    img.anchors.bottom=undefined
            //                }

            //                onReleased: {
            //                    drop()
            //                }

            //            }
        }

        function showImage(){
            if(items.dataset[items.count].id=="monitor")
            {
                monitor.opacity=1
            }
            else
                if(items.dataset[items.count].id=="cpu")
                {
                    cpu.opacity=1
                }
                else
                    if(items.dataset[items.count].id=="keyboard")
                    {
                        keyboard.opacity=1
                    }
                    else
                        if(items.dataset[items.count].id=="mouse")
                        {
                            mouse.opacity=1
                        }
            return 0
        }


        Rectangle {
            id: name_rect
            visible: false
            border.color: "black"
            border.width: 1
            radius: 2*ApplicationInfo.ratio
            color: "white"
            width: name.width * 1.1
            height: name.height * 1.1
            anchors {
                top: boxopened.bottom
                horizontalCenter: boxopened.horizontalCenter
                bottomMargin: 0.1*parent.height
            }
            GCText {
                id: name
                color: "black"
                fontSize: regularSize
                anchors.centerIn: name_rect
                text: items.dataset[items.count].name
            }
        }

        Image {
            id: next
            visible: false
            anchors.left: boxopened.right
            anchors.leftMargin: 10 * ApplicationInfo.ratio
            anchors.verticalCenter: boxopened.verticalCenter
            source: "qrc:/gcompris/src/core/resource/bar_next.svg"
            sourceSize.height: 40 * ApplicationInfo.ratio
            Behavior on scale { PropertyAnimation { duration: 100} }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: next.scale = 1.1
                onExited: next.scale = 1
                onClicked: background.next()
            }
        }




        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home}
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onHomeClicked: activity.home()
        }
    }
}

