/* GCompris - tangram.qml
 *
 * Copyright (C) 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Yves Combe /  Philippe Banwarth (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
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
import QtGraphicalEffects 1.0
import GCompris 1.0

import "../../core"
import "tangram.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        signal start
        signal stop
        fillMode: Image.PreserveAspectCrop
        source: Activity.url + "background.svg"
        sourceSize.width: parent.width


        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        onWidthChanged: {
            for(var i=0; i < itemList.model; i++) {
                itemList.itemAt(i).positionMe()
            }
        }

        onHeightChanged: {
            for(var i=0; i < itemList.model; i++) {
                itemList.itemAt(i).positionMe()
            }
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias itemListModel: itemList.model
            property Item selected
        }

        onStart: {
            Activity.start(items)
        }
        onStop: { Activity.stop() }

        MouseArea {
            id: rotateArea
            anchors.fill: parent
            enabled: items.selected
            property double prevRotation: 0
            onPositionChanged: {
                // Calc the angle touch / object center
                var rotation = Activity.getAngleOfLineBetweenTwoPoints(
                            items.selected.x + items.selected.width / 2, items.selected.y + items.selected.height / 2,
                            mouseX, mouseY) * (180 / Math.PI)
                if(prevRotation) {
                    items.selected.rotation += rotation - prevRotation
                }
                prevRotation = rotation
            }
            onReleased: {
                prevRotation = 0
                // Force a modulo 5 rotation
                items.selected.rotation = items.selected.rotation + (items.selected.rotation + 2.5) % 5
            }
        }

        DropArea {
            id: dropableArea
            anchors.left: background.left
            anchors.bottom: background.bottom
            width: background.width
            height: background.height
        }

        Repeater {
            id: itemList
            Image {
                id: tans
                // Let the items comes from random side of the screen
                x: Math.random() > 0.5 ? - width : background.width
                y: Math.random() > 0.5 ? - height : background.height
                source: Activity.url + 'triangle.svg'
                sourceSize.width: 200
                z: 0

                property real xRatio
                property real yRatio
                property bool selected: false

                Component.onCompleted: {
                    xRatio = Activity.getRandomInt(10, background.width - 220 * ApplicationInfo.ratio) /
                            (background.width  - 220 * ApplicationInfo.ratio)
                    yRatio = Activity.getRandomInt(10, background.height - 180 * ApplicationInfo.ratio) /
                            (background.height - 180 * ApplicationInfo.ratio)
                    positionMe()
                }

                function positionMe() {
                    x = (background.width - 220 * ApplicationInfo.ratio) * xRatio
                    y = (background.height- 180 * ApplicationInfo.ratio) * yRatio
                }

                Drag.active: dragArea.drag.active
                Drag.hotSpot.x : width / 2
                Drag.hotSpot.y : height / 2

                MouseArea {
                    id: dragArea
                    anchors.fill: parent
                    drag.target: parent
                    onPressed: {
                        parent.z = ++Activity.globalZ
                        if(items.selected)
                            items.selected.selected = false
                        items.selected = tans
                        parent.selected = true
                    }
                    onReleased: parent.Drag.drop()
                }

                Colorize {
                    id: color
                    anchors.fill: parent
                    source: parent
                    hue: 0.6
                    lightness: -0.2
                    saturation: 0.5
                    opacity: parent.selected ? 1 : 0
                }
                Behavior on x {
                    PropertyAnimation  {
                        duration: 2000
                        easing.type: Easing.InOutQuad
                    }
                }
                Behavior on y {
                    PropertyAnimation  {
                        duration: 2000
                        easing.type: Easing.InOutQuad
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
