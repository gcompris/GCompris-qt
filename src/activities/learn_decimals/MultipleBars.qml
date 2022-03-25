/* GCompris - MultipleBars.qml
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
    id: multipleBars
    anchors.centerIn: parent
    property int cellSize: 10
    interactive: false
    model: largestNumberRepresentation

    delegate: delegateUnit

    states: [
        State {
            when: background.horizontalLayout
            PropertyChanges {
                target: multipleBars
                cellSize: Math.min(mainRectangle.height / 6, mainRectangle.width / 11)
                cellHeight: cellSize * 1.14
                cellWidth: cellSize
                width: cellSize * 10
                height: cellSize * 5.86
                anchors.verticalCenterOffset: cellSize * 0.14
                anchors.horizontalCenterOffset: 0
                flow: GridView.FlowTopToBottom
            }
        },
        State {
            when: !background.horizontalLayout
            PropertyChanges {
                target: multipleBars
                cellSize: Math.min(mainRectangle.width / 6, mainRectangle.height / 11)
                cellHeight: cellSize
                cellWidth: cellSize * 1.14
                width: cellSize * 5.86
                height: cellSize * 10
                anchors.verticalCenterOffset: 0
                anchors.horizontalCenterOffset: cellSize * 0.14
                flow: GridView.FlowLeftToRight
            }
        }
    ]

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
                    id: squareRepeater

                    property int gridIndex: index

                    model: Activity.squaresNumber

                    Image {
                        id: squareDark
                        source: "qrc:/gcompris/src/activities/learn_decimals/resource/rectDark.svg"
                        width: multipleBars.cellSize
                        height: width
                        sourceSize.width: width

                        Image {
                            id: squareWhite
                            source: "qrc:/gcompris/src/activities/learn_decimals/resource/rectWhite.svg"
                            anchors.centerIn: parent
                            width: parent.width - 6
                            height: width
                            sourceSize.width: width
                        }

                        Image {
                            id: crossImage
                            source: "qrc:/gcompris/src/activities/learn_decimals/resource/cross.svg"
                            anchors.centerIn: parent
                            width: squareWhite.width
                            sourceSize.width: width
                            visible: squareRepeater.gridIndex < largestNumberRepresentation.count - 1 ||
                                     index < Activity.lastBarSquareUnits
                        }

                        Image {
                            id: squareFill
                            source: "qrc:/gcompris/src/activities/learn_decimals/resource/rectFill.svg"
                            anchors.centerIn: parent
                            width: squareWhite.width
                            height: width
                            sourceSize.width: width
                            visible: crossImage.visible && index < selectedSquareNumbers
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
                                Activity.changeMultiBarVisibility(i, index);
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
        }
    }
}
