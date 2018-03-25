/* GCompris - superbrain.js
 *
 * Copyright (C) 2015 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port)
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
.import QtQuick 2.6 as Quick
.import GCompris 1.0 as GCompris

var currentLevel = 0;
var maxLevel = 8;
var currentSubLevel = 0;
var maxSubLevel = 6;
var items;
var baseUrl = "qrc:/gcompris/src/activities/superbrain/resource/";

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
            "#FF0000FF",  // dark blue
            "#FF00FF00",  // light green
            "#FFFF0000",  // red
            "#FF00FFFF",  // light blue
            "#FFFF00FF",  // magenta
            "#FFFFFF00",  // yellow
            "#FF8e7016",  // brown
            "#FF04611a",  // dark green
            "#FFa0174b",   // dark magenta
        ];
var mode = "color";
var symbols = [
            baseUrl + "darkblue_star.svg",
            baseUrl + "lightgreen_triangle.svg",
            baseUrl + "red_heart.svg",
            baseUrl + "lightblue_cloud.svg",
            baseUrl + "magenta_diamond.svg",
            baseUrl + "yellow_star.svg",
            baseUrl + "brown_cross.svg",
            baseUrl + "darkgreen_ring.svg",
            baseUrl + "red_circle.svg",
        ];

var ackColors = new Array();
var currentIndeces = new Array();
var maxColors = colors.length;

var STATUS_UNKNOWN = 0;
var STATUS_MISPLACED = 1;
var STATUS_CORRECT = 2;

function start(items_) {
    items = items_;
    currentLevel = 0;
    currentSubLevel = 0;
    initLevel();
}

function stop() {
}

function initLevel() {
    if (currentSubLevel == 0) {
        // init level
        items.bar.level = currentLevel + 1;
    }

    // init sublevel
    ackColors = new Array(levels[currentLevel].numberOfPieces);
    items.score.numberOfSubLevels = maxSubLevel;
    items.score.currentSubLevel = currentSubLevel + 1;
    var selectedColors = new Array(maxColors);
    solution = new Array(levels[currentLevel].numberOfPieces);
    for (var i = 0; i < maxColors; ++i)
        selectedColors[i] = false;
    // generate solution:
    for(var i = 0; i < levels[currentLevel].numberOfPieces; ++i) {
        var j;
        do
            j = Math.floor(Math.random() * levels[currentLevel].numberOfColors);
        while (levels[currentLevel].uniqueColors && selectedColors[j]);

        solution[i] = j;
        selectedColors[j] = true;
    }
    //console.log("XXX solution: " + JSON.stringify(solution));
    // populate currentIndeces:
    items.colorsRepeater.model.clear();
    items.currentRepeater.model = new Array();
    currentIndeces = new Array();
    for (var i = 0; i < levels[currentLevel].numberOfColors; ++i) {
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
    for (var i = 0; i < levels[currentLevel].numberOfPieces; ++i) {
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
    for (var i = 0; i < levels[currentLevel].numberOfPieces; i++) {
        var guessIndex = obj.guess.get(i).colIndex;
        var newStatus;
        if (solution[i] == guessIndex) {
            // correct
            remainingIndeces.splice(remainingIndeces.indexOf(guessIndex), 1);
            if (levels[currentLevel].help)
                obj.guess.setProperty(i, "status", STATUS_CORRECT);
            correctCount++;
        }
    }
    obj.result = ({ correct: correctCount });
    if (remainingIndeces.length == 0) {
        items.bonus.good("smiley");
    }

    for (var i = 0; i < levels[currentLevel].numberOfPieces; i++) {
        if (obj.guess.get(i).status == STATUS_CORRECT)
            continue;
        var guessIndex = obj.guess.get(i).colIndex;
        var newStatus = STATUS_UNKNOWN;
        if (solution.indexOf(guessIndex) != -1 &&
                remainingIndeces.indexOf(guessIndex) != -1) {
            // misplaced
            remainingIndeces.splice(remainingIndeces.indexOf(guessIndex), 1);
            if (levels[currentLevel].help)
                obj.guess.setProperty(i, "status", STATUS_MISPLACED);
            misplacedCount++;
        }
    }
    obj.result = ({ misplaced: misplacedCount, correct: correctCount });

    appendGuessRow();
}

function nextLevel() {
    if(maxLevel <= ++currentLevel ) {
        currentLevel = 0;
    }
    currentSubLevel = 0;
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = maxLevel - 1
    }
    currentSubLevel = 0;
    initLevel();
}

function nextSubLevel() {
    if( ++currentSubLevel >= maxSubLevel) {
        currentSubLevel = 0
        nextLevel()
    }
    initLevel();
}
