/* GCompris - my_new_activity.qml
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
import "my_new_activity.js" as Activity

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
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Text {
            text: "<b>Press the arrow keys to move the rectangle</b>"
            font.pointSize: 24
            x: parent.width*0.3
            y: parent.height*0.1
            color: "#000000"
        }

        Text {
            anchors.centerIn: parent
            text: "Pikachu"
            font.pointSize: 24
            color: "blue"
        }

        Rectangle {
            id: rect
            height: parent.height/13
            width: parent.width/8
            color: "lightgreen"

            x: parent.width*0.3
            y: parent.height*0.5


            radius: 20
            border.width: 10
            border.color: "red"

            Behavior on x { SmoothedAnimation { velocity: 200} }
            Behavior on y { SmoothedAnimation { velocity: 200} }
        }



         focus: true
         Keys.onRightPressed: rect.x = rect.x + 100
         Keys.onLeftPressed: rect.x = rect.x - 100
         Keys.onUpPressed: rect.y = rect.y - 100
         Keys.onDownPressed: rect.y = rect.y + 100


        Image {
            id: pikachu
            source: "qrc:/gcompris/src/activities/my_new_activity/resource/pikachu.jpg"

            height: parent.height/7
            width: parent.width/9

            x: parent.width*0.7
            y:parent.height*0.5
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
