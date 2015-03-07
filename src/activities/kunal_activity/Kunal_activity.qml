/* GCompris - kunal_activity.qml
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
import "kunal_activity.js" as Activity

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

        Rectangle {
            id: page
            anchors.centerIn: parent
            width: 500; height: 500
            color: "lightgray"

            Image {
                id: imageSample
                width: 250; height: 200
                fillMode: Image.PreserveAspectFit
                smooth: true
                source: "qrc:/gcompris/src/activities/menu/resource/background.svgz"    //Taken from Hexagon Activity
                anchors.horizontalCenter: page.horizontalCenter

                MouseArea { id: mouseArea; anchors.fill: parent }

                states: State {
                    name: "down"; when: mouseArea.pressed == true
                    PropertyChanges { target: imageSample; y: 250; rotation: 180 }
                }

                transitions: Transition {
                    from: ""; to: "down"; reversible: true
                    ParallelAnimation {
                        NumberAnimation { properties: "y,rotation"; duration: 500; easing.type: Easing.InOutQuad }
                        ColorAnimation { duration: 500 }
                    }
                }
            }
        }

        GCText {
            text: "kunal_activity activity"
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
