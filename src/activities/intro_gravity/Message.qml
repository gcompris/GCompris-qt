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

    property alias text: intro_text.text
    property bool displayed: intro_text.text != "" ? true : false

    property int clickCount: 0
    property alias button: button
    property alias skipButton: skipButton

    property string intro1: qsTr("Gravity is universal and Newton's law of universal gravitation extends gravity"
                                 +"\n"+" beyond earth. This force of gravitational attraction is directly dependent"
                                 +"\n"+" upon the masses of both objects and inversely proportional to "
                                 +"\n"+"the square of the distance that separates their centers.")
    property string intro2: qsTr("Since the gravitational force is directly proportional to the mass of both interacting"
                                 +"\n"+"objects, more massive objects will attract each other with a greater gravitational"
                                 +"\n"+"force.So as the mass of either object increases, the force of gravitational"
                                 +"\n"+" attraction between them also increases")
    property string intro3: qsTr(" but this force is inversely proportional to the square of the separation distance"
                                 +"\n"+" between the two interacting objects, more separation distance will "
                                 +"\n"+"result in weaker gravitational forces.")
    property string intro4: qsTr("Your goal is to let Tux's spaceship move by changing the mass"
                                 +"\n"+" of its surrounding planets. Don't get too close to the planets"
                                 +"\n"+" or you will crash on them."
                                 +"\n"+" The arrow indicates the direction of the force on your ship.")
    property string intro5: qsTr("Avoid the asteroid and join the space"
                           +"\n"+" shuttle to win.")

    Rectangle{
        id: intro_textbg
        x: intro_text.x -4
        y: intro_text.y -4
        width: intro_text.width +4
        height: intro_text.height +4
        color: "#ffff30"
        border.color: "#7AA3CC"
        border.width: 2
        radius: 8
        opacity: message.displayed ? 1 : 0
        Behavior on opacity { NumberAnimation {duration: 100 } }

    }

    GCText{
        id: intro_text
        text: qsTr("Gravity is universal and Newton's law of universal gravitation extends gravity"
                       +"\n"+" beyond earth. This force of gravitational attraction is directly dependent"
                       +"\n"+" upon the masses of both objects and inversely proportional to "
                       +"\n"+"the square of the distance that separates their centers.")
        fontSize: regularSize
        font.weight: Font.DemiBold
        horizontalAlignment: Text.AlignHCenter
//        verticalAlignment: Text.AlignVCenter
        anchors {
            top: parent.top
            topMargin: 10 *ApplicationInfo.ratio
            right: parent.right
            rightMargin: 5 * ApplicationInfo.ratio
            left: parent.left
            leftMargin: 5 * ApplicationInfo.ratio
        }
        color: "#800000"
        width: parent.width
        wrapMode: Text.WordWrap
        opacity: message.displayed ? 1 : 0
        Behavior on opacity {  NumberAnimation { duration: 100} }
    }

    Rectangle { // our inlined button ui
            id: button
            property alias buttonText: buttonText.text
            width: 160; height: 40
            x: intro_textbg.x + (intro_textbg.width/2) + 20
            y: intro_textbg.y + intro_textbg.height - button.height - 5
            gradient: Gradient {
                        GradientStop { position: 0.0; color: "#ffff30" }
                        GradientStop { position: 1.0; color: "#CCCC29" }
                    }
            border.color: "#7AA3CC"
            border.width: 3
            radius: 8
            opacity: 1
            z: 5
            Behavior on opacity { NumberAnimation {duration: 100 } }

            anchors.top : intro_textbg.bottom
            anchors.topMargin: 10

            Text {
                id: buttonText
                anchors.centerIn: button
                text: "Next"
                color: "#800000"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if( clickCount == 0){
                        message.text = intro2
                    }else if(clickCount == 1){
                        message.text = intro3
                    }else if(clickCount == 2){
                        message.text = intro4
                    }else if(clickCount == 3){
                        message.text = intro5
                        button.buttonText = "Let's Go"
                    }else if(clickCount == 4){
                        message.text = qsTr("")
                        button.opacity = 0
                        skipButton.opacity = 0
                        items.timer.start()
                        items.asteroidCreation.start()
                        items.shuttleMotion.restart()
                    }
                    clickCount++;
                }
            }
    }

    Rectangle { // our inlined button ui
            id: skipButton
            width: 160; height: 40
            x: intro_textbg.x + (intro_textbg.width/2) -20- skipButton.width
            y: intro_textbg.y + intro_textbg.height - skipButton.height - 5
            gradient: Gradient {
                        GradientStop { position: 0.0; color: "#ffff30" }
                        GradientStop { position: 1.0; color: "#CCCC29" }
                    }
            border.color: "#7AA3CC"
            border.width: 3
            radius: 8
            opacity: 1
            z: 5
            Behavior on opacity { NumberAnimation {duration: 100 } }

            anchors.top : intro_textbg.bottom
            anchors.topMargin: 10
            GCText {
                anchors.centerIn: skipButton
                text: "Skip Instruction"
                color: "#800000"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                        message.text = qsTr("")
                        button.opacity = 0
                        skipButton.opacity = 0
                        items.timer.start()
                        items.asteroidCreation.start()
                        items.shuttleMotion.restart()
                    }
                }
            }
}

