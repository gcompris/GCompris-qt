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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
.pragma library
.import QtQuick 2.0 as Quick
.import GCompris 1.0 as GCompris

/* Todo/possible improvements:
 *
 * - select colors to guess instead of cycling through
 * - (> 6 levels with duplicate colors)
 * - improve layout for smartphones (too small, stretch horizontally/vertically
 *   in landscape/portrait orientation)
 */

var currentLevel = 0;
var maxLevel = 6;
var currentSubLevel = 0;
var maxSubLevel = 6;
var items;
var baseUrl = "qrc:/gcompris/src/activities/superbrain/resource/";

var maxLevelForHelp = 4; // after this level, we provide less feedback to the user
var numberOfPieces = 0;
var numberOfColors = 0;
var maxPieces = 5;
var solution = new Array(maxPieces);
var colors = [
            "#FF0000FF",
            "#FF00FF00",
            "#FFFF0000",
            "#FF00FFFF",
            "#FFFF00FF",
            "#FFFFFF00",
            "#FF8e7016",
            "#FF04611a",
            "#FFa0174b",
            "#FF7F007F"
        ];
var ackColors = new Array();
var currentColors = new Array();
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

        if(currentLevel + 1 < maxLevelForHelp) {
            numberOfPieces = currentLevel + 3;
            numberOfColors = currentLevel + 5;
        } else {
            numberOfPieces = currentLevel - maxLevelForHelp + 4;
            numberOfColors = currentLevel - maxLevelForHelp + 6;
        }
    }

    // init sublevel
    ackColors = new Array(numberOfPieces);
    items.score.numberOfSubLevels = maxSubLevel;
    items.score.currentSubLevel = currentSubLevel + 1;
    var selectedColors = new Array(maxColors);
    solution = new Array(numberOfPieces);
    for (var i = 0; i < maxColors; ++i)
        selectedColors[i] = false;
    // generate solution:
    for(var i = 0; i < numberOfPieces; ++i) {
        var j;
        do
            j = Math.floor(Math.random() * numberOfColors);
        while (selectedColors[j]);

        solution[i] = j;
        selectedColors[j] = true;
    }
    //console.log("XXX solution: " + JSON.stringify(solution));
    // populate currentColors:
    items.colorsRepeater.model.clear();
    items.currentRepeater.model = new Array();
    currentColors = new Array();
    for (var i = 0; i < numberOfColors; ++i) {
        currentColors[i] = colors[i];
        items.colorsRepeater.model.append({"col": colors[i]});
    }
    items.chooserGrid.model = currentColors;
    // add first guess row:
    items.guessModel.clear();
    appendGuessRow();
}

function appendGuessRow()
{
    var guessRow = new Array();
    for (var i = 0; i < numberOfPieces; ++i) {
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
    for (var i = 0; i < numberOfPieces; i++) {
        var guessIndex = obj.guess.get(i).colIndex;
        var newStatus;
        if (solution[i] == guessIndex) {
            // correct
            remainingIndeces.splice(remainingIndeces.indexOf(guessIndex), 1);
            if (currentLevel + 1 < maxLevelForHelp)
                obj.guess.setProperty(i, "status", STATUS_CORRECT);
            correctCount++;
        }
    }
    obj.result = ({ correct: correctCount });
    if (remainingIndeces.length == 0) {
        items.bonus.good("smiley");
    }

    for (var i = 0; i < numberOfPieces; i++) {
        if (obj.guess.get(i).status == STATUS_CORRECT)
            continue;
        var guessIndex = obj.guess.get(i).colIndex;
        var newStatus = STATUS_UNKNOWN;
        if (solution.indexOf(guessIndex) != -1 &&
                remainingIndeces.indexOf(guessIndex) != -1) {
            // misplaced
            remainingIndeces.splice(remainingIndeces.indexOf(guessIndex), 1);
            if (currentLevel + 1 < maxLevelForHelp)
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
