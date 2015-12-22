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
var numberOfLevel = 6
var items
var url = "qrc:/gcompris/src/activities/graph-coloring/resource/"

var colors = [
            "white",
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

var levels = [
            {numberOfColors:5, graph:"graph_1.qml"},
            {numberOfColors:3, graph:"graph_1.qml"},
            {numberOfColors:4, graph:"graph_2.qml"},
            {numberOfColors:3, graph:"graph_2.qml"},
            {numberOfColors:5, graph:"graph_3.qml"},
            {numberOfColors:3, graph:"graph_3.qml"},
        ];

function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    var filename = url + levels[currentLevel].graph
    items.dataset.source = filename
    var currentIndeces = new Array();
    var levelData = items.dataset.item
    items.colorsRepeater.model.clear();
    items.nodesRepeater.model.clear();
    items.edgesRepeater.model.clear();
    for (var i = 0; i < levels[currentLevel].numberOfColors; ++i) {
        currentIndeces[i] = i;
        items.colorsRepeater.model.append({"itemIndex": i});
    }
    items.chooserGrid.model = currentIndeces
    for (var i = 0; i < levelData.nodePositions.length; ++i){
        items.nodesRepeater.model.append({
                                             "posX":levelData.nodePositions[i][0],
                                             "posY":levelData.nodePositions[i][1],
                                             "colIndex": 0
                                         });
    }
    for (var i = 0; i < levelData.edgeList.length; ++i){
        var node1 = levelData.edgeList[i][0]
        var node2 = levelData.edgeList[i][1]
        items.edgesRepeater.model.append({
                                             "x1": levelData.nodePositions[node1][0],
                                             "y1": levelData.nodePositions[node1][1],
                                             "x2": levelData.nodePositions[node2][0],
                                             "y2": levelData.nodePositions[node2][1]
                                         });
    }
}

function checkGuess() {
    var flag = false;
    var levelData = items.dataset.item
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
    else items.bonus.bad("lion");
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
