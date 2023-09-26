/* GCompris - redraw.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0
import QtGraphicalEffects 1.0

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
        sourceSize.width: width
        sourceSize.height: height

        property bool landscape: width >= height
        property int areaWidth: landscape ? (width - colorSelectorFlick.width) / 2 - 20 :
                                            width - colorSelectorFlick.width - 20
        property int areaHeight: landscape ? height - bar.height * 1.2 - 20:
                                             (height - bar.height * 1.2) / 2 - 20
        property int cellSize: Math.min(areaWidth / items.numberOfColumn,
                                        areaHeight / items.numberOfLine)
        signal start
        signal stop

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property int colorSelector: 0
            property alias userModel: userModel
            property int numberOfColumn
            property int numberOfColor
            property int numberOfLine: targetModelData.length / numberOfColumn
            property alias targetModel: targetModel
            property var targetModelData
            readonly property var levels: activity.datasetLoader.data.length !== 0 ? activity.datasetLoader.data : null
        }

        onStart: { Activity.start(items) }
        onStop: {
            checkTimer.stop()
            Activity.stop()
        }

        Keys.enabled: !bonus.isPlaying
        Keys.onPressed: {
            if(event.key >= Qt.Key_0 && event.key < Qt.Key_0 + items.numberOfColor)
                items.colorSelector = event.key - Qt.Key_0

            if(event.key === Qt.Key_Backspace)
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
            Flickable {
                id: colorSelectorFlick
                interactive: true
                width: height / 7
                height: background.height - bar.height * 1.2
                boundsBehavior: Flickable.StopAtBounds
                contentHeight: items.numberOfColor * width
                Column {
                    id: colorSelector
                    Repeater {
                        model: items.numberOfColor
                        Item {
                            width: colorSelectorFlick.width
                            height: width
                            Image {
                                id: img
                                source: Activity.url + Activity.colorShortcut[modelData] + ".svg"
                                sourceSize.width: colorSelectorFlick.width
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
                                        when: mouseArea.containsMouse && !img.iAmSelected
                                        PropertyChanges {
                                            target: img
                                            scale: 1
                                        }
                                    },
                                    State {
                                        name: "selected"
                                        when: img.iAmSelected
                                        PropertyChanges {
                                            target: img
                                            scale: 1.1
                                        }
                                    }
                                ]

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
                width: parent.width - colorSelector.width
                height: parent.height - bar.height * 1.2
                spacing: 10

                // The drawing area
                Grid {
                    id: drawingArea
                    width: background.areaWidth
                    height: background.areaHeight
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
                            width: background.cellSize
                            height: background.cellSize
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
                                            if(!running) checkTimer.restart();
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
                    width: background.areaWidth
                    height: background.areaHeight
                    columns: items.numberOfColumn
                    LayoutMirroring.enabled: activity.symmetry
                    LayoutMirroring.childrenInherit: true
                    Repeater {
                        id: targetModel
                        model: items.targetModelData
                        Item {
                            width: background.cellSize
                            height: background.cellSize
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

        Timer {
            id: checkTimer
            interval: 500
            onTriggered: if(Activity.checkModel()) bonus.good("flower")
        }

        MultiPointTouchArea {
            x: drawAndExampleArea.x
            y: drawAndExampleArea.y
            width: drawingArea.width
            height: drawingArea.height
            onPressed: checkTouchPoint(touchPoints)
            onTouchUpdated: checkTouchPoint(touchPoints)
            enabled: !bonus.isPlaying

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

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo
            onSaveData: {
                levelFolder = dialogActivityConfig.chosenLevels
                currentActivity.currentLevels = dialogActivityConfig.chosenLevels
                ApplicationSettings.setCurrentLevels(currentActivity.name, dialogActivityConfig.chosenLevels)
                activity.focus = true
            }
            onLoadData: {
                if(activityData) {
                    Activity.initLevel()
                }
            }
            onClose: {
                home()
            }
            onStartActivity: {
                background.stop()
                background.start()
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level | activityConfig}
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onActivityConfigClicked: {
                 displayDialog(dialogActivityConfig)
             }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }
}
