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
import QtMultimedia 5.0
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
    property string audioFile
    property string textDisplayed

    fillMode: Image.PreserveAspectFit

    MouseArea {
        anchors.fill: parent
        enabled: item.isBack
        onClicked: {
            console.log("code=" + matchCode, textDisplayed)
            item.isBack = false
            Activity.cardClicked(item)
            if (Activity.type == "sound"){
                console.log("playing sound : " + audioFile)
                sound1.source = "qrc:/gcompris/src/activities/memory-sound/resource/"+ audioFile
                sound1.play()
            }
        }
    }

//    Audio {
//           id: sound1
//           source: "qrc:/gcompris/src/activities/memory-sound/resource/" + audioFile
//       }
    Text {
           id:text1
           anchors.centerIn: parent
           text: textDisplayed
           font.family: "Helvetica"
           font.pointSize: Activity.column==5 ? 14 : 36/(Math.floor(Activity.column/3)+1) //awful hack to set a good font size
           horizontalAlignment: Text.AlignHCenter
           verticalAlignment: Text.AlignVCenter
           color: "black"
           visible: !isBack
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
