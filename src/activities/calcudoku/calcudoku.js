/* GCompris - calcudoku.js
 *
 * SPDX-FileCopyrightText: 2023 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 */
.pragma library
.import QtQuick 2.12 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var numberOfLevel;
var items;
var symbols;
var url = "qrc:/gcompris/src/activities/sudoku/resource/";

var cages = []; // { "indexes": [], "result": integer, "operator": "" }
var cagesIndexes = []; // for each cage, remember which cage it is in
var initialCalcudoku;

var OperandsEnum = {
    TIMES_SIGN: "\u00D7",
    PLUS_SIGN: "\u002B",
    MINUS_SIGN: "\u2212",
    DIVIDE_SIGN: "\u2215"
}

var Direction = {
    TOP: 0,
    BOTTOM: 1,
    RIGHT: 2,
    LEFT: 3
}
function getVisualOperator(operator) {
    if(operator == "+") {
        return OperandsEnum.PLUS_SIGN;
    }
    else if(operator == "*") {
        return OperandsEnum.TIMES_SIGN;
    }
    else if(operator == "-") {
        return OperandsEnum.MINUS_SIGN;
    }
    else if(operator == ":") {
        return OperandsEnum.DIVIDE_SIGN;
    }
    return operator;
}

function start(items_) {
    items = items_;
    numberOfLevel = items.levels.length;
    items.currentLevel = Core.getInitialLevel(numberOfLevel);
    items.score.currentSubLevel = 1;
    // Shuffle all levels
    for(var nb = 0 ; nb < items.levels.length ; ++ nb) {
        if(items.levels[nb]["data"]) {
            Core.shuffle(items.levels[nb]["data"]);
        }
    }
    initLevel();
}

function stop() {
}

function tryExpand(cagesIndexes, cages, newCage, id, attempt, attemptsMax, size) {
    // Wander
    while(newCage.length < size && attempt < 5) {
        var direction = Core.shuffle([Direction.TOP, Direction.BOTTOM, Direction.RIGHT, Direction.LEFT])[0];
        attempt = attempt + 1; // Make sure we don't do too much trials
        if(direction == Direction.TOP && id >= size && cagesIndexes[id-size] == -1) {
            cagesIndexes[id-size] = id;
            newCage.push(id-size);
            //print("expand to top");
            tryExpand(cagesIndexes, cages, newCage, id-size, attempt+1, attemptsMax, size);
        }
        if(direction == Direction.BOTTOM && id + size < size * size && cagesIndexes[id+size] == -1) {
            cagesIndexes[id+size] = id;
            newCage.push(id+size);
            //print("expand to bottom");
            tryExpand(cagesIndexes, cages, newCage, id+size, attempt+1, attemptsMax, size);
        }
        if(direction == Direction.LEFT && id%size != 0 && cagesIndexes[id-1] == -1) {
            cagesIndexes[id-1] = id;
            newCage.push(id-1);
            //print("expand to left");
            tryExpand(cagesIndexes, cages, newCage, id-1, attempt+1, attemptsMax, size);
        }
        if(direction == Direction.RIGHT && id%size != size-1 && cagesIndexes[id+1] == -1) {
            cagesIndexes[id+1] = id;
            newCage.push(id+1);
            //print("expand to right");
            tryExpand(cagesIndexes, cages, newCage, id+1, attempt+1, attemptsMax, size);
        }
    }
}

function computeResult(values, indexes, operator) {
    var result = operator == OperandsEnum.TIMES_SIGN ? 1 : 0;
    for(var index = 0 ; index < indexes.length ; ++ index) {
        var value = values[indexes[index]];
        if(operator == OperandsEnum.DIVIDE_SIGN) {
            if(result == 0) {
                result = value;
            }
            else if(result > value) {
                result = result / value;
            }
            else {
                result = value / result;
            }
        }
        else if(operator == OperandsEnum.MINUS_SIGN) {
            if(result == 0) {
                result = value;
            }
            else if(result > value) {
                result = result - value;
            }
            else {
                result = value - result;
            }
        }
        else if(operator == OperandsEnum.TIMES_SIGN) {
            result = result * value;
        }
        else if(operator == OperandsEnum.PLUS_SIGN) {
            result = result + value;
        }
        else {
            result = value;
        }
    }
    return result;
}

