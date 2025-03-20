/* GCompris - superbrain.js
 *
 * SPDX-FileCopyrightText: 2015 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.12 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var maxLevel = 8;
var maxSubLevel = 6;
var items;
var baseUrl = "qrc:/gcompris/src/activities/graph-coloring/resource/shapes/";

var levels = [
            { numberOfPieces: 3, numberOfColors: 5, help: true,  uniqueColors: true  },
            { numberOfPieces: 4, numberOfColors: 6, help: true,  uniqueColors: true  },
            { numberOfPieces: 5, numberOfColors: 7, help: true,  uniqueColors: true  },
            { numberOfPieces: 5, numberOfColors: 7, help: true,  uniqueColors: false },
            { numberOfPieces: 3, numberOfColors: 5, help: false, uniqueColors: true  },
            { numberOfPieces: 4, numberOfColors: 6, help: false, uniqueColors: true  },
            { numberOfPieces: 5, numberOfColors: 7, help: false, uniqueColors: true  },
            { numberOfPieces: 5, numberOfColors: 7, help: false, uniqueColors: false }
        ];
var maxPieces = 5;
var solution = new Array(maxPieces);
var colors = [
            "#387BE0",  // dark blue
            "#8EEB76",  // light green
            "#E65B48",  // red
            "#ECA06F",  // bluish white
            "#E31BE3",  // magenta
            "#E8EF48",  // yellow
            "#BBB082",  // brown
            "#49BBF0",  // light blue
            "#D81965",   // dark magenta
        ];
var symbols = [
            baseUrl + "star.svg",
            baseUrl + "triangle.svg",
            baseUrl + "heart.svg",
            baseUrl + "hexagon.svg",
            baseUrl + "diamond.svg",
            baseUrl + "star_simple.svg",
            baseUrl + "cross.svg",
            baseUrl + "ring.svg",
            baseUrl + "circle.svg",
        ];

var ackColors = new Array();
var currentIndeces = new Array();
var maxColors = colors.length;

var STATUS_UNKNOWN = 0;
var STATUS_MISPLACED = 1;
var STATUS_CORRECT = 2;

function start(items_) {
    items = items_;
    items.currentLevel = Core.getInitialLevel(maxLevel);
    items.score.currentSubLevel = 0;
    initLevel();
}

function stop() {
}

function initLevel() {
    // init sublevel
    ackColors = new Array(levels[items.currentLevel].numberOfPieces);
    items.score.numberOfSubLevels = maxSubLevel;
    var selectedColors = new Array(maxColors);
    solution = new Array(levels[items.currentLevel].numberOfPieces);
    for (var i = 0; i < maxColors; ++i)
        selectedColors[i] = false;
    // generate solution:
    for(var i = 0; i < levels[items.currentLevel].numberOfPieces; ++i) {
        var j;
        do
            j = Math.floor(Math.random() * levels[items.currentLevel].numberOfColors);
        while (levels[items.currentLevel].uniqueColors && selectedColors[j]);

        solution[i] = j;
        selectedColors[j] = true;
    }
    //console.log("XXX solution: " + JSON.stringify(solution));
    // populate currentIndeces:
    items.colorsRepeater.model.clear();
    items.currentRepeater.model = new Array();
    currentIndeces = new Array();
    for (var i = 0; i < levels[items.currentLevel].numberOfColors; ++i) {
        currentIndeces[i] = i;
        items.colorsRepeater.model.append({"itemIndex": i});
    }
    items.chooserGrid.model = currentIndeces;
    // add first guess row:
    items.guessModel.clear();
    appendGuessRow();
    items.buttonsBlocked = false;
}

function appendGuessRow() {
    var guessRow = new Array();
    for (var i = 0; i < levels[items.currentLevel].numberOfPieces; ++i) {
        var col =
        guessRow.push({
                          index: i,
                          colIndex: (ackColors[i] === undefined) ? 0 : ackColors[i],
                          status: STATUS_UNKNOWN,
                          isAcked: (ackColors[i] !== undefined)
                      });
    }
    items.guessModel.insert(0, {
                                guess: guessRow,
                                result: {correct: 0, misplaced: 0}
                            });
    var obj = items.guessModel.get(0);
    items.currentRepeater.model = obj.guess;
}

function ackColor(column, colIndex) {
    ackColors[column] = (ackColors[column] == colIndex) ?  undefined : colIndex;
    for (var i = 0; i < items.guessModel.count; i++) {
        var obj = items.guessModel.get(i).guess.get(column);
        obj.isAcked = (ackColors[column] == obj.colIndex);
    }
    items.currentRepeater.model.get(column).colIndex = colIndex;
    items.currentRepeater.model.get(column).isAcked = (ackColors[column] !== undefined);
}

function checkGuess() {
    var obj = items.guessModel.get(0);
    var correctCount = 0;
    var misplacedCount = 0;

    // these will be used to check for mismatches later
    var remainingIndices = [];  // stores indices where mismatches can happen
    var remainingColors = [];   // stores the solution values at those indices

    // check for exact matches first:
    for (var i = 0; i < levels[items.currentLevel].numberOfPieces; i++) {
        var guessIndex = obj.guess.get(i).colIndex;
        var newStatus;
        if (solution[i] == guessIndex) {
            // correct
            if (levels[items.currentLevel].help)
                obj.guess.setProperty(i, "status", STATUS_CORRECT);
            correctCount++;
        }
        else {
            remainingIndices.push(i);
            remainingColors.push(solution[i]);
        }
    }
    obj.result = ({ correct: correctCount });
    if (remainingIndices.length == 0) {
        items.buttonsBlocked = true;
        items.score.currentSubLevel += 1;
        items.score.playWinAnimation();
        items.goodAnswerSound.play();
        return;
    }

    for (var i = 0; i < remainingIndices.length; i++) {
        var index = remainingIndices[i];
        var guessIndex = obj.guess.get(index).colIndex;
        var newStatus = STATUS_UNKNOWN;
        if (remainingColors.indexOf(guessIndex) != -1) {
            // misplaced
            if (levels[items.currentLevel].help)
                obj.guess.setProperty(index, "status", STATUS_MISPLACED);

            // remove guessIndex from remainingColors, so that multiple mismatches are not reported
            remainingColors.splice(remainingColors.indexOf(guessIndex), 1)

            misplacedCount++;
        }
    }
    obj.result = ({ misplaced: misplacedCount, correct: correctCount });

    appendGuessRow();
}

function nextLevel() {
    items.score.stopWinAnimation();
    items.currentLevel = Core.getNextLevel(items.currentLevel, maxLevel);
    items.score.currentSubLevel = 0;
    initLevel();
}

function previousLevel() {
    items.score.stopWinAnimation();
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, maxLevel);
    items.score.currentSubLevel = 0;
    initLevel();
}

function nextSubLevel() {
    if(items.score.currentSubLevel >= maxSubLevel) {
        items.bonus.good("smiley");
    }
    else {
        initLevel();
    }
}
