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

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }
        QtObject {
            id: items
            property alias background: background
            property alias bar: bar
            property alias paintModel: paintModel
            property var colors: bar.level < 10 ? Activity.colorsSimple : Activity.colorsAdvanced
            property string colorSelector: colors[0]
            property string backgroundImg: Activity.backgrounds[bar.level - 1]
        }

        onStart: Activity.start(main, items)
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
