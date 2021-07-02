/* GCompris - learn_decimals.qml
 *
 * SPDX-FileCopyrightText: 2021 Mariam Fahmy <mariamfahmy66@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9
import GCompris 1.0
import "../../core"
import "learn_decimals.js" as Activity

GridView {
    id: singleBar
    clip: true

    property bool isAnswerRepresentation: false
    property bool isUnselectedBar: false
    property ListModel selectedModel

    model: selectedModel

    delegate: delegateUnit

    Component {
        id: delegateUnit
        Item {
            id: squareItem
            width: singleBar.cellWidth
            height: singleBar.cellHeight

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
                    Rectangle {
                        id: square
                        opacity: setSquareOpacity()
                        color: "#87cefa"
                        border.color: "black"
                        border.width: 2

                        function setSquareOpacity() {
                            if(!isAnswerRepresentation && !isUnselectedBar)
                            {
                                if(!isUnselectedBar) {
                                    if(index < selectedSquareNumbers) return 1
                                    else return 0
                                }
                                else {
                                    if(index > selectedSquareNumbers) return 0.3
                                    else return 0
                                }
                            }
                            else return 1
                        }

                        states: [
                            State {
                                when: background.horizontalLayout && isAnswerRepresentation
                                PropertyChanges {
                                    target: square
                                    width: squareItem.width * 0.1
                                    height: squareItem.height
                                }
                            },
                            State {
                                when: !background.horizontalLayout && isAnswerRepresentation
                                PropertyChanges {
                                    target: square
                                    width: squareItem.width
                                    height: squareItem.height * 0.1
                                }
                            },
                            State {
                                when: !isAnswerRepresentation
                                PropertyChanges {
                                    target: square
                                    width: squareItem.width
                                    height: squareItem.height
                                }
                            }
                        ]
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
