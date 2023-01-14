/* GCompris - RectangleChart.qml
 *
 * SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-FileCopyrightText: 2022 Timothée Giet <animtim@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQml.Models 2.12

import GCompris 1.0

Item {
    id: chart

    Item {
        id: chartContainer
        // reduce the margin only in case it's vertical and there's more than one rectangle
        height: !chart.parent.horizontalLayout && chart.parent.numberOfCharts > 1 ?
            parent.height - 20 * ApplicationInfo.ratio :
            parent.height - 60 * ApplicationInfo.ratio
        width: height
        anchors.centerIn: parent

        GridView {
            id: chartGrid
            anchors.fill: parent
            model: ListModel {
                id: listModel
            }
            cellWidth: Math.floor(parent.width / model.count)
            cellHeight: cellWidth * model.count
            interactive: false
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            delegate: Rectangle {
                border.width: 5
                border.color: "white"
                color: selected ? gridContainer.selectedColor : gridContainer.unselectedColor
                // add border.width as an offset to avoid double-sized separation lines
                width: chartGrid.cellWidth + border.width
                // also add border.width to height to keep it square
                height: chartGrid.cellHeight + border.width

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if(bonus.isPlaying || activity.mode === "findFraction") {
                            return;
                        }
                        if(selected) {
                            numeratorText.value --;
                        }
                        else {
                            numeratorText.value ++;
                        }
                        selected = !selected;
                    }
                }
            }
        }
    }
    function initLevel(pieIndex) {
        chartGrid.model.clear();
        for(var pieSliceIndex = 0 ; pieSliceIndex < items.denominatorToFind ; ++ pieSliceIndex) {
            // Select the good number of slices at the beginning
            var selectPie = (activity.mode === "findFraction" && (pieSliceIndex+pieIndex*items.denominatorToFind < items.numeratorToFind));

            chartGrid.model.append({
                "selected": selectPie
            });
        }

    }

    function countSelectedParts() {
        var selected = 0;
        for(var i = 0 ; i < listModel.count ; ++ i) {
            if(listModel.get(i).selected) {
                selected ++;
            }
        }
        return selected;
    }
}
