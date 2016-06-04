/* GCompris - family.js
 *
 * Copyright (C) 2016 RAJDEEP KAUR <rajdeep.kaur@kde.org>
 *
 * Authors:
 *   RAJDEEP KAUR <rajdeep.kaur@kde.org>
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
.import GCompris 1.0 as GCompris

var currentLevel = 0
var items;
var barAtStart;
var url = "qrc:/gcompris/src/activities/family/resource/"
var treeStructure = [
                    // level 1
                    {  edgeList: [
                                   [0.37, 0.25, 0.64, 0.25],
                                   [0.51, 0.25, 0.51, 0.50]
                                ],
                       nodePositions: [
                               [0.211, 0.20],
                               [0.633, 0.20],
                               [0.40, 0.50]
                       ],
                       captions: [ [0.27, 0.57],
                                  [0.101, 0.25]
                                ],
                       nodeleave: ["man3.svg", "lady2.svg", "boy1.svg"],
                       currentstate: ["activeto", "deactive", "active"],
                       edgeState:["married","others"],
                       answer: [qsTr("Father")],
                       optionss: [qsTr("Father"), qsTr("Grandfather"), qsTr("Uncle")]

                    },
                    // level 2
                    {  edgeList: [
                                   [0.37, 0.25, 0.64, 0.25],
                                   [0.51, 0.25, 0.51, 0.50]
                                ],
                      nodePositions: [
                                  [0.211, 0.20],
                                  [0.633, 0.20],
                                  [0.4, 0.50]
                      ],
                      captions: [  [0.27, 0.57],
                                  [0.8283, 0.24]
                               ],
                      nodeleave: ["man3.svg", "lady2.svg", "boy1.svg"],
                      currentstate: ["deactive", "activeto", "active"],
                      edgeState:["married","others"],
                      answer: [qsTr("Mother")],
                      optionss: [qsTr("Mother"), qsTr("Grandmother"), qsTr("Aunt")]

                    },
                    // level 3
                    {  edgeList: [ [0.37, 0.25, 0.64, 0.25],
                                  [0.51, 0.257, 0.42, 0.50],
                                  [0.51, 0.257, 0.63, 0.50]
                                ],
                       nodePositions: [
                                [0.211, 0.20],
                                [0.633, 0.20],
                                [0.33, 0.50],
                                [0.55, 0.50]
                       ],
                       captions:[ [0.21, 0.59],
                                   [0.740, 0.595]
                                ],
                       nodeleave: ["man3.svg", "lady2.svg", "boy1.svg", "boy2.svg"],
                       currentstate: ["deactive", "deactive", "active", "activeto"],
                       edgeState:["married","others","others","others"],
                       answer: [qsTr("Brother")],
                       optionss: [qsTr("Cousin"), qsTr("Brother"), qsTr("Sister")]
                    },
                    // level 4
                    {  edgeList: [ [0.37, 0.25, 0.64, 0.25],
                                  [0.51, 0.26, 0.33, 0.50],
                                  [0.51, 0.25, 0.51, 0.50],
                                  [0.51, 0.25, 0.70, 0.51]
                              ],
                      nodePositions: [
                                 [0.211, 0.20],
                                 [0.633, 0.20],
                                 [0.22, 0.50],
                                 [0.43, 0.50],
                                 [0.65, 0.50]
                            ],
                      captions: [ [0.27,0.74],
                                  [0.49,0.74]
                                ],
                      nodeleave: ["man3.svg", "lady2.svg", "boy1.svg", "girl1.svg", "boy2.svg"],
                      currentstate: ["deactive", "deactive", "active", "activeto", "deactive"],
                      edgeState:["married","others","others","others"],
                      answer: [qsTr("Sister")],
                      optionss: [qsTr("Cousin"), qsTr("Brother"), qsTr("Sister")]
                    },
                    // level 5
                    {  edgeList: [ [0.445, 0.17, 0.567, 0.17],
                                   [0.515, 0.17, 0.515, 0.45],
                                   [0.41, 0.45, 0.60, 0.45],
                                   [0.515, 0.45, 0.515, 0.65],
                                   [0.33, 0.65, 0.70, 0.65],
                                   [0.33, 0.65, 0.33, 0.70],
                                   [0.515, 0.65, 0.515, 0.70],
                                   [0.70, 0.65, 0.70, 0.725]
                      ],
                      nodePositions: [
                                   [0.2911, 0.10],
                                   [0.553, 0.10],
                                   [0.251, 0.390],
                                   [0.588, 0.390],
                                   [0.22, 0.70],
                                   [0.43, 0.70],
                                   [0.65, 0.70]
                      ],
                      captions: [  [0.10,0.76],
                                   [0.20,0.17],
                                ],
                      nodeleave: ["grandfather.svg", "old-lady.svg", "man2.svg", "lady1.svg", "girl1.svg", "boy1.svg", "boy2.svg"],
                      currentstate: ["activeto", "deactive", "deactive", "deactive", "active", "deactive", "deactive"],
                      edgeState:["married","others","married","others","others","others","others","others" ],
                      answer: [qsTr("Grandfather")],
                      optionss: [qsTr("Granddaughter"), qsTr("Grandson"), qsTr("Grandfather"), qsTr("Grandmother")]
                     },
                     // level 6
                     { edgeList: [ [0.445, 0.17, 0.567, 0.17],
                                   [0.515, 0.17, 0.515, 0.45],
                                   [0.41, 0.45, 0.60, 0.45],
                                   [0.515, 0.45, 0.515, 0.65],
                                   [0.33, 0.65, 0.70, 0.65],
                                   [0.33, 0.65, 0.33, 0.70],
                                   [0.515, 0.65, 0.515, 0.70],
                                   [0.70, 0.65, 0.70, 0.725]
                       ],
                       nodePositions: [
                                  [0.2911, 0.10],
                                  [0.553, 0.10],
                                  [0.251, 0.390],
                                  [0.588, 0.390],
                                  [0.22, 0.70],
                                  [0.43, 0.70],
                                  [0.65, 0.70]
                      ],

                      captions: [   [0.85,0.76],
                                    [0.743,0.16]
                                ],
                      nodeleave: ["grandfather.svg", "old-lady.svg", "man2.svg", "lady1.svg", "boy1.svg", "girl1.svg", "boy2.svg"],
                      currentstate: ["deactive", "activeto", "deactive", "deactive", "deactive", "deactive", "active", "active"],
                      edgeState:["married","others","married","others","others","others","others","others" ],
                      answer: [qsTr("Grandmother")],
                      optionss: [qsTr("Granddaughter"), qsTr("Grandson"), qsTr("Grandfather"), qsTr("Grandmother")],
                   },
                   // level 7
                   {  edgeList: [ [0.44, 0.17, 0.567, 0.17],
                                  [0.515, 0.17, 0.515, 0.45],
                                  [0.41, 0.45, 0.60, 0.45],
                                  [0.515, 0.45, 0.515, 0.65],
                                  [0.33, 0.65, 0.70, 0.65],
                                  [0.33, 0.65, 0.33, 0.70],
                                  [0.525, 0.65, 0.525, 0.70],
                                  [0.70, 0.65, 0.70, 0.725]
                      ],
                      nodePositions: [
                                 [0.2911, 0.10],
                                 [0.553, 0.10],
                                 [0.251, 0.39],
                                 [0.588, 0.39],
                                 [0.22, 0.70],
                                 [0.43, 0.70],
                                 [0.65, 0.70]
                      ],

                      captions: [  [0.17,0.17],
                                   [0.85,0.76]
                                ],
                      nodeleave: ["grandfather.svg", "old-lady.svg", "man2.svg", "lady1.svg", "boy1.svg", "boy2.svg","girl1.svg" ],
                      currentstate: ["active", "deactive", "deactive", "deactive", "deactive", "deactive", "activeto"],
                      edgeState:["married","others","married","others","others","others","others","others" ],
                      answer: [qsTr("Granddaughter")],
                      optionss: [qsTr("Granddaughter"), qsTr("Grandson"), qsTr("Grandfather"), qsTr("Grandmother")]
                   },
                   // level 8
                   {  edgeList: [ [0.44, 0.17, 0.567, 0.17],
                              [0.515, 0.17, 0.515, 0.45],
                              [0.41, 0.45, 0.60, 0.45],
                              [0.515, 0.45, 0.515, 0.65],
                              [0.33, 0.65, 0.70, 0.65],
                              [0.33, 0.65, 0.33, 0.70],
                              [0.515, 0.65, 0.515, 0.70],
                              [0.70, 0.65, 0.70, 0.725]
                   ],
                   nodePositions: [
                              [0.2911, 0.10],
                              [0.553, 0.10],
                              [0.251, 0.39],
                              [0.588, 0.39],
                              [0.22, 0.70],
                              [0.43, 0.70],
                              [0.65, 0.70]
                  ],

                  captions: [ [0.743,0.16],
                              [0.85,0.76]
                            ],
                  nodeleave: ["grandfather.svg", "old-lady.svg", "man2.svg", "lady1.svg", "boy1.svg", "girl1.svg", "boy2.svg"],
                  currentstate: ["deactive", "active", "deactive", "deactive", "deactive", "deactive", "activeto", "active"],
                  edgeState:["married","others","married","others","others","others","others","others" ],
                  answer: [qsTr("Grandson")],
                  optionss: [qsTr("Granddaughter"), qsTr("Grandson"), qsTr("Grandfather"), qsTr("Grandmother")]
                   },
                   // level 9
                   {  edgeList: [  [0.50, 0.17, 0.53, 0.17],
                                   [0.525, 0.17, 0.525, 0.45],
                                   [0.41, 0.45, 0.60, 0.45],
                                   [0.22, 0.45, 0.254, 0.45],
                                   [0.22, 0.45, 0.22, 0.72],
                                   [0.22, 0.71, 0.25, 0.71],
                                   [0.78, 0.45, 0.83, 0.45],
                                   [0.83, 0.45, 0.83, 0.72],
                                   [0.83, 0.72, 0.78, 0.72]


                        ],
                      nodePositions: [
                                   [0.311, 0.10],
                                   [0.251, 0.40],
                                   [0.588, 0.40],
                                   [0.22, 0.70],
                                   [0.610, 0.70]


                        ],

                     captions: [  [0.83,0.76],
                                  [0.118,0.76],
                        ],
                     nodeleave: ["grandfather.svg", "man3.svg", "man2.svg", "boy1.svg","boy2.svg"],
                     currentstate: ["deactive", "deactive", "deactive", "active","activeto"],
                     edgeState:["others","others","others","others","others","others"],
                     answer: [qsTr("Cousin")],
                     optionss: [qsTr("Brother"), qsTr("Sister"), qsTr("Cousin")]
                   },
                   // level 10
                   {  edgeList: [  [0.50, 0.17, 0.53, 0.17],
                              [0.525, 0.17, 0.525, 0.45],
                              [0.41, 0.45, 0.60, 0.45],
                              [0.22, 0.45, 0.254, 0.45],
                              [0.22, 0.45, 0.22, 0.72],
                              [0.22, 0.71, 0.25, 0.71]
                           ],
                  nodePositions: [
                              [0.311, 0.10],
                              [0.251, 0.40],
                              [0.588, 0.40],
                              [0.22, 0.70]

                  ],

                  captions: [   [0.10,0.76],
                                [0.77,0.45]
                            ],
                  nodeleave: ["grandfather.svg", "man3.svg", "man2.svg", "boy1.svg"],
                  currentstate: ["deactive", "deactive", "activeto", "active"],
                  edgeState:["others","others","siblings","others","others","others"],
                  answer: [qsTr("Uncle")],
                  optionss: [qsTr("Uncle"), qsTr("Aunt"), qsTr("Nephew"), qsTr("Niece")]
                   },
                   // level 11
                   {  edgeList: [  [0.50, 0.17, 0.53, 0.17],
                              [0.525, 0.17, 0.525, 0.45],
                              [0.41, 0.45, 0.60, 0.45],
                              [0.22, 0.45, 0.254, 0.45],
                              [0.22, 0.45, 0.22, 0.72],
                              [0.22, 0.71, 0.25, 0.71]
                        ],
                 nodePositions: [
                              [0.311, 0.10],
                              [0.251, 0.40],
                              [0.588, 0.40],
                              [0.22, 0.70]

                       ],

                 captions: [  [0.77,0.45],
                              [0.118,0.76],
                           ],
                 nodeleave: ["grandfather.svg", "man3.svg", "man2.svg", "boy1.svg"],
                 currentstate: ["deactive", "deactive", "active", "activeto"],
                 edgeState:["others","others","siblings","others","others","others"],
                 answer: [qsTr("Nephew")],
                 optionss: [qsTr("Uncle"), qsTr("Aunt"), qsTr("Nephew"), qsTr("Niece")]
                  },
                   // level 12
                   {  edgeList: [  [0.45, 0.17, 0.56, 0.17],
                           [0.515, 0.17, 0.515, 0.45],
                           [0.41, 0.45, 0.60, 0.45],
                           [0.22, 0.45, 0.254, 0.45],
                           [0.22, 0.45, 0.22, 0.72],
                           [0.22, 0.71, 0.25, 0.71]
                     ],
              nodePositions: [
                           [0.301, 0.10],
                           [0.553, 0.10],
                           [0.251, 0.40],
                           [0.588, 0.40],
                           [0.22, 0.70]

                    ],

              captions: [  [0.118,0.76],
                           [0.83,0.45],
                        ],
              nodeleave: ["grandfather.svg", "old-lady.svg", "man3.svg", "lady1.svg", "babyboy.svg"],
              currentstate: ["deactive", "deactive", "deactive", "activeto", "active"],
              edgeState:["married","others","siblings","others","others","others"],
              answer: [qsTr("Aunt")],
              optionss: [qsTr("Uncle"), qsTr("Aunt"), qsTr("Nephew"), qsTr("Niece")]
                   },
                   // level 13
                   {  edgeList: [  [0.44, 0.17, 0.55, 0.17],
                           [0.505, 0.17, 0.505, 0.45],
                           [0.41, 0.45, 0.60, 0.45],
                           [0.22, 0.45, 0.254, 0.45],
                           [0.22, 0.45, 0.22, 0.72],
                           [0.22, 0.71, 0.25, 0.71]
              ],
            nodePositions: [
                           [0.291, 0.10],
                           [0.543, 0.10],
                           [0.251, 0.40],
                           [0.588, 0.40],
                           [0.22, 0.70]
               ],

              captions: [  [0.83,0.45],
                           [0.118,0.76]
                        ],
              nodeleave: ["grandfather.svg", "old-lady.svg", "man3.svg", "lady1.svg", "babygirl.svg"],
              currentstate: ["deactive", "deactive", "deactive", "active", "activeto"],
              edgeState:["married","others","siblings","others","others","others"],
              answer: [qsTr("Niece")],
              optionss: [qsTr("Uncle"), qsTr("Aunt"), qsTr("Nephew"), qsTr("Niece")]
                   },
                   // level 14
                   {  edgeList: [     [0.62, 0.16, 0.745, 0.16],
                           [0.69, 0.16, 0.69, 0.70],
                           [0.69, 0.52, 0.555, 0.52],
                           [0.405, 0.53, 0.32, 0.53],
                           [0.68, 0.695, 0.75, 0.695]
            ],
            nodePositions: [
                          [0.463, 0.10],
                          [0.733, 0.10],
                          [0.400, 0.45],
                          [0.150, 0.45],
                          [0.733, 0.67]
            ],

            captions: [   [0.02,0.51],
                          [0.32,0.16]
                      ],
            nodeleave: ["grandfather.svg", "old-lady.svg", "man3.svg", "lady2.svg", "man1.svg"],
            currentstate: ["activeto", "deactive", "deactive", "active", "deactive"],
            edgeState:["married","others","others","married","others"],
            answer: [qsTr("Father-in-law")],
            optionss: [qsTr("Father-in-law"), qsTr("Mother-in-law"), qsTr("Sister-in-law"), qsTr("Brother-in-law"), qsTr("Daughter-in-law")]
                   },
                   // level 15
                   {  edgeList: [     [0.62, 0.16, 0.745, 0.16],
                              [0.69, 0.16, 0.69, 0.70],
                              [0.69, 0.50, 0.555, 0.50],
                              [0.405, 0.53, 0.32, 0.53],
                              [0.68, 0.695, 0.75, 0.695]
               ],
            nodePositions: [
                           [0.463, 0.10],
                           [0.733, 0.10],
                           [0.400, 0.45],
                           [0.150, 0.45],
                           [0.733, 0.67]
              ],

             captions: [  [0.02,0.51],
                          [0.80,0.365],
                       ],
             nodeleave: ["grandfather.svg", "old-lady.svg", "man3.svg", "lady2.svg", "man1.svg"],
             currentstate: ["deactive", "activeto", "deactive", "active", "deactive"],
              edgeState:["married","others","others","married","others"],
             answer: [qsTr("Mother-in-law")],
             optionss: [qsTr("Father-in-law"), qsTr("Mother-in-law"), qsTr("Sister-in-law"), qsTr("Brother-in-law"), qsTr("Daughter-in-law")]
                   },
                   // level 16
                   {  edgeList: [     [0.62, 0.16, 0.745, 0.16],
                            [0.69, 0.16, 0.69, 0.70],
                            [0.69, 0.50, 0.555, 0.50],
                            [0.405, 0.53, 0.32, 0.53],
                            [0.68, 0.695, 0.75, 0.695]
                  ],
             nodePositions: [
                            [0.463, 0.10],
                            [0.733, 0.10],
                            [0.400, 0.45],
                            [0.150, 0.45],
                            [0.733, 0.67]
                 ],

            captions: [ [0.02,0.51],
                        [0.78,0.52]
                      ],
            nodeleave: ["grandfather.svg", "old-lady.svg", "man3.svg", "lady2.svg", "man1.svg"],
            currentstate: ["deactive", "deactive", "deactive", "active", "activeto"],
             edgeState:["married","others","others","married","others"],
            answer: [qsTr("Brother-in-law")],
            optionss: [qsTr("Father-in-law"), qsTr("Mother-in-law"), qsTr("Sister-in-law"), qsTr("Brother-in-law"), qsTr("Daughter-in-law")]
                   },
                   // level 17
                   {  edgeList: [     [0.50, 0.16, 0.61, 0.16],
                            [0.56, 0.16, 0.56, 0.70],
                            [0.56, 0.50, 0.44, 0.50],
                            [0.310, 0.53, 0.21, 0.53],
                            [0.555, 0.695, 0.63, 0.695],
                            [0.615, 0.765, 0.47, 0.765]
                    ],
            nodePositions: [
                            [0.343, 0.10],
                            [0.603, 0.10],
                            [0.300, 0.45],
                            [0.040, 0.45],
                            [0.603, 0.67],
                            [0.30, 0.70]
                    ],

            captions: [ [0.10,0.34],
                        [0.20,0.76]
                      ],
            nodeleave: ["grandfather.svg", "old-lady.svg", "man3.svg", "lady2.svg", "man1.svg", "lady1.svg"],
            currentstate: ["dective", "deactive", "deactive", "active", "deactive", "activeto"],
            edgeState:["married","others","others","married","others","married"],
            answer: [qsTr("Sister-in-law")],
            optionss: [qsTr("Father-in-law"), qsTr("Mother-in-law"), qsTr("Sister-in-law"), qsTr("Brother-in-law"), qsTr("Daughter-in-law")]
                   },
                   // level 18
                   {  edgeList: [     [0.61, 0.16, 0.745, 0.16],
                            [0.69, 0.16, 0.69, 0.70],
                            [0.69, 0.50, 0.56, 0.50],
                            [0.41, 0.53, 0.32, 0.53],
                            [0.69, 0.695, 0.75, 0.695]
                    ],
            nodePositions: [
                            [0.463, 0.10],
                            [0.733, 0.10],
                            [0.400, 0.45],
                            [0.150, 0.45],
                            [0.733, 0.67]
                   ],

             captions: [ [0.32,0.15],
                         [0.05,0.50]
                       ],
             nodeleave: ["grandfather.svg", "old-lady.svg", "lady2.svg", "man3.svg", "man1.svg"],
             currentstate: ["active", "deactive", "deactive", "activeto", "deactive", "deactive"],
             edgeState:["married","others","others","married","others"],
             answer: [qsTr("Son-in-law")],
             optionss: [qsTr("Son-in-law"), qsTr("Mother-in-law"), qsTr("Sister-in-law"), qsTr("Brother-in-law"), qsTr("Daughter-in-law")]
            }
]

var numberOfLevel = treeStructure.length;
var answerButtonRatio = 0;

function start(items_) {
    items = items_
    currentLevel = 0
    barAtStart = GCompris.ApplicationSettings.isBarHidden;
    GCompris.ApplicationSettings.isBarHidden = true;
    initLevel()
}

function stop() {
    GCompris.ApplicationSettings.isBarHidden = barAtStart;
}

function initLevel() {
    items.bar.level = currentLevel + 1
    var levelTree = treeStructure[currentLevel]
    answerButtonRatio = 1/(levelTree.optionss.length+4);
    items.nodeCreator.model.clear();
    items.answersChoice.model.clear();
    items.edgeCreator.model.clear();
    items.wringcreator.model.clear();
    for(var i = 0 ; i < levelTree.nodePositions.length ; i++) {
        items.nodeCreator.model.append({
                       "xx": levelTree.nodePositions[i][0],
                       "yy": levelTree.nodePositions[i][1],
                       "nodee": levelTree.nodeleave[i],
                       "currentstate": levelTree.currentstate[i]
                     });
    }

    for(var j = 0 ; j <levelTree.optionss.length ; j++) {
       items.answersChoice.model.append({
               "optionn": levelTree.optionss[j],
               "answer": levelTree.answer[0]
       });
    }

    for(var k = 0 ; k < levelTree.edgeList.length ; k++) {
        items.edgeCreator.model.append({
             "x1": levelTree.edgeList[k][0],
             "y1": levelTree.edgeList[k][1],
             "x22": levelTree.edgeList[k][2],
             "y22": levelTree.edgeList[k][3],
             "edgeState": levelTree.edgeState[k]

        });
    }

    for(var l = 0 ; l < levelTree.edgeState.length ; l++) {
        if(levelTree.edgeState[l] === "married") {
            var xcor = (levelTree.edgeList[l][0]+levelTree.edgeList[l][2]-0.04)/2;
            var ycor =  levelTree.edgeList[l][3] -0.02
            items.wringcreator.model.append({
                "ringx": xcor,
                "ringy": ycor
            });
        }
    }
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel) {
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
