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
            for(var i=0; i < modelList.model; i++) {
                modelList.itemAt(i).positionMe()
            }
        }

        onHeightChanged: {
            for(var i=0; i < modelList.model; i++) {
                modelList.itemAt(i).positionMe()
            }
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias modelListModel: modelList.model
            property alias userList: userList
            property alias userListModel: userList.model
            property Item selected
            property double tansRatio: 2
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
                // Force a modulo 45 rotation
                items.selected.rotation = Math.floor((items.selected.rotation + 45 / 2) / 45) * 45
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
            id: modelList
            Image {
                id: tansModel
                // Let the items comes from random side of the screen
                x: Math.random() > 0.5 ? - width : background.width
                y: Math.random() > 0.5 ? - height : background.height
                mirror: modelData[1]
                rotation: modelData[4]
                source: Activity.url + modelData[0] + '.svg'
                sourceSize.width: 100 * items.tansRatio
                z: 0

                property real xRatio: modelData[2]
                property real yRatio: modelData[3]
                property bool selected: false

                Component.onCompleted: {
                    positionMe()
                }

                function positionMe() {
                    x = background.width * xRatio / 7
                    y = background.height * yRatio / 8
                }

                Colorize {
                    anchors.fill: parent
                    source: parent
                    hue: 0.5
                    lightness: -0.2
                    saturation: 0
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


        GCText {
            id: text
            x: 100
            y: bar.y - 50
        }

        Repeater {
            id: userList
            Image {
                id: tans
                // Let the items comes from random side of the screen
                x: Math.random() > 0.5 ? - width : background.width
                y: Math.random() > 0.5 ? - height : background.height
                mirror: modelData[1]
                rotation: modelData[4]
                source: Activity.url + modelData[0] + '.svg'
                sourceSize.width: 100 * items.tansRatio
                z: 0

                property real xRatio: modelData[2]
                property real yRatio: modelData[3]
                property bool selected: false
                property int animDuration: 3000

                Component.onCompleted: {
                    positionMe()
                }

                function positionMe() {
                    x = background.width * xRatio / 7
                    y = background.height * yRatio / 8
                }

                function positionToTans() {
                    return [
                                x / (background.width / 7),
                                y / (background.height / 8)
                            ]
                }

                // Manage to return a base rotation as it was provided in the model
                function rotationToTans() {
                    var mod = Activity.pieceRules[modelData[0]][0]
                    var flipable = Activity.pieceRules[modelData[0]][1]
                    if(flipable || !mirror)
                        return rotation >= 0 ? rotation % mod : (360 + rotation) % mod
                    else
                        // It flipping but model is not flipping sensitive we have to rotate accordingly
                        return rotation >= 0 ? (rotation - (mod - 90)) % mod : (360 + rotation - (mod - 90)) % mod
                }

                // Return all the positions as we got it from a tans definition
                function asTans() {
                    return [modelData[0],
                            Activity.pieceRules[modelData[0]][1] ? mirror : 0,
                            positionToTans()[0], positionToTans()[1],
                            rotationToTans()]
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
                        var win = Activity.check()
                        if(win)
                            text.text = "win"
                        else
                            text.text = "loose"
                    }
                    onDoubleClicked: parent.mirror = !parent.mirror
                    onReleased: {
                        tans.animDuration = 30
                        parent.Drag.drop()
                        var closest = Activity.getClosest(positionToTans())
                        if(closest) {
                            console.log('closest found', closest[0], closest[1])
                            tans.xRatio = closest[0]
                            tans.yRatio = closest[1]
                            tans.positionMe()
                        }
                    }
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
                        duration: tans.animDuration
                        easing.type: Easing.InOutQuad
                    }
                }
                Behavior on y {
                    PropertyAnimation  {
                        duration: tans.animDuration
                        easing.type: Easing.InOutQuad
                    }
                }
            }

            // Return the tans model of all the user tans
            function asTans() {
                var tans = []
                for(var i = 0; i < userList.count; i++) {
                    tans.push(userList.itemAt(i).asTans())
                }
                return tans
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
