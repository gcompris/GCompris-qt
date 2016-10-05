/* GCompris - redraw.qml
 *
 * Copyright (C) 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
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
import GCompris 1.0
import QtGraphicalEffects 1.0
import QtQuick.Window 2.0

import "../../core"
import "redraw.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property bool symmetry: false

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: Activity.url + "background.svg"
        fillMode: Image.PreserveAspectCrop
        sourceSize.width: Math.max(parent.width, parent.height)

        property bool landscape: width > height

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
            property int colorSelector: 0
            property alias userModel: userModel
            property int numberOfColumn
            property int numberOfColor
            property int numberOfLine: targetModelData.length / numberOfColumn
            property alias targetModel: targetModel
            property variant targetModelData
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Keys.onPressed: {
            if(event.key >= Qt.Key_0 && event.key < Qt.Key_0 + items.numberOfColor)
                items.colorSelector = event.key - Qt.Key_0

            if(event.key == Qt.Key_Backspace)
                userModel.clearCurrentItem()
        }
        Keys.onEnterPressed: userModel.paintCurrentItem()
        Keys.onReturnPressed: userModel.paintCurrentItem()
        Keys.onSpacePressed: userModel.paintCurrentItem()
        Keys.onDeletePressed: userModel.clearCurrentItem()
        Keys.onRightPressed: userModel.moveCurrentIndexRight()
        Keys.onLeftPressed: userModel.moveCurrentIndexLeft()
        Keys.onDownPressed: userModel.moveCurrentIndexDown()
        Keys.onUpPressed: userModel.moveCurrentIndexUp()
        // For creating new content, dump the drawing on the console
        Keys.onTabPressed: Activity.dump()

        Row {
            anchors {
                top: parent.top
                right: parent.right
                left: parent.left
                bottom: bar.top
            }
            anchors.margins: 10
            spacing: 20

            // The color selector
            Flickable{
                interactive: true
                width: 70 * ApplicationInfo.ratio
                height: background.height
                boundsBehavior: Flickable.StopAtBounds
                contentHeight: items.numberOfColor * width
                bottomMargin: bar.height
                Column {
                    id: colorSelector
                    Repeater {
                        model: items.numberOfColor
                        Item {
                            width: 70 * ApplicationInfo.ratio
                            height: width
                            Image {
                                id: img
                                source: Activity.url + Activity.colorShortcut[modelData] + ".svg"
                                sourceSize.width: parent.width
                                z: iAmSelected ? 10 : 1

                                property bool iAmSelected: modelData == items.colorSelector

                                states: [
                                    State {
                                        name: "notclicked"
                                        when: !img.iAmSelected && !mouseArea.containsMouse
                                        PropertyChanges {
                                            target: img
                                            scale: 0.8
                                        }
                                    },
                                    State {
                                        name: "clicked"
                                        when: mouseArea.pressed
                                        PropertyChanges {
                                            target: img
                                            scale: 0.7
                                        }
                                    },
                                    State {
                                        name: "hover"
                                        when: mouseArea.containsMouse
                                        PropertyChanges {
                                            target: img
                                            scale: 1.1
                                        }
                                    },
                                    State {
                                        name: "selected"
                                        when: img.iAmSelected
                                        PropertyChanges {
                                            target: img
                                            scale: 1
                                        }
                                    }
                                ]

                                SequentialAnimation {
                                    id: anim
                                    running: img.iAmSelected
                                    loops: Animation.Infinite
                                    alwaysRunToEnd: true
                                    NumberAnimation {
                                        target: img
                                        property: "rotation"
                                        from: 0; to: 10
                                        duration: 200
                                        easing.type: Easing.OutQuad
                                    }
                                    NumberAnimation {
                                        target: img
                                        property: "rotation"
                                        from: 10; to: -10
                                        duration: 400
                                        easing.type: Easing.InOutQuad
                                    }
                                    NumberAnimation {
                                        target: img
                                        property: "rotation"
                                        from: -10; to: 0
                                        duration: 200
                                        easing.type: Easing.InQuad
                                    }
                                }

                                Behavior on scale { NumberAnimation { duration: 70 } }
                                MouseArea {
                                    id: mouseArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: {
                                        activity.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/scroll.wav')
                                        items.colorSelector = modelData
                                    }
                                }
                            }
                            GCText {
                                id: text1
                                anchors.fill: parent
                                text: modelData
                                fontSize: regularSize
                                z: modelData == items.colorSelector ? 12 : 2
                                font.bold: true
                                style: Text.Outline
                                styleColor: "black"
                                color: "white"
                            }
                            DropShadow {
                                anchors.fill: text1
                                cached: false
                                horizontalOffset: 1
                                verticalOffset: 1
                                radius: 8.0
                                samples: 16
                                color: "#80000000"
                                source: text1
                            }
                        }
                    }
                }
            }
            Grid {
                id: drawAndExampleArea
                columns: background.landscape ? 2 : 1
                width: gridWidth
                height: parent.height
                spacing: 10

                property int gridWidth: parent.width - colorSelector.width

                // The drawing area
                Grid {
                    id: drawingArea
                    width: background.landscape ? parent.gridWidth / 2 - parent.spacing * 2 : parent.gridWidth
                    height: background.landscape ? parent.height : parent.height / 2
                    columns: items.numberOfColumn
                    Repeater {
                        id: userModel
                        model: items.targetModelData.length
                        property int currentItem: 0
                        property bool keyNavigation: false

                        function reset() {
                            for(var i=0; i < items.userModel.count; ++i)
                                userModel.itemAt(i).paint(items.colorSelector)
                            currentItem = 0
                            keyNavigation = false
                        }

                        function clearCurrentItem() {
                            userModel.itemAt(currentItem).paint(0)
                        }

                        function paintCurrentItem() {
                            userModel.itemAt(currentItem).playEffect(items.colorSelector)
                            userModel.itemAt(currentItem).paint(items.colorSelector)
                        }

                        function moveCurrentIndexRight() {
                            keyNavigation = true
                            if(currentItem++ >= items.targetModelData.length - 1)
                                currentItem = 0
                        }

                        function moveCurrentIndexLeft() {
                            keyNavigation = true
                            if(currentItem-- <= 0)
                                currentItem = items.targetModelData.length - 1
                        }

                        function moveCurrentIndexUp() {
                            keyNavigation = true
                            currentItem -= items.numberOfColumn
                            if(currentItem < 0)
                                currentItem += items.targetModelData.length
                        }

                        function moveCurrentIndexDown() {
                            keyNavigation = true
                            currentItem += items.numberOfColumn
                            if(currentItem > items.targetModelData.length - 1)
                                currentItem -= items.targetModelData.length
                        }

                        Item {
                            id: userItem
                            width: Math.min(drawingArea.width / items.numberOfColumn,
                                            drawingArea.height / items.numberOfLine)
                            height: width
                            property color color: Activity.colors[colorIndex]
                            property int colorIndex

                            function paint(color) {
                                colorIndex = color
                            }

                            function playEffect(color) {
                                if(color === 0)
                                    activity.audioEffects.play(Activity.url + 'eraser.wav')
                                else
                                    activity.audioEffects.play(Activity.url + 'brush.wav')
                            }

                            Rectangle {
                                id: userRect
                                anchors.fill: parent
                                border.width: userModel.keyNavigation && userModel.currentItem == modelData ? 3 : 1
                                border.color: 'black'
                                color: parent.color

                                Behavior on color {
                                    ColorAnimation {
                                        duration: 200
                                        onRunningChanged: {
                                            if(!running && Activity.checkModel()) bonus.good("flower")
                                        }
                                    }
                                }
                            }
                            GCText {
                                id: text2
                                anchors.fill: parent
                                anchors.margins: 4
                                text: parent.colorIndex == 0 ? "" : parent.colorIndex
                                fontSize: regularSize
                                font.bold: true
                                style: Text.Outline
                                styleColor: "black"
                                color: "white"
                            }
                            DropShadow {
                                anchors.fill: text2
                                cached: false
                                horizontalOffset: 1
                                verticalOffset: 1
                                radius: 8.0
                                samples: 16
                                color: "#80000000"
                                source: text2
                            }
                        }
                    }
                }

                // The painting to reproduce
                Grid {
                    id: imageArea
                    width: drawingArea.width
                    height: drawingArea.height
                    columns: items.numberOfColumn
                    LayoutMirroring.enabled: activity.symmetry
                    LayoutMirroring.childrenInherit: true
                    Repeater {
                        id: targetModel
                        model: items.targetModelData
                        Item {
                            width: Math.min(imageArea.width / items.numberOfColumn,
                                            imageArea.height / items.numberOfLine)
                            height: width
                            property alias color: targetRect.color

                            Rectangle {
                                id: targetRect
                                anchors.fill: parent
                                color: Activity.colors[modelData]
                                border.width: 1
                                border.color: 'black'
                            }
                            GCText {
                                id: text3
                                anchors.fill: parent
                                anchors.margins: 4
                                text: modelData == 0 ? "" : modelData
                                fontSize: regularSize
                                font.bold: true
                                style: Text.Outline
                                styleColor: "black"
                                color: "white"
                            }
                            DropShadow {
                                anchors.fill: text3
                                cached: false
                                horizontalOffset: 1
                                verticalOffset: 1
                                radius: 8.0
                                samples: 16
                                color: "#80000000"
                                source: text3
                            }

                        }
                    }
                }
            }
        }

        MultiPointTouchArea {
            x: drawAndExampleArea.x
            y: drawAndExampleArea.y
            width: drawAndExampleArea.width
            height: drawAndExampleArea.height
            onPressed: checkTouchPoint(touchPoints)
            onTouchUpdated: checkTouchPoint(touchPoints)

            function checkTouchPoint(touchPoints) {
                for(var i in touchPoints) {
                    var touch = touchPoints[i]
                    var block = drawingArea.childAt(touch.x, touch.y)
                    if(block) {
                        block.playEffect(items.colorSelector)
                        block.paint(items.colorSelector)
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