function generateLevel(size, allowedOperators) {
    var columns = [];
    var level = [];
    var line = [];
    var indexInLevel = 0;
    for(var c = 0 ; c < size; c++) {
        columns.push([]);
    }
    for(var x = 0 ; x < size; ++ x) {
        // Generate a line with values between 1 and size
        line = Core.shuffle(Array.from(Array(size+1).keys()).slice(1));
        for(var c = 0 ; c < size ; ++ c) {
            var notInColumn = line.filter(v => !columns[c].includes(v));
            //print("column", c, columns[c]);
            //print("notInColumn", notInColumn);
            //print("line before", line);
            var value = notInColumn[Math.floor(Math.random() * notInColumn.length)];
            //print("value", value);
            // Revert the whole line if it is not possible and create a new line again.
            // Not really optimised but working :)
            if(notInColumn.length == 0) {
                x = x-1;
                for(var g = 0 ; g < c; g++) {
                    columns[g].splice(columns[g].length-1, 1);
                    indexInLevel --;
                }
                break;
            }
            level[indexInLevel ++] = value;
            line.splice(line.indexOf(value), 1);
            columns[c].push(value);
        }
    }
    var cagesIndexes = Array(size*size).fill(-1);
    var cages = [];
    // Now generate the cages (between 1 and size elements)
    for(var id = 0 ; id < size*size; ++ id) {
        if(cagesIndexes[id] == -1) {
            var newCage = [id];
            cagesIndexes[id] = id;
            tryExpand(cagesIndexes, cages, newCage, id, 1, 10, size);
            cages.push({"indexes": newCage, "result": -1, "operator": ""});
        }
    }
    //print("Level", level);
    //print("Cages", JSON.stringify(cages));
    //print("cagesIndexes", cagesIndexes);
    // Now, if there are 2 elements, it's either - or /, we should favorise if they are allowed, if it is more it can only be + or *. Don't do * if the result is above 100 ?
    for(var cageId = 0 ; cageId < cages.length ; ++ cageId) {
        var currentCage = cages[cageId];
        if(currentCage.indexes.length == 1) {
            currentCage.operator = "";
            currentCage.result = level[currentCage.indexes[0]];
        }
        else if(currentCage.indexes.length == 2) {
            var operatorsProbabilities = {};
            operatorsProbabilities[OperandsEnum.MINUS_SIGN] = 40;
            operatorsProbabilities[OperandsEnum.DIVIDE_SIGN] = 35;
            operatorsProbabilities[OperandsEnum.TIMES_SIGN] = 25;
            operatorsProbabilities[OperandsEnum.PLUS_SIGN] = 20;
            // remove all operators not allowed...
            // then get a number between 0 and 100 and assign the good operator according to "luck"
            var firstValue = level[currentCage.indexes[0]];
            var secondValue = level[currentCage.indexes[1]];
            if(firstValue/secondValue % 1 != 0 && secondValue/firstValue % 1 != 0) {
                delete operatorsProbabilities[OperandsEnum.DIVIDE_SIGN];
            }
            var operators = {};
            for(var ope = 0 ; ope < allowedOperators.length ; ++ ope) {
               if(operatorsProbabilities[allowedOperators[ope]] != undefined) {
                    operators[allowedOperators[ope]] = operatorsProbabilities[allowedOperators[ope]];
                }
            }
            var keys = Object.keys(operators);
            var maxValue = 0;
            for(var v = 0 ; v < keys.length ; ++ v) {
                maxValue = maxValue + operators[keys[v]];
            }
            var rand = Math.floor(Math.random() * maxValue);
            var sum = 0;
            for(var c = 0 ; c < keys.length ; ++ c) {
                sum = sum + operators[keys[c]];
                if(sum > rand) {
                    currentCage.operator = keys[c];
                    currentCage.result = computeResult(level, currentCage.indexes, currentCage.operator);
                    break;
                }
            }
        }
        else if(currentCage.indexes.length > 2) {
            var operatorsProbabilities = {};
            operatorsProbabilities[OperandsEnum.TIMES_SIGN] = 40;
            operatorsProbabilities[OperandsEnum.PLUS_SIGN] = 60;
            // remove all operators not allowed...
            // then get a number between 0 and the max value autorised and assign the corresponding operator
            var operators = {};
            for(var ope = 0 ; ope < allowedOperators.length ; ++ ope) {
                if(operatorsProbabilities[allowedOperators[ope]] != undefined) {
                    operators[allowedOperators[ope]] = operatorsProbabilities[allowedOperators[ope]];
                }
            }
            var maxValue = 0;
            var keys = Object.keys(operators);
            for(var v = 0 ; v < keys.length ; ++ v) {
                maxValue = maxValue + operators[keys[v]];
            }
            var rand = Math.floor(Math.random() * maxValue);
            var sum = 0;
            for(var c = 0 ; c < keys.length ; ++ c) {
                sum = sum + operators[keys[c]];
                if(sum > rand) {
                    currentCage.operator = keys[c];
                    currentCage.result = computeResult(level, currentCage.indexes, currentCage.operator);
                    break;
                }
            }
        }
    }
    return {"cages": cages, "size": size};
}

