/* GCompris - tangram.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Yves Combe /  Philippe Banwarth (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (layout improvements and cleaning)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
pragma ComponentBehavior: Bound
import QtQuick
import core 1.0

import "../../core"
import "tangram.js" as Activity
import "dataset.js" as Dataset

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property var dataset: Dataset.dataset
    property string resourceUrl: "qrc:/gcompris/src/activities/tangram/resource/"

    Keys.onPressed: (event) => { Activity.processPressedKey(event) }

    pageComponent: Rectangle {
        id: activityBackground
        color: "#b9d3ff"

        property int playX: playArea.x
        property int playY: playArea.y
        property int playWidth: Math.min(layoutArea.width, layoutArea.height)
        property double playRatio: playWidth / 1000

        signal start
        signal stop

        Item {
            id: layoutArea
            anchors.fill: parent
            anchors.margins: GCStyle.baseMargins
            anchors.bottomMargin: bar.height * 1.2
        }

        /* In order to accept any screen ratio the play area is always a 1000x1000 square * playRatio
         * and is centered in the layoutArea
         */
        Rectangle {
            id: playArea
            width: activityBackground.playWidth
            height: activityBackground.playWidth
            anchors.centerIn: layoutArea
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
            property alias activityBackground: activityBackground
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias modelListModel: modelList.model
            property alias userList: userList
            property alias userListModel: userList.model
            property Item selectedItem
            property var currentTans: activity.dataset[items.currentLevel]
            property int numberOfLevel: activity.dataset.length
            property bool editionMode: false
        }

        onStart: {
            Activity.start(items)
        }
        onStop: {
            checkWinTimer.stop()
            Activity.stop()
        }

        Image {
            id: bgData
            source: items.currentTans.bg ? activity.resourceUrl + items.currentTans.bg : ''
            sourceSize.width: width
            sourceSize.height: width
            width: playArea.width
            height: width
            anchors.centerIn: playArea
        }

        RotateMouseArea {
            enabled: items.selectedItem && items.selectedItem.selected && items.selectedItem.rotable
            selectedItem: items.selectedItem
        }

        DropArea {
            id: dropableArea
            anchors.left: activityBackground.left
            anchors.bottom: activityBackground.bottom
            width: activityBackground.width
            height: activityBackground.height
        }

        Repeater {
            id: modelList
            model: items.currentTans.pieces
            Item {
                id: currentPiece
                anchors.fill: activityBackground
                required property var modelData
                required property int index
                Image {
                    id: tansModel
                    x: activityBackground.playX + activityBackground.playWidth * currentPiece.modelData.x - width / 2
                    y: activityBackground.playY + activityBackground.playWidth * currentPiece.modelData.y - height / 2
                    source: activity.resourceUrl + "m-" + currentPiece.modelData.img
                    sourceSize.width: currentPiece.modelData.width * activityBackground.playWidth
                    sourceSize.height: currentPiece.modelData.height * activityBackground.playWidth
                    z: currentPiece.index
                    rotation: currentPiece.modelData.rotation
                    mirror: currentPiece.modelData.flipping ? true : false
                    visible: true
                }
            }
        }

        Repeater {
            id: userList
            model: items.currentTans.pieces
            Item {
                id: tansItem
                required property var modelData
                required property int index
                x: activityBackground.playX + activityBackground.playWidth * xRatio - tans.width / 2
                y: activityBackground.playY + activityBackground.playWidth * yRatio - tans.height / 2
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
                    (x + width / 2 - activityBackground.playX) / activityBackground.playWidth,
                    (y + height / 2 - activityBackground.playY) / activityBackground.playWidth
                    ]
                }

                // After a drag the [x, y] positions are addressed directly breaking our
                // binding. Call me to reset the binding.
                function restoreBindings() {
                    x = Qt.binding(function() { return activityBackground.playX + activityBackground.playWidth * xRatio - width / 2})
                    y = Qt.binding(function() { return activityBackground.playY + activityBackground.playWidth * yRatio - height / 2 })
                }

                Image {
                    id: tans
                    mirror: !items.editionMode ? tansItem.modelData.initFlipping : tansItem.modelData.flipping
                    source: activity.resourceUrl + tansItem.modelData.img
                    sourceSize.width: tansItem.modelData.width * activityBackground.playWidth
                    sourceSize.height: tansItem.modelData.height * activityBackground.playWidth
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
                    activityBackground.checkWin()
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
                        activityBackground.checkWin()
                    }
                    onDoubleClicked: {
                        tansItem.flipMe()
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
                        activityBackground.checkWin()
                    }
                }

                Image {
                    id: rotateButton
                    source: "qrc:/gcompris/src/core/resource/bar_reload.svg"
                    x: - width
                    y: parent.height / 2 - height / 2
                    visible: tansItem.selected && tansItem.rotable
                    width: 40 * ApplicationInfo.ratio
                    sourceSize.width: width
                    fillMode: Image.PreserveAspectFit
                    z: tansItem.z + 1

                    RotateMouseArea {
                        enabled: items.selectedItem && items.selectedItem.selected && items.selectedItem.rotable
                        selectedItem: items.selectedItem
                    }
                }

                Image {
                    id: flip
                    source: "qrc:/gcompris/src/activities/tangram/resource/tangram/flip.svg"
                    x: parent.width / 2 - width / 2
                    y: parent.height - height / 2
                    visible: tansItem.selected && tansItem.flippable
                    width: 40 * ApplicationInfo.ratio
                    sourceSize.width: width
                    fillMode: Image.PreserveAspectFit
                    z: tansItem.z + 1

                    MouseArea {
                        anchors.fill: parent
                        onClicked: tansItem.flipMe()
                    }
                }

                Behavior on x {
                    PropertyAnimation  {
                        duration: tansItem.animDuration
                        easing.type: Easing.InOutQuad
                    }
                }
                Behavior on y {
                    PropertyAnimation  {
                        duration: tansItem.animDuration
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
            onClose: activity.home()
        }

        File {
            id: file
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level |
                                             (items.editionMode ? repeat : 0) }
            onHelpClicked: {
                activity.displayDialog(dialogHelp)
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
