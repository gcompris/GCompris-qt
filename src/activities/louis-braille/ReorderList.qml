/* GCompris - List.qml
 *
 * Copyright (C) 2014 Arkit Vora <arkitvora123@gmail.com>
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
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
    property int selectedIndex: -1
    property alias containerModel: list.model

    signal up
    signal down
    signal space

    onUp: list.decrementCurrentIndex()
    onDown: list.incrementCurrentIndex()
    onSpace: {
        if(list.currentIndex == selectedIndex) {
            selectedIndex = -1
        } else if(selectedIndex != -1) {
            containerModel.move(selectedIndex, list.currentIndex, 1)
            list.currentIndex -= 1
            selectedIndex = -1
        } else {
            selectedIndex = list.currentIndex
        }
    }

    function checkWin() {
        var win = true
        // The shifted numbering comes from the header in the List
        for(var i = 1; i < list.count + 1; i++) {
            if(!list.contentItem.children[i] ||
                list.contentItem.children[i].placed === false)
                win = false
        }
        if(win) {
            list.currentIndex = -1
            bonus.good("tux")
        }
    }

    Component {
        id: listElement

        Rectangle {
            id: listRect
            color: wholeBody.selectedIndex == index ? "#b5b9ff" : (placed ? goodColor : badColor)
            border.width: list.currentIndex == index ? 0 : 1
            border.color: "#ff525c5c"
            radius: 3
            width: list.width
            height: Math.max(textinfo.height * 1.3, 50 * ApplicationInfo.ratio)

            property int sequence: model.sequence
            property bool placed: model.sequence === index
            property string text: model.text

            SequentialAnimation {
                id: borderAnim
                running: list.currentIndex == index
                loops: Animation.Infinite
                NumberAnimation {
                    target: listRect
                    property: "border.width"
                    to: 5; duration: 500
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    target: listRect
                    property: "border.width"
                    to: 0; duration: 500
                    easing.type: Easing.InOutQuad
                }
            }

            GCText {
                id: textinfo
                text: listRect.text
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                width: parent.width * 0.94
                wrapMode: Text.WordWrap
                fontSize: regularSize
            }

            MouseArea {
                id: dragArea
                anchors.fill: parent
                onClicked: {
                    wholeBody.selectedIndex = -1
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

            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }

        }
    }

    ListModel {
        id: containerModel
    }

    ListView {
        id: list
        anchors {
            fill: parent
            bottomMargin: bar.height
            leftMargin: 30 * ApplicationInfo.ratio
            rightMargin: 30 * ApplicationInfo.ratio
            topMargin: 10 * ApplicationInfo.ratio
        }
        width: parent.width * 0.7
        model: containerModel
        spacing: 5 * ApplicationInfo.ratio
        delegate: listElement
        interactive: true

        header: Rectangle {
            width: parent.width
            height: heading.height + 10
            color: "#cceaeaea"
            GCText {
                id: heading
                text: qsTr("Arrange the events in the order in which they happened. " +
                           "Select the line to move, then touch its target position.")
                width: parent.width - 4
                wrapMode: Text.WordWrap
                fontSize: regularSize
            }
        }
        onCurrentIndexChanged: timer.restart()
        displaced: Transition {
            NumberAnimation { properties: "y"; duration: 500 }
        }
        move: Transition {
            NumberAnimation { properties: "y"; duration: 500 }
        }
        Component.onCompleted: currentIndex = -1
    }

    Timer {
        id: timer
        interval: 1000
        running: false
        repeat: false
        onTriggered: wholeBody.checkWin()
    }
}
