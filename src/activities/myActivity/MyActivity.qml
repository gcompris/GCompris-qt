/* GCompris - myActivity.qml
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
import GCompris 1.0

import "../../core"
import "myActivity.js" as Activity

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

        Image { //background
            source: "qrc:/gcompris/src/activities/myActivity/resource/bambooForest.png"
            anchors.fill: parent
        }

        Text { //heading
            text: "Welcome to Panda Domain!"
            font.bold: true
            font.family: Arial
            font.pointSize: 40
            color: "white"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top; anchors.topMargin: 50
        }

        Rectangle {
            id: rectangle
            width: 300
            height: 80
            property color buttonColor: "lightgray"
            property color onHoverColor: "black"
            property color borderColor: "gray"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom; anchors.bottomMargin: 100

            Text {
                //anchors.centerIn: parent
                y: 50
                x: 50
                anchors.centerIn: parent
                text: "Click the Panda!"
                font.bold: true
                font.family: Times
                font.pointSize: 25
            }

            MouseArea {
                id: rectMouseArea
                anchors.fill: parent
            }

            color: rectMouseArea.pressed ? "white" : "grey"

        }


        Image {
            id: panda
            source: "qrc:/gcompris/src/activities/myActivity/resource/panda.png"
            anchors.centerIn: parent

            MouseArea {
                width: panda.x
                height: panda.y
                anchors.fill: panda
                onClicked: {
                    panda.visible = false;
                    pandaBamboo.visible = true;
                }
            }
        }

        Image {
            id: pandaBamboo
            source: "qrc:/gcompris/src/activities/myActivity/resource/bambooPanda.png"
            visible: false
            anchors.centerIn: parent

            MouseArea {
                width: pandaBamboo.x
                height: pandaBamboo.y
                anchors.fill: pandaBamboo
                onClicked: {
                    pandaBamboo.visible = false;
                    panda.visible = true;
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
