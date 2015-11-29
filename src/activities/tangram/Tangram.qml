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

    pageComponent: Item {
        id: background
        anchors.fill: parent

        property bool horizontalLayout: background.width > background.height
        property int playX: (activity.width - playWidth) / 2
        property int playY: (activity.height - playHeight) / 2
        property int playWidth: horizontalLayout ? activity.height : activity.width
        property int playHeight: playWidth
        property double playRatio: playWidth / 1000

        signal start
        signal stop

        /* In order to accept any screen ratio the play area is always a 1000x1000
         * square and is centered in a big background image that is 2000x2000
         */

        Image {
            id: bg
            source: Activity.url + "tangram/background.svg"
            sourceSize.width: 2000 * ApplicationInfo.ratio
            sourceSize.height: 2000 * ApplicationInfo.ratio
            width: 2000 * background.playRatio
            height: width
            anchors.centerIn: parent
        }

        Rectangle {
            width: background.playWidth
            height: background.playHeight
            anchors.centerIn: parent
            border.width: 2
            border.color: "black"
            color: "transparent"
            visible: true /* debug to see the play area */
        }

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
            property alias modelListModel: modelList.model
            property alias userList: userList
            property alias userListModel: userList.model
            property Item selected
            property var currentTans: Activity.dataset[bar.level - 1]

            onSelectedChanged: {
                if(selected) {
                    if(selected.flippable)
                        flip.display()
                    else
                        flip.visible = false
                    rotateButton.display()
                } else {
                    flip.visible = false
                    rotateButton.visible = false
                }
            }
        }

        onStart: {
            Activity.start(items)
        }
        onStop: { Activity.stop() }

        Image {
            id: bgData
            source: Activity.url + items.currentTans.bg
            sourceSize.width: 1000 * background.playRatio
            sourceSize.height: 1000 * background.playRatio
            width: 1000 * background.playRatio
            height: width
            anchors.centerIn: parent
        }

        RotateMouseArea {}

        DropArea {
            id: dropableArea
            anchors.left: background.left
            anchors.bottom: background.bottom
            width: background.width
            height: background.height
        }

        Repeater {
            id: modelList
            model: items.currentTans.pieces
            Image {
                id: tansModel
                x: background.playX + background.playWidth * modelData.x
                y: background.playY + background.playHeight * modelData.y
                mirror: modelData.flipping
                rotation: modelData.rotation
                source: Activity.url + modelData.img
                sourceSize.width: modelData.width * background.playWidth
                sourceSize.height: modelData.height * background.playWidth
                z: index
                opacity: modelData.opacity

                Colorize {
                    anchors.fill: parent
                    source: parent
                    hue: 0
                    lightness: -0.75
                    saturation: 1
                }
            }
        }


        GCText {
            id: text
            x: 100
            y: 20
        }

        Image {
            id: rotateButton
            source: "qrc:/gcompris/src/core/resource/bar_reload.svg"
            visible: false
            sourceSize.width: 40 * ApplicationInfo.ratio
            z: 300

            function display() {
                visible = Qt.binding(function() { return items.selected.selection })
                x = Qt.binding(function() { return items.selected.x - width / 2 })
                y = Qt.binding(function() { return items.selected.y + items.selected.height / 2 - height / 2 })
            }

            RotateMouseArea {
                anchors.fill: parent.parent
            }
        }

        Image {
            id: flip
            source: "qrc:/gcompris/src/activities/tangram/resource/tangram/flip.svg"
            visible: false
            sourceSize.width: 40 * ApplicationInfo.ratio
            z: 300

            function display() {
                visible = Qt.binding(function() { return items.selected.selection })
                x = Qt.binding(function() { return items.selected.x + items.selected.width / 2 - width / 2 })
                y = Qt.binding(function() { return items.selected.y + items.selected.height - height / 2 })
            }

            MouseArea {
                anchors.fill: parent
                onClicked: items.selected.flip()
            }
        }

        Repeater {
            id: userList
            model: items.currentTans.pieces
            Image {
                id: tans
                x: background.playX + background.playWidth * xRatio
                y: background.playY + background.playHeight * yRatio
                mirror: modelData.initFlipping
                rotation: modelData.initRotation
                source: Activity.url + modelData.img
                sourceSize.width: modelData.width * background.playWidth
                sourceSize.height: modelData.height * background.playWidth
                z: 100 + index

                property real xRatio: modelData.initX
                property real yRatio: modelData.initY
                property bool selected: false
                property int animDuration: 1000
                property bool selection: false
                property bool flippable: modelData.flippable

                // After a drag the [x, y] positions are adressed directly breaking our
                // binding. Call me to reset the binding.
                function restoreBindings() {
                    x = Qt.binding(function() { return background.playX + background.playWidth * xRatio })
                    y = Qt.binding(function() { return background.playY + background.playHeight * yRatio })
                }

                function restoreZindex() {
                    z = 100 + index
                }

                function positionToTans() {
                    return [
                                (x - background.playX) / background.playWidth,
                                (y - background.playY) / background.playHeight
                            ]
                }

                // Manage to return a base rotation as it was provided in the model
                function rotationToTans() {
                    var mod = modelData.moduloRotation
                    if(modelData.flipable || !mirror)
                        return rotation >= 0 ? rotation % mod : (360 + rotation) % mod
                    else
                        // It flipping but model is not flipping sensitive we have to rotate accordingly
                        return rotation >= 0 ? (rotation - (mod - 90)) % mod : (360 + rotation - (mod - 90)) % mod
                }

                // Return all the positions as we got it from a tans definition
                function asTans() {
                    return {
                        'img': modelData.img,
                        'flipping': mirror,
                         'x': positionToTans()[0],
                         'y': positionToTans()[1],
                         'rotation': rotationToTans()
                    }
                }

                function flip() {
                    if(flippable)
                        mirror = !mirror
                    background.checkWin()
                }

                Drag.active: dragArea.drag.active
                Drag.hotSpot.x : width / 2
                Drag.hotSpot.y : height / 2

                MouseArea {
                    id: dragArea
                    anchors.fill: parent
                    drag.target: parent
                    onPressed: {
                        parent.z = 200
                        if(parent.selection) {
                            parent.selection = false
                            background.checkWin()
                            return
                        }
                        if(items.selected)
                            items.selected.selection = false
                        items.selected = tans
                        parent.selection = true
                        background.checkWin()
                    }
                    onDoubleClicked: {
                        flip()
                    }
                    onReleased: {
                        tans.animDuration = 30
                        parent.Drag.drop()
                        var posTans = positionToTans()
                        var closest = Activity.getClosest(posTans)
                        if(closest) {
                            tans.xRatio = closest[0]
                            tans.yRatio = closest[1]
                        } else {
                            tans.xRatio = posTans[0]
                            tans.yRatio = posTans[1]
                        }
                        tans.restoreBindings()
                        tans.restoreZindex()
                        background.checkWin()
                    }
                }

                Colorize {
                    id: color
                    anchors.fill: parent
                    source: parent
                    hue: 0.6
                    lightness: -0.2
                    saturation: 0.5
                    opacity: parent.selection ? 1 : 0
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

        function checkWin() {
            var win = Activity.check()
            if(win)
                text.text = "win"
            else
                text.text = "loose"
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
