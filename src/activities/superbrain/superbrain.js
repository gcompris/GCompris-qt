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
var currentSubLevel = 0;
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
            "#E7F7FD",  // bluish white
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
            baseUrl + "cloud.svg",
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
    currentSubLevel = 0;
    initLevel();
}

function stop() {
}

function initLevel() {
    if (currentSubLevel == 0) {
        // init level
    }

    // init sublevel
    ackColors = new Array(levels[items.currentLevel].numberOfPieces);
    items.score.numberOfSubLevels = maxSubLevel;
    items.score.currentSubLevel = currentSubLevel + 1;
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
}

function appendGuessRow()
{
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

function ackColor(column, colIndex)
{
    ackColors[column] = (ackColors[column] == colIndex) ?  undefined : colIndex;
    for (var i = 0; i < items.guessModel.count; i++) {
        var obj = items.guessModel.get(i).guess.get(column);
        obj.isAcked = (ackColors[column] == obj.colIndex);
    }
    items.currentRepeater.model.get(column).colIndex = colIndex;
    items.currentRepeater.model.get(column).isAcked = (ackColors[column] !== undefined);
}

function checkGuess()
{
    var remainingIndeces = solution.slice();
    var obj = items.guessModel.get(0);
    var correctCount = 0;
    var misplacedCount = 0;
    // check for exact matches first:
    for (var i = 0; i < levels[items.currentLevel].numberOfPieces; i++) {
        var guessIndex = obj.guess.get(i).colIndex;
        var newStatus;
        if (solution[i] == guessIndex) {
            // correct
            remainingIndeces.splice(remainingIndeces.indexOf(guessIndex), 1);
            if (levels[items.currentLevel].help)
                obj.guess.setProperty(i, "status", STATUS_CORRECT);
            correctCount++;
        }
    }
    obj.result = ({ correct: correctCount });
    if (remainingIndeces.length == 0) {
        items.bonus.good("smiley");
    }

    for (var i = 0; i < levels[items.currentLevel].numberOfPieces; i++) {
        if (obj.guess.get(i).status == STATUS_CORRECT)
            continue;
        var guessIndex = obj.guess.get(i).colIndex;
        var newStatus = STATUS_UNKNOWN;
        if (solution.indexOf(guessIndex) != -1 &&
                remainingIndeces.indexOf(guessIndex) != -1) {
            // misplaced
            remainingIndeces.splice(remainingIndeces.indexOf(guessIndex), 1);
            if (levels[items.currentLevel].help)
                obj.guess.setProperty(i, "status", STATUS_MISPLACED);
            misplacedCount++;
        }
    }
    obj.result = ({ misplaced: misplacedCount, correct: correctCount });

    appendGuessRow();
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, maxLevel);
    currentSubLevel = 0;
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, maxLevel);
    currentSubLevel = 0;
    initLevel();
}

function nextSubLevel() {
    if(++currentSubLevel >= maxSubLevel) {
        nextLevel();
    }
    else {
        initLevel();
    }
}
