/*GCompris-Qt Message.qml
*
* Copyright (C) 2015 Siddhesh suthar <siddhesh.it@gmail.com>
*
* Authors:
*   Bruno Coudoin <bruno.coudoin@gcompris.net> and Matilda Bernard (GTK+ version)
*   Siddhesh suthar <siddhesh.it@gmail.com> (Qt Quick port)
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
import "intro_gravity.js" as Activity

Item{
    id: message    
    opacity: displayed ? 1 : 0

    property bool displayed: index == 0 ? false : true

    // The message in the intro array, set to 0 to disable
    property int index: 1

    property variant intro: [
        "",
        qsTr("Gravity is universal and Newton's law of universal gravitation extends gravity"
             +" beyond earth. This force of gravitational attraction is directly dependent"
             +" upon the masses of both objects and inversely proportional to"
             +" the square of the distance that separates their centers."),
        qsTr("Since the gravitational force is directly proportional to the mass of both interacting "
             +"objects, more massive objects will attract each other with a greater gravitational "
             +"force. So as the mass of either object increases, the force of gravitational "
             +"attraction between them also increases"),
        qsTr("But this force is inversely proportional to the square of the separation distance "
             +"between the two interacting objects, more separation distance will "
             +"result in weaker gravitational forces."),
        qsTr("Your goal is to let Tux's spaceship move by changing the mass "
             +"of its surrounding planets. Don't get too close to the planets "
             +"or you will crash on them. "
             +"The arrow indicates the direction of the force on your ship."),
        qsTr("Avoid the asteroid and join the space "
             +"shuttle to win.")
        ]

    Behavior on opacity { NumberAnimation {duration: 100 } }

    Rectangle {
        id: intro_textbg
        x: intro_text.x -4
        y: intro_text.y -4
        width: intro_text.width +4
        height: intro_text.height +4
        color: "#ffff30"
        border.color: "#7AA3CC"
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
        color: "#ffff30"
        border.color: "#7AA3CC"
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
                    items.timer.start()
                    items.asteroidCreation.start()
                    items.shuttleMotion.restart()
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
        color: "#ffff30"
        border.color: "#7AA3CC"
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
                items.timer.start()
                items.asteroidCreation.start()
                items.shuttleMotion.restart()
            }
        }
    }
}
