/* GCompris - List.qml
 *
 * Copyright (C) 2014 <Arkit Vora>
 *
 * Authors:
 *   <Srishti Sethi> (GTK+ version)
 *   Arkit Vora <arkitvora123@gmail.com> (Qt Quick port)
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
import QtQuick.Layouts 1.1
import GCompris 1.0

import "../../core"
import "louis-braille.js" as Activity

Rectangle {
    id: wholeBody
    width: parent.width
    height: parent.height
    color: "#ABCDEF"

    Component {
        id: listElement

        Rectangle {
            id: listRect
            border.color: { "black"
                textinfo.text = text
                if(ok_area.pressed === true){
                    if(number == index + 1){
                        listRect.color = "#398414"
                    }
                    else{
                        listRect.color = "#E13B3B"
                    }
                }
                if(clear_area.pressed === true){
                    listRect.color = "#FFFFFF"
                }
            }

            anchors.leftMargin: 20 * ApplicationInfo.ratio
            border.width: 3 * ApplicationInfo.ratio
            radius: 10 * ApplicationInfo.ratio
            width: wholeBody.width * 0.7
            height: textinfo.height * 1.3

            Text {
                id: textinfo
                text: ""
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                width: parent.width * 0.94
                wrapMode: Text.WordWrap
                font.pixelSize: Math.max(parent.width * 0.023, 12)
            }

            MouseArea {
                id: dragArea
                anchors.fill: parent
                property int positionStarted: 0
                property int positionEnded: 0
                property int positionsMoved: Math.floor((positionEnded - positionStarted)/(listRect.height + list.spacing))
                property int newPosition: index + positionsMoved
                property bool held: false
                drag.axis: Drag.YAxis
                onPressAndHold: {

                    listRect.z = 2,
                            positionStarted = listRect.y,
                            dragArea.drag.target = listRect,
                            listRect.opacity = 0.5,
                            list.interactive = false,
                            held = true
                    drag.maximumY = (wholeBody.height - textinfo.height - 1 + list.contentY),
                            drag.minimumY = 0
                }
                onPositionChanged: {
                    positionEnded = listRect.y

                }
                onReleased: {
                    if (Math.abs(positionsMoved) < 1 && held == true) {
                        listRect.y = positionStarted,
                                listRect.opacity = 1,
                                list.interactive = true,
                                dragArea.drag.target = null,
                                held = false
                    } else {
                        if (held == true) {
                            if (newPosition < 1) {
                                listRect.z = 1,
                                        containerModel.move(index,0,1),
                                        listRect.opacity = 1,
                                        list.interactive = true,
                                        dragArea.drag.target = null,
                                        held = false
                            } else if (newPosition > 11 - 1) {
                                listRect.z = 1,
                                        containerModel.move(index,11 - 1,1),
                                        listRect.opacity = 1,
                                        list.interactive = true,
                                        dragArea.drag.target = null,
                                        held = false
                            }
                            else {
                                listRect.z = 1,
                                        containerModel.move(index,newPosition,1),
                                        listRect.opacity = 1,
                                        list.interactive = true,
                                        dragArea.drag.target = null,
                                        held = false

                            }
                        }
                    }
                }
            }

        }
    }

    Rectangle {
        id: heading_rect
        anchors.right: parent.right
        anchors.rightMargin: 20 * ApplicationInfo.ratio
        anchors.topMargin: 40 * ApplicationInfo.ratio
        radius: 20 * ApplicationInfo.ratio
        height: heading.height + instructions.height
        color: "yellow"
        width: wholeBody.width * 0.20

        Text {
            id:heading
            text: "Arrange the events in the order in which they happened"
            anchors.centerIn: heading_rect
            width: heading_rect.width * 0.9
            wrapMode: Text.WordWrap
            font.pixelSize: Math.max(heading_rect.width * 0.05, 12)

        }

        Text {
            id:instructions
            text: "Press and hold the event to select it."
            anchors.top: heading_rect.bottom
            anchors.topMargin: 10 * ApplicationInfo.ratio
            width: heading_rect.width * 0.9
            wrapMode: Text.WordWrap
            font.pixelSize: Math.max(heading_rect.width * 0.04, 10)

        }

    }

    ListView {
        id: list
        anchors.fill: parent
        anchors.leftMargin: 30 * ApplicationInfo.ratio
        anchors.topMargin: 30 * ApplicationInfo.ratio
        model: containerModel
        spacing: 5 * ApplicationInfo.ratio
        delegate: listElement
        interactive: true

    }

    Image {
        id: ok
        anchors.top: heading_rect.bottom
        anchors.horizontalCenter: heading_rect.horizontalCenter
        anchors.topMargin: 30 * ApplicationInfo.ratio
        source: "qrc:/gcompris/src/core/resource/bar_ok.svgz"
        Behavior on scale { PropertyAnimation { duration: 100} }
        MouseArea {
            id: ok_area
            anchors.fill: parent
            hoverEnabled: true
            onEntered: ok.scale = 1.1
            onExited: ok.scale = 1
        }
    }

    Text {
        id: confirmtext
        text: "Confirm"
        anchors.top: ok.bottom
        anchors.topMargin: 20 * ApplicationInfo.ratio
        anchors.horizontalCenter: ok.horizontalCenter
        font.pixelSize: Math.max(heading_rect.width * 0.05, 12)
    }

    Text {
        text: "Clear"
        anchors.top: clear.bottom
        anchors.horizontalCenter: clear.horizontalCenter
        font.pixelSize: Math.max(heading_rect.width * 0.05, 12)
    }

    Image {
        id: clear
        anchors.top: confirmtext.bottom
        anchors.horizontalCenter: heading_rect.horizontalCenter
        source: "qrc:/gcompris/src/core/resource/cancel.svgz"
        scale: 0.5 * ApplicationInfo.ratio
        Behavior on scale { PropertyAnimation { duration: 100} }
        MouseArea {
            id: clear_area
            anchors.fill: parent
            hoverEnabled: true
            onEntered: clear.scale = 0.6
            onExited: clear.scale = 0.5
        }
    }
}
