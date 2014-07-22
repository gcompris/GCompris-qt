/* GCompris - drawnumber.qml
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

import "../../core"
import "drawnumber.js" as Activity
import GCompris 1.0


ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

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
            property alias canvas: canvas
            property alias pointImageRepeater: pointImageRepeater
            property alias pointNumberTextRepeater: pointNumberTextRepeater
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Canvas {
               id: canvas
               anchors {
                   left: parent.left
                   right: parent.right
                   top: parent.top
                   bottom: parent.bottom
                   margins: 8
               }

               property color color: "black"
               property var pointOrigin
               property var pointToClick

               onPaint: {

                   var ctx = getContext('2d')
                   ctx.lineWidth = 1.5
                   ctx.strokeStyle = canvas.color
                   ctx.beginPath()
                   ctx.moveTo(pointOrigin[0],pointOrigin[1])
                   ctx.lineTo(pointToClick[0],pointToClick[1])
                   console.log("origin: " + pointOrigin)
                   console.log("to click: " + pointToClick)
                   ctx.stroke()
               }

               MouseArea {
                   id: area
                   anchors.fill: parent
                   onClicked: {
                       canvas.requestPaint()
                   }
               }
        }


        Repeater {
            id: pointImageRepeater
            model: Activity.pointPositions

            Component.onCompleted: console.log("maison : " + Activity.pointPositions[0])

            Image {
                id: pointImage

                x: modelData[0]
                y: modelData[1]
          //      width: activity.width / 5
          //      height: activity.height / 5
                source: Activity.url + "bluepoint.svgz"

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        Activity.drawSegment(index)
                    }
                }
            }
        }


        Repeater {
            id: pointNumberTextRepeater
            model: Activity.pointPositions

            Text {
                id: pointNumberText
                text: index
                x: modelData[0] + activity.width / 200
                y: modelData[1]
            }
        }



        Text {
            anchors.centerIn: parent
            text: "drawnumber activity"
            font.pointSize: 24
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | previous | next }
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
