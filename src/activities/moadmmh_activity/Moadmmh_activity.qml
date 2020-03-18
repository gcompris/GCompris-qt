/* GCompris - moadmmh_activity.qml
 *
 * Copyright (C) 2018 YOUR NAME <xx@yy.org>
 *
 * Authors:
 *   <THE GTK VERSION AUTHOR> (GTK+ version)
 *   Moad Mohammed Elhebri <moadmohammedelhebri@gmail.com> (Qt Quick port)
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
import GCompris 1.0

import "../../core"
import "moadmmh_activity.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        source: Activity.resourceURL + "moadmmh-bg.svg"
        sourceSize.height: background.height
        fillMode: Image.PreserveAspectCrop
        anchors.horizontalCenter: parent.horizontalCenter


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
            property alias rectangle: rectangle
            property alias bar: bar
            property alias bonus: bonus
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Rectangle {
            id: rectangle
            width: 300; height: 300
            state: "RELEASED"

            PropertyAnimation on x { to: 500 }
            PropertyAnimation on y { to: 500 }
            MouseArea {
                anchors.fill: parent
                onPressed: rectangle.state = "PRESSED"
                onReleased: rectangle.state = "RELEASED"
            }

            states: [
                State {
                    name: "PRESSED"
                    PropertyChanges { target: rectangle; color: "blue"}
                },
                State {
                    name: "RELEASED"
                    PropertyChanges { target: rectangle; color: "red"}
                }
            ]

            transitions: [
                Transition {
                    from: "PRESSED"
                    to: "RELEASED"
                    ColorAnimation { target: rectangle; duration: 100}
                },
                Transition {
                    from: "RELEASED"
                    to: "PRESSED"
                    ColorAnimation { target: rectangle; duration: 100}
                }
            ]
        }

        GCText {
            anchors.centerIn: parent
            text: "An Exercise Activity Done by Moad Mohammed Elhebri"
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

}
