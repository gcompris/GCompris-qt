/* GCompris - graph-coloring.js
 *
 * Copyright (C) Akshat Tandon <akshat.tandon@research.iiit.ac.in>
 *
 * Authors:
 *
 *   Akshat Tandon <akshat.tandon@research.iiit.ac.in> (Qt Quick version)
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
.pragma library
.import QtQuick 2.0 as Quick

var currentLevel = 0
var numberOfLevel = 14
var items
var url = "qrc:/gcompris/src/activities/graph-coloring/resource/"
var coloringLeft
var colors = [
            "#FF0000FF",  // dark blue
            "#FF00FF00",  // light green
            "#FFFF0000",  // red
            "#FF00FFFF",  // light blue
            "#FFFF00FF",  // magenta
            "#FFFFFF00",  // yellow
            "#FF8e7016",  // brown
            "#FF04611a",  // dark green
            "#FFa0174b"   // dark magenta
        ];

var symbols = [
            url + "shapes/" + "darkblue_star.svg",
            url + "shapes/" + "lightgreen_triangle.svg",
            url + "shapes/" + "red_heart.svg",
            url + "shapes/" + "lightblue_cloud.svg",
            url + "shapes/" + "magenta_diamond.svg",
            url + "shapes/" + "yellow_star.svg",
            url + "shapes/" + "brown_cross.svg",
            url + "shapes/" + "darkgreen_ring.svg",
            url + "shapes/" + "red_circle.svg",
        ];

var levels = [
            {extraColor:2, graph:"graph_1.qml"},
            {extraColor:0, graph:"graph_1.qml"},
            {extraColor:1, graph:"graph_2.qml"},
            {extraColor:0, graph:"graph_2.qml"},
            {extraColor:2, graph:"graph_3.qml"},
            {extraColor:0, graph:"graph_3.qml"},
            {extraColor:2, graph:"graph_4.qml"},
            {extraColor:0, graph:"graph_4.qml"},
            {extraColor:2, graph:"graph_5.qml"},
            {extraColor:0, graph:"graph_5.qml"},
            {extraColor:2, graph:"graph_6.qml"},
            {extraColor:0, graph:"graph_6.qml"},
            {extraColor:3, graph:"graph_7.qml"},
            {extraColor:0, graph:"graph_7.qml"}
        ];

var mode = "symbol";

function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {
}

function initLevel() {
    coloringLeft = true
    items.bar.level = currentLevel + 1
    var filename = url + "graphs/" + levels[currentLevel].graph
    items.dataset.source = filename
    var currentIndeces = new Array();
    var levelData = items.dataset.item
    items.colorsRepeater.model.clear();
    items.nodesRepeater.model.clear();
    items.edgesRepeater.model.clear();
    var numColors = levelData.minColor + levels[currentLevel].extraColor;
    for (var i = 0; i < numColors; ++i) {
        currentIndeces[i] = i;
        items.colorsRepeater.model.append({"itemIndex": i});
    }
    items.chooserGrid.model = currentIndeces
    for (var i = 0; i < levelData.nodePositions.length; ++i){
        items.nodesRepeater.model.append({
                                             "posX":levelData.nodePositions[i][0],
                                             "posY":levelData.nodePositions[i][1],
                                             "colIndex": -1,
                                             "highlight": false
                                         });
    }
    for (var i = 0; i < levelData.edgeList.length; ++i){
        var node1 = levelData.edgeList[i][0]
        var node2 = levelData.edgeList[i][1]
        items.edgesRepeater.model.append({
                                             "xp": levelData.nodePositions[node1][0],
                                             "yp": levelData.nodePositions[node1][1],
                                             "xpp": levelData.nodePositions[node2][0],
                                             "ypp": levelData.nodePositions[node2][1],
                                             "highlight": false
                                         });
    }
}

function checkGuess() {
    var flag = false;
    var levelData = items.dataset.item

    //Check wether all the nodes have been colored or not
    for (var i = 0; i < levelData.nodePositions.length; i++){
        var node1 = items.nodesRepeater.model.get(i)
        if (node1.colIndex == -1){
            flag = true;
            break;
        }
    }

    //Check wether the adjacent nodes do not have the same color
    for (var i = 0; i < levelData.edgeList.length; i++){
        var node1 = items.nodesRepeater.model.get(levelData.edgeList[i][0])
        var node2 = items.nodesRepeater.model.get(levelData.edgeList[i][1])
        //console.log("node1 " + levelData.edgeList[i][0] + " node2 "+ levelData.edgeList[i][1]+" node1 color "+ node1.colIndex+ " node2 color " + node2.colIndex);
        if (node1.colIndex == node2.colIndex) {
            //console.log("node1 " + levelData.edgeList[i][0] + " node2 "+ levelData.edgeList[i][1]+" node1 color "+ node1.colIndex+ " node2 color " + node2.colIndex);
            flag = true;
            break;
        }
    }
    //console.log("flag is " + flag);
    if (flag == false) {
        items.bonus.good("lion");
    }
}

function checkAdjacent() {
    var levelData = items.dataset.item
    var flagNodes = new Array(levelData.nodePositions.length)
    for (var i = 0; i < levelData.nodePositions.length; i++){
        flagNodes[i] = false
    }

    for (var i = 0; i < levelData.edgeList.length; i++){

        var node1 = items.nodesRepeater.model.get(levelData.edgeList[i][0])
        var node1Num = levelData.edgeList[i][0]
        var node2 = items.nodesRepeater.model.get(levelData.edgeList[i][1])
        var node2Num = levelData.edgeList[i][1]
        if (node1.colIndex == node2.colIndex && node2.colIndex != -1) {
            items.nodesRepeater.model.setProperty(node1Num, "highlight", true)
            items.nodesRepeater.model.setProperty(node2Num, "highlight", true)
            items.edgesRepeater.model.setProperty(i, "highlight", true)
            flagNodes[node1Num] = true
            flagNodes[node2Num] = true
        }
        else {
            if(!flagNodes[node1Num]) {
                items.nodesRepeater.model.setProperty(node1Num, "highlight", false)
            }
            if(!flagNodes[node2Num]) {
                items.nodesRepeater.model.setProperty(node2Num, "highlight", false)
            }
            items.edgesRepeater.model.setProperty(i, "highlight", false)

        }

    }

}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel ) {
        currentLevel = 0
    }
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel();
}
