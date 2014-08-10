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

    pageComponent: Item{
        id: background
        anchors.fill: parent

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
            property alias pointImageRepeater: pointImageRepeater
            property alias segmentsRepeater: segmentsRepeater
            property alias imageBack: imageBack
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Image {
            id: imageBack

            anchors.top: parent.top
            width: background.width
            height: background.height
        }


        Repeater {
            id: segmentsRepeater

            Canvas {
                   id: canvas
                   anchors {
                       left: parent.left
                       right: parent.right
                       top: parent.top
                       bottom: parent.bottom
                       margins: 8
                   }

                   opacity: 0

                   property color color: "black"
                   property var pointOrigin
                   property var pointToClick

                   onPaint: {
                       var ctx = getContext('2d')
                       ctx.lineWidth = 1.5
                       ctx.strokeStyle = canvas.color
                       ctx.beginPath()
                       ctx.moveTo(modelData[0][0]* items.background.width / 801,modelData[0][1]* items.background.height / 521)
                       ctx.lineTo(modelData[1][0]* items.background.width / 801,modelData[1][1]* items.background.height / 521)
                       ctx.stroke()
                   }
            }
        }



        Repeater {
            id: pointImageRepeater

            Image {
                id: pointImage

                x: modelData[0] * items.background.width / 801
                y: modelData[1] * items.background.height / 521
                source: Activity.url + "bluepoint.svgz"
                sourceSize.height: items.background.height / 15


                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        Activity.drawSegment(index)
                    }
                }

                Text {
                    id: pointNumberText1
                    text: index
                    anchors.top: parent.top
                    anchors.left: parent.left

                    width: pointImage.width
                    height: pointImage.height

                    x: modelData[0]
                    y: modelData[1]
                }
            }
        }


        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | previous | next }

            // anchor in top right corner:
            anchors.bottom: undefined
            anchors.top: parent.top
            x: parent.width - width
            anchors.topMargin: height + 10

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
