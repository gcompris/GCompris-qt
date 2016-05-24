/* GCompris - Crane.qml
 *
 * Copyright (C) 2016 Stefan Toncu <stefan.toncu29@gmail.com>
 *
 * Authors:
 *   <Marc BRUN> (GTK+ version)
 *   Stefan Toncu <stefan.toncu29@gmail.com> (Qt Quick port)
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
import "crane.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        // source: "resource/crane-bg.svgz"

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
            property alias board: board
            property alias grid: grid
            property alias repeater: repeater
            property alias repeater2: repeater2
            property var names
            property var names2
            property int selected
            property int columns
            property int rows
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Keys.onPressed: {
            if (event.key === Qt.Key_Left) {
                if (items.selected % items.columns != 0) {
                    Activity.makeMove(-1)
                }
            } else if (event.key === Qt.Key_Right) {
                if ((items.selected+1) % items.columns != 0) {
                    Activity.makeMove(1)
                }
            } else if (event.key === Qt.Key_Up) {
                if (items.selected > items.columns-1) {
                    Activity.makeMove(-items.columns)
                }
            } else if (event.key === Qt.Key_Down) {
                if (items.selected < (items.repeater.count-items.columns)) {
                    Activity.makeMove(items.columns)
                }
            } else if (event.key === Qt.Key_Space || event.key === Qt.Key_Tab) {
                items.selected = Activity.getNextIndex(items.selected)
            }
        }

        Rectangle {
            id: board
            color: "lightblue"
            x: 10
            y: 10
            width: 600
            height: 550

            Grid {
                id: grid
                columns: items.columns
                rows: items.rows
//                spacing: 5

                Repeater {
                    id: repeater

                    Image {
                        id: figure
                        width: board.width/items.columns
                        height: board.height/items.rows

                        property bool showSelected: false
                        property alias selected: selected
                        // make current index accessible from outside
                        property int _index: index

                        // select a figure
                        MouseArea {
                            anchors.fill: parent
                            onClicked: source != "" ? items.selected = index : undefined
                        }

                        // selected marker
                        Image {
                            id: selected
                            source: "resource/selected.png"
                            width: parent.width
                            height: parent.height
                            // show only on the selected figure
                            opacity: parent._index == items.selected ? 1 : 0
                        }
                    }
                }
            }
        }

        Rectangle {
            id: board2
            color: "pink"
            x: 650
            y: 10
            width: 600
            height: 550

            Grid {
                id: grid2
                columns: items.columns
                rows: items.rows
//                spacing: 5

                Repeater {
                    id: repeater2

                    Image {
                        id: figure2
                        width: board.width/items.columns
                        height: board.height/items.rows
                    }
                }
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
