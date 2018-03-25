﻿/* GCompris - family.js
 *
 * Copyright (C) 2016 Rajdeep Kaur <rajdeep.kaur@kde.org>
 *
 * Authors:
 *
 *   Rajdeep Kaur <rajdeep.kaur@kde.org>
 *   Rudra Nil Basu <rudra.nil.basu.1996@gmail.com>
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
.pragma library
.import QtQuick 2.0 as Quick
.import GCompris 1.0 as GCompris

.import "qrc:/gcompris/src/core/core.js" as Core

var currentLevel = 0
var items;
var barAtStart;
var url = "qrc:/gcompris/src/activities/family/resource/"

var numberOfLevel
var shuffledLevelIndex = []
var levelToLoad
var answerButtonRatio = 0;

function start(items_) {
    items = items_
    currentLevel = 0
    numberOfLevel = items.dataset.levelElements.length
    barAtStart = GCompris.ApplicationSettings.isBarHidden;
    GCompris.ApplicationSettings.isBarHidden = true;

    shuffle()

    initLevel()
}

function stop() {
    GCompris.ApplicationSettings.isBarHidden = barAtStart;
}

function initLevel() {
    items.bar.level = currentLevel + 1

    items.selectedPairs.reset()
    levelToLoad = getCurrentLevelIndex()
    var levelTree = items.dataset.levelElements[levelToLoad]
    items.dataset.numberOfGenerations = levelTree.numberOfGenerations
    // Need to delay in order of the number of generation change to be taken in account
    items.loadDatasetDelay.start()
}

function loadDatasets() {
    if (!items) {
        return
    }

    var levelTree = items.dataset.levelElements[levelToLoad]

    answerButtonRatio = 1 / (levelTree.options.length + 4);

    items.nodeRepeater.model.clear();
    items.answersChoice.model.clear();
    items.edgeRepeater.model.clear();
    items.ringRepeator.model.clear();

    for(var i = 0 ; i < levelTree.nodePositions.length ; i++) {
        items.nodeRepeater.model.append({
                       "xPosition": levelTree.nodePositions[i][0],
                       "yPosition": levelTree.nodePositions[i][1],
                       "nodeValue": levelTree.nodeValue[i],
                       "currentState": items.mode == "family" ? levelTree.currentState[i] : "deactive",
                       "nodeWeight": levelTree.nodeWeights[i]
                     });
    }

    for(var i = 0 ; i <levelTree.options.length ; i++) {
       items.answersChoice.model.append({
               "optionn": levelTree.options[i],
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
        if(levelTree.edgeState[i] === "married") {
            var xcor = (levelTree.edgeList[i][0]+levelTree.edgeList[i][2]-0.04)/2;
            var ycor =  levelTree.edgeList[i][3] - 0.02
            items.ringRepeator.model.append({
                "ringx": xcor,
                "ringy": ycor
            });
        }
    }

    items.questionTopic = levelTree.answer[0]
    items.questionMarkPosition.x = levelTree.captions[1][0]
    items.questionMarkPosition.y = levelTree.captions[1][1]
    items.meLabelPosition.x = levelTree.captions[0][0]
    items.meLabelPosition.y = levelTree.captions[0][1]
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

    return shuffledLevelIndex[currentLevel]
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
