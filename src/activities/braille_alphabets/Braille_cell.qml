/* GCompris - ColorItem.qml
 *
 * Copyright (C) 2014 Bruno Coudoin
 *
 * Authors:
 *   Pascal Georges <pascal.georges1@free.fr> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
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
import QtMultimedia 5.0
import "braille_alphabets.js" as Activity
import "../../core"
import GCompris 1.0

Rectangle {
    id:incircle1
    border.width: 6
    property bool on: false
    color:"white"

    Text{
        text:modelData
        scale: 3
        function alignment(){
            if(index%2==0){
                anchors.right=incircle1.left
            }
            else
                anchors.left=incircle1.right
        }

        anchors.left:alignment()
        font.weight: Font.DemiBold
        anchors.margins: 10


    }

    MouseArea {

        function abcd(){
            if (incircle1.state=="on"){
                incircle1.state="off"
            }
            else{
                incircle1.state="on"
            }
            incircle1.opacity=1
        }
        id:mouse1
        anchors.fill: parent
        hoverEnabled: true
        onEntered:if(incircle1.state=="off"){
                      incircle1.color="#E41B2D"
                      incircle1.opacity=0.3
                  }
        onExited:if(incircle1.opacity==0.3){
                     incircle1.color="white"
                     incircle1.opacity=1
                 }
        onClicked: abcd()
    }
    state: "off"
    states: [
        State {
            name: "on"

            PropertyChanges { target: incircle1; color:"red" }
            PropertyChanges { target: incircle1; on: true }

        },
        State {
            name: "off"

            PropertyChanges { target: incircle1; color:"white" }
            PropertyChanges { target: incircle1; on: false }
        }
    ]

    border.color: "black"
    width: rect2.height/3.1; height: rect2.height/3.1
    radius: width*0.5

}
