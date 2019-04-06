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
*   along with this program; if not, see <https://www.gnu.org/licenses/>.
*/
import QtQuick 2.6

import "../../core"
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

        property bool keyNavigationVisible: false

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
            property bool blockClicks: false
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

        Keys.enabled: !items.blockClicks
        Keys.onPressed: {
            background.keyNavigationVisible = true
            if (event.key === Qt.Key_Left)
                grid.moveCurrentIndexLeft()
            if (event.key === Qt.Key_Right)
                grid.moveCurrentIndexRight()
            if (event.key === Qt.Key_Down)
                grid.moveCurrentIndexDown()
            if (event.key === Qt.Key_Up)
                grid.moveCurrentIndexUp()
            if (event.key === Qt.Key_Space || event.key === Qt.Key_Enter || event.key === Qt.Key_Return)
                Activity.windowPressed(grid.currentIndex)
        }

        /* The background picture */
        Image {
            source: Activity.url + "back.svg"
            anchors.bottom: parent.bottom
            fillMode: Image.TileHorizontally
            sourceSize.height: (parent.height - (gridarea.y + gridarea.height)) * 1.2
            z: 2
        }
        Image {
            source: Activity.url + "building.svg"
            fillMode: Image.PreserveAspectFit
            anchors.fill: gridarea
            anchors.margins: -1 * Math.ceil(items.nbCell / 2) * items.cellSize
            z: 2
        }
        Image {
            source: Activity.url + "front.svg"
            anchors.bottom: parent.bottom
            fillMode: Image.TileHorizontally
            sourceSize.height: 20 + tux.height * 0.5
            z: 999
        }

        /* The sun */
        Image {
            id: sun
            source: Activity.url + "sun.svg"
            sourceSize.height: items.cellSize * 2 * items.nbCell / 5
            anchors {
                left: parent.left
                leftMargin: 10
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
            source: Activity.url + "tux.svg"
            sourceSize.width: parent.width - grid.width < 200 ?
                                  bar.height * 1.2 :
                                  Math.min((parent.width - grid.width - 40) / 2, 150)
            z: 3
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
            id: gridarea
            anchors.fill: grid
            anchors.margins: items.cellSize / -10
            opacity: 0
            z: 4
        }

        GridView {
            id: grid
            anchors.top: parent.top
            anchors.topMargin: (parent.height - height) / 6
            anchors.horizontalCenter: parent.horizontalCenter
            width: items.nbCell * items.cellSize
            height: width
            cellWidth: items.cellSize
            cellHeight: items.cellSize
            z: 5

            ListModel {
                id: modelTable
            }

            model: modelTable

            delegate: Rectangle {
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
                    source: Activity.url + "off.svg"
                    sourceSize.height: items.cellSize
                    mouseArea.hoverEnabled: !items.blockClicks
                    mouseArea.enabled: !items.blockClicks
                    onClicked: Activity.windowPressed(index)
                    visible: true
                    Image {
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectFit
                        source: Activity.url + "on.svg"
                        opacity: lighton === 1 ? 1 : 0
                        sourceSize.height: items.cellSize
                        Behavior on opacity {
                            PropertyAnimation {
                                duration: 200
                            }
                        }
                    }
                }
            }
            
            interactive: false
            keyNavigationWraps: true
            highlightFollowsCurrentItem: true
            highlight: Rectangle {
                width: items.cellSize
                height: items.cellSize
                color: "#AAFFFFFF"
                radius: items.cellSize / 10
                visible: background.keyNavigationVisible
                Behavior on x { SpringAnimation { spring: 2; damping: 0.2 } }
                Behavior on y { SpringAnimation { spring: 2; damping: 0.2 } }
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent {
                value: help | home | level | reload
            }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onReloadClicked: Activity.initLevel()
        }

        Bonus {
            id: bonus
            onStop: items.blockClicks = false
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }
}
