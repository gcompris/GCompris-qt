/* GCompris - Simplepaint.qml
 *
 * Copyright (C) 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Christof Petig and Ingo Konrad (GTK+ version)
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */

import QtQuick 2.6
import GCompris 1.0

import "../../core"
import "simplepaint.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true

    pageComponent: Image {
        id: background
        source: items.backgroundImg
        sourceSize.width: Math.max(parent.width, parent.height)
        fillMode: Image.PreserveAspectCrop
        signal start
        signal stop
        focus: true
        property bool isColorTab: false

        Keys.onUpPressed: {
            if(isColorTab) {
                if (--items.current_color<0) {
                    items.current_color = items.colors.length-1
                }
                items.colorSelector = items.colors[items.current_color]
                moveColorSelector()
            }else {
                if(cursor.iy>0) {
                cursor.iy--
                }
            }
        }

        Keys.onDownPressed: {
            if(isColorTab) {
                if (++items.current_color>items.colors.length-1){
                    items.current_color = 0
                }
                items.colorSelector = items.colors[items.current_color]
                moveColorSelector()
        }else {
                if(cursor.iy<(Activity.nby-1)) {
                cursor.iy++
                }
            }
        }

        Keys.onRightPressed: {
            if(!isColorTab) {
                if(cursor.ix<(Activity.nbx-1)) {
                cursor.ix++
                }
            }
        }

        Keys.onLeftPressed: {
            if(!isColorTab) {
                if(cursor.ix>0) {
                cursor.ix--
                }
            }
        }

        Keys.onSpacePressed: spawnBlock()

        Keys.onReturnPressed: spawnBlock()

        Keys.onEnterPressed: spawnBlock()

        Keys.onTabPressed:changeTab()

        function changeTab() {
            isColorTab = !isColorTab
            if(isColorTab) {
                 colorSelector.cellWidth = 60 * ApplicationInfo.ratio+20
            }else {
                colorSelector.cellWidth = 60 * ApplicationInfo.ratio
            }
        }

        function spawnBlock() {
            if(!isColorTab) {
                var block = rootItem.childAt(cursor.x, cursor.y)
                if(block)
                    block.touched()
            }else {
                changeTab()
            }
        }

        function refreshCursor() {
            cursor.nbx= Activity.nbx
            cursor.nby=Activity.nby
        }

        function moveColorSelector() {
            moveColorSelectorAnim.running = false
            moveColorSelectorAnim.from = colorSelector.contentY
            if(items.current_color != (items.colors.length-1)) {
                colorSelector.positionViewAtIndex(items.current_color >= 1 ? items.current_color-2 : items.current_color, colorSelector.Contain)
            }else {
                colorSelector.positionViewAtEnd()
                colorSelector.positionViewAtEnd()
            }
            moveColorSelectorAnim.to = colorSelector.contentY
            moveColorSelectorAnim.running = true
        }

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        //Cursor to navigate in cells
        PaintCursor {
            id:cursor;
            initialX: colorSelector.width + 20 * ApplicationInfo.ratio
            z:1
            ix: 0
            iy: 0
            nbx: 20
            nby: 10
            color: items.colors[0]
        }


        QtObject {
            id: items
            property alias background: background
            property alias bar: bar
            property alias paintModel: paintModel
            property var colors: bar.level < 10 ? Activity.colorsSimple : Activity.colorsAdvanced
            property int current_color:0
            property string colorSelector: colors[current_color]
            property string backgroundImg: Activity.backgrounds[bar.level - 1]
        }

        onStart: Activity.start(main, items, background)
        onStop: Activity.stop()

        MultiPointTouchArea {
            anchors.fill: parent
            onPressed: checkTouchPoint(touchPoints)
            onTouchUpdated: checkTouchPoint(touchPoints)
        }

        function checkTouchPoint(touchPoints) {
            for(var i in touchPoints) {
                var touch = touchPoints[i]
                var block = rootItem.childAt(touch.x, touch.y)
                if(block)
                    cursor.ix = block.ix
                    cursor.iy = block.iy
                    block.touched()
            }
        }

        Item {
            id: rootItem
            anchors.fill: parent
        }

        ListModel {
            id: paintModel
        }

        Column {
            id: colorSelectorColumn
            spacing: 2

            anchors {
                left: background.left
                top: background.top
                bottom: bar.top
            }

            // The color selector
            GridView {
                id: colorSelector
                clip: true
                width: cellWidth + 10 * ApplicationInfo.ratio
                height: colorSelectorColumn.height - (2 + colorSelectorButton.height)
                model: items.colors
                cellWidth: 60 * ApplicationInfo.ratio
                cellHeight: cellWidth

                NumberAnimation {
                    id: moveColorSelectorAnim
                    target: colorSelector
                    property: "contentY"
                    duration: 150
                }

                delegate: Item {
                    width: colorSelector.cellWidth
                    height: width
                    Rectangle {
                        id: rect
                        width: parent.width
                        height: width
                        radius: width * 0.1
                        z: iAmSelected ? 10 : 1
                        color: modelData
                        border.color: "#373737"
                        border.width: modelData == "#00FFFFFF" ? 0 : 1

                        Image {
                            scale: 0.9
                            width: rect.height
                            height: rect.height
                            sourceSize.width: rect.height
                            sourceSize.height: rect.height
                            source: Activity.url + "eraser.svg"
                            visible: modelData == "#00FFFFFF" ? 1 : 0
                            anchors.centerIn: parent
                        }

                        property bool iAmSelected: modelData == items.colorSelector

                        states: [
                            State {
                                name: "notclicked"
                                when: !rect.iAmSelected && !mouseArea.containsMouse
                                PropertyChanges {
                                    target: rect
                                    scale: 0.8
                                }
                            },
                            State {
                                name: "clicked"
                                when: mouseArea.pressed
                                PropertyChanges {
                                    target: rect
                                    scale: 0.7
                                }
                            },
                            State {
                                name: "hover"
                                when: mouseArea.containsMouse
                                PropertyChanges {
                                    target: rect
                                    scale: 1.1
                                }
                            },
                            State {
                                name: "selected"
                                when: rect.iAmSelected
                                PropertyChanges {
                                    target: rect
                                    scale: 1
                                }
                            }
                        ]

                        SequentialAnimation {
                            id: anim
                            running: rect.iAmSelected
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
                                activity.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/scroll.wav')
                                items.colorSelector = modelData
                                items.current_color=items.colors.indexOf(modelData)
                                items.colorSelector=items.colors[items.current_color]
                            }
                        }
                    }
                }
            }

            // Scroll buttons
            GCButtonScroll {
                id: colorSelectorButton
                isHorizontal: true
                width: colorSelectorColumn.width - 10 * ApplicationInfo.ratio
                height: width * heightRatio
                onUp: colorSelector.flick(0, 1400)
                onDown: colorSelector.flick(0, -1400)
                upVisible: colorSelector.visibleArea.yPosition <= 0 ? 0 : 1
                downVisible: colorSelector.visibleArea.yPosition + colorSelector.visibleArea.heightRatio >= 1 ? 0 : 1
            }
        }

        Item {
            anchors {
                top: parent.top
                left: colorSelectorColumn.right
                right: parent.right
                bottom: parent.bottom
            }

            Repeater {
                model: paintModel
                parent: rootItem

                PaintItem {
                    initialX: colorSelector.width + 20 * ApplicationInfo.ratio
                    ix: m_ix
                    iy: m_iy
                    nbx: m_nbx
                    nby: m_nby
                    color: items.colors[0]
                }
            }
        }

        DialogHelp {
            id: dialogHelpLeftRight
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | reload | level }
            onHelpClicked: {
                displayDialog(dialogHelpLeftRight)
            }
            onReloadClicked: Activity.initLevel()
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: home()
        }
    }

}
