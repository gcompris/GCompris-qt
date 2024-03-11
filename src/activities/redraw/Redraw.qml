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
import Qt5Compat.GraphicalEffects 1.0

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

        property int baseMargins: Math.round(10 * ApplicationInfo.ratio)
        property bool landscape: width >= height
        property int cellSize: Math.floor(Math.min(drawingArea.width / items.numberOfColumn,
                                        drawingArea.height / items.numberOfLine))
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
            readonly property var levels: activity.datasets.length !== 0 ? activity.datasets : null
            property bool buttonsBlocked: false
            property var selectedRect: null
        }

        onStart: { Activity.start(items) }
        onStop: {
            Activity.stop()
        }

        Keys.enabled: !items.buttonsBlocked
        Keys.onPressed: (event) => {
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

        // The color selector
        Flickable {
            id: colorSelectorFlick
            interactive: true
            width: Math.ceil(Math.min(height / 7, 60 * ApplicationInfo.ratio))
            height: Math.ceil(background.height - bar.height * 1.5)
            boundsBehavior: Flickable.StopAtBounds
            maximumFlickVelocity: activity.height
            contentHeight: items.numberOfColor * width
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: background.baseMargins
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

        Item {
            id: gridsArea
            width: Math.floor(parent.width - colorSelector.width - background.baseMargins * 3)
            height: colorSelectorFlick.height
            anchors.top: colorSelectorFlick.top
            anchors.left: colorSelectorFlick.right
            anchors.leftMargin: background.baseMargins
        }

        // The drawing area
        Grid {
            id: drawingArea
            width: Math.ceil(background.landscape ? (gridsArea.width - background.baseMargins) * 0.5 : gridsArea.width)
            height: Math.ceil(background.landscape ? gridsArea.height : (gridsArea.height- background.baseMargins) * 0.5)
            columns: items.numberOfColumn
            anchors.top: gridsArea.top
            anchors.left: gridsArea.left
            Repeater {
                id: userModel
                model: items.targetModelData.length
                property int currentItem: 0
                property bool keyNavigation: false
                onCurrentItemChanged: {
                    items.selectedRect = userModel.itemAt(currentItem)
                    selectedRectHint.parent = items.selectedRect
                }

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
                        color = Activity.colors[colorIndex] //Needs to be set explicitly before running checkModel()
                        Activity.checkModel()
                    }

                    function playEffect(color) {
                        if(color === 0)
                            activity.audioEffects.play(Activity.url + 'eraser.wav')
                        else
                            activity.audioEffects.play(Activity.url + 'brush.wav')
                    }

                    MouseArea {
                        id: userMouseArea
                        anchors.fill: parent
                        hoverEnabled: !items.buttonsBlocked
                        onEntered:
                        {
                            userModel.currentItem = index
                            // Enable displaying cursor
                            userModel.keyNavigation = true
                        }
                    }

                    Rectangle {
                        id: userRect
                        anchors.fill: parent
                        property bool displayCursor: userModel.keyNavigation && userModel.currentItem == modelData
                        border.width: displayCursor ? 3 : 1
                        border.color: 'black'
                        color: parent.color

                        Behavior on color {
                            ColorAnimation {
                                duration: 200
                            }
                        }
                    }
                    GCText {
                        id: text2
                        anchors.left: parent.left
                        anchors.bottom: parent.bottom
                        anchors.margins: 4
                        width: parent.width * 0.35
                        height: width
                        text: parent.colorIndex == 0 ? "" : parent.colorIndex
                        fontSize: regularSize
                        fontSizeMode: Text.Fit
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
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
            layoutDirection: activity.symmetry ? Qt.RightToLeft : Qt.LeftToRight
            states: [
                State {
                    name: "horizontalLayout"
                    when: background.landscape
                    AnchorChanges {
                        target: imageArea
                        anchors.top: gridsArea.top
                        anchors.bottom: undefined
                        anchors.right: gridsArea.right
                        anchors.left: undefined
                    }
                },
                State {
                    name: "verticalLayout"
                    when: !background.landscape
                    AnchorChanges {
                        target: imageArea
                        anchors.top: undefined
                        anchors.bottom: gridsArea.bottom
                        anchors.right: gridsArea.right
                        anchors.left: undefined
                    }
                }
            ]
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
                        anchors.left: parent.left
                        anchors.bottom: parent.bottom
                        anchors.margins: 4
                        width: parent.width * 0.35
                        height: width
                        text: modelData == 0 ? "" : modelData
                        fontSize: regularSize
                        fontSizeMode: Text.Fit
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
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


        Rectangle {
            id: selectedRectHint
            width: background.cellSize * 0.3
            height: width
            radius: width * 0.5
            color: Activity.colors[items.colorSelector]
            anchors.centerIn: parent
            opacity: userModel.keyNavigation ? 1 : 0
        }

        MultiPointTouchArea {
            id: touchArea
            x: drawingArea.x
            y: drawingArea.y
            width: background.cellSize * items.numberOfColumn
            height: background.cellSize * items.numberOfLine
            onPressed: (touchPoints) => checkTouchPoint(touchPoints)
            onTouchUpdated: (touchPoints) => checkTouchPoint(touchPoints)
            enabled: !items.buttonsBlocked

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

        Rectangle {
            id: drawingAreaBorders
            x: drawingArea.x - 1
            y: drawingArea.y - 1
            width: touchArea.width + 2
            height: touchArea.height + 2
            color: "transparent"
            border.color: "black"
            border.width: 1
        }

        Rectangle {
            id: imageAreaBorders
            x: activity.symmetry ? imageArea.x + imageArea.width - width + 1 : imageArea.x - 1
            y: imageArea.y - 1
            width: drawingAreaBorders.width
            height: drawingAreaBorders.height
            color: "transparent"
            border.color: "black"
            border.width: 1
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
