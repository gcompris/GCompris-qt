/* GCompris - level1.qml
 *
 * Copyright (C) 2015 Sagar Chand Agarwal <atomsagar@gmail.com>
 *
 * Authors:
 *   Sagar Chand Agarwal <atomsagar@gmail.com> (Qt Quick)
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
import "../../computer.js" as Activity
import "../../../../core"

Item {

    property bool power: false

    Rectangle {
        id: help_textbg
        x: help_text.x - 4
        y: help_text.y - 4
        width: help_text.width + 4
        height: help_text.height + 4
        color: "#d8ffffff"
        border.color: "#2a2a2a"
        border.width: 2
        radius: 8
    }

    GCText {
        id: help_text
        font.weight: Font.DemiBold
        horizontalAlignment: Text.AlignHCenter
        anchors {
            top: parent.top
            topMargin: 10 * ApplicationInfo.ratio
            right: parent.right
            rightMargin: 5 * ApplicationInfo.ratio
            left: parent.left
            leftMargin: 5 * ApplicationInfo.ratio
        }
        width: parent.width
        wrapMode: Text.WordWrap
        fontSize: smallSize * 0.5
        text: qsTr("Click on the power switch to begin")
    }


    Image {
        id: switchboard
        sourceSize.width: parent.width*0.1
        source: Activity.url + "images/switchoff.svg"
        anchors {
            top: help_textbg.bottom
            left: parent.left
            leftMargin: parent.width*0.2
            bottomMargin: parent.height*0.3
        }
        MouseArea {
            anchors.fill: switchboard
            onClicked: {
                if( switchboard.source == Activity.url + "images/switchoff.svg" )
                {
                    power = true
                    switchboard.source = Activity.url + "images/switchon.svg"
                    cpu_area.visible = true
                    help_text.text = qsTr("Click on the Central Processing unit Power button to start the system ")
                }
                else
                {
                    power = false
                    switchboard.source = Activity.url + "images/switchoff.svg"
                    poweroff()
                    help_text.text = qsTr("You have shut down the power. Press on the switchboard for electricity.")
                }
            }
        }
    }


    Image {
        id: table
        source: Activity.url + "images/table.svg"
        height: parent.height*0.40
        width: parent.width*0.70
        anchors {
            left: parent.left
            leftMargin: parent.width*0.1*ApplicationInfo.ratio
            bottom: parent.bottom
            bottomMargin: 0.1*parent.height*ApplicationInfo.ratio
        }

        Image {
            id: monitor
            source: Activity.url + "images/monitor_off.svg"
            sourceSize.height: parent.height/2
            sourceSize.width :parent.width/2
            anchors {
                bottom: table.bottom
                left: table.left
                leftMargin: table.width*0.2
                bottomMargin: table.height*0.9
            }

            Image {
                id: cursor
                source: Activity.url + "images/cursor.svg"
                height: monitor.height*0.2
                width: monitor.width*0.2
                visible: false
            }

            Image {
                id: wallpaper
                opacity: 0
                source: Activity.url + "images/GCompris.png"
                sourceSize.height: parent.height/2
                sourceSize.width: parent.width/2
                anchors {
                    centerIn: parent
                }
                NumberAnimation on opacity {
                    id: load
                    running: false
                    from: 0
                    to: 1
                    duration: 10000
                    onRunningChanged:  {
                        if(!load.running && cpu.source == Activity.url + "images/cpuoff.svg") {
                            monitor.source= Activity.url + "images/monitor.svg"
                            wallpaper.visible = false
                            help_text.text = qsTr("Click on the Mouse to activate the cursor on the screen. You will see the cursor moves with your actual mouse, when being pressed. ")
                            mouse_area.visible = true
                        }
                    }
                }
                MouseArea {
                    onClicked: {
                        if(cursor.visible == true)
                        {
                            wallpaper.opacity = 0
                        }
                    }
                }
            }

            Flickable {
                id: flick
                visible: false
                width:monitor.width*0.65
                height:monitor.height*0.7
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
                    color:"black"
                    width: flick.width
                    height: flick.height
                    focus: true
                    wrapMode: TextEdit.Wrap
                    onCursorRectangleChanged: flick.ensureVisible(cursorRectangle)
                }
            }
            MouseArea{
                id: monitor_area
                visible: false
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
            source: Activity.url + "images/cpu.svg"
            sourceSize.height: parent.height*0.60
            sourceSize.width :parent.width/2

            anchors {
                bottom: table.bottom
                left: monitor.right
                leftMargin: table.width *0.1
                bottomMargin: table.height*0.8
            }
            visible: true
            Image {
                id: cpu_switch
                source: Activity.url + "images/cpuoff.svg"
                height: parent.height*0.2
                width: cpu_switch.height
                MouseArea {
                    id: cpu_area
                    visible: false
                    anchors.fill: cpu_switch
                    onClicked: {
                        if( cpu_switch.source == Activity.url + "images/cpuoff.svg")
                        {
                            cpu_switch.source = Activity.url + "images/cpuon.svg"
                            help_text.text = qsTr("Great, The monitor is switched on.")
                            load.running = true
                        }
                        else
                        {
                            cpu_switch.source = Activity.url + "images/cpuoff.svg"
                            cpu_reset()
                            help_text.text = qsTr(" You have switched off the Central processing Unit.<br/> Press on the CPU button to power again. ")
                        }
                    }
                }

                anchors {
                    bottom: parent.bottom
                    right: parent.right
                    bottomMargin: parent.height * 0.1
                    leftMargin: parent.widhth * 0.1
                }
            }
        }

        Image {
            id:keyboard
            source: Activity.url + "images/keyboard.svg"
            sourceSize.height: parent.height/4
            sourceSize.width : parent.width/3

            anchors {
                top: monitor.bottom
                left: table.left
                leftMargin: table.width *0.3
            }
            visible: true
            MouseArea {
                id: keyboard_area
                visible: false
                anchors.fill: keyboard
                onClicked: {
                    flick.visible = true
                    edit.text =  qsTr("Enter Text ::>")
                    help_text.text = qsTr("Congrats, you know how to power up a virtual computer. Proceed to Quiz to check knowledge of the parts. ")
                    keyboard_area.visible = false
                    Activity.sublevel()
                }
            }
        }

        Image {
            id: mouse
            source: Activity.url + "images/mouse.svg"
            sourceSize.height: parent.height/3
            sourceSize.width :parent.width/3

            anchors {
                bottom: table.bottom
                left: keyboard.right
                leftMargin: table.width *0.1
                bottomMargin :table.height*0.6
            }
            MouseArea {
                id: mouse_area
                visible: false
                anchors.fill: mouse
                onClicked: {
                    cursor.visible = true
                    monitor_area.visible = true
                    wallpaper.opacity = 1
                    help_text.text = qsTr("Click on the Keyboard to type on the screen. ")
                    keyboard_area.visible = true
                    mouse_area.visible = false
                }
            }
            visible: true
        }
    }

    function poweroff() {
        cpu_switch.source = Activity.url + "images/cpuoff.svg"
        cpu_reset()
    }

    function cpu_reset() {
        wallpaper.opacity = 0
        load.running = false
        monitor.source = Activity.url + "images/monitor_off.svg"
        flick.visible = false
        mouse_area.visible = false
        keyboard_area.visible = false
        cursor.visible = false
        monitor_area.visible = false
    }
}
