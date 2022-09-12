/* GCompris - RectangleChart.qml
 *
 * SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQml.Models 2.12

GridView {
    id: chart
    anchors.fill: parent
    model: ListModel {
        id: listModel
    }
    cellWidth: parent.width / model.count
    cellHeight: parent.height

    interactive: false

    delegate: Rectangle {
        border.width: 1
        border.color: "black"
        color: selected ? gridContainer.selectedColor : gridContainer.unselectedColor
        width: chart.cellWidth;
        height: chart.cellHeight;

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
    function initLevel(pieIndex) {
        chart.model.clear();
        for(var pieSliceIndex = 0 ; pieSliceIndex < items.denominatorToFind ; ++ pieSliceIndex) {
            // Select the good number of slices at the beginning
            var selectPie = (activity.mode === "findFraction" && (pieSliceIndex+pieIndex*items.denominatorToFind < items.numeratorToFind));

            chart.model.append({
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
