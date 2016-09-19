/* GCompris - Admin.qml
 *
 * Copyright (C) 2016 RAHUL YADAV <rahulyadav170923@gmail.com>
 *
 * Authors:
 *   <Pascal Georges> (GTK+ version)
 *   RAHUL YADAV <rahulyadav170923@gmail.com> (Qt Quick port)
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
import "guesscount-summer.js" as Activity


Row {
    id: admin
    spacing: 30
    property int level
    property var levelOperators
    property int minOperatorsNeeded: Activity.maxLength(Activity.dataset[level])
    Rectangle {
        id: operator
        width: parent.width*0.328
        height: parent.height
        radius: 20.0;
        color: "red"
        state: "selected"
        GCText {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            fontSize: mediumSize
            text: qsTr("Level %1").arg(level+1)
        }
    }
    Repeater {
        model: Activity.operators
        delegate: Rectangle {
            id: tile
            width: 100
            height: parent.height
            radius: 20
            opacity: 0.7
            state: Activity.check(modelData,levelOperators[level]) ? "selected" : "notselected"
            GCText {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                text: modelData
                fontSize: mediumSize
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(tile.state=="selected"){
                        tile.state="notselected"
                        levelOperators[level].splice(levelOperators[level].indexOf(modelData),1)
                        Activity.sync(levelOperators,level)
                    }
                    else{
                        tile.state="selected"
                        levelOperators[level].push(modelData)
                        Activity.sync(levelOperators,level)
                    }
                    if(levelOperators[level].length<minOperatorsNeeded){
                        warning.visible=true
                    }
                    else{
                        warning.visible=false
                    }
                }
            }
            states: [
                State {
                    name: "selected"
                    PropertyChanges { target: tile; color: "green"}
                },
                State {
                    name: "notselected"
                    PropertyChanges { target: tile; color: "red"}
                }
            ]
        }
    }
    Rectangle {
        id: warning
        visible: levelOperators[level].length<minOperatorsNeeded ? true : false
        width: parent.width*0.25
        height: parent.height
        radius: 20.0;
        color: "gray"
        GCText {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            fontSize: smallSize
            text: qsTr("%1 more operator needed").arg(minOperatorsNeeded-levelOperators[level].length)
        }
    }
}
