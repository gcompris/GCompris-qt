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
            "#2760B5",  // dark blue
            "#8EEB76",  // light green
            "#E65B48",  // red
            "#ECA06F",  // orange
            "#E31BE3",  // magenta
            "#E8EF48",  // yellow
            "#BBB082",  // brown
            "#42B324",  // dark green
            "#881744"   // dark magenta
        ];

var symbols = [
            url + "shapes/" + "star.svg",
            url + "shapes/" + "triangle.svg",
            url + "shapes/" + "heart.svg",
            url + "shapes/" + "hexagon.svg",
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
                    [0, 0], [0.5, 0.5], [1, 0], [1, 1], [0, 1]
                ]
            },
            {

                minColor: 3,
                edgeList:[
                    [0, 1], [0, 3], [1, 2], [1, 3], [2, 3]
                ],
                nodePositions : [
                    [0, 0.5], [0.5, 0], [1, 0.5], [0.5, 1]
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
                    [0.628, 0.5],
                    [0, 0.5],
                    [1, 0],
                    [1, 1]
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
                    [0.5,0], [0.90,0.44], [0.80,1],
                    [0.20, 1], [0.10, 0.44], [0.5,0.25],
                    [0.75,0.5], [0.65, 0.8], [0.35, 0.8], [0.25, 0.5]
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
                    [0.75, 1.00],
                    [1.00, 0.50],
                    [0.25, 0.00],
                    [0.25, 1.00],
                    [0.00, 0.50]
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
                    [0.2, 0.00],
                    [0.8, 0.00],
                    [0.0, 0.50],
                    [0.2, 1.00],
                    [0.8, 1.00],
                    [1.0, 0.50],
                    [0.6, 0.25],
                    [0.8, 0.50],
                    [0.6, 0.75],
                    [0.4, 0.75],
                    [0.2, 0.50],
                    [0.4, 0.25]
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
                    [1.00, 1.00],
                    [0.00, 1.00],
                    [0.20, 0.40],
                    [0.80, 0.40],
                    [0.20, 0.60],
                    [0.80, 0.60],
                    [0.40, 0.20],
                    [0.60, 0.20],
                    [0.40, 0.80],
                    [0.60, 0.80]
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
    items.keyNavigationMode = false
    items.activityBackground.showChooser(false)
    var levelData = levels[items.currentLevel].graph
    items.nodesRepeater.model.clear();
    items.edgesRepeater.model.clear();
    items.numberOfColors = levelData.minColor + levels[items.currentLevel].extraColor;
    for (var i = 0; i < levelData.nodePositions.length; ++i){
        items.nodesRepeater.model.append({
                                             "posX":levelData.nodePositions[i][0],
                                             "posY":levelData.nodePositions[i][1],
                                             "colorIndex": -1,
                                             "isError": false
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
                                             "isError": false
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
        if (node1.colorIndex == -1){
            flag = true;
            break;
        }
    }

    //Check whether the adjacent nodes do not have the same color
    for (var i = 0; i < levelData.edgeList.length; i++){
        var node1 = items.nodesRepeater.model.get(levelData.edgeList[i][0])
        var node2 = items.nodesRepeater.model.get(levelData.edgeList[i][1])
        if (node1.colorIndex == node2.colorIndex) {
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
        if (node1.colorIndex == node2.colorIndex && node2.colorIndex != -1) {
            items.nodesRepeater.model.setProperty(node1Num, "isError", true)
            items.nodesRepeater.model.setProperty(node2Num, "isError", true)
            items.edgesRepeater.model.setProperty(i, "isError", true)
            flagNodes[node1Num] = true
            flagNodes[node2Num] = true
        }
        else {
            if(!flagNodes[node1Num]) {
                items.nodesRepeater.model.setProperty(node1Num, "isError", false)
            }
            if(!flagNodes[node2Num]) {
                items.nodesRepeater.model.setProperty(node2Num, "isError", false)
            }
            items.edgesRepeater.model.setProperty(i, "isError", false)

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
