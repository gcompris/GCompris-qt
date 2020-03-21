/* GCompris - matorix.qml
 *
 * Copyright (C) 2020 Abhay Kaushik <abhay.gyanbharati@gmail.com>
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
/*
import QtQuick 2.12
import QtQuick.Window 2.12

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")
    }
*/
import QtQuick 2.6

import "../../core"
import "matorix.js" as Activity

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

        GCText {
            id: textElement
            anchors.centerIn: parent
            text: qsTr("Matorix activity")
            fontSize: largeSize
        }

        Rectangle {
            //visible: true
            id: underlineElement
            anchors.top: textElement.bottom
            anchors.right: textElement.right
            height: 5
            width: textElement.width
            color: "blue"
        }

        Image {
            id: imageElement
            anchors.horizontalCenter: textElement.horizontalCenter
            anchors.bottom: textElement.top
            source: "matorix.svg"
            sourceSize: 50 * ApplicationInfo.ratio
            width: sourceSize.width*2
            height: sourceSize.height*2
        }

        Rectangle {
            anchors.topMargin: 20
            anchors.horizontalCenter: textElement.horizontalCenter
            anchors.top: underlineElement.bottom
            height: 80
            width: textElement.width/2
            color: "lightgreen"
            GCText {
                text: qsTr("Click Here")
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }
            MouseArea {
                anchors.fill: parent
                onPressed: parent.color = "green"
                onReleased: parent.color = "lightgreen"
                onClicked: textElement.font.bold = !textElement.font.bold
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
