/* GCompris - yask123.qml
 *
 * Copyright (C) 2015 YOUR NAME <xx@yy.org>
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
import QtQuick 2.3

import "../../core"
import "yask123.js" as Activity
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

        // rectangle.qml

        Rectangle {
            id: simpleButton
            width: 150; height: 75
            property color buttonColor: "lightblue"
            property color onHoverColor: "gold"
            property color borderColor: "white"
            x:380
            y:150

            signal buttonClick()

            onButtonClick: {
                console.log(buttonLabel.text + " was clicked")
            }
            Text {
                id: buttonLabel
                anchors.centerIn: parent
                text: "Fire"
                color: "white"
            }
            MouseArea {
                    id: buttonMouseArea

                    // Anchor all sides of the mouse area to the rectangle's anchors
                    anchors.fill: parent
                    // onClicked handles valid mouse button clicks
                    onClicked: console.log("Rocket Fired")
                }
            color: buttonMouseArea.pressed ? Qt.darker(buttonColor, 1.5) : buttonColor

        }
        Rectangle {
            x: 300
            y: 220
            width: 320; height: 340
            Image {
                id: rocket

                // reference the parent
                x: (parent.width - width)/2; y: (parent.width - width)/2

                source: 'http://images.clipartpanda.com/rocket-clipart-black-and-white-nTXREpaTB.png'

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
