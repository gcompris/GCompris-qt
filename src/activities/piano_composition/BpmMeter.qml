/* GCompris - BpmMeter.qml
*
* SPDX-FileCopyrightText: 2018 Aman Kumar Gupta <gupta2140@gmail.com>
*
* Authors:
*   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
*   Johnny Jazeix <jazeix@gmail.com> (Qt Quick port)
*   Aman Kumar Gupta <gupta2140@gmail.com> (Qt Quick port)
*   Timothée Giet <animtim@gmail.com> (refactoring)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12
import core 1.0

import "../../core"

Item {
    id: bpmMeter
    width: optionsRow.iconsWidth * 2
    height: optionsRow.iconsWidth
    visible: bpmVisible

    signal stop

    Component.onCompleted: {
        activity.stop.connect(stop);
    }

    onStop: {
        decreaseBpm.stop();
        increaseBpm.stop();
    }

    Rectangle {
        id: bpmBg
        color: "#80FFFFFF"
        border.width: GCStyle.thinBorder
        border.color: "#80000000"
        width: optionsRow.iconsWidth
        height: optionsRow.iconsWidth
        anchors.left: parent.left
        radius: GCStyle.halfMargins
    }
    GCText {
        //: BPM is the abbreviation for Beats Per Minute.
        text: qsTr("%1 BPM").arg(multipleStaff.bpmValue + "<br>")
        anchors.fill: bpmBg
        anchors.margins: GCStyle.halfMargins
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        fontSizeMode: Text.Fit
        fontSize: smallSize
        minimumPointSize: 5
    }
    Item {
        id: bpmDown
        width: optionsRow.iconsWidth
        height: optionsRow.iconsWidth * 0.5
        anchors.bottom: parent.bottom
        anchors.left: bpmBg.right
        Image {
            source: "qrc:/gcompris/src/core/resource/bar_down.svg"
            anchors.centerIn: parent
            width: parent.width * 0.9
            sourceSize.width: width
            fillMode: Image.PreserveAspectFit
        }
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
                    bpmDown {
                        scale: 1.0
                    }
                }
            },
            State {
                name: "clicked"
                when: mouseDown.pressed
                PropertyChanges {
                    bpmDown {
                        scale: 0.9
                    }
                }
            },
            State {
                name: "hover"
                when: mouseDown.containsMouse
                PropertyChanges {
                    bpmDown {
                        scale: 1.1
                    }
                }
            }
        ]
        Behavior on scale { NumberAnimation { duration: 70 } }
        Behavior on opacity { PropertyAnimation { duration: 200 } }
    }
    Image {
        id: bpmUp
        width: iconsWidth
        height: bpmDown.height
        fillMode: Image.PreserveAspectFit
        anchors.top: parent.top
        anchors.left: bpmBg.right
        Image {
            source: "qrc:/gcompris/src/core/resource/bar_up.svg"
            anchors.centerIn: parent
            width: parent.width * 0.9
            sourceSize.width: width
            fillMode: Image.PreserveAspectFit
        }
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
                    bpmUp {
                        scale: 1.0
                    }
                }
            },
            State {
                name: "clicked"
                when: mouseUp.pressed
                PropertyChanges {
                    bpmUp {
                        scale: 0.9
                    }
                }
            },
            State {
                name: "hover"
                when: mouseUp.containsMouse
                PropertyChanges {
                    bpmUp {
                        scale: 1.1
                    }
                }
            }
        ]
        Behavior on scale { NumberAnimation { duration: 70 } }
        Behavior on opacity { PropertyAnimation { duration: 200 } }
    }
}
