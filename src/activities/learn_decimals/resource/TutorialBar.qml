/* GCompris - TutorialBar.qml
 *
 * SPDX-FileCopyrightText: 2021 Mariam Fahmy <mariamfahmy66@gmail.com>
 *
 * Authors:
 *   Mariam Fahmy <mariamfahmy66@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0
import "../../../core"


Item {
    id: tutorialBar
    width: activityBackground.horizontalLayout ? tutorialBar.cellSize * 10 : tutorialBar.cellSize
    height: activityBackground.horizontalLayout ? tutorialBar.cellSize : tutorialBar.cellSize * 10
    property int cellSize: 10

    property alias model: rowRepeater.model

    Grid {
        id: singleBarTuto
        anchors.fill: parent
        rows: 10
        columns: 10
        flow: activityBackground.horizontalLayout ? Grid.LeftToRight : Grid.TopToBottom

        Repeater {
            id: rowRepeater

            Image {
                source: activity.isQuantityMode ? "qrc:/gcompris/src/core/resource/empty.svg" :
                    "qrc:/gcompris/src/activities/learn_decimals/resource/rectDark.svg"
                width: tutorialBar.cellSize
                height: width
                sourceSize.width: width
                visible: modelData != "none"

                Image {
                    id: whiteSquare
                    source: activity.isQuantityMode ? "qrc:/gcompris/src/activities/babyshapes/resource/food/orange.svg" :
                        "qrc:/gcompris/src/activities/learn_decimals/resource/rectWhite.svg"
                    width: parent.width - 2 * GCStyle.thinnestBorder
                    height: width
                    sourceSize.width: width
                    anchors.centerIn: parent
                    opacity: activity.isQuantityMode ? 0.2 : 1
                }
                Image {
                    source: "qrc:/gcompris/src/activities/learn_decimals/resource/cross.svg"
                    width: whiteSquare.width
                    height: width
                    sourceSize.width: width
                    anchors.centerIn: parent
                    visible: modelData === "deleted"
                }
                Image {
                    source: activity.isQuantityMode ? "qrc:/gcompris/src/activities/babyshapes/resource/food/orange.svg" :
                        "qrc:/gcompris/src/activities/learn_decimals/resource/rectFill.svg"
                    width: whiteSquare.width
                    height: width
                    sourceSize.width: width
                    anchors.centerIn: parent
                    visible: modelData === "fill"
                }
            }
        }
    }
}
