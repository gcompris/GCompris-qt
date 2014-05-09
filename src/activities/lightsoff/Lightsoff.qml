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
            property alias modelTable: modelTable
            property int nbCell: 5
            property int cellSize: Math.min(
                                       (parent.height - 200) / items.nbCell,
                                       (parent.width - 40) / items.nbCell)
            property int nbCelToWin: 0
        }

        onStart: {
            Activity.start(items)
        }
        onStop: {
            Activity.stop()
        }

        /* The background picture */
        Image {
            source: Activity.url + "back.svgz"
            fillMode: Image.Stretch
            anchors.fill: parent
            z: 2
        }
        Image {
            source: Activity.url + "building.svgz"
            fillMode: Image.PreserveAspectFit
            anchors.fill: gridarea
            anchors.margins: -3 * items.cellSize
            z: 2
        }

        /* The sun */
        Image {
            id: sun
            source: Activity.url + "sun.svgz"
            sourceSize.height: items.cellSize * 2 * items.nbCell / 5
            anchors {
                left: parent.left
                leftMargin: 80
                bottom: parent.bottom
                bottomMargin: parent.height / 3 + 2 / 3 * parent.height
                              * items.nbCelToWin / (items.nbCell * items.nbCell)
            }
            z: 1
            Behavior on anchors.bottomMargin {
                PropertyAnimation {
                    duration: 1000
                }
            }
        }

        /* Tux */
        BarButton {
            id: tux
            fillMode: Image.PreserveAspectFit
            source: Activity.url + "tux.svgz"
            sourceSize.height: items.cellSize * 3 * items.nbCell / 5
            z: 3
            visible: true
            anchors {
                right: parent.right
                rightMargin: 20
                left: grid.right
                leftMargin: 20
                bottom: parent.bottom
                bottomMargin: 20
            }
            onClicked: Activity.solve()
        }

        /* The grid */
        Rectangle {
            id: gridarea
            anchors.fill: grid
            anchors.margins: items.cellSize / -10
            color: "lightgrey"
            opacity: 0.6
            z: 4
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
            rows: items.nbCell
            columns: items.nbCell
            spacing: items.cellSize / 10
            z: 5

            ListModel {
                id: modelTable
            }

            Repeater {
                model: modelTable
                Rectangle {
                    color: "transparent"
                    height: items.cellSize
                    width: items.cellSize
                    border {
                        color: soluce === 1 ? "red" : "transparent"
                        width: items.cellSize / 40
                    }
                    radius: items.cellSize / 10

                    BarButton {
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectFit
                        source: Activity.url + "../lightsoff.svgz"
                        opacity: lighton === 1 ? 1 : 0
                        z: lighton === 1 ? 11 : 10
                        sourceSize.height: items.cellSize
                        onClicked: {
                            Activity.switchLight(index)
                        }
                        Behavior on opacity {
                            PropertyAnimation {
                                duration: 200
                            }
                        }
                        visible: true
                    }

                    BarButton {
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectFit
                        source: Activity.url + "off.svgz"
                        opacity: lighton === 1 ? 0 : 1
                        z: lighton === 1 ? 10 : 11
                        sourceSize.height: items.cellSize
                        onClicked: {
                            Activity.switchLight(index)
                        }
                        Behavior on opacity {
                            PropertyAnimation {
                                duration: 200
                            }
                        }
                        visible: true
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
