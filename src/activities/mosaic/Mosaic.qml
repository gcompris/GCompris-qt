/* GCompris - mosaic.qml
 *
 * Copyright (C) 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Clement coudoin <clement.coudoin@free.fr> (GTK+ version)
 *   Bruno.coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
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
import "mosaic.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        source: Activity.url + "background.svg"
        sourceSize.width: Math.max(parent.width, parent.height)
        fillMode: Image.PreserveAspectCrop
        anchors.fill: parent
        signal start
        signal stop

        property bool keyboardMode: false
        property var areaWithKeyboardFocus: selector

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property GCSfx audioEffects: activity.audioEffects
            property alias question: question
            property alias answer: answer
            property alias selector: selector
            property alias nbItems: column.nbItems
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property string selectedItem
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Keys.onLeftPressed: {
            keyboardMode = true
            areaWithKeyboardFocus.moveCurrentIndexLeft()
        }

        Keys.onRightPressed: {
            keyboardMode = true
            areaWithKeyboardFocus.moveCurrentIndexRight()
        }

        Keys.onUpPressed: {
            keyboardMode = true
            areaWithKeyboardFocus.moveCurrentIndexUp()
        }

        Keys.onDownPressed: {
            keyboardMode = true
            areaWithKeyboardFocus.moveCurrentIndexDown()
        }

        Keys.onEnterPressed: {
            selectCell()
        }

        Keys.onSpacePressed: {
            selectCell()
        }

        Keys.onReturnPressed: {
            selectCell()
        }

        Keys.onTabPressed: {
            keyboardMode = true
            areaWithKeyboardFocus.changeAreaWithKeyboardFocus()
        }

        function selectCell() {
            keyboardMode = true
            areaWithKeyboardFocus.selectCurrentCell(areaWithKeyboardFocus.currentItem)
        }

        Column {
            id: column
            spacing: 10
            x: parent.width * 0.05
            y: parent.height * 0.05
            width: parent.width * 0.9

            property int nbItems: 24
            property bool horizontal: background.width >= background.height
            property int nbColumns: Activity.questionLayout[nbItems][0]
            property int nbLines: Activity.questionLayout[nbItems][1]
            property int itemWidth: horizontal ?
                                        Math.min(width / 2 / nbColumns - 10 - 10 / nbColumns / 2,
                                                 parent.height / 2 / nbLines - 10 - 10 / nbLines / 2) :
                                        Math.min(width / nbColumns - 10 - 10 / nbColumns / 2,
                                                 parent.height * 0.25 / nbLines - 10 - 10 / nbLines / 2)
            property int itemHeight: itemWidth

            property int nbSelectorColumns: horizontal ?
                                                Activity.selectorLayout[nbItems][0] :
                                                Activity.selectorLayout[nbItems][0] / 2
            property int nbSelectorLines: horizontal ?
                                              Activity.selectorLayout[nbItems][1] :
                                              Activity.selectorLayout[nbItems][1] * 2

            Grid {
                id: row
                spacing: 10
                columns: column.horizontal ? 2 : 1

                // === The Question Area ===
                Rectangle {
                    height: (column.itemHeight + 10) * column.nbLines
                    width: column.horizontal ? column.width / 2 : column.width + 10
                    color: "#55333333"
                    border.color: "black"
                    border.width: 2
                    radius: 5

                    GridView {
                        id: question
                        width: (column.nbColumns * column.itemWidth) + (12.5 * (column.nbColumns - 1))
                        height: parent.height
                        x: 2 * ApplicationInfo.ratio
                        y: 2 * ApplicationInfo.ratio
                        cellHeight: cellWidth
                        cellWidth: width / column.nbColumns
                        interactive: false
                        keyNavigationWraps: true
                        delegate: Image {
                            source: Activity.url + modelData
                            fillMode: Image.PreserveAspectFit
                            width: question.cellWidth - 5 * ApplicationInfo.ratio
                            height: width
                            sourceSize.width: width
                            sourceSize.height: height
                        }
                    }
                }

                // === The Answer Area ===
                Rectangle {
                    height: (column.itemHeight + 10) * column.nbLines
                    width: column.horizontal ? column.width / 2 : column.width + 10
                    color: "#55333333"
                    border.color: "black"
                    border.width: 2
                    radius: 5

                    GridView {
                        id: answer
                        width: (column.nbColumns * column.itemWidth) + (12.5 * (column.nbColumns - 1))
                        height: parent.height
                        x: 2 * ApplicationInfo.ratio
                        cellHeight: cellWidth
                        cellWidth: width / column.nbColumns
                        interactive: false
                        keyNavigationWraps: true
                        highlightFollowsCurrentItem: true
                        highlight: Rectangle {
                            color: "red"
                            border.width: 3
                            border.color: "black"
                            opacity: 0.6
                            visible: background.keyboardMode && (background.areaWithKeyboardFocus === answer)
                            Behavior on x { SpringAnimation { spring: 2; damping: 0.2 } }
                            Behavior on y { SpringAnimation { spring: 2; damping: 0.2 } }
                        }

                        // If the image was directly used as a delegate (without containing it in the item), the highlight element would have been be hard to notice as it would get completely hidden by the image due to the same sizes.
                        delegate: Item {
                            id: cellItem
                            width: answer.cellWidth
                            height: answer.cellHeight

                            readonly property int cellIndex: index

                            Image {
                                id: imageAnswerId
                                source: Activity.url + modelData
                                fillMode: Image.PreserveAspectFit
                                width: answer.cellWidth - 5 * ApplicationInfo.ratio
                                height: width
                                sourceSize.width: width
                                sourceSize.height: height
                                anchors.centerIn: parent

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: answer.selectCurrentCell(cellItem)
                                }
                            }
                        }

                        function selectCurrentCell(selectedCell) {
                            Activity.answerSelected(selectedCell.cellIndex)
                        }

                        function changeAreaWithKeyboardFocus() {
                            areaWithKeyboardFocus = selector
                        }
                    }
                }
            }

            // === The Selector ===
            Rectangle {
                height: (column.itemWidth + 10) * column.nbSelectorLines
                width: column.width + 10
                color: "#661111AA"
                border.color: "black"
                border.width: 2
                radius: 5
                GridView {
                    id: selector
                    width: (column.nbSelectorColumns * column.itemWidth) + (12.5 * (column.nbSelectorColumns - 1))
                    height: parent.height
                    x: 2 * ApplicationInfo.ratio
                    y: 2 * ApplicationInfo.ratio
                    cellHeight: cellWidth
                    cellWidth: width / column.nbSelectorColumns
                    interactive: false
                    keyNavigationWraps: true
                    highlightFollowsCurrentItem: true
                    highlight: Rectangle {
                        color: "red"
                        border.width: 3
                        border.color: "black"
                        opacity: 0.6
                        visible: background.keyboardMode && (background.areaWithKeyboardFocus === selector)
                        Behavior on x { SpringAnimation { spring: 2; damping: 0.2 } }
                        Behavior on y { SpringAnimation { spring: 2; damping: 0.2 } }
                    }
                    delegate: Image {
                        id: imageId
                        source: Activity.url + modelData
                        fillMode: Image.PreserveAspectFit
                        width: selector.cellWidth - 5 * ApplicationInfo.ratio
                        height: width
                        sourceSize.width: width
                        sourceSize.height: height
                        z: iAmSelected ? 10 : 1

                        readonly property bool iAmSelected: items.selectedItem === modelData
                        readonly property string imageName: modelData

                        states: [
                            State {
                                name: "notclicked"
                                when: !imageId.iAmSelected && !mouseArea.containsMouse
                                PropertyChanges {
                                    target: imageId
                                    scale: 0.8
                                }
                            },
                            State {
                                name: "clicked"
                                when: mouseArea.pressed
                                PropertyChanges {
                                    target: imageId
                                    scale: 0.7
                                }
                            },
                            State {
                                name: "hover"
                                when: mouseArea.containsMouse
                                PropertyChanges {
                                    target: imageId
                                    scale: 1.1
                                }
                            },
                            State {
                                name: "selected"
                                when: imageId.iAmSelected
                                PropertyChanges {
                                    target: imageId
                                    scale: 1
                                }
                            }
                        ]

                        SequentialAnimation {
                            id: anim
                            running: imageId.iAmSelected
                            loops: Animation.Infinite
                            alwaysRunToEnd: true
                            NumberAnimation {
                                target: imageId
                                property: "rotation"
                                from: 0; to: 10
                                duration: 200
                                easing.type: Easing.OutQuad
                            }
                            NumberAnimation {
                                target: imageId
                                property: "rotation"
                                from: 10; to: -10
                                duration: 400
                                easing.type: Easing.InOutQuad
                            }
                            NumberAnimation {
                                target: imageId
                                property: "rotation"
                                from: -10; to: 0
                                duration: 200
                                easing.type: Easing.InQuad
                            }
                        }

                        Behavior on scale { NumberAnimation { duration: 70 } }
                        MouseArea {
                            id: mouseArea
                            anchors.fill: imageId
                            hoverEnabled: true
                            onClicked: selector.selectCurrentCell(parent)
                        }
                    }

                    function selectCurrentCell(selectedCell) {
                        items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/scroll.wav")
                        items.selectedItem = selectedCell.imageName
                    }

                    function changeAreaWithKeyboardFocus() {
                        areaWithKeyboardFocus = answer
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
