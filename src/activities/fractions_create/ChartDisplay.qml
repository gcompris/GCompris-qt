/* GCompris - ChartDisplay.qml
 *
 * SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

Flow {
    id: gridContainer
    // color needs to be in hex format with lowercase for comparison checks to work
    readonly property string selectedColor: "#80ffffff"
    readonly property string unselectedColor: "#00000000"
    flow: items.horizontalLayout ? Flow.LeftToRight : Flow.TopToBottom
    spacing: 10
    Repeater {
        id: repeater
        model: Math.ceil(items.numeratorToFind / items.denominatorToFind)
        Loader {
            id: graphLoader
            width: gridContainer.width / repeater.model - gridContainer.spacing / 2
            height: gridContainer.height / repeater.model - gridContainer.spacing / 2
            asynchronous: false
            source: items.chartType === "pie" ? "PieChart.qml" : "RectangleChart.qml"
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
            goodAnswer = (items.numeratorValue == items.numeratorToFind) && (items.denominatorValue == items.denominatorToFind);
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
