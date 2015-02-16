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
    color: "#ff55afad"

    property color goodColor: colorMode ?  "#ffc1ffb4" : "#FFF"
    property color badColor: colorMode ?  "#FFF" : "#FFF"
    property bool colorMode: true
    property Item bonus

    Component {
        id: listElement

        Rectangle {
            id: listRect
            color: placed ? goodColor : badColor
            border.width: list.currentIndex == index ? 5 : 1
            border.color: "#ff525c5c"
            radius: 3
            width: list.width
            height: Math.max(textinfo.height * 1.3, 50 * ApplicationInfo.ratio)

            property int index: model.index
            property bool placed: number == index + 1

            Text {
                id: textinfo
                text: model.text
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                width: parent.width * 0.94
                wrapMode: Text.WordWrap
                font.pixelSize: Math.max(parent.width * 0.023, 12)
            }

            MouseArea {
                id: dragArea
                anchors.fill: parent
                onPressed: {
                    if(list.currentIndex == index) {
                        list.currentIndex = -1
                    } else if(list.currentIndex == -1) {
                        list.currentIndex = index
                    } else {
                        containerModel.move(list.currentIndex, index, 1)
                        list.currentIndex = -1
                    }
                }
            }
        }
    }

    Column {
        spacing: 10
        anchors {
            top: parent.top
            topMargin: 10
            left: list.right
            leftMargin: 10
        }
        width: parent.width * 0.2


        Rectangle {
            width: parent.width
            height: heading.height + 2
            color: "#cceaeaea"

            GCText {
                id:heading
                text: qsTr("Arrange the events in the order in which they happened. " +
                           "Select the line to move then touch it's target position")
                width: parent.width - 4
                wrapMode: Text.WordWrap
                fontSize: smallSize
            }
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

        onCurrentIndexChanged: {
            var win = true
            for(var i = 0; i < count; i++) {
                if(!list.contentItem.children[i].placed)
                    win = false
            }
            if(win)
                bonus.good("tux")
        }
        displaced: Transition {
            NumberAnimation { properties: "y"; duration: 500 }
        }
        move: Transition {
            NumberAnimation { properties: "y"; duration: 500 }
        }
        Component.onCompleted: currentIndex = -1
    }

}
