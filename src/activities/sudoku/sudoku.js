/* gcompris - sudoku.js

 Copyright (C)
 2003, 2014: Bruno Coudoin: initial version
 2014: Johnny Jazeix: Qt port

 SPDX-License-Identifier: GPL-3.0-or-later
*/

.pragma library
.import QtQuick 2.12 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var numberOfLevel
var items
var symbols
var url = "qrc:/gcompris/src/activities/sudoku/resource/"

function start(items_) {
    items = items_
    items.score.currentSubLevel = 1
    numberOfLevel = items.levels.length
    items.currentLevel = Core.getInitialLevel(numberOfLevel);

    // Shuffle all levels
    for(var nb = 0 ; nb < items.levels.length ; ++ nb) {
        Core.shuffle(items.levels[nb]["data"]);
    }

    initLevel()
}

function stop() {
}

function initLevel() {
    items.score.numberOfSubLevels = items.levels[items.currentLevel]["data"].length
    symbols = items.levels[items.currentLevel]["symbols"]

    for(var i = items.availablePiecesModel.model.count-1 ; i >= 0 ; -- i) {
        items.availablePiecesModel.model.remove(i);
    }
    items.sudokuModel.clear();

    // Copy current sudoku in local variable
    var initialSudoku = items.levels[items.currentLevel]["data"][items.score.currentSubLevel-1];

    items.columns = initialSudoku.length
    items.rows = items.columns

    // Compute number of regions
    var nbLines = Math.floor(Math.sqrt(items.columns));
    items.background.nbRegions = (nbLines*nbLines == items.columns) ? nbLines : 1;

    // Create grid
    for(var i = 0 ; i < initialSudoku.length ; ++ i) {
        var line = [];
        for(var j = 0 ; j < initialSudoku[i].length ; ++ j) {
            items.sudokuModel.append({
                                         'textValue': initialSudoku[i][j],
                                         'initial': initialSudoku[i][j] != ".",
                                         'mState': initialSudoku[i][j] != "." ? "initial" : "default",
                                     })
        }
    }

    for(var i = 0 ; i < symbols.length ; ++ i) {
        for(var line = 0 ; line < items.sudokuModel.count ; ++ line) {
            if(items.sudokuModel.get(line).textValue == symbols[i].text) {
                items.availablePiecesModel.model.append(symbols[i]);
                break; // break to pass to the next symbol
            }
        }
    }

}

function nextLevel() {
    items.score.currentSubLevel = 1
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.score.currentSubLevel = 1
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

/*
 Code that increments the sublevel and level
 And bail out if no more levels are available
*/
function incrementLevel() {
    items.score.currentSubLevel ++

    if(items.score.currentSubLevel > items.score.numberOfSubLevels) {
        nextLevel()
    }
    else {
        initLevel()
    }
}

function clickOn(caseX, caseY) {
    var initialSudoku = items.levels[items.currentLevel]["data"][items.score.currentSubLevel-1];

    var currentCase = caseX + caseY * initialSudoku.length;

    if(initialSudoku[caseY][caseX] == '.') { // Don't update fixed cases.
        var currentSymbol = items.availablePiecesModel.model.get(items.availablePiecesModel.view.currentIndex);
        var isGood = isLegal(caseX, caseY, currentSymbol.text);
        /*
            If current case is empty, we look if it is legal and put the symbol.
            Else, we colorize the existing cases in conflict with the one pressed
        */
        if(items.sudokuModel.get(currentCase).textValue == '.') {
            if(isGood) {
                items.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/win.wav')
                items.sudokuModel.get(currentCase).textValue = currentSymbol.text
            } else {
                items.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/smudge.wav')
            }
        }
        else {
            // Already a symbol in this case, we remove it
            items.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/darken.wav')
            items.sudokuModel.get(currentCase).textValue = '.'
        }
    }

    if(isSolved()) {
        items.bonus.good("flower")
    }
}

// return true or false if the given number is possible
function isLegal(posX, posY, value) {

    var possible = true

    // Check this number is not already in a row
    var firstX = posY * items.columns;
    var lastX = firstX + items.columns-1;

    var clickedCase = posX + posY * items.columns;

    for (var x = firstX ; x <= lastX ; ++ x) {
        if (x == clickedCase)
            continue

        var rowValue = items.sudokuModel.get(x)

        if(value == rowValue.textValue) {
            items.sudokuModel.get(x).mState = "error";
            possible = false
        }
    }

    var firstY = posX;
    var lastY = items.sudokuModel.count - items.columns + firstY;

    // Check this number is not already in a column
    for (var y = firstY ; y <= lastY ; y += items.columns) {

        if (y == clickedCase)
            continue

        var colValue = items.sudokuModel.get(y)

        if(value == colValue.textValue) {
            items.sudokuModel.get(y).mState = "error";
            possible = false
        }
    }

    // Check this number is in a region
    if(items.background.nbRegions > 1) {
        // First, find the top-left square of the region
        var firstSquareX = Math.floor(posX/items.background.nbRegions)*items.background.nbRegions;
        var firstSquareY = Math.floor(posY/items.background.nbRegions)*items.background.nbRegions;

        for(var x = firstSquareX ; x < firstSquareX +items.background.nbRegions ; x ++) {
            for(var y = firstSquareY ; y < firstSquareY + items.background.nbRegions ; y ++) {
                if(x == posX && y == posY) {
                    // Do not check the current square
                    continue;
                }

                var checkedCase = x + y * items.columns;
                var checkedCaseValue = items.sudokuModel.get(checkedCase)

                if(value == checkedCaseValue.textValue) {
                    items.sudokuModel.get(checkedCase).mState = "error";
                    possible = false
                }
            }
        }
    }

    return possible
}

/*
 Return true or false if the given sudoku is solved
 We don't really check it's solved, only that all squares
 have a value. This works because only valid numbers can
 be entered up front.
*/
function isSolved() {
    for(var i = 0 ; i < items.sudokuModel.count ; ++ i) {
        var value = items.sudokuModel.get(i).textValue
        if(value == '.')
            return false
    }
    return true
}

function restoreState(mCase) {
    items.sudokuModel.get(mCase.gridIndex).mState = mCase.isInitial ? "initial" : "default"
}

function dataToImageSource(data) {
    var imageName = "";

    for(var i = 0 ; i < symbols.length ; ++ i) {
        if(symbols[i].text == data) {
            imageName = url + symbols[i].imgName;
            break;
        }
    }

    return imageName;
}

function onKeyPressed(event) {
    var keyValue = -1;
    switch(event.key)
    {
    case Qt.Key_1:
        keyValue = 0;
        break;
    case Qt.Key_2:
        keyValue = 1;
        break;
    case Qt.Key_3:
        keyValue = 2;
        break;
    case Qt.Key_4:
        keyValue = 3;
        break;
    case Qt.Key_5:
        keyValue = 4;
        break;
    case Qt.Key_6:
        keyValue = 5;
        break;
    case Qt.Key_7:
        keyValue = 6;
        break;
    case Qt.Key_8:
        keyValue = 7;
        break;
    case Qt.Key_9:
        keyValue = 8;
        break;
    }
    if(keyValue >= 0 && keyValue < items.availablePiecesModel.model.count) {
        items.availablePiecesModel.view.currentIndex = keyValue;
        event.accepted=true;
    }
}
