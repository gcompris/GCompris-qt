/* GCompris - learn_decimals.qml
 *
 * SPDX-FileCopyrightText: 2021 Mariam Fahmy <mariamfahmy66@gmail.com>
 *
 * Authors:
 *   Mariam Fahmy <mariamfahmy66@gmail.com>
 *   Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0
import "../../core"

GridView {
    id: singleBar
    clip: true

    property bool isAnswerRepresentation: false
    property bool isUnselectedBar: false
    property ListModel selectedModel
    property int cellSize: 10

    model: selectedModel
    interactive: false
    delegate: delegateUnit

    Component {
        id: delegateUnit
        Item {
            id: barItem
            width: activityBackground.horizontalLayout ? cellSize * 10 : cellSize
            height: activityBackground.horizontalLayout ? cellSize : cellSize * 10

            Grid {
                id: gridLayout
                anchors.fill: parent
                rows: 10
                columns: 10
                flow: activityBackground.horizontalLayout ? Grid.LeftToRight : Grid.TopToBottom

                Repeater {
                    id: rowsRepeater
                    model: isAnswerRepresentation ? selectedSquareNumbers : 10
                    // There can be random glitches happening on the squares borders if using Rectangle
                    // items in this code when using OpenGL, so using Images instead of Rectangles
                    // helps to avoid it in most cases.
                    Image {
                        id: squareContainer
                        source: items.isQuantityMode ? "qrc:/gcompris/src/core/resource/empty.svg" :
                            "qrc:/gcompris/src/activities/learn_decimals/resource/rectDark.svg"
                        visible: singleBar.Drag.active && index >= selectedSquareNumbers ? false : true
                        width: singleBar.cellSize
                        height: width
                        sourceSize.width: width

                        Image {
                            id: square
                            source: items.isQuantityMode ? "qrc:/gcompris/src/activities/babyshapes/resource/food/orange.svg" :
                                index < selectedSquareNumbers ? "qrc:/gcompris/src/activities/learn_decimals/resource/rectFill.svg" :
                                "qrc:/gcompris/src/activities/learn_decimals/resource/rectWhite.svg"
                            width: singleBar.cellSize - 2 * GCStyle.thinBorder
                            height: width
                            sourceSize.width: width
                            anchors.centerIn: parent
                            opacity: items.isQuantityMode && index >= selectedSquareNumbers ? 0.2 : 1
                        }
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                enabled: isAnswerRepresentation && !items.typeResult && !items.buttonsBlocked
                onPressed: selectedModel.remove(index)
            }
        }
    }
}
