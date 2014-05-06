/* GCompris - lightsoff.qml
*
* Copyright (C) 2014 Stephane Mankowski <stephane@mankowski.fr>
*
* Authors:
*   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
*   Stephane Mankowski <stephane@mankowski.fr> (Qt Quick port)
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
import "lightsoff.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {
    }

    pageComponent: Rectangle {
        id: background
        color: "blue"
        anchors.fill: parent
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
            property alias skyColor: background.color
            property alias modelTable: modelTable.model
            property int cellSize: Math.min((parent.height - 200) / 5,
                                            (parent.width - 40) / 5)
        }

        onStart: {
            Activity.start(items)
        }
        onStop: {
            Activity.stop()
        }

        /* The background picture */
        Image {
            source: Activity.url + "back.svg"
            fillMode: Image.Stretch
            anchors.fill: parent
        }

        /* Tux */
        BarButton {
            id: tux
            fillMode: Image.PreserveAspectFit
            source: Activity.url + "tux.svgz"
            sourceSize.height: items.cellSize * 3
            visible: true
            anchors {
                right: parent.right
                rightMargin: 20
                bottom: parent.bottom
                bottomMargin: 20
            }
            onClicked: Activity.solve()
        }

        /* The grid */
        Rectangle {
            anchors.fill: grid
            anchors.margins: items.cellSize / -10
            color: "lightgrey"
            opacity: 0.6
            border {
                color: "black"
                width: items.cellSize / 20
            }
            radius: items.cellSize / 10
        }

        Grid {
            id: grid
            anchors.top: parent.top
            anchors.topMargin: (parent.height - height - items.bar.height) / 2
            anchors.horizontalCenter: parent.horizontalCenter
            rows: 5
            columns: 5
            spacing: items.cellSize / 10

            Repeater {
                id: modelTable
                model: Activity.getTable()
                Rectangle {
                    color: "transparent"
                    height: items.cellSize
                    width: items.cellSize
                    border {
                        color: modelData > 1 ? "red" : "transparent"
                        width: items.cellSize / 40
                    }
                    radius: items.cellSize / 10
                    Image {
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectFit
                        source: Activity.url + (modelData % 2
                                                === 0 ? "off.svg" : "../lightsoff.svg")
                        sourceSize.height: items.cellSize

                        MouseArea {
                            anchors.fill: parent
                            onClicked: Activity.switchLight(index)
                        }
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
            content: BarEnumContent {
                value: help | home | previous | next
            }
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
