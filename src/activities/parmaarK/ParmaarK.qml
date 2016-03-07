/* GCompris - parmaarK.qml
 *
 * Copyright (C) 2016 YOUR NAME <xx@yy.org>
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

import "../../core"
import "parmaarK.js" as Activity

ActivityBase {
    id: activity
    states: [
        State {
            name: "rectangle"

            PropertyChanges {
                target: rectangle1
                opacity: 1
            }
        }
    ]

    onStart: focus = true
    onStop: {}
    property string url: "qrc:/gcompris/src/activities/parmaarK/"

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: "#ABCDEF"
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
            property alias bonus: bonus
        }

        GCText {
            anchors.left: disp.top
            text : "Click on the image to rotate it"
            fontSize: mediumSize

        }
        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Rectangle {
            anchors.top : img.bottom
            anchors.leftMargin: 100
            id: rectangle1
            x: 100
            y: 100
            width: 200
            height: 100
            color: '#FA5882'
            opacity: 10
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                anchors.margins: -10
                hoverEnabled: true
                onClicked: {
                    anim.stop();
                }
            }
        }

        Image {
            id: img
            x: 100
            y: 100
            anchors.centerIn: parent
            sourceSize.width: 200
            sourceSize.height: 200
            source: activity.url + "img.svg"
            opacity: 1
               MouseArea {
                   id: mouseAreaimg
                   anchors.fill: parent
                   anchors.margins: -10
                   hoverEnabled: true
                   onClicked: {
                       anim.show();
                   }
               }
        }

        SequentialAnimation {
              id: anim
              running: false
             loops: Animation.Infinite
              NumberAnimation {
                  target: img
                  property: "rotation"
                  from: -180; to: 180
                  duration: 4000 + Math.floor(Math.random() * 400)
                  easing.type: Easing.InOutQuad
              }
              function show(){
                  running = true
                  disp.displaystatus();
              }
              function stop(){
                  running = false
                  disp.displaystatus();
              }
        }

        GCText {
            id: disp
            anchors.top: img.top
            fontSize: mediumSize
            function displaystatus()
            {
               if(anim.running==true)
                   text = "Image Rotating. \nClick on the rectangle to stop it"
               else
                   text = "Still Image"
            }
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


