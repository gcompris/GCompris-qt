/* GCompris - watercycle.qml
 *
 * Copyright (C) 2015 Sagar Chand Agarwal <atomsagar@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>(GTK+ version)
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

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Item {
        id: background
        anchors.fill: parent

        signal start
        signal stop
        signal clicked

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
        Image {
            id: scenery
            source: "resource/background.svg"
            width: parent.width
            height: parent.height
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
            MouseArea{
                anchors.fill:tuxboat
                onClicked: {
                    tuxparked.visible= false
                }
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
            visible: true
        }


        Image {
            id: sun
            source: "resource/sun.svg"
            width: background.width*0.1
            height: sun.width
            anchors {
                left: parent.left
                top: parent.top
                leftMargin: parent.width*0.05
                topMargin: parent.height*0.25

            }
            MouseArea{
                anchors.fill:sun
                onClicked:
                    sun.anchors.left=undefined,
                    sun.anchors.top=undefined,
                    background.state="rise"
            }

        }


        Image {
            id: mask
            source: "resource/mask.svg"
            width: sun.width
            height: sun.height*0.75
            anchors{
                left: parent.left
                top: parent.top
                leftMargin: parent.width*0.05
                topMargin: parent.height*0.32
            }
        }

        Image {
            id:vapor
            source: "resource/vapor.svg"
            height: sun.height
            width: sun.width
            anchors {
                top: mask.bottom
                left: parent.left
                leftMargin: parent.width*0.05
            }
            visible: true
            MouseArea{
                anchors.fill:vapor
                onClicked: {
                    vapor.anchors.left=undefined,
                            vapor.anchors.top=undefined,
                            vapor.state="vapor"
                }
            }
        }

        Image {
            id: cloud
            source: "resource/cloud.svg"
            height: sun.height
            width: sun.width*1.5
            anchors {
                left:parent.left
                top:parent.top
            }
            MouseArea {
                onClicked:cloud.anchors.left= undefined,
                          cloud.anchors.top= undefined,
                          rain.visible= true,
                          river.visible= true

            }
            visible:true
        }

        Image {
            id: rain
            source: "resource/rain.svg"
            height:cloud.height*2
            width: cloud.width
            anchors {
                top:cloud.bottom
                left:parent.left
            }
            visible:false
        }

        Image {
            id:river
            source: "resource/river.svg"
            height: parent.height*0.745
            width: parent.width*0.46
            anchors {
                top: parent.top
                left: parent.left
                topMargin:parent.height*0.175
                leftMargin: parent.width*0.250
            }
            visible:false
        }

        Image {
            id: motor
            source:"resource/motor.svg"
            height: parent.width*0.05
            width: parent.width*0.05
            anchors {
                top:parent.top
                right:river.right
                rightMargin: parent.width*0.24
                topMargin: parent.height*0.34
            }
            MouseArea{
                anchors.fill:motor
                onClicked: {
                    fillwater.opacity= 1
                }
            }
        }

        Image{
            id: tower
            source: "resource/watertower.svg"
            height:parent.width*0.1
            width:parent.width*0.05
            anchors {
                top: parent.top
                right:parent.right
                topMargin: parent.height*0.20
                rightMargin:parent.width*0.18
            }
        }

        Image {
            id: resident
            source:"resource/resident.svg"
            height:parent.height*0.3
            width: parent.width*0.4
            anchors {
                bottom:parent.bottom
                right:parent.right
                rightMargin: parent.width*0.13
                bottomMargin: parent.height*0.295
            }
        }

        Image {
            id: shower
            source:"resource/shower.svg"
            height:parent.height*0.2
            width: parent.width*0.15
            anchors{
                bottom: parent.bottom
                right: parent.right
                bottomMargin: parent.height* 0.32
                rightMargin: parent.width*0.01

            }
            Image {
                id:tuxoff
                source:"resource/tuxoff.svg"
                height: shower.height*0.4
                width: shower.width*0.2
                anchors {
                    horizontalCenter: shower.horizontalCenter
                    verticalCenter: shower.verticalCenter
                    verticalCenterOffset: shower.height*0.1
                    horizontalCenterOffset: -shower.width*0.05
                }
                visible:false
            }
            Image {
                id:tuxbath
                source:"resource/tuxbath.svg"
                height: shower.height*0.5
                width: shower.width*0.3
                anchors {
                    horizontalCenter: shower.horizontalCenter
                    verticalCenter: shower.verticalCenter
                    verticalCenterOffset: shower.height*0.1
                    horizontalCenterOffset: -shower.width*0.05
                }
                visible:false
            }
            visible:true
        }

        Rectangle {
            id: knob
            color:"white"
            radius: 10
            height: parent.height*0.05
            width: parent.width*0.05
            anchors{
                bottom:parent.bottom
                right:shower.left
                bottomMargin: parent.height*0.35
            }

            Image {
                id:showeroff
                source: "resource/showeroff.svg"
                anchors.horizontalCenter: knob.horizontalCenter
                anchors.verticalCenter: knob.verticalCenter
                MouseArea{
                    anchors.fill:showeroff
                    onClicked: {
                        tuxbath.visible=true
                        tuxoff.visible= false
                        showeron.visible= true
                        showeroff.visible= false
                        wastewater.opacity= 1
                    }
                }
                visible: true
            }
            Image{
                id:showeron
                source: "resource/showeron.svg"
                anchors.horizontalCenter: knob.horizontalCenter
                anchors.verticalCenter: knob.verticalCenter
                MouseArea{
                    anchors.fill:showeron
                    onClicked: {
                        tuxoff.visible= true
                        tuxbath.visible= false
                        showeron.visible= false
                        showeroff.visible= true
                    }
                }
                visible:false
            }
            visible: true

        }

        Image {
            id: waste
            source: "resource/wastewater.svg"
            height:motor.height*2
            width: motor.width*2
            anchors{
                top:resident.bottom
                right:resident.right
                rightMargin: parent.width*0.1
                topMargin: parent.height*0.05
            }
        }

        Image {
            id:fillwater
            source: "resource/fillwater.svg"
            height: parent.height*0.2
            width :parent.width*0.4
            anchors{
                right: parent.right
                top: parent.top
                topMargin: parent.height*0.35
                rightMargin: parent.width*0.15
            }
            opacity:0.1
        }

        Image {
            id:wastewater
            source: "resource/waste.svg"
            height: parent.height*0.13
            width: parent.width*0.35
            anchors {
                bottom:parent.bottom
                right:parent.right
                bottomMargin: parent.height*0.24
                rightMargin: parent.width*0.1
            }
            opacity: 0.1
        }

        states: [ State{
                name:"rise"
                AnchorChanges{
                    target: sun
                    anchors{
                        left: parent.left
                        top: parent.top
                    }
                }
                PropertyChanges {
                    target: sun
                    anchors
                    {
                        leftMargin: parent.width*0.05
                        topMargin: parent.height*0.05
                    }
                }
            },
            State{
                name:"vapor"
                AnchorChanges{
                    target:vapor
                    anchors{
                        left:parent.left
                        top:parent.top
                    }
                }
                PropertyChanges {
                    target: vapor
                    anchors {
                        leftMargin: parent.width*0.05
                        topMargin: parent.width*0.10
                    }
                }
            }
        ]
        transitions:[
            Transition {
                AnchorAnimation{
                    targets: sun
                    duration:1000
                }
            },
            Transition {
                AnchorAnimation{
                    targets: vapor
                    loops: Animation.Infinite
                    duration: 1000
                }
            }
        ]

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
