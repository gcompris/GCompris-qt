/* GCompris - BpmMeter.qml
*
* Copyright (C) 2018 Aman Kumar Gupta <gupta2140@gmail.com>
*
* Authors:
*   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
*   Johnny Jazeix <jazeix@gmail.com> (Qt Quick port)
*   Aman Kumar Gupta <gupta2140@gmail.com> (Qt Quick port)
*   Timothée Giet <animtim@gmail.com> (refactoring)
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

Item {
    id: bpmMeter
    width: optionsRow.iconsWidth * 2
    height: optionsRow.iconsWidth
    visible: bpmVisible
    Rectangle {
        id: bpmBg
        color: "yellow"
        opacity: 0.1
        border.width: 2
        border.color: "black"
        width: optionsRow.iconsWidth
        height: optionsRow.iconsWidth
        anchors.left: parent.left
        radius: 10
    }
    GCText {
        //: BPM is the abbreviation for Beats Per Minute.
        text: qsTr("%1 BPM").arg(multipleStaff.bpmValue + "<br>")
        width: 0.9 * bpmBg.width
        height: 0.9 * bpmBg.height
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.centerIn: bpmBg
        fontSizeMode: Text.Fit
    }
    
    Image {
        id: bpmDown
        source: "qrc:/gcompris/src/core/resource/bar_down.svg"
        width: iconsWidth
        height: iconsWidth * 0.5
        sourceSize.width: width
        fillMode: Image.PreserveAspectFit
        anchors.bottom: parent.bottom
        anchors.left: bpmBg.right
        Timer {
            id: decreaseBpm
            interval: 500
            repeat: true
            onTriggered: {
                bpmDecreased()
                interval = 1
            }
            onRunningChanged: {
                if(!running)
                    interval = 500
            }
        }
        MouseArea {
            id: mouseDown
            anchors.fill: parent
            hoverEnabled: true
            onPressed: {
                bpmDown.scale = 0.85
                bpmDecreased()
                decreaseBpm.start()
            }
            onReleased: {
                decreaseBpm.stop()
                bpmDown.scale = 1
                bpmChanged()
            }
        }
        states: [
            State {
                name: "notclicked"
                PropertyChanges {
                    target: bpmDown
                    scale: 1.0
                }
            },
            State {
                name: "clicked"
                when: mouseDown.pressed
                PropertyChanges {
                    target: bpmDown
                    scale: 0.9
                }
            },
            State {
                name: "hover"
                when: mouseDown.containsMouse
                PropertyChanges {
                    target: bpmDown
                    scale: 1.1
                }
            }
        ]
        
        Behavior on scale { NumberAnimation { duration: 70 } }
        Behavior on opacity { PropertyAnimation { duration: 200 } }
    }
    
    Image {
        id: bpmUp
        source: "qrc:/gcompris/src/core/resource/bar_up.svg"
        width: iconsWidth
        height: bpmDown.height
        sourceSize.width: width
        fillMode: Image.PreserveAspectFit
        anchors.top: parent.top
        anchors.left: bpmBg.right
        Timer {
            id: increaseBpm
            interval: 500
            repeat: true
            onTriggered: {
                bpmIncreased()
                interval = 1
            }
            onRunningChanged: {
                if(!running)
                    interval = 500
            }
        }
        MouseArea {
            id: mouseUp
            anchors.fill: parent
            hoverEnabled: true
            onPressed: {
                bpmUp.scale = 0.85
                bpmIncreased()
                increaseBpm.start()
            }
            onReleased: {
                increaseBpm.stop()
                bpmUp.scale = 1
                bpmChanged()
            }
        }
        states: [
            State {
                name: "notclicked"
                PropertyChanges {
                    target: bpmUp
                    scale: 1.0
                }
            },
            State {
                name: "clicked"
                when: mouseUp.pressed
                PropertyChanges {
                    target: bpmUp
                    scale: 0.9
                }
            },
            State {
                name: "hover"
                when: mouseUp.containsMouse
                PropertyChanges {
                    target: bpmUp
                    scale: 1.1
                }
            }
        ]
        
        Behavior on scale { NumberAnimation { duration: 70 } }
        Behavior on opacity { PropertyAnimation { duration: 200 } }
    }
}
