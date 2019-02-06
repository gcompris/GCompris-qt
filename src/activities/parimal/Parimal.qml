/* GCompris - parimal.qml
 *
 * Copyright (C) 2018 PARIMAL PRASOON <parimalprasoon7@gmail.com>
 *
 * Authors:
 *   <THE GTK VERSION AUTHOR> (GTK+ version)
 *   PARIMAL PRASOON <PARIMALPRASOON7@GMAIL.COM> (Qt Quick port)
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6

import "../../core"
import "parimal.js" as Activity

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
            id: element
            width: 200
            height: 100
            text: qsTr("Click to rotate the image and rectangle")
            renderType: Text.NativeRendering
            font.pixelSize: 50
        }


        property bool running: false

        Rectangle{
            id: object2
            anchors.centerIn: parent
            height: 500
            width: 500
            color: "#f56a6a"
            RotationAnimation on rotation {
            from: 0
            to: -360
            duration: 3000
            running: background.running
            loops: Animation.Infinite


            }
        }

        Image {
            id: clickThis
            source: "parimal.svg"
            anchors.centerIn: parent
            height: 250
            width: 250
            fillMode: Image.PreserveAspectFit

            RotationAnimation on rotation {
            from: 0
            to: 360
            duration: 3000
            running: background.running
            loops: Animation.Infinite


            }
        }

        MouseArea{
            anchors.fill: clickThis
            onClicked: background.running = true

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

