/* GCompris - comparator.js
 *
 * SPDX-FileCopyrightText: 2022 Aastha Chauhan <aastha.chauhan01@gmail.com>
 *
 * Authors:
 *   Aastha Chauhan <aastha.chauhan01@gmail.com>
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import GCompris 1.0 as GCompris
.import "qrc:/gcompris/src/core/core.js" as Core

var numberOfLevel;
var currentSubLevel = 0;
var numberOfSubLevel;
var items;

function start(items_) {
    items = items_;
    numberOfLevel = items.levels.length;
    items.currentLevel = Core.getInitialLevel(numberOfLevel);
    currentSubLevel = 0;
    initLevel();
}

function stop() {
}

function initLevel() {
    items.score.currentSubLevel = currentSubLevel + 1;
    items.dataListModel.clear();
    items.numberOfRowsCompleted = 0;
    items.background.resetSelectedButton();
    var currentDataset = items.levels[items.currentLevel];
    var minValue = currentDataset.minValue;
    var maxValue = currentDataset.maxValue;
    var numberOfEquations = currentDataset.numberOfEquations;
    var sameInteger = currentDataset.sameInteger;
    // By default, the precision is the unit, no decimal numbers
    var precision = currentDataset.precision ? currentDataset.precision : 1;
    var decimalNumbersCount = Math.log10(1 / precision);
    var maxDistanceBetweenNumbers = currentDataset.maxDistanceBetweenNumbers;
    if(maxDistanceBetweenNumbers) {
        minValue = minValue + maxDistanceBetweenNumbers;
        maxValue = maxValue - maxDistanceBetweenNumbers;
    }

    //RandomDataset
    if(currentDataset.random) {
        for(var i = 0; i < numberOfEquations; ++i) {
            var leftHandSideFloat = 0;
            var rightHandSideFloat = 0;
            var leftHandSide = 0;
            var rightHandSide = 0;
            // Find a number between [minValue+maxDistanceBetweenNumbers; maxValue-maxDistanceBetweenNumbers] at the good precision
            // Find the distance from this number to the second one between [-maxDistanceBetweenNumbers; +maxDistanceBetweenNumbers]
            // allowing the second number to be between [minValue; maxValue]
            // truncate the numbers at the good precision
            if(maxDistanceBetweenNumbers) {
                leftHandSideFloat = Math.floor(Math.random() * (maxValue - minValue) / precision) * precision + minValue;
                var distance = Math.floor(2 * Math.random() * maxDistanceBetweenNumbers / precision) * precision - maxDistanceBetweenNumbers;
                rightHandSideFloat = leftHandSideFloat + distance;
                leftHandSide = toDecimalLocaleNumber(leftHandSideFloat, decimalNumbersCount);
                rightHandSide = toDecimalLocaleNumber(rightHandSideFloat, decimalNumbersCount);
            }
            else {
                leftHandSideFloat = Math.floor(Math.random() * (maxValue - minValue + 1)) + minValue;
                leftHandSide = toDecimalLocaleNumber(leftHandSideFloat, decimalNumbersCount);
                rightHandSideFloat = Math.floor(Math.random() * (maxValue - minValue + 1)) + minValue;
                rightHandSide = toDecimalLocaleNumber(rightHandSideFloat, decimalNumbersCount);
            }

            // If we use the option to have same integer part on both sides
            if(sameInteger) {
                var sharedInteger = Math.trunc(leftHandSideFloat);
                var rightHandDecimal = rightHandSideFloat - Math.trunc(rightHandSideFloat);
                rightHandSideFloat = sharedInteger + rightHandDecimal;
                rightHandSide = toDecimalLocaleNumber(rightHandSideFloat, decimalNumbersCount);
            }

            items.dataListModel.append({
                "leftHandSide": leftHandSide,
                "rightHandSide": rightHandSide,
                "symbol": "",
                "isValidationImageVisible": false,
                "isCorrectAnswer": true
            })
        }
        items.score.numberOfSubLevels = currentDataset.numberOfSublevels;
    }
    //fixedDataset
    else {
        var sublevel = currentDataset.values[currentSubLevel];
        numberOfEquations = sublevel.length;
        for(var i = 0; i < numberOfEquations; i++) {
            var leftHandSide = sublevel[i][0].toString()
            var rightHandSide = sublevel[i][1].toString()
            items.dataListModel.append({
                "leftHandSide": leftHandSide,
                "rightHandSide": rightHandSide,
                "symbol": "",
                "isValidationImageVisible": false,
                "isCorrectAnswer": true
            })
        }
        items.score.numberOfSubLevels = currentDataset.values.length;
    }
    numberOfSubLevel = items.score.numberOfSubLevels;
    // Refresh the bindings by forcing a change of value and always select the first line by default
    items.selectedLine = 1;
    items.selectedLine = 0;
}

function checkAnswer() {
    var allCorrect = true;

    for(var i = 0; i < items.dataListModel.count; ++i) {
        var line = items.dataListModel.get(i);
        line.isCorrectAnswer = evaluateAnswer(line);
        if(!line.isCorrectAnswer) {
            allCorrect = false;
        }
        line.isValidationImageVisible = true;
    }

    if(allCorrect) {
        items.bonus.good('flower');
    }
    else {
        items.bonus.bad('flower');
    }
}


function evaluateAnswer(equation) {
    var leftHandSide = fromDecimalLocaleNumber(equation.leftHandSide);
    var rightHandSide = fromDecimalLocaleNumber(equation.rightHandSide);
    var symbol = equation.symbol;

    var isCorrectAnswer = true;

    if((leftHandSide < rightHandSide) && (symbol !== "<")) {
        isCorrectAnswer = false;
    }
    else if ((leftHandSide > rightHandSide) && (symbol !== ">")) {
        isCorrectAnswer = false;
    }
    else if ((leftHandSide === rightHandSide) && (symbol !== "=")) {
        isCorrectAnswer = false;
    }
    return isCorrectAnswer;
}

function upAction() {
    if (items.selectedLine > 0) {
        items.selectedLine --;
    } else {
        items.selectedLine = items.dataListModel.count - 1
    }
}

function downAction() {
    if (items.selectedLine < (items.dataListModel.count - 1)) {
        items.selectedLine ++;
    } else {
        items.selectedLine = 0
    }
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    currentSubLevel = 0;
    initLevel();
}

function nextSubLevel() {
    if(numberOfSubLevel <= ++currentSubLevel) {
        currentSubLevel = 0;
        nextLevel();
    }
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    currentSubLevel = 0;
    initLevel();
}

function toDecimalLocaleNumber(decimalNumber, precision) {
    var locale = GCompris.ApplicationSettings.locale;
    if(locale === "system") {
        locale = Qt.locale().name === "C" ? "en_US" : Qt.locale().name;
    }
    var decimalLocale = Core.convertNumberToLocaleString(decimalNumber, locale, 'f', precision);
    return decimalLocale;
}

function fromDecimalLocaleNumber(decimalNumberString) {
    var locale = GCompris.ApplicationSettings.locale;
    if(locale === "system") {
        locale = Qt.locale().name === "C" ? "en_US" : Qt.locale().name;
    }
    var decimalValue = Number.fromLocaleString(Qt.locale(locale), decimalNumberString);
    return decimalValue;
}
