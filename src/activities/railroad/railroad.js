/* GCompris - railroad.js
 *
 * Copyright (C) 2016 Utkarsh Tiwari <iamutkarshtiwari@kde.org>
 * Copyright (C) 2018 Amit Sagtani <asagtani06@gmail.com>
 *
 * Authors:
 *   <Pascal Georges> (GTK+ version)
 *   Utkarsh Tiwari <iamutkarshtiwari@kde.org> (Qt Quick port)
 *   Amit Sagtani <asagtani06@gmail.com> (Qt Quick port)
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
.import QtQuick 2.6 as Quick
.import GCompris 1.0 as GCompris

var currentLevel = 0
var numberOfLevel = 10
var solutionArray = []
var backupListModel = []
var isNewLevel = true
var resourceURL = "qrc:/gcompris/src/activities/railroad/resource/"
var items
var uniqueId = []

/**
* Stores configuration for each level.
* 'WagonsInCorrectAnswers' contains no. of wagons in correct answer.
* 'memoryTime' contains time(in seconds) for memorizing the wagons.
* 'numberOfSubLevels' contains no. of sublevels in each level.
* 'columnsInHorizontalMode' contains no. of columns in a row of sampleZone in horizontal mode.
* 'columnsInVerticalMode' contains no. of columns in a row of sampleZone in vertical mode.
* 'noOfLocos' stores no. of locos to be displayed in sampleZone.
* 'noOfWagons' stores no. of wagons to be displayed in sampleZone.
*/
var dataset = {
    "WagonsInCorrectAnswers": [1, 1, 2, 2, 3, 3, 4, 4, 5, 5],
    "memoryTime": [4, 4, 6, 6, 7, 7, 8, 8, 10, 10],
    "numberOfSubLevels": 3,
    "columnsInHorizontalMode": [3, 5, 3, 5, 3, 5, 3, 5, 3, 5],
    "columsInVerticalMode": [3, 4, 3, 4, 3, 4, 3, 4, 3, 4],
    "noOfLocos": [8, 9, 4, 9, 4, 9, 4, 9, 4, 9],
    "noOfWagons": [4, 11, 8, 11, 8, 11, 8, 11, 8, 11]
}

function start(items_) {
    items = items_
    currentLevel = 0
    items.score.numberOfSubLevels = dataset["numberOfSubLevels"];
    items.score.currentSubLevel = 1;
    initLevel()
}

function stop() {
}

function initLevel() {
    generateUniqueId();
    items.mouseEnabled = true;
    items.memoryMode = false;
    items.trainAnimationTimer.stop();
    items.animateFlow.stop(); // Stops any previous animations
    items.listModel.clear();
    items.answerZone.currentIndex = 0;
    items.sampleList.currentIndex = 0;
    items.answerZone.selectedSwapIndex = -1;
    if(isNewLevel) {
        // Initiates a new level
        backupListModel = [];
        solutionArray = [];
        //Adds wagons to display in answerZone
        var identifier;
        // Adds a loco at the beginning
        identifier = "loco" + Math.floor(Math.random() * dataset["noOfLocos"][currentLevel])
        solutionArray.push(identifier);
        addWagon(identifier, items.listModel.length);

        for(var i = 0; i < dataset["WagonsInCorrectAnswers"][currentLevel] - 1; i++) {
            do {
                identifier = "wagon" + Math.floor(Math.random() * dataset["noOfWagons"][currentLevel])
            } while (solutionArray.indexOf(identifier) != -1)
            solutionArray.push(identifier);
            addWagon(identifier, i);
        }

        solutionArray.reverse();

    } else {
        // Re-setup the same level
        for(var i = 0; i < solutionArray.length; i++) {
            addWagon(solutionArray[i], i);
        }
    }
    if(items.introMessage.visible === false && isNewLevel) {
        items.trainAnimationTimer.start()
    }
    items.bar.level = currentLevel + 1;
    items.trainAnimationTimer.interval = dataset["memoryTime"][currentLevel] * 1000
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel) {
        currentLevel = 0
    }
    items.score.currentSubLevel = 1;
    isNewLevel = true;
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    items.score.currentSubLevel = 1;
    isNewLevel = true;
    initLevel();
}

function restoreLevel() {
    backupListModel = [];
    for (var index = 0; index < items.listModel.count; index++) {
        backupListModel.push(items.listModel.get(index).id);
    }
    isNewLevel = false;
    initLevel();
}

function nextSubLevel() {
    /* Sets up the next sublevel */
    items.score.currentSubLevel ++;
    if(items.score.currentSubLevel > dataset["numberOfSubLevels"]) {
        nextLevel();
    }
    else {
        isNewLevel = true;
        initLevel();
    }
}

function checkAnswer() {
    /* Checks if the top level setup equals the solutions */
    if(items.listModel.count === solutionArray.length) {
        var isSolution = true;
        for (var index = 0; index < items.listModel.count; index++) {
            if(items.listModel.get(index).id !== solutionArray[index]) {
                isSolution = false;
                break;
            }
        }
        if(isSolution == true) {
            items.mouseEnabled = false; // Disables the touch
            items.bonus.good("flower");
        }
        else {
            items.bonus.bad("flower");
        }
    }
    else {
        items.bonus.bad("flower");
    }
}

function addWagon(uniqueID, dropIndex) {
    /* Appends wagons to the display area */
    items.listModel.insert(dropIndex, {"id": uniqueID});
}

function getDropIndex(x) {
    var count = items.listModel.count;
    for (var index = 0; index < count; index++) {
        var xVal = items.answerZone.cellWidth * index
        var itemWidth = items.answerZone.cellWidth
        if(x < xVal && index == 0) {
            return 0;
        }
        else if((xVal + itemWidth + items.background.width * 0.0025) <= x && index == (count - 1)) {
            return count;
        }
        else if(xVal <= x && x < (xVal + itemWidth + items.background.width * 0.0025)) {
            return index + 1;
        }
    }
    return 0;
}

function generateUniqueId() {
    uniqueId = [];
    var index;
    for(index = 0; index < dataset["noOfLocos"][currentLevel]; index++) {
        uniqueId.push("loco" + index)
    }
    for(index = 0; index < dataset["noOfWagons"][currentLevel]; index++) {
        uniqueId.push("wagon" + index)
    }
}
