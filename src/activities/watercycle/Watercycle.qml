/* GCompris - watercycle.qml
 *
 * Copyright (C) 2015 Sagar Chand Agarwal <atomsagar@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
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
import GCompris 1.0

import "../../core"
import "."


ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Item {
        id: background
        anchors.fill: parent

        signal start
        signal stop

        Image {
            id:poster
            source:"resource/background.svg"
            anchors.fill:parent
            sourceSize.width:parent.width
            sourceSize.height:parent.height
        }

        Image {
            id:sun
            source:"resource/sun.svg"
            sourceSize.width:Math.min(120 * ApplicationInfo.ratio , parent.width*0.1)
            sourceSize.height:Math.min(120 * ApplicationInfo.ratio , parent.height*0.1)
            anchors {
                left:parent.left
                top:parent.top
                leftMargin: parent.width*0.10
                topMargin: parent.height*0.25
            }
        }

        Image {
            id:mask
            source:"resource/mask.svg"
            sourceSize.width:sun.width
            sourceSize.height:sun.height
            anchors {
                left:parent.left
                top:parent.top
                leftMargin: parent.width*0.10
                topMargin: parent.height*0.30
            }
        }

        Image {
            id:vapor
            source:"resource/vapor.svg"
            sourceSize.width:Math.min(120 * ApplicationInfo.ratio , parent.width*0.12)
            sourceSize.height:Math.min(120 * ApplicationInfo.ratio , parent.height*0.1)
            anchors {
                left:parent.left
                top:parent.top
                leftMargin: parent.width*0.10
                topMargin: parent.height*0.25
            }
        }

        Image{
            id:cloud
            source:"resource/cloud.svg"
            sourceSize.width:Math.min(120 * ApplicationInfo.ratio , parent.width*0.15)
            sourceSize.height:Math.min(120 * ApplicationInfo.ratio , parent.height*0.1)
            anchors{
                left:parent.left
                leftMargin:parent.width*0.10
            }
        }

        Image {
            id:tuxboat
            source:"resource/boat.svg"
            sourceSize.width:Math.min(120 * ApplicationInfo.ratio , parent.width*0.15)
            sourceSize.height:Math.min(120 * ApplicationInfo.ratio , parent.height*0.15)
            anchors{
                bottom:parent.bottom
                left:parent.left
                leftMargin:parent.width*0.10
                bottomMargin:15
            }
        }


        Image {
            id:tuxparked
            source:"resource/boat_parked.svg"
            sourceSize.width:Math.min(120 * ApplicationInfo.ratio , parent.width*0.15)
            sourceSize.height:Math.min(120 * ApplicationInfo.ratio , parent.height*0.15)
            anchors{
                bottom:parent.bottom
                right:parent.right
                rightMargin:parent.width*0.01
                bottomMargin:15
            }
        }

        Image {
            id:river
            source:"resource/river.svg"
            anchors {
                top:parent.top
                left:parent.left
//                right: parent.right
//                bottom: parent.bottom
                topMargin:parent.height*0.17
                leftMargin:parent.width*0.24
//                rightMargin: parent.width*0.24
//                bottomMargin: parent.height*0.17
            }
            visible: true

        }

//        Image {
//            id:fillwater
//            source:"resource/fillwater.svg"
//            anchors {
//                top:parent.top
//                right:parent.right
//                topMargin: parent.height*0.20
//                rightMargin: parent.width*0.20
//            }
//        }



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


        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home  }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }

            onHomeClicked: activity.home()
        }
    }

}
