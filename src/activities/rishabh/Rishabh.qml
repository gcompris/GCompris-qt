/* GCompris - new.qml
 *
 * Copyright (C) 2015 YOUR NAME <xx@yy.org>
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
import QtQuick.Window 2.2

import "../../core"
import "rishabh.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: Activity.url + "../algorithm/resource/desert_scene.svg"
        sourceSize.width: parent.width

        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }
        GridView
        {
            model: 8
            width:800
            height: 300
            cellWidth: 200
            cellHeight: 200
            anchors.centerIn: parent
            delegate: Flipable{


                id:flipable
                width: 100
                height: 100
                property bool fliped: false
                MouseArea {
                    anchors.fill: parent
                    onClicked: {

                        parent.fliped = !parent.fliped
                    }

                }

                transform: Rotation {
                    id: rotation
                    origin.x: flipable.width/2
                    origin.y: flipable.height/2
                    axis.x: 0; axis.y: 1; axis.z: 0     // set axis.y to 1 to rotate around y-axis
                    angle:   0
                    Behavior on angle { NumberAnimation {duration: 2000} }
                }
                states:State {
                    name: "clicked"
                    PropertyChanges {target: rotation; angle:180;}
                    when:flipable.fliped
                }


                front:Rectangle{

                    id:frect
                    width: 100
                    height: 100
                    radius: 10
                    color: "yellow"
                    Text
                    {
                        id: ftext
                        text: modelData
                        color: "black"
                        anchors.centerIn: frect
                        font.pixelSize: 40
                    }
                }

                back: Rectangle{

                    id:brect
                    width: 100
                    height: 100
                    radius: 10
                    gradient: Gradient{
                        GradientStop { position: 0.0; color: "maroon" }
                               GradientStop { position: 0.33; color: " orange" }
                               GradientStop { position: 1.0; color: "white" }
                    }
    //                color: "yellow"
                    Text
                    {
                        id: btext
                        text: Math.pow(modelData,2)
                        color: "black"
                        anchors.centerIn: brect
                        font.pixelSize: 40

                    }
                }
            }
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

       /* GCText {
            anchors.centerIn: parent
            text: "new activity"
            fontSize: largeSize
        }*/

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
