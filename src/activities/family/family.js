/* GCompris - family.js
 *
 * SPDX-FileCopyrightText: 2016 Rajdeep Kaur <rajdeep.kaur@kde.org>
 *
 * Authors:
 *
 *   Rajdeep Kaur <rajdeep.kaur@kde.org>
 *   Rudra Nil Basu <rudra.nil.basu.1996@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.12 as Quick
.import core 1.0 as GCompris

.import "qrc:/gcompris/src/core/core.js" as Core

var items;
var url = "qrc:/gcompris/src/activities/family/resource/"

var numberOfLevel
var shuffledLevelIndex = []
var levelToLoad

function start(items_) {
    items = items_
    numberOfLevel = items.dataset.levelElements.length
    items.currentLevel = Core.getInitialLevel(numberOfLevel)

    shuffle()

    initLevel()
}

function stop() {
}

function initLevel() {

    items.selectedPairs.reset()
    levelToLoad = getCurrentLevelIndex()
    var levelTree = items.dataset.levelElements[levelToLoad]
    loadDatasets()
}

function loadDatasets() {
    if (!items) {
        return
    }

    var levelTree = items.dataset.levelElements[levelToLoad]

    items.nodeRepeater.model.clear();
    items.answersChoice.model.clear();
    items.edgeRepeater.model.clear();
    items.ringRepeater.model.clear();

    for(var i = 0 ; i < levelTree.nodePositions.length ; i++) {
        items.nodeRepeater.model.append({
                       "xPosition": levelTree.nodePositions[i][0] - 1,
                       "yPosition": levelTree.nodePositions[i][1] - 1,
                       "nodeValue": levelTree.nodeValue[i],
                       "currentState": items.mode == "family" ? levelTree.currentState[i] : "deactive",
                       "nodeWeight": levelTree.nodeWeights[i]
                     });
        if(levelTree.currentState[i] === "active") {
            items.meLabelPosition.x = levelTree.nodePositions[i][0] - 1;
            items.meLabelPosition.y = levelTree.nodePositions[i][1] - 1;
        } else if(levelTree.currentState[i] === "activeTo") {
            items.questionMarkPosition.x = levelTree.nodePositions[i][0] - 1;
            items.questionMarkPosition.y = levelTree.nodePositions[i][1] - 1;
        }
    }

    for(var i = 0 ; i <levelTree.options.length ; i++) {
       items.answersChoice.model.append({
               "optionText": levelTree.options[i],
               "answer": levelTree.answer[0]
       });
    }

    for(var i = 0 ; i < levelTree.edgeList.length ; i++) {
        items.edgeRepeater.model.append({
             "_x1": levelTree.edgeList[i][0],
             "_y1": levelTree.edgeList[i][1],
             "_x2": levelTree.edgeList[i][2],
             "_y2": levelTree.edgeList[i][3],
             "edgeState": levelTree.edgeState[i]
        });
    }

    for(var i = 0 ; i < levelTree.edgeState.length ; i++) {
        if(levelTree.edgeState[i] === 1) {
            var xcor = levelTree.edgeList[i][0];
            var ycor =  levelTree.edgeList[i][1] - 1;
            items.ringRepeater.model.append({
                "ringX": xcor,
                "ringY": ycor
            });
        }
    }

    items.questionTopic = levelTree.answer[0]
    items.meLabelSide = levelTree.captions[0]
    items.questionMarkSide = levelTree.captions[1]
}

function shuffle() {
    for (var i = 0;i < numberOfLevel;i++) {
        shuffledLevelIndex[i] = i
    }

    Core.shuffle(shuffledLevelIndex);
}

function getCurrentLevelIndex() {
    if (!items) {
        return
    }

    return shuffledLevelIndex[items.currentLevel]
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}