function replaceOperator(array, operator, newValue) {
    var id = array.indexOf(operator);
    if(id != -1) {
        array[id] = newValue;
    }
}

function initLevel() {
    symbols = items.levels[items.currentLevel]["symbols"];

    for(var i = items.availablePiecesModel.model.count-1 ; i >= 0 ; -- i) {
        items.availablePiecesModel.model.remove(i);
    }
    items.calcudokuModel.clear();
    if(items.levels[items.currentLevel].random) {
        items.score.numberOfSubLevels = items.levels[items.currentLevel]["length"];
        replaceOperator(items.levels[items.currentLevel]["operators"], "+", OperandsEnum.PLUS_SIGN);
        replaceOperator(items.levels[items.currentLevel]["operators"], "*", OperandsEnum.TIMES_SIGN);
        replaceOperator(items.levels[items.currentLevel]["operators"], "-", OperandsEnum.MINUS_SIGN);
        replaceOperator(items.levels[items.currentLevel]["operators"], ":", OperandsEnum.DIVIDE_SIGN);
        initialCalcudoku = generateLevel(items.levels[items.currentLevel]["size"], items.levels[items.currentLevel]["operators"]);
    }
    else {
        items.score.numberOfSubLevels = items.levels[items.currentLevel]["data"].length
        initialCalcudoku = items.levels[items.currentLevel]["data"][items.score.currentSubLevel-1];
    }

    items.columns = initialCalcudoku.size;
    items.rows = items.columns;

    var cagesCount = initialCalcudoku.cages.length;
    var operatorsPositions = [];
    cages = [];
    cagesIndexes = [];

    for(var v = 0 ; v < cagesCount ; ++ v) {
        var currentCage = initialCalcudoku.cages[v];
        cages.push(currentCage);
        for (var p = 0 ; p < currentCage.indexes.length ; ++ p) {
            cagesIndexes[currentCage.indexes[p]] = v;
        }
        // Easiest way to retrieve the top info of the case
        var operatorResult = {"operator":"", "result": ""};
        // Adding here the space to display before the operator
        operatorResult.operator = " " + getVisualOperator(currentCage.operator);
        operatorResult.result = "" + currentCage.result;
        operatorsPositions[currentCage.indexes[0]] = operatorResult;
    }
    //print("initLevel, cages", JSON.stringify(cages));
    //print("initLevel, operatorsPositions", JSON.stringify(operatorsPositions));
    //print("initLevel, cagesIndexes", JSON.stringify(cagesIndexes));
    // Create grid
    for(var i = 0 ; i < items.rows ; ++ i) {
        for(var j = 0 ; j < items.columns ; ++ j) {
            var id = i * items.columns + j;
            var operator = "";
            var result = "";
            if(operatorsPositions[id] != undefined) {
                operator = operatorsPositions[id].operator;
                result = operatorsPositions[id].result;
            }

            var cage = cages[cagesIndexes[id]].indexes;
            // Check walls
            var topWall = false;
            if(id < items.columns || cage.indexOf(id-items.columns) == -1) {
                topWall = true;
            }
            var bottomWall = false;
            if(id+items.columns >= items.columns*items.columns || cage.indexOf(id+items.columns) == -1) {
                bottomWall = true;
            }
            var leftWall = false;
            if(id%items.columns == 0 || cage.indexOf(id-1) == -1) {
                leftWall = true;
            }
            var rightWall = false;
            if(id%items.columns == items.columns-1 || cage.indexOf(id+1) == -1) {
                rightWall = true;
            }


            items.calcudokuModel.append({
                                         'textValue': "", // Empty for now, TODO check if we want initial values, else remove it
                                         'initial': false, // remove this if we don't have default values
                                         'mState': "default",
                                         'resultValue': result,
                                         'operatorValue': operator,
                                         'topWall': topWall,
                                         'leftWall': leftWall,
                                         'rightWall': rightWall,
                                         'bottomWall': bottomWall
                                     });
        }
    }

    for(var line = 0 ; line < initialCalcudoku.size ; ++ line) {
        items.availablePiecesModel.model.append({"imgName": (line+1)+".svg", "text": ""+(line+1)});
    }
}

