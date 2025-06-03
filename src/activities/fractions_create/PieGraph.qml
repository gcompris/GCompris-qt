/* GCompris - PieGraph.qml
*
* SPDX-FileCopyrightText: 2025 Johnny Jazeix <jazeix@gmail.com>
* SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick
import QtGraphs

import "../../core"

GraphsView {
    id: chart
    theme: GraphsTheme {
        backgroundColor: "transparent"
    }

    antialiasing: true
    property alias pieSeries: pieSeries
    PieSeries {
        id: pieSeries
        pieSize: 0.95
        selectable: true
        PieSlice {
            value: 1
            color: gridContainer.unselectedColor
            borderColor: GCStyle.whiteBorder
            borderWidth: GCStyle.thinBorder
        }

        onClicked: (slice) => {
            if(items.buttonsBlocked || activity.mode === "findFraction") {
                return;
            }
            if(slice.color == gridContainer.selectedColor) {
                numeratorText.value --;
                slice.color = gridContainer.unselectedColor;
            }
            else {
                numeratorText.value ++;
                slice.color = gridContainer.selectedColor;
            }
            // workaround for https://bugreports.qt.io/browse/QTBUG-137392
            // we need to refresh the graph to have the change taken in account
            pieSeries.visible = false; pieSeries.visible = true;
        }

        function setSliceStyle(sliceNumber: int, selected: bool) {
            var slice = pieSeries.at(sliceNumber);
            slice.borderColor = GCStyle.whiteBorder;
            slice.borderWidth = GCStyle.thinBorder;
            slice.color = selected ? gridContainer.selectedColor : gridContainer.unselectedColor;
        }
    }

    function initLevel(pieIndex: int) {
        var pieSeries = chart.pieSeries;
        pieSeries.clear();
        var sizeOfOnePie = 1.0 / items.denominatorToFind;

        for(var pieSliceIndex = 0 ; pieSliceIndex < items.denominatorToFind ; ++ pieSliceIndex) {
            pieSeries.append(1, sizeOfOnePie);
            // Select the good number of slices at the beginning
            var selectPie = (activity.mode === "findFraction" && (pieSliceIndex+pieIndex*items.denominatorToFind < items.numeratorToFind));
            pieSeries.setSliceStyle(pieSeries.count-1, selectPie);
        }
    }

    function countSelectedParts(): int {
        var selected = 0;
        for(var pieSliceIndex = 0 ; pieSliceIndex < pieSeries.count ; ++ pieSliceIndex) {
            if(pieSeries.at(pieSliceIndex).color == gridContainer.selectedColor) {
                selected ++;
            }
        }
        return selected;
    }
}
