 /* GCompris - mirrorgame.qml
 *
 * Copyright (C) 2016 Shubham Nagaria <shubhamrnagaria@gmail.com>
 *
 * Authors:
 *  Shubham Nagaria <shubhamrnagaria@gmail.com>
 *
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
import "mirrorgame.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source:"resource/background.svg"
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
            property alias grid:grid
            property alias pieces: pieces
            property alias ok : ok
            property alias bar: bar
            property alias bonus: bonus
            property alias repeater: repeater
            property alias columns: grid.columns
            property alias rows: grid.rows
            property int cellSize: Math.min(background.width / (columns + 1),
                                            background.height / (rows + 3))


        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        ListModel {
            id: pieces
        }


        Grid {
            id: grid            
            anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
            }
            columns: 5
            rows: 5
            spacing:2
            Repeater {
                id: repeater
                model: pieces
                delegate: blackSquare

                Component {
                    id: blackSquare
                    Rectangle {
                        color: "#000000"
                        width: items.cellSize
                        height: items.cellSize
                        radius: 10
                        }
                }
            }
        }

        Image{
            id:ok
            source:"qrc:/gcompris/src/core/resource/bar_ok.svg"
            anchors.horizontalCenter: background.horizontalCenter
            visible: false
            MouseArea{
                anchors.fill: parent
                onClicked: {Activity.win()
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
