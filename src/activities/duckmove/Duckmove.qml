/* GCompris - duckmove.qml
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

import "qrc:/gcompris/src/core"
import "duckmove.js" as Activity

ActivityBase {
    id: activity
    focus: true

    onStart: {}
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
        onStart: { Activity.start(main, background, bar, bonus) }
        onStop: { Activity.stop() }

        Text {
            anchors.centerIn: parent
            wrapMode : Text.Wrap
            text: "Click on the Rectangle"
            font.pointSize: 18
        }
        Image {
             id: duck
             x:50;y:50
             width: 190; height: 190
             source: "qrc:/gcompris/src/activities/colors/resource/purple_duck.svgz"
         }
        Rectangle {
             id: flashingblob
             x:320
             y:430
             width: 100
             height: 100
             color: "red"
             border.color: "black"
             border.width: 5
             radius: 10

             MouseArea {
                     anchors.fill: parent
                     onClicked: {
                         animateColor.start()
                         animateOpacity.start()
                         animt.running=true


                     }
                 }

                 PropertyAnimation {id: animateColor; target: flashingblob; properties: "color"; to: "green"; duration: 500}
                 PropertyAnimation { id:animt; target:duck; property: "x"; to: 500; duration:2000 }
                 NumberAnimation {
                     id: animateOpacity
                     target: flashingblob
                     properties: "opacity"
                     from: 0.99
                     to: 1.0
                     loops: Animation.Infinite
                     easing {type: Easing.OutBack; overshoot: 500}
                }

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
