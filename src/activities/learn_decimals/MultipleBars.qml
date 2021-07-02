/* GCompris - MultipleBars.qml
 *
 * SPDX-FileCopyrightText: 2021 Mariam Fahmy <mariamfahmy66@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9
import GCompris 1.0
import "../../core"
import "learn_decimals.js" as Activity

GridView {
    id: multipleBars
    width: background.horizontalLayout ? parent.width * 0.5 : parent.width * 0.9
    height: parent.height * 0.9
    anchors.centerIn: parent
    flow: background.horizontalLayout? GridView.LeftToRight : GridView.TopToBottom
    cellWidth: background.horizontalLayout ? multipleBars.width : multipleBars.width * 0.2
    cellHeight: background.horizontalLayout ? multipleBars.height * 0.2 : multipleBars.height
    interactive: false
    model: largestNumberRepresentation

    delegate: delegateUnit

    Component {
        id: delegateUnit
        Item {
            id: singleBar

            Grid {
                id: gridLayout

                signal barClicked
                onBarClicked: {
                    multipleBars.currentIndex = index
                }

                states: [
                    State {
                        when: background.horizontalLayout
                        PropertyChanges {
                            target: gridLayout
                            width: multipleBars.cellWidth
                            height: multipleBars.cellHeight * 0.5
                            rows: 1
                            columns: 0
                        }
                    },
                    State {
                        when: !background.horizontalLayout
                        PropertyChanges {
                            target: gridLayout
                            width: multipleBars.cellWidth * 0.5
                            height: multipleBars.cellHeight
                            x: multipleBars.cellWidth * 0.5 + index
                            rows: 0
                            columns: 1
                        }
                    }
                ]

                Repeater {
                    id: squareRepeater

                    property int gridIndex: index

                    model: Activity.squaresNumber

                    Rectangle {
                        id: square
                        color: "#87cefa"
                        opacity: setSquareUnitOpacity()
                        border.color: "black"
                        border.width: 2

                        states: [
                            State {
                                when: background.horizontalLayout
                                PropertyChanges {
                                    target: square
                                    width: gridLayout.width * 0.1
                                    height: gridLayout.height
                                }
                            },
                            State {
                                when: !background.horizontalLayout
                                PropertyChanges {
                                    target: square
                                    width: gridLayout.width
                                    height: gridLayout.height * 0.1
                                }
                            }
                        ]

                        function setSquareUnitOpacity() {
                            if(squareRepeater.gridIndex == largestNumberRepresentation.count - 1) {
                                if(index >= Activity.lastBarSquareUnits) return 0.3
                            }

                            if(index < selectedSquareNumbers) return 1
                            else return 0.7
                        }

                        Image {
                            id: crossImage
                            source: "qrc:/gcompris/src/activities/learn_decimals/resource/cross.svg"
                            anchors.fill: parent
                            visible: square.opacity == 0.7 ? true : false
                        }

                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            onPressed: {
                                if(items.typeResult) return;
                                gridLayout.barClicked();

                                //All bars before the clicked bar are totally full
                                var i;
                                for(i = 0; i < multipleBars.currentIndex ; i++) {
                                    Activity.changeMultiBarVisibility(i, Activity.squaresNumber);
                                }

                                //Adjusting the visibility of square units of the clicked bar.
                                Activity.changeMultiBarVisibility(i, index + 1);
                                i = i + 1;

                                //All bars after the clicked bar are totally transparent.
                                for(; i < largestNumberRepresentation.count; i++) {
                                    Activity.changeMultiBarVisibility(i, 0);
                                }
                            }
                        }
                    }
                }
            }

            Item {
                id: emptySpace

                states: [
                    State {
                        when: background.horizontalLayout
                        PropertyChanges {
                            target: emptySpace
                            width: multipleBars.cellWidth
                            height: multipleBars.cellHeight * 0.5
                        }
                        AnchorChanges {
                            target: emptySpace
                            anchors.top: gridLayout.bottom
                        }
                    },
                    State {
                        when: !background.horizontalLayout
                        PropertyChanges {
                            target: emptySpace
                            width: multipleBars.cellWidth * 0.5
                            height: multipleBars.cellHeight
                        }
                        AnchorChanges {
                            target: emptySpace
                            anchors.right: gridLayout.left
                        }
                    }
                ]
            }
        }
    }
}
