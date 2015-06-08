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
import "computer-data.js" as Dataset
import "qrc:/gcompris/src/core/core.js" as Core


ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: "resource/background.svg"
        sourceSize.width: parent.width
        sourceSize.height: parent.height


        signal start
        signal stop

        property bool mouseEnabled : true

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
        }

        Rectangle {
            id:switchboard
            radius:10
            height: parent.width*0.05
            width: switchboard.height*1.5
            anchors {
                bottom: table.top
                right: table.right
                rightMargin: 0.1*parent.width
                bottomMargin: 0.05*parent.height
            }

            Image {
                id: poweron
                source: "resource/poweron.svg"
                anchors.fill: switchboard
                visible: false
                MouseArea {
                    anchors.fill:poweron
                    onClicked:
                        poweroff.visible= true,
                        poweron.visible= false
                }
            }

            Image {
                id: poweroff
                source: "resource/poweroff.svg"
                anchors.fill: switchboard
                visible: true
                MouseArea
                {
                    anchors.fill: poweroff
                    onClicked:
                        poweron.visible=true,
                        poweroff.visible= false
                }

            }
        }

        Image {
            id: table
            visible: false
            source: "resource/table.svg"
            sourceSize.height: parent.height
            sourceSize.width: parent.width/2
            anchors {
                left: parent.left
                leftMargin: parent.width*0.1
                bottom: parent.bottom
                bottomMargin: 0.25*parent.height
            }


    }


    Image {
        id: boxclosed
        source: "resource/closebox.svg"
        visible: true
        sourceSize.height: parent.width/4
        sourceSize.width: parent.height/4
        anchors {
            left :table.right
            leftMargin: parent.width*0.1*ApplicationInfo.ratio
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
            left: table.right
            leftMargin: parent.width*0.1*ApplicationInfo.ratio
            bottom: parent.bottom
            bottomMargin: parent.height*0.15*ApplicationInfo.ratio

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
        visible:false
    }

    Rectangle {
        id: info_rect
        border.color: "red"
        border.width: 2 * ApplicationInfo.ratio
        radius: 8*ApplicationInfo.ratio
        color: "gold"
        height: parent.height*0.5
        width: parent.width*0.5
        anchors.top :table.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 0.1*parent.width*ApplicationInfo.ratio
        anchors.right: boxopened.left
        anchors.rightMargin: 50*ApplicationInfo.ratio

        GCText {
            id:info
            color: "black"
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            width: info_rect.width
            height: info_rect.height
            wrapMode: Text.WordWrap
            fontSize: regularSize
            text: items.dataset[items.count].text
        }
        visible: false
    }

    Image {
        id: img
        anchors.bottom: boxclosed.top
        anchors.right : parent.right
        anchors.rightMargin: parent.width*0.15*ApplicationInfo.ratio
        height: boxclosed.height
        width: boxclosed.width
        source: items.dataset[items.count].img
        fillMode: Image.PreserveAspectFit
        visible: false
        MouseArea {
            anchors.fill: img
            id:drag
            drag.target:img
            drag.axis: Drag.XandYAxis
            hoverEnabled: true

            onPressed:img.anchors.right= undefined,
                      img.anchors.bottom= undefined

        }
    }


    Rectangle {
        id: name_rect
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
        visible: false
    }

    Image {
        id: next
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
        visible: false
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

