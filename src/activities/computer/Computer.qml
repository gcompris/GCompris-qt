/* GCompris - computer.qml
 *
 * Copyright (C) 2015 <atomsagar@gmail.com>
 *
 * Authors:
 *
 *   "Sagar Chand Agarwal" <atomsagar@gmail.com> (Qt Quick)
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
import GCompris 1.0

import "../../core"
import "qrc:/gcompris/src/core/core.js" as Core


ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: "resource/room/background.svg"
        sourceSize.width: parent.width
        sourceSize.height: parent.height


        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
        }

        Rectangle {
            id: switchboard
            radius: 10
            height: parent.height*0.1
            width: parent.width*0.1
            anchors {
                top: parent.top
                left: parent.left
                leftMargin: 0.45*parent.width
                topMargin: 0.2*parent.height
            }

            Image {
                id: poweron
                source: "resource/room/poweron.svg"
                anchors.fill: switchboard
                visible: false
                MouseArea {
                    anchors.fill: poweron
                    onClicked:
                        poweroff.visible= true,
                        poweron.visible= false
                }
            }

            Image {
                id: poweroff
                source: "resource/room/poweroff.svg"
                anchors.fill: switchboard
                visible: true
                MouseArea
                {
                    anchors.fill: poweroff
                    onClicked:
                        poweron.visible = true,
                        poweroff.visible = false
                }
            }
        }


        Image {
            id: boxclosed
            source: "resource/room/closebox.svg"
            visible: true
            sourceSize.height: parent.width/4
            sourceSize.width: parent.height/4
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: parent.height*0.15
            }
            MouseArea {
                anchors.fill :boxclosed
                onClicked: {
                    boxclosed.visible=false
                    boxopened.visible=true
                }
            }
        }


        Image {
            id: boxopened
            source: "resource/room/openbox.svg"
            sourceSize.height: boxclosed.height
            sourceSize.width: boxclosed.width
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: parent.height*0.15
            }
            visible: false
        }


        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home}
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onHomeClicked: activity.home()
        }
    }
}

