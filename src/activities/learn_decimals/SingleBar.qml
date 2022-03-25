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
import GCompris 1.0
import "../../core"
import "learn_decimals.js" as Activity

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
            width: background.horizontalLayout ? cellSize * 10 : cellSize
            height: background.horizontalLayout ? cellSize : cellSize * 10

            Grid {
                id: gridLayout
                anchors.fill: parent

                states: [
                    State {
                        when: background.horizontalLayout
                        PropertyChanges {
                            target: gridLayout
                            rows: 1
                            columns: 0
                        }
                    },
                    State {
                        when: !background.horizontalLayout
                        PropertyChanges {
                            target: gridLayout
                            rows: 0
                            columns: 1
                        }
                    }
                ]

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
                            width: singleBar.cellSize - 6
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
                enabled: isAnswerRepresentation && !items.typeResult
                onPressed: selectedModel.remove(index)
            }
        }
    }
}
