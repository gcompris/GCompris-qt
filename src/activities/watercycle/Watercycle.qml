/* GCompris - watercycle.qml
 *
 * Copyright (C) 2015 <Sagar Chand Agarwal>
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
import "../../core"
import "watercycle.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image{
        id: background
        anchors.fill: parent
        source:"resource/background.svg"
        signal start
        signal stop

        Image{
            id:tuxboat
            source:"resource/boat.svg"
            x:100
            visible:true
            anchors{
                bottom:parent.bottom
            }
            SequentialAnimation on x{
                id:tuxdrive
                running:true
                NumberAnimation{
                    from:100
                    to:1300
                    duration:18000

                }
            }

        }

        Image{
            id:tuxparked
            source:"resource/boat_parked.svg"
            anchors{
                right:parent.right
                bottom:parent.bottom
            }
        }


        Image{
            id:sun
            source:"resource/sun.svg"
            x:120
            y:200

            SequentialAnimation on y{
                id:sunrise
                running:false
                NumberAnimation{
                    duration: 1500
                    to:10
                }

            }
            MouseArea{
                anchors.fill:sun
                onClicked:sunrise.running=true,
                          vaporrise.running=true,
                          cloud.visible=true
            }
            ToolTipArea{
                tip {
                    text: "The sun heats the water and create wate vapor.Water vapor combines with water droplets to form clouds"
                    x: sun.width + 10
                    y: sun.height/2 - tip.height/2
                }
            }

        }
        Image{
            id:mask
            source:"resource/mask.svg"
            x:120
            y:235
            height:sun.height
            width:sun.width
        }

        Image{
            id:vapor
            x:120
            y:240
            source:"resource/vapor.svg"
            height:sun.height
            width:sun.width
            visible:true
            SequentialAnimation on y{
                id:vaporrise
                running:false
                loops:Animation.Infinite
                NumberAnimation{
                    from:240
                    to:150
                    duration:1200
                }
            }
        }

        Image{
            id:cloud
            source:"resource/cloud.svg"
            x:120
            height:sun.height
            width:sun.width*2.5
            visible:false
            SequentialAnimation on x{
                id:cloudform
                running:true
                NumberAnimation{
                    from:120
                    to:500
                    duration:5500
                }
            }

            MouseArea{
                anchors.fill:cloud
                onClicked:rain.visible=true,
                          river.visible=true
            }
            ToolTipArea{
                tip {
                    text: "Clouds when become heavy,they rain and rivers gets filled up with water"
                    x: cloud.width + 10
                    y: cloud.height/2 - tip.height/2
                }
            }
        }

        Image{
            id:rain
            source:"resource/rain.svg"
            x:500
            y:50
            height:150
            width:150
            visible:false
            SequentialAnimation on y{
                running:true;
                loops:Animation.Infinite
                NumberAnimation{
                    to:60
                    duration: 500
                }
            }
        }

        Image{
            id:river
            source:"resource/river.svg"
            x:345
            y:140
            height:570
            width:630
            visible:false
        }


        Image{

            id:pump
            source:"resource/motor.svg"
            x:480
            y:330
            MouseArea{
                anchors.fill:pump
                onClicked:fillwater.visible=true
            }
            ToolTipArea{
                tip {
                    text: "Motors are used to pump water to tower and then supplied to residential homes."
                    x: pump.width + 10
                    y: pump.height/2 - tip.height/2
                }
            }


        }

        Image{
            id:tower
            source:"resource/watertower.svg"
            visible:true
            x:1020
            y:200
        }

        Image{
            id:resident
            source:"resource/resident.svg"
            visible:true
            y:400
            x:690
        }

        Image{
            id:wastewater
            source:"resource/wastewater.svg"
            visible:true
            y:600
            x:880
            MouseArea{
                anchors.fill:wastewater
                onClicked:waste.visible=true
            }
            ToolTipArea{
                tip {
                    text: "This is a cleanup plant. "
                    x: wastewater.width + 10
                    y: wastewater.height/2 - tip.height/2
                }
            }
        }

        Image{
            id:bath
            source:"resource/bath.svg"
            x:1100
            y:450

            MouseArea{
                anchors.fill:bath
                onClicked:tuxoff.visible=true,
                          showeron.visible=true
            }
            Image{
                id:showeron
                source:"resource/showeron.svg"
                anchors{
                    right:bath.right
                }
                visible:false
                MouseArea{
                    anchors.fill:showeron
                    onClicked:showeron.visible=false,
                              showeroff.visible=true,
                              tuxbath.visible=true,
                              tuxoff.visible=true
                }
            }
            Image{
                id:showeroff
                source:"resource/showeroff.svg"
                visible:false
                anchors.right:bath.right
                MouseArea{
                    anchors.fill:showeroff
                    onClicked:showeroff.visible=false,
                              tuxbath.visible=false,
                              showeron.visible=true,
                              tuxoff.visible=true
                }
            }
            ToolTipArea{
                tip {
                    text: "Touch the shower button on!"
                    x: bath.width + 10
                    y: bath.height/2 - tip.height/2
                }
            }
        }

        Image{
            id:tuxoff
            x:10
            source:"resource/tuxoff.svg"
            anchors{
                centerIn:bath
            }
            visible:false
        }




        Image{
            x:10
            id:tuxbath
            source:"resource/tuxbath.svg"
            anchors{
                centerIn:bath
            }
            visible:false
        }

        Image{
            id:fillwater
            source:"resource/fillwater.svg"
            height:200
            width:600
            x:520
            y:310
            visible:false

        }
        Image {
            id:waste
            source:"resource/waste.svg"
            height:100
            width:400
            x:700
            y:500
            visible:false
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar

        }


        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }


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
