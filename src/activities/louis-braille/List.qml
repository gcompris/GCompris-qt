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
import QtQuick.Controls 1.1
import GCompris 1.0

import "../../core"
import "louis-braille.js" as Activity

Rectangle {
    id: wholeBody
    width: parent.width
    height: parent.height
    color: "#ABCDEF"

    property color goodColor: colorMode ?  "#398414" : "#FFF"
    property color badColor: colorMode ?  "#E13B3B" : "#FFF"
    property bool colorMode: false

    Component {
        id: listElement

        Rectangle {
            id: listRect
            border.color: "black"
            color: (colorMode && number == index + 1) ? goodColor : badColor
            border.width: list.currentIndex == index ? 3 : 1
            radius: 5
            width: list.width
            height: textinfo.height * 1.3

            property int index: model.index

            Text {
                id: textinfo
                text: model.text + " " + index
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                width: parent.width * 0.94
                wrapMode: Text.WordWrap
                font.pixelSize: Math.max(parent.width * 0.023, 12)
            }

            MouseArea {
                id: dragArea
                anchors.fill: parent
                property bool held: false
                drag.axis: Drag.YAxis
                onPressed: list.currentIndex = index
                onPressAndHold: {
                    listRect.z = 2
                    dragArea.drag.target = listRect
                    list.interactive = false
                    held = true
                    drag.maximumY = list.contentItem.height
                    drag.minimumY = -10
                }
                onPositionChanged: {
                    var underItem = list.contentItem.childAt(listRect.x + 1, listRect.y - 1)
                    if(underItem) {
                        console.log("move", underItem, underItem.index, listRect.index)
//                        containerModel.move(underItem.index, listRect.index, 1)
                    }
                }
                onReleased: {
                    listRect.z = 1
                    list.interactive = true
                    dragArea.drag.target = null
                    held = false
                }
            }
        }
    }

    Column {
        spacing: 10
        anchors {
            top: parent.top
            left: list.right
            leftMargin: 10
        }
        width: parent.width * 0.2

        GCText {
            id:heading
            text: "Arrange the events in the order in which they happened"
            width: parent.width
            wrapMode: Text.WordWrap
            fontSize: smallSize
        }

        Button {
            width: parent.width
            height: 60 * ApplicationInfo.ratio
            text: qsTr("UP")
            style: GCButtonStyle {
            }

            onClicked: {
                containerModel.move(list.currentIndex, list.currentIndex - 1, 1)
                list.currentIndex--
            }
        }

        Button {
            width: parent.width
            height: 60 * ApplicationInfo.ratio
            text: qsTr("DOWN")
            style: GCButtonStyle {
            }

            onClicked: {
                containerModel.move(list.currentIndex, list.currentIndex + 1, 1)
                list.currentIndex++
            }
        }

        Button {
            width: parent.width
            height: 60 * ApplicationInfo.ratio
            text: qsTr("OK")
            style: GCButtonStyle {
            }

            onClicked: wholeBody.colorMode = true
        }

        Button {
            width: parent.width
            height: 60 * ApplicationInfo.ratio
            text: qsTr("CANCEL")
            style: GCButtonStyle {
            }

            onClicked: wholeBody.colorMode = false
        }
    }

    ListView {
        id: list
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.bottomMargin: bar.height
        anchors.leftMargin: 30 * ApplicationInfo.ratio
        anchors.topMargin: 10 * ApplicationInfo.ratio
        width: parent.width * 0.7
        model: containerModel
        spacing: 5 * ApplicationInfo.ratio
        delegate: listElement
        interactive: true
    }

}
