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
import "."

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
            property Item selectedITem
            property var currentTans: Activity.dataset[bar.level - 1]
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
            Item {
                anchors.fill: background
                Image {
                    id: tansModel
                    x: background.playX + background.playWidth * modelData.x - width / 2
                    y: background.playY + background.playHeight * modelData.y - height / 2
                    source: Activity.url + modelData.img
                    sourceSize.width: modelData.width * background.playWidth
                    sourceSize.height: modelData.height * background.playWidth
                    z: index
                    visible: false
                }
                Rectangle {
                    id: mask
                    anchors.fill: tansModel
                    color: '#CCC'
                    visible: false
                }
                OpacityMask {
                    anchors.fill: tansModel
                    source: mask
                    maskSource: tansModel
                    rotation: modelData.rotation
                    opacity: modelData.opacity
                    transform: Scale {
                        origin.x: modelData.width * background.playWidth / 2
                        xScale: modelData.flipping ? -1 : 1
                    }
                }
            }
        }

        Repeater {
            id: userList
            model: items.currentTans.pieces
            Image {
                id: tans
                x: background.playX + background.playWidth * xRatio - width / 2
                y: background.playY + background.playHeight * yRatio - height / 2
                mirror: modelData.initFlipping
                rotation: modelData.initRotation
                source: Activity.url + modelData.img
                sourceSize.width: modelData.width * background.playWidth
                sourceSize.height: modelData.height * background.playWidth
                z: 100 + index

                property real xRatio: modelData.initX
                property real yRatio: modelData.initY
                property bool selected: false
                property int animDuration: 48
                property bool flippable: modelData.flippable

                // After a drag the [x, y] positions are adressed directly breaking our
                // binding. Call me to reset the binding.
                function restoreBindings() {
                    x = Qt.binding(function() { return background.playX + background.playWidth * xRatio - width / 2})
                    y = Qt.binding(function() { return background.playY + background.playHeight * yRatio - height / 2 })
                }

                function restoreZindex() {
                    z = 100 + index
                }

                function positionToTans() {
                    return [
                                (x + width / 2 - background.playX) / background.playWidth,
                                (y + height / 2 - background.playY) / background.playHeight
                            ]
                }

                // Manage to return a base rotation as it was provided in the model
                function rotationToTans() {
                    var mod = modelData.moduloRotation
                    if(modelData.flipable || modelData.flipping || !mirror)
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

                function flipMe() {
                    if(flippable)
                        mirror = !mirror
                    background.checkWin()
                }

                Drag.active: dragArea.drag.active
                Drag.hotSpot.x : width / 2
                Drag.hotSpot.y : height / 2

                onSelectedChanged: {
                    if(!selected)
                        tans.restoreZindex()
                }

                MouseArea {
                    id: dragArea
                    anchors.fill: parent
                    drag.target: parent
                    onPressed: {
                        parent.z = 200
                        if(items.selectedITem && items.selectedITem != tans)
                            items.selectedITem.selected = false
                        items.selectedITem = tans
                        parent.selected = true
                        background.checkWin()
                    }
                    onDoubleClicked: {
                        flipMe()
                    }
                    onReleased: {
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

                Image {
                    id: rotateButton
                    source: "qrc:/gcompris/src/core/resource/bar_reload.svg"
                    x: - width
                    y: parent.height / 2 - height / 2
                    visible: parent.selected
                    sourceSize.width: 40 * ApplicationInfo.ratio
                    z: parent.z + 1

                    RotateMouseArea {}
                }

                Image {
                    id: flip
                    source: "qrc:/gcompris/src/activities/tangram/resource/tangram/flip.svg"
                    x: parent.width / 2 - width / 2
                    y: parent.height - height / 2
                    visible: parent.selected && parent.flippable
                    sourceSize.width: 40 * ApplicationInfo.ratio
                    z: parent.z + 1

                    MouseArea {
                        anchors.fill: parent
                        onClicked: tans.flipMe()
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

        // We use a timere here because we have to check only once the potential
        // animation are over
        Timer {
            id: checkWinTimer
            interval: 200
            property bool alreadyStarted: false
            onTriggered: {
                if(Activity.check() && !alreadyStarted) {
                    alreadyStarted = true
                    bonus.good('flower')
                }
            }
        }

        function checkWin() {
            checkWinTimer.start()
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
            interval: 1600
            Component.onCompleted: win.connect(nextLevel)

            function nextLevel() {
                checkWinTimer.alreadyStarted = false
                Activity.nextLevel()
            }
        }
    }

}
