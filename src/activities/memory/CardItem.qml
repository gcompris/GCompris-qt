/* gcompris - Card.qml

 Copyright (C)
 2003, 2014: Bruno Coudoin: initial version
 2014: JB BUTET: Qt port

 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, see <http://www.gnu.org/licenses/>.
*/
import QtQuick 2.1
import "memory.js" as Activity
import GCompris 1.0

Image {
    id: item
    property Item main
    property Item bar
    property string audioSrc
    property string backPict
    property string imagePath
    property string matchCode
    property bool isBack: true
    property bool isFound: false

    fillMode: Image.PreserveAspectFit

    MouseArea {
        anchors.fill: parent
        enabled: item.isBack
        onClicked: {
            console.log("code=" + code)
            item.isBack = false
            Activity.cardClicked(item)
        }
    }


    states : [
        State {
          name: "hidden"; when: isFound == true
          PropertyChanges { target: item; source:item.imagePath; opacity:0 }
        },
        State {
            name:"returned"; when: isBack == true
            PropertyChanges { target: item; source:item.backPict }
        },
        State {
            name:"faced"; when: isBack==false
            PropertyChanges { target: item; source:item.imagePath }
        }
    ]

    transitions: [
        Transition {
            from: "faced"; to: "hidden"; reversible: false
            ParallelAnimation {
                PropertyAnimation {
                    duration: 500;
                    target: item;
                    property: "opacity";
                    to: 0
                }
            }
        },
        Transition {
            from: "faced"; to: "back"; reversible: false
            ParallelAnimation {
                PropertyAnimation {
                    duration: 500;
                    target: item;
                    property: "source";
                    from: item.imagePath;
                    to: item.backPict }
            }
        }

    ]

}
