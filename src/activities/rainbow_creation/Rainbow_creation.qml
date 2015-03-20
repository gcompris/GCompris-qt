/* GCompris - rainbow_creation.qml
 *
 * Copyright (C) 2014 <YOUR NAME HERE>
 *
 * Authors:
 *   <THE GTK VERSION AUTHOR> (GTK+ version)
 *   YOUR NAME <YOUR EMAIL> (Qt Quick port)
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
import "../../core"
import "rainbow_creation.js" as Activity

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
            id:menu
            anchors.centerIn: parent
            source:"resource/play.svg"

            MouseArea{
                anchors.fill:menu
                onClicked:menu.visible=false

            }
        }


        Image{
            id:cloud
            anchors{
                top:background.top
            }
            source:"resource/cloud.svgz"
            MouseArea{
                anchors.fill:cloud
                onClicked:drops.visible=true
            }
        }

        Image{
            id:drops
            visible:false
            source:"resource/drops.svg"
            SequentialAnimation on y{
                id:drops_anim
                running: true;
                loops: Animation.Infinite
                NumberAnimation{
                    id:drops_anim1
                    duration:500
                    from:70
                    to:90
                }
            }

        }



        BorderImage {
            id: rise_sun
            y:100
            source: "resource/sun.svg"
            width: 50; height: 50
            border.left: 5; border.top: 5
            border.right: 5; border.bottom: 5
            MouseArea{
                anchors.fill:rise_sun
                onClicked:rise_sun.visible=false,
                          sun.visible=true,
                          rainbow.visible=true,
                          cloud.opacity=0.8,
                          drops.opacity=0.6,
                          drops_anim1.duration=1000

            }

        }

        Image{
            id:sun
            y:800
            height:cloud.height
            width:sun.height
            visible:false
            source:"resource/sun.svg"

            anchors{
                left:cloud.left
            }
            SequentialAnimation on y{
                id:sun_anim
                running:true
                NumberAnimation{
                    to:0
                    duration:4500
                }
            }
        }

        Image{
            id:rainbow

            y:2*sun
            x:800
            height:900
            width:600

            source:"resource/rainbow.svg"
            SequentialAnimation on y{
                id:rainbow_anim
                running: true;
                NumberAnimation{
                    to:80
                    duration:9000
                }
            }

        }




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
