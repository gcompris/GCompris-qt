/* GCompris - dcracan.qml
 *
 * Copyright (C) 2014 <Dan Cracan>
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
import "dcracan.js" as Activity

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
            property alias exampleImage: exampleImage
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Text {
            anchors.horizontalCenter: parent
            text: "click on the image, the fun is there :)"
            font.pointSize: 18
        }

        Image {
            id : exampleImage
            x: 450; y: 40;
            rotation: 0
            focus: true
            width: 331; height: 298
            source: "qrc:/gcompris/src/activities/dcracan/gsoc.svg"
            MouseArea {
                    id: mousearea
                    anchors.fill: parent
                    onClicked: Activity.onImageClick(exampleImage)
                }
        }

        Rectangle {
            id: exampleRectangle
            width: 80; height: 80
            x: 250; y: 50;
            color: "#FF0000"
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
