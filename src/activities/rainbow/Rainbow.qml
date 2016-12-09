/* GCompris - test.qml
 *
 * Copyright (C) 2014 <YOUR NAME HERE>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Sagar Chand Agarwal<atomsagar@gmail.com> (Qt Quick port)
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
import "rainbow.js" as Activity


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
            Rectangle {
               anchors.centerIn: parent
                id:start
                width: 300
                height: 50
                color: "lightblue"

                radius: 10
                Text{
                       id: starttext
                       anchors.centerIn: parent
                       text: qsTr("Start")
                       visible:true
                   }


               Audio{
                    id:cloudintro
                    source:"resource/cloud.ogg"
                 }
        MouseArea{
            anchors.fill:parent
            onClicked:cloudintro.play(),start.visible=false,starttext.visible=false
         }
       }
        Loader{

            id:loaded
            source:"Cloud.qml"
        }
        Item{

            width:1500; height: 50
            Rectangle {
                            id:button
                            width: 1000
                            height: 100
                            color: "#00f1ffff"
                            border.color: "#00f1ffff"
                            border.width: 5

                            radius: 10
                            Audio {
                                    id:introsun
                                    source: "resource/sun.ogg"
                                }

           Loader { id: pageLoader }

            MouseArea {
                anchors.fill: parent
                onClicked: pageLoader.source = "Drops.qml",introsun.play()


            }
        }
        }

        Item {
            width: 100; height: 50
            Rectangle {
                            y:100
                            id:button1
                            width: 60
                            height: 60
                            color: "#00f1ffff"
                           border.color: "#00f1ffff"
                           border.width: 5
                            visible: true

                        Image {
                            height:50
                            width:50
                                id: label1
                                source:"resource/sun.svg"
                                anchors.centerIn: parent
                               visible:true
                            }
                        Audio {
                                id:introrainbow
                                source: "resource/rainbow.ogg"
                            }

            Loader { id: pageLoader1}

            MouseArea {
                anchors.fill: parent
                onClicked: pageLoader1.source = "Sun.qml",label1.visible=false,introrainbow.play()
            }
        }
        }

        Item {
            width: 100; height: 50
            Rectangle {
                            y:200
                            id:button2
                            width: 60
                            height: 60
                            color: "#00f1ffff"
                           border.color: "#00f1ffff"
                           border.width: 5
                            visible: true

                        Image {
                            height:50
                            width:50
                                id: label2
                                source:"resource/drop.svg"
                                anchors.centerIn: parent
                               visible:true
                            }
                        Audio {
                                id:introprism
                                source: "resource/prism.ogg"
                            }


            Loader { id: pageLoader2}

            MouseArea {
                anchors.fill: parent
                onClicked: pageLoader2.source = "Prism.qml",introprism.play(),label2.visible=false,pageLoader1.visible=false,pageLoader.visible=false,loaded.visible=false

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
            property alias bonus: bonus
            property GCAudio audioVoices: activity.audioVoices
            property GCAudio audioEffects: activity.audioEffects
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        GCText {
            anchors.centerIn: parent
            text: ""
            fontSize: largeSize
        }

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
