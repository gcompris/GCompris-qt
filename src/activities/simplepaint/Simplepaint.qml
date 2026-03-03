/* GCompris - Simplepaint.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Christof Petig and Ingo Konrad (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (refactoring)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
pragma ComponentBehavior: Bound

import QtQuick
import core 1.0

import "../../core"
import "simplepaint.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true

     onActivityNextLevel: {
         Activity.nextLevel()
    }

    pageComponent: Image {
        id: activityBackground
        source: items.backgroundImg
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop
        signal start
        signal stop
        focus: true
        property bool isColorTab: true
        property bool spaceIsPressed: false

        Keys.onPressed: (event) => {
            items.keyboardControls = true;

            if(event.key === Qt.Key_Up) {
                if(isColorTab) {
                    if(--items.current_color < 0) {
                        items.current_color = items.colors.length - 1;
                    }
                    items.selectedColor = items.colors[items.current_color];
                    moveColorSelector();
                } else {
                    if(cursor.nbY > 0) {
                        cursor.nbY--;
                    }
                    if(spaceIsPressed) {
                        spawnBlock();
                    }
                }
            }

            if(event.key === Qt.Key_Down) {
                if(isColorTab) {
                    if(++items.current_color > items.colors.length - 1){
                        items.current_color = 0;
                    }
                    items.selectedColor = items.colors[items.current_color];
                    moveColorSelector();
                }else {
                    if(cursor.nbY < (items.nbY - 1)) {
                        cursor.nbY++;
                    }
                    if(spaceIsPressed) {
                        spawnBlock();
                    }
                }
            }

            if(event.key === Qt.Key_Right) {
                if(!isColorTab) {
                    if(cursor.nbX < (items.nbX - 1)) {
                        cursor.nbX++;
                    }
                    if(spaceIsPressed) {
                        spawnBlock();
                    }
                }
            }

            if(event.key === Qt.Key_Left) {
                if(!isColorTab) {
                    if(cursor.nbX > 0) {
                        cursor.nbX--;
                    }
                    if(spaceIsPressed) {
                        spawnBlock();
                    }
                }
            }

            if(event.key === Qt.Key_Space || event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                if(!isColorTab) {
                    spawnBlock();
                    spaceIsPressed = true;
                } else {
                    changeTab();
                }
            }

            if(event.key === Qt.Key_Tab) {
                changeTab();
            }
        }

        Keys.onReleased: (event) => {
            if(event.key === Qt.Key_Space || event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                spaceIsPressed = false;
            }
        }

        function changeTab() {
            isColorTab = !isColorTab;
        }

        function spawnBlock() {
            if(!isColorTab) {
                var block = paintGrid.childAt(cursor.x, cursor.y) as PaintItem;
                if(block)
                    block.touched();
            }else {
                changeTab();
            }
        }

        function moveColorSelector() {
            moveColorSelectorAnim.running = false;
            moveColorSelectorAnim.from = colorSelector.contentY;
            if(items.current_color != (items.colors.length-1)) {
                colorSelector.positionViewAtIndex(items.current_color >= 1 ? items.current_color-2 : items.current_color, GridView.Contain);
            }else {
                colorSelector.positionViewAtEnd();
            }
            moveColorSelectorAnim.to = colorSelector.contentY;
            moveColorSelectorAnim.running = true;
        }

        Component.onCompleted: {
            activity.start.connect(start);
            activity.stop.connect(stop);
        }

        QtObject {
            id: items
            property int currentLevel: activity.currentLevel
            onCurrentLevelChanged: activity.currentLevel = currentLevel
            property int numberOfLevel: 0
            onNumberOfLevelChanged: activity.numberOfLevel = numberOfLevel
            property int paintModel: 1
            property alias paintArea: paintArea
            property alias colorSelector: colorSelector
            property alias cursor: cursor
            property list<string> colors: bar.level < 10 ? Activity.colorsSimple : Activity.colorsAdvanced
            property int current_color: 1
            property string selectedColor: colors[current_color]
            property string backgroundImg: Activity.backgrounds[items.currentLevel]
            property bool keyboardControls: false
            property int paintPixelSize: Math.min(paintArea.width / nbX, paintArea.height / nbY)
            property int nbX: 1
            property int nbY: 1
        }

        onStart: Activity.start(items);
        onStop: Activity.stop();

        MultiPointTouchArea {
            anchors.fill: paintArea
            property PaintItem block: null
            onPressed: (touchPoints) => {
                items.keyboardControls = false;
                activityBackground.isColorTab = false;
                block = null;
                checkTouchPoint(touchPoints);
            }
            onTouchUpdated: (touchPoints) => checkTouchPoint(touchPoints);
            onReleased: {
                if(block) {
                    cursor.nbX = block.x / items.paintPixelSize;
                    cursor.nbY = block.y / items.paintPixelSize;
                }
            }

            function checkTouchPoint(touchPoints) {
                for(var i in touchPoints) {
                    var touch = touchPoints[i];
                    if(paintGrid.childAt(touch.x, touch.y)) {
                        block = paintGrid.childAt(touch.x, touch.y);
                        block.touched();
                    }
                }
            }
        }

        GCSoundEffect {
            id: scrollSound
            source: "qrc:/gcompris/src/core/resource/sounds/scroll.wav"
        }

        Column {
            id: colorSelectorColumn
            spacing: GCStyle.baseMargins
            width: 70 * ApplicationInfo.ratio

            anchors {
                left: activityBackground.left
                top: activityBackground.top
                bottom: bar.top
                topMargin: GCStyle.baseMargins
            }

            // The color selector
            GridView {
                id: colorSelector
                clip: true
                width: parent.width
                height: colorSelectorColumn.height - colorSelectorButton.height - GCStyle.baseMargins
                model: items.colors
                cellWidth: width
                cellHeight: cellWidth - GCStyle.baseMargins
                maximumFlickVelocity: activity.height
                boundsBehavior: Flickable.StopAtBounds

                NumberAnimation {
                    id: moveColorSelectorAnim
                    target: colorSelector
                    property: "contentY"
                    duration: 150
                }

                delegate: Item {
                    id: colorSlot
                    width: colorSelector.cellWidth
                    height: colorSelector.cellHeight - GCStyle.baseMargins

                    required property string modelData
                    Rectangle {
                        id: rect
                        width: parent.height
                        height: parent.height
                        anchors.centerIn: parent
                        radius: GCStyle.halfMargins
                        z: iAmSelected ? 10 : 1
                        color: colorSlot.modelData
                        border.color: GCStyle.darkBorder
                        border.width: colorSlot.modelData == "#00FFFFFF" ? 0 : 1

                        Image {
                            width: parent.width
                            height: parent.height
                            sourceSize.width: width
                            sourceSize.height: height
                            source: Activity.url + "eraser.svg"
                            visible: colorSlot.modelData == "#00FFFFFF" ? 1 : 0
                            anchors.centerIn: parent
                        }

                        Rectangle {
                            id: colorCursor
                            visible: items.keyboardControls && activityBackground.isColorTab
                            anchors.centerIn: parent
                            width: rect.width + border.width * 0.5
                            height: width
                            color: "#00FFFFFF"
                            radius: GCStyle.halfMargins
                            border.width: rect.iAmSelected ? GCStyle.halfMargins : 0
                            border.color: "#E0FFFFFF"
                        }

                        property bool iAmSelected: colorSlot.modelData == items.selectedColor

                        states: [
                            State {
                                name: "notclicked"
                                when: !rect.iAmSelected && !mouseArea.containsMouse
                                PropertyChanges {
                                    rect {
                                        scale: 0.9
                                    }
                                }
                            },
                            State {
                                name: "clicked"
                                when: mouseArea.pressed
                                PropertyChanges {
                                    rect {
                                        scale: 0.8
                                    }
                                }
                            },
                            State {
                                name: "hover"
                                when: mouseArea.containsMouse
                                PropertyChanges {
                                    rect {
                                        scale: 1
                                    }
                                }
                            },
                            State {
                                name: "selected"
                                when: rect.iAmSelected
                                PropertyChanges {
                                    rect {
                                        scale: 1
                                    }
                                }
                            }
                        ]

                        SequentialAnimation {
                            id: anim
                            running: rect.iAmSelected && !mouseArea.containsMouse
                            loops: Animation.Infinite
                            alwaysRunToEnd: true
                            NumberAnimation {
                                target: rect
                                property: "rotation"
                                from: 0; to: 10
                                duration: 200
                                easing.type: Easing.OutQuad
                            }
                            NumberAnimation {
                                target: rect
                                property: "rotation"
                                from: 10; to: -10
                                duration: 400
                                easing.type: Easing.InOutQuad
                            }
                            NumberAnimation {
                                target: rect
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
                                scrollSound.play();
                                items.keyboardControls = false;
                                items.selectedColor = colorSlot.modelData;
                                items.current_color = items.colors.indexOf(colorSlot.modelData);
                                items.selectedColor = items.colors[items.current_color];
                            }
                        }
                    }
                }
            }

            // Scroll buttons
            GCButtonScroll {
                id: colorSelectorButton
                isHorizontal: true
                width: colorSelectorColumn.width + GCStyle.baseMargins
                height: width * heightRatio
                onUp: colorSelector.flick(0, 1400)
                onDown: colorSelector.flick(0, -1400)
                upVisible: colorSelector.atYBeginning ? false : true
                downVisible: colorSelector.atYEnd ? false : true
            }
        }

        Item {
            id: paintArea
            anchors {
                top: parent.top
                left: colorSelectorColumn.right
                right: parent.right
                bottom: parent.bottom
                margins: GCStyle.baseMargins
                bottomMargin: bar.height * 1.4
            }

            Grid {
                id: paintGrid
                columns: items.nbX
                rows: items.nbY
                anchors.fill: parent

                Repeater {
                    model: items.paintModel
                    PaintItem {
                        width: items.paintPixelSize
                        height: items.paintPixelSize
                        border.width: items.currentLevel > 0 ? 0 : 1
                        color: items.colors[0]
                    }
                }
            }

            //Cursor to navigate in cells
            PaintCursor {
                id: cursor
                visible: items.keyboardControls && !activityBackground.isColorTab
                x: nbX * items.paintPixelSize
                y: nbY * items.paintPixelSize
                width: items.paintPixelSize
                height: items.paintPixelSize
            }
        }

        DialogHelp {
            id: dialogHelpLeftRight
            onClose: activity.home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | reload | level }
            onHelpClicked: {
                activity.displayDialog(dialogHelpLeftRight)
            }
            onReloadClicked: Activity.initLevel()
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: activity.nextLevel()
            onHomeClicked: activity.home()
        }
    }

}
