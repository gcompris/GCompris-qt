/* GCompris - soura97.qml
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
import "soura97.js" as Activity

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
            anchors.centerIn: parent
            text: "soura97 activity"
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

    Rectangle {
        id: simpleButton
        x: 245
        y: 277
        color: "grey"
        width: 100; height: 50
        property color buttonColor: "lightblue"
        property color onHoverColor: "gold"
        property color borderColor: "white"

        signal buttonClick()
        onButtonClick: {
            console.log(buttonLabel.text + " clicked")
        }

        Text {
            id: buttonLabel
            anchors.centerIn: parent
            text: "Click Me!"
        }
        MouseArea {
            id: mouseArea1
            anchors.fill: parent

            hoverEnabled: true
            //anchors.fill: parent
          //  onEntered: parent.border.color = onHoverColor
           // onExited:  parent.border.color = borderColor
            onClicked: Activity.buttonclick()
        }
        //color: buttonMouseArea.pressed ? Qt.darker(buttonColor, 1.5) : buttonColor
    }




    Image {
        id: image1
        x: 213
        y: 15
        source: "resource/hi.svg"
    }



}
