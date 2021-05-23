/* GCompris - tangram.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Yves Combe /  Philippe Banwarth (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9
import GCompris 1.0

import "../../core"
import "tangram.js" as Activity
import "dataset.js" as Dataset
import "."

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property var dataset: Dataset
    property string resourceUrl: "qrc:/gcompris/src/activities/tangram/resource/"

    Keys.onPressed: Activity.processPressedKey(event)

    pageComponent: Item {
        id: background
        anchors.fill: parent

        property bool horizontalLayout: background.width >= background.height
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
            source: activity.resourceUrl + "tangram/background.svg"
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
            visible: items.editionMode /* debug to see the play area */
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
            property Item selectedItem
            property var currentTans: dataset.dataset[bar.level - 1]
            property int numberOfLevel: dataset.dataset.length
            property bool editionMode: false
        }

        onStart: {
            Activity.start(items)
        }
        onStop: { Activity.stop() }

        Image {
            id: bgData
            source: items.currentTans.bg ? activity.resourceUrl + items.currentTans.bg : ''
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
                    source: activity.resourceUrl + "m-" + modelData.img
                    sourceSize.width: modelData.width * background.playWidth
                    sourceSize.height: modelData.height * background.playWidth
                    z: index
                    rotation: modelData.rotation
                    mirror: modelData.flipping ? true : false
                    visible: true
                }
            }
        }

        Repeater {
            id: userList
            model: items.currentTans.pieces
            Item {
                id: tansItem
                x: background.playX + background.playWidth * xRatio - tans.width / 2
                y: background.playY + background.playHeight * yRatio - tans.height / 2
                width: tans.width
                height: tans.height

                z: 100 + index
                property real xRatio: !items.editionMode ? modelData.initX : modelData.x
                property real yRatio: !items.editionMode ? modelData.initY : modelData.y
                property bool selected: false
                property int animDuration: 48
                property bool flippable: modelData.flippable
                property bool rotable: modelData.moduloRotation != 0

                property alias tans: tans
                rotation: !items.editionMode ? modelData.initRotation : modelData.rotation
                property alias mirror: tans.mirror
                function restoreZindex() {
                    z = 100 + index
                }

                onSelectedChanged: {
                    if(!selected)
                        restoreZindex()
                }

                function positionToTans() {
                    return [
                    (x + width / 2 - background.playX) / background.playWidth,
                    (y + height / 2 - background.playY) / background.playHeight
                    ]
                }

                // After a drag the [x, y] positions are addressed directly breaking our
                // binding. Call me to reset the binding.
                function restoreBindings() {
                    x = Qt.binding(function() { return background.playX + background.playWidth * xRatio - width / 2})
                    y = Qt.binding(function() { return background.playY + background.playHeight * yRatio - height / 2 })
                }

                Image {
                    id: tans
                    mirror: !items.editionMode ? modelData.initFlipping : modelData.flipping
                    source: activity.resourceUrl + modelData.img
                    sourceSize.width: modelData.width * background.playWidth
                    sourceSize.height: modelData.height * background.playWidth
                }
                // Manage to return a base rotation as it was provided in the model
                function rotationToTans() {
                    // moduloRotation == 0 to disable rotation, assume 360 in this case
                    var mod = modelData.moduloRotation ? modelData.moduloRotation : 360
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

                MouseArea {
                    id: dragArea
                    anchors.fill: parent
                    drag.target: parent
                    onPressed: {
                        tansItem.z = 200
                        if(items.selectedItem && items.selectedItem != tansItem)
                        items.selectedItem.selected = false
                        items.selectedItem = tansItem
                        tansItem.selected = true
                        background.checkWin()
                    }
                    onDoubleClicked: {
                        flipMe()
                    }
                    onReleased: {
                        parent.Drag.drop()
                        var posTans = positionToTans()
                        var closest = Activity.getClosest(posTans)
                        if(closest && !items.editionMode) {
                            tansItem.xRatio = closest[0]
                            tansItem.yRatio = closest[1]
                        } else {
                            tansItem.xRatio = posTans[0]
                            tansItem.yRatio = posTans[1]
                        }
                        tansItem.restoreBindings()
                        background.checkWin()
                    }
                }

                Image {
                    id: rotateButton
                    source: "qrc:/gcompris/src/core/resource/bar_reload.svg"
                    x: - width
                    y: parent.height / 2 - height / 2
                    visible: tansItem.selected && tansItem.rotable
                    sourceSize.width: 40 * ApplicationInfo.ratio
                    z: tansItem.z + 1

                    RotateMouseArea {}
                }

                Image {
                    id: flip
                    source: "qrc:/gcompris/src/activities/tangram/resource/tangram/flip.svg"
                    x: parent.width / 2 - width / 2
                    y: parent.height - height / 2
                    visible: tansItem.selected && tansItem.flippable
                    sourceSize.width: 40 * ApplicationInfo.ratio
                    z: tansItem.z + 1

                    MouseArea {
                        anchors.fill: parent
                        onClicked: tansItem.flipMe()
                    }
                }

                Behavior on x {
                    PropertyAnimation  {
                        duration: animDuration
                        easing.type: Easing.InOutQuad
                    }
                }
                Behavior on y {
                    PropertyAnimation  {
                        duration: animDuration
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

        // We use a timer here because we have to check only once the potential
        // animation are over
        Timer {
            id: checkWinTimer
            interval: 200
            property bool alreadyStarted: false
            onTriggered: {
                if(Activity.check() && !alreadyStarted) {
                    alreadyStarted = true
                    if(!items.editionMode)
                        bonus.good('flower')
                }
            }
        }

        function checkWin() {
            checkWinTimer.start()
        }

        GCText {
            anchors.top: parent.top
            anchors.left: parent.left
            text: items.currentTans.name
            visible: items.editionMode
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        File {
            id: file
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level |
                                             (items.editionMode ? repeat : 0) }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onRepeatClicked: file.write(Activity.toDataset(), "/tmp/" + items.currentTans.name)
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