function reinitLevel() {
    for(var i = 0 ; i < items.calcudokuModel.count ; ++ i) {
        items.calcudokuModel.get(i).textValue = "";
    }
}

function nextLevel() {
    items.score.currentSubLevel = 1;
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.score.currentSubLevel = 1;
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

/*
 Code that increments the sublevel and level
 And bail out if no more levels are available
*/
function incrementLevel() {
    items.score.currentSubLevel ++;

    if(items.score.currentSubLevel > items.score.numberOfSubLevels) {
        // Try the next level
        nextLevel();
    }
    else {
        initLevel();
    }
}

function clickOn(caseX, caseY) {
    var currentCase = caseX + caseY * initialCalcudoku.size;

    var currentSymbol = items.availablePiecesModel.model.get(items.availablePiecesModel.view.currentIndex);
    var isGood = isLegal(caseX, caseY, currentSymbol.text);
    /*
      If current case is empty, we look if it is legal and put the symbol.
      Else, we colorize the existing cases in conflict with the one pressed
    */
    if(items.calcudokuModel.get(currentCase).textValue == "") {
        if(isGood) {
            items.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/win.wav');
            items.calcudokuModel.get(currentCase).textValue = currentSymbol.text;
        } else {
            items.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/smudge.wav');
        }
    }
    else {
        // Already a symbol in this case, we remove it
        items.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/darken.wav');
        items.calcudokuModel.get(currentCase).textValue = "";
    }

    if(isSolved()) {
        items.bonus.good("flower");
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

        var rowValue = items.calcudokuModel.get(x)

        if(value == rowValue.textValue) {
            items.calcudokuModel.get(x).mState = "error";
            possible = false
        }
    }

    var firstY = posX;
    var lastY = items.calcudokuModel.count - items.columns + firstY;

    // Check this number is not already in a column
    for (var y = firstY ; y <= lastY ; y += items.columns) {
        if (y == clickedCase)
            continue;

        var colValue = items.calcudokuModel.get(y);

        if(value == colValue.textValue) {
            items.calcudokuModel.get(y).mState = "error";
            possible = false;
        }
    }

    return possible;
}

/*
 Return true or false if the given calcudoku is solved
 We don't really check it's solved, only that all squares
 have a value. This works because only valid numbers can
 be entered up front.
*/
function isSolved() {
    var level = [];
    for(var i = 0 ; i < items.calcudokuModel.count ; ++ i) {
        var value = items.calcudokuModel.get(i).textValue;
        if(value == "")
            return false;
        level[i] = parseInt(value);
    }
    // for each cage, check if the count is correct
    for(var r = 0 ; r < cages.length ; ++ r) {
        var currentCage = cages[r];
        var result = computeResult(level, currentCage.indexes, currentCage.operator);
        if(result != currentCage.result) {
            return false;
        }
    }
    return true;
}

function restoreState(mCase) {
    items.calcudokuModel.get(mCase.gridIndex).mState = mCase.isInitial ? "initial" : "default";
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
        event.accepted = true;
    }
}
