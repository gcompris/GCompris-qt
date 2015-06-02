/*GCompris-Qt Information.qml
*
* Copyright (C) 2015 Sagar Chand Agarwal <atomsagar@gmail.com>
*
* Authors:
*
*   Sagar Chand Agarwal <atomsagar@gmail.com> (Qt Quick port)
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
import GCompris 1.0
import "computer-part.js" as Activity

Item{
    id: message
    opacity: displayed ? 1 : 0

    property bool displayed: index == 0 ? false : true

    // The message in the intro array, set to 0 to disable
    property int index: 1

    property variant intro: [
        "",
        qsTr("Computer is a general-purpose device that can be programmed to carry out a set of "
             +"arithmetic or logical operations automatically. Since a sequence of operations "
             +"can be readily changed, the computer can solve more than one kind of problem."),
        qsTr("A general purpose computer has four main components: the arithmetic logic unit (ALU),  "
             +" the control unit, the memory, and the input and output devices (collectively termed I/O). "
             +"These parts are interconnected by buses, often made of groups of wires."),
        qsTr("Inside each of these parts are thousands to trillions of small electrical circuits "
             +" which can be turned off or on by means of an electronic switch. "),
        qsTr("Your goal is to click on the box kept beside the table "
             +"and see the components of computer one by one and read about it. "
             +"Then,Drag the image to the specific point on the table and place it."),
        qsTr("Zoom at the table to enjoy virtual settings. "
             +"and click done.")
    ]

    Behavior on opacity { NumberAnimation {duration: 100 } }

    Rectangle {
        id: intro_textbg
        x: intro_text.x -4
        y: intro_text.y -4
        width: intro_text.width +4
        height: intro_text.height +4
        color: "#d8ffffff"
        border.color: "#2a2a2a"
        border.width: 2
        radius: 8
    }

    GCText {
        id: intro_text
        fontSize: regularSize
        font.weight: Font.DemiBold
        horizontalAlignment: Text.AlignHCenter
        anchors {
            top: parent.top
            topMargin: 10 *ApplicationInfo.ratio
            right: parent.right
            rightMargin: 5 * ApplicationInfo.ratio
            left: parent.left
            leftMargin: 5 * ApplicationInfo.ratio
        }
        width: parent.width
        wrapMode: Text.WordWrap
        text: parent.intro[parent.index]
    }

    Rectangle { // our inlined button ui
        id: button
        width: Math.max(skipText.width, nextText.width) * 1.2
        height: Math.max(skipText.height, nextText.height) * 1.4
        x: intro_textbg.x + (intro_textbg.width/2) + 20
        y: intro_textbg.y + intro_textbg.height - button.height - 5
        color: "#d8ffffff"
        border.color: "#2a2a2a"
        border.width: 3
        radius: 8
        z: 5

        anchors.top : intro_textbg.bottom
        anchors.topMargin: 10

        GCText {
            id: nextText
            anchors.centerIn: parent
            text: index != 4 ? qsTr("Next") : qsTr("Let's Go")
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(index++ == 4) {
                    index = 0

                }
            }
        }
    }

    Rectangle { // our inlined button ui
        id: skipButton
        width: button.width
        height: button.height
        x: intro_textbg.x + (intro_textbg.width/2) -20- skipButton.width
        y: intro_textbg.y + intro_textbg.height - skipButton.height - 5
        color: "#d8ffffff"
        border.color: "#2a2a2a"
        border.width: 3
        radius: 8
        z: 5

        anchors.top : intro_textbg.bottom
        anchors.topMargin: 10
        GCText {
            id: skipText
            anchors.centerIn: parent
            text: qsTr("Skip Instruction")
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                message.index = 0

            }
        }
    }
}
