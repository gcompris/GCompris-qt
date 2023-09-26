/* GCompris - graph-coloring.js
 *
 * Copyright (C) Akshat Tandon <akshat.tandon@research.iiit.ac.in>
 *
 * Authors:
 *
 *   Akshat Tandon <akshat.tandon@research.iiit.ac.in> (Qt Quick version)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.12 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

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
            url + "shapes/" + "star.svg",
            url + "shapes/" + "triangle.svg",
            url + "shapes/" + "heart.svg",
            url + "shapes/" + "cloud.svg",
            url + "shapes/" + "diamond.svg",
            url + "shapes/" + "star_simple.svg",
            url + "shapes/" + "cross.svg",
            url + "shapes/" + "ring.svg",
            url + "shapes/" + "circle.svg",
        ];

var graphs = [
            {
                minColor:3,
                edgeList:[
                    [0, 1], [0, 4], [1, 4], [1, 2], [1, 3], [2, 3]
                ],
                nodePositions : [
                    [0, 0], [0.5, 0.4], [1, 0], [1, 0.7], [0, 0.7]
                ]
            },
            {

                minColor: 3,
                edgeList:[
                    [0, 1], [0, 3], [1, 2], [1, 3], [2, 3]
                ],
                nodePositions : [
                    [0, 0.4], [0.5, 0], [1, 0.4], [0.5, 0.8]
                ]
            },
            {

                minColor: 4,
                edgeList:[
                    [0, 1], [0, 2], [0, 3],
                    [1, 2], [1, 3],
                    [2, 3]
                ],
                nodePositions : [
                    [0.628, 0.401],
                    [0.083, 0.401],
                    [0.900, 0.030],
                    [0.900, 0.773]
                ]

            },
            {

                minColor: 3,
                edgeList:[
                    [0,1], [1,2], [2,3], [3,4], [4,0], [5,7],
                    [7,9], [9,6], [6,8], [8,5], [0,5], [1,6],
                    [2,7], [3,8], [4,9]
                ],
                nodePositions : [
                    [0.5,0], [0.90,0.35], [0.80,0.80],
                    [0.20, 0.80], [0.10, 0.35], [0.5,0.20],
                    [0.75,0.45], [0.65, 0.65], [0.35, 0.65], [0.25, 0.45]
                ]

            },
            {

                minColor: 5,
                edgeList: [
                    [5, 1],
                    [5, 0],
                    [0, 3],
                    [0, 1],
                    [0, 2],
                    [2, 4],
                    [2, 1],
                    [3, 4],
                    [3, 2],
                    [4, 1],
                    [5, 4],
                    [5, 3]
                ],
                nodePositions : [
                    [0.75, 0.00],
                    [0.75, 0.80],
                    [1.00, 0.40],
                    [0.25, 0.00],
                    [0.25, 0.80],
                    [0.00, 0.40]
                ]

            },
            {

                minColor: 3,
                edgeList: [
                    [5, 4],
                    [2, 0],
                    [0, 1],
                    [1, 5],
                    [4, 3],
                    [3, 2],
                    [0, 11],
                    [1, 6],
                    [7, 5],
                    [3, 9],
                    [8, 4],
                    [2, 10],
                    [11, 9],
                    [7, 9],
                    [11, 7],
                    [6, 8],
                    [10, 8],
                    [6, 10]
                ],
                nodePositions : [
                    [0.26, 0.00],
                    [0.74, 0.00],
                    [0.00, 0.40],
                    [0.26, 0.80],
                    [0.74, 0.80],
                    [1.00, 0.40],
                    [0.62, 0.26],
                    [0.74, 0.40],
                    [0.62, 0.64],
                    [0.38, 0.64],
                    [0.26, 0.40],
                    [0.38, 0.26]
                ]
            },
            {

                minColor: 4,
                edgeList: [
                    [0, 8],
                    [0, 4],
                    [3, 6],
                    [10, 3],
                    [2, 11],
                    [7, 2],
                    [9, 1],
                    [5, 1],
                    [0, 1],
                    [1, 2],
                    [4, 6],
                    [8, 9],
                    [10, 11],
                    [0, 3],
                    [3, 2],
                    [8, 11],
                    [10, 9],
                    [4, 7],
                    [5, 7],
                    [6, 5],
                    [6, 9],
                    [10, 5],
                    [4, 11],
                    [8, 7]
                ],
                nodePositions : [
                    [0.00, 0.00],
                    [1.00, 0.00],
                    [1.00, 0.80],
                    [0.00, 0.80],
                    [0.32, 0.32],
                    [0.74, 0.32],
                    [0.32, 0.53],
                    [0.74, 0.53],
                    [0.42, 0.22],
                    [0.63, 0.22],
                    [0.42, 0.64],
                    [0.63, 0.64]
                ]
            }
        ]

var levels = [
            {extraColor:1, graph:graphs[0]},
            {extraColor:0, graph:graphs[0]},
            {extraColor:1, graph:graphs[1]},
            {extraColor:0, graph:graphs[1]},
            {extraColor:1, graph:graphs[2]},
            {extraColor:0, graph:graphs[2]},
            {extraColor:1, graph:graphs[3]},
            {extraColor:0, graph:graphs[3]},
            {extraColor:1, graph:graphs[4]},
            {extraColor:0, graph:graphs[4]},
            {extraColor:1, graph:graphs[5]},
            {extraColor:0, graph:graphs[5]},
            {extraColor:1, graph:graphs[6]},
            {extraColor:0, graph:graphs[6]}
        ];

var numberOfLevel = levels.length

function start(items_) {
    items = items_
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    initLevel()
}

function stop() {
}

function initLevel() {
    coloringLeft = true
    var currentIndeces = new Array();
    var levelData = levels[items.currentLevel].graph
    items.colorsRepeater.model.clear();
    items.nodesRepeater.model.clear();
    items.edgesRepeater.model.clear();
    var numColors = levelData.minColor + levels[items.currentLevel].extraColor;
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
    if(items.keyNavigationMode) {
        items.nodeHighlight.setHighlight(0);
    }
}

function checkGuess() {
    var flag = false;
    var levelData = levels[items.currentLevel].graph
    //Check whether all the nodes have been colored or not
    for (var i = 0; i < levelData.nodePositions.length; i++){
        var node1 = items.nodesRepeater.model.get(i)
        if (node1.colIndex == -1){
            flag = true;
            break;
        }
    }

    //Check whether the adjacent nodes do not have the same color
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
    var levelData = levels[items.currentLevel].graph
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
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function focusEventInput() {
    if (items && items.eventHandler)
        items.eventHandler.forceActiveFocus();
}
