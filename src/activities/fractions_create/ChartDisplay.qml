/* GCompris - ChartDisplay.qml
 *
 * SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-FileCopyrightText: 2022 Timothée Giet <animtim@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

Flow {
    id: gridContainer
    // color needs to be in hex format with lowercase for comparison checks to work
    readonly property string selectedColor: "#80ffffff"
    readonly property string unselectedColor: "#00000000"
    property double layoutWidth: 10
    property double layoutHeight: 10
    property double gridItemHeight: items.horizontalLayout ?
                        Math.min(layoutWidth / repeater.model, layoutHeight) :
                        Math.min(layoutWidth, layoutHeight / repeater.model)
    property double gridItemWidth: items.horizontalLayout ? gridItemHeight :
                        layoutWidth
    width: items.horizontalLayout ? gridItemWidth * repeater.model : gridItemWidth
    height: items.horizontalLayout ? gridItemHeight : gridItemHeight * repeater.model
    flow: items.horizontalLayout ? Flow.LeftToRight : Flow.TopToBottom
    spacing: 0
    anchors.centerIn: parent
    Repeater {
        id: repeater
        model: Math.ceil(items.numeratorToFind / items.denominatorToFind)
        Loader {
            id: graphLoader
            width: gridContainer.gridItemWidth
            height: gridContainer.gridItemHeight
            asynchronous: false
            source: items.chartType === "pie" ? "PieChart.qml" : "RectangleChart.qml"
            property bool horizontalLayout: items.horizontalLayout
            property int numberOfCharts: repeater.model
        }
    }
    function initLevel() {
        for(var pieIndex = 0; pieIndex < repeater.count; ++ pieIndex) {
            repeater.itemAt(pieIndex).item.initLevel(pieIndex);
        }
    }

    function checkAnswer() {
        var goodAnswer = false;
        if(activity.mode === "selectPie") {
            // count how many selected
            var selected = 0;
            for(var pieIndex = 0; pieIndex < repeater.count; ++ pieIndex) {
                selected += repeater.itemAt(pieIndex).item.countSelectedParts();
            }
            goodAnswer = (selected == items.numeratorToFind);
        }
        else {
            // We also accept multiples of the actual solution (it is used in the case you can choose both numerator and denominator).
            // For example, if we want 2/4, we also accept 1/2 or 3/6 as good answer.
            // We force the check on the denominator not null because 1) it's not possible, 2) if both numerator and denominator to find are 0, it is not a correct answer
            goodAnswer = Number(items.denominatorValue) != 0 && (Number(items.numeratorValue) * items.denominatorToFind == items.numeratorToFind * Number(items.denominatorValue));
        }
        if(goodAnswer) {
            if (items.currentSubLevel === items.numberOfSubLevels) {
                bonus.good("sun");
            }
            else {
                bonus.good("star");
            }
        }
        else {
            bonus.bad("star");
        }
    }
}
