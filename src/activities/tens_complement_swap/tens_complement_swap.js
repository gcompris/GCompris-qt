/* GCompris - tens_complement_swap.js
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 */
.pragma library
.import "qrc:/gcompris/src/core/core.js" as Core

var numberOfLevel;
var items;
var datasets = [];
var currentDatasetLevel = 0;
var numberOfDatasetLevel;
var previousSelectedCard = undefined;

function start(items_) {
    items = items_
    datasets.length = 0;
    for(var indexForDataset = 0; indexForDataset < items.levels.length; indexForDataset++) {
        for(var indexForLevel = 0; indexForLevel < items.levels[indexForDataset].value.length; indexForLevel++) {
            datasets.push(items.levels[indexForDataset].value[indexForLevel]);
        }
    }
    numberOfDatasetLevel = items.levels.length;
    numberOfLevel = datasets.length;
    items.currentLevel = Core.getInitialLevel(numberOfLevel);
    initLevel();
}

function stop() {
    clearListModels();
}

function initLevel() {
    clearListModels();
    previousSelectedCard = undefined;
    for(var indexOfListModel = 0; indexOfListModel < datasets[items.currentLevel].length; indexOfListModel++) {
        var model = [];
        var valueArray = getValueArray(datasets[items.currentLevel][indexOfListModel]);
        for(var indexOfDisplayArray = 0; indexOfDisplayArray < valueArray.length - 1; indexOfDisplayArray++) {
            var card = {};
            if(!Number.isNaN(parseInt(valueArray[indexOfDisplayArray]))) {
                card = {
                    "type": "numberCard",
                    "value": valueArray[indexOfDisplayArray].toString(),
                    "rowNumber": indexOfListModel,
                    "selected": false,
                    "selectable": true
                }
            }
            else {
                card = {
                    "type": "symbolCard",
                    "value": valueArray[indexOfDisplayArray].toString()
                }
            }
            model.push(card);
        }
        var resultCard = {
            "type": "resultCard",
            "value": valueArray[valueArray.length - 1].toString(),
        }
        model.push(resultCard);
        items.equations.append({
            "listmodel": model,
            "isGood": false,
            "isValidationImageVisible": false
        });
    }
}

function clearListModels() {
    items.equations.clear();
}

/*
 * For a given array of numbers this function returns an array of elements to be displayed.
 * It calculates the number of pairs to display and an additional number if the size is odd.
 */
function getValueArray(numberArray) {
    var valueArray = [];
    var totalSum = 0;
    var indexOfNumberValue = 0;
    var countOfNumbers = numberArray.randomValues ? numberArray.numberOfElements : numberArray.numberValue.length;
    var numberOfPairs = Math.floor(countOfNumbers / 2);
    var values = [];
    if(numberArray.randomValues) {
        var numberOfPairsFilled = 0;
        while(numberOfPairsFilled != numberOfPairs) {
            // Get a number between 1 and 9
            var randomNumber = Math.floor(1 + Math.random() * 9);
            if(values.indexOf(randomNumber) > -1) {
                continue; // Avoid having twice the same numbers
            }
            values.push(randomNumber);
            values.push(10 - randomNumber);
            numberOfPairsFilled ++;
        };
        if(countOfNumbers % 2 != 0) {
            // Add a random number at the end between 1 and 9
            values.push(Math.floor(Math.random() * 9) + 1);
        }
    }
    else {
        values = numberArray.numberValue;
    }
    if(numberArray.randomizeOrder == undefined || numberArray.randomizeOrder == true) {
        do {
            // Shuffle the numbers before creating the model.
            // Make sure at least the first computation is not correct to avoid having the possibility to have all good answers at start
            Core.shuffle(values);
        } while(values[0] + values[1] == 10);
    }

    for(var i = 0; i < numberOfPairs; i++) {
        valueArray.push("(");
        valueArray.push(values[indexOfNumberValue].toString());
        totalSum += values[indexOfNumberValue];
        indexOfNumberValue++;
        valueArray.push("+");
        valueArray.push(values[indexOfNumberValue].toString());
        totalSum += values[indexOfNumberValue];
        indexOfNumberValue++;
        valueArray.push(")");
        if(i != numberOfPairs - 1) {
            valueArray.push("+");
        }
    }
    if(countOfNumbers % 2 != 0) {
        valueArray.push("+");
        valueArray.push(values[indexOfNumberValue].toString());
        totalSum += values[indexOfNumberValue];
    }
    valueArray.push("=");
    valueArray.push(totalSum.toString());
    return valueArray;
}

function swapCards(firstCard, secondCard) {
    var selectedEquation = items.equations.get(firstCard.rowNumber).listmodel;
    var firstPosition = Math.min(firstCard.columnNumber, secondCard.columnNumber);
    var secondPosition = Math.max(firstCard.columnNumber, secondCard.columnNumber);
    if(firstPosition != secondPosition) {
        selectedEquation.move(firstPosition, secondPosition, 1);
        selectedEquation.move(secondPosition - 1, firstPosition, 1);
    }
}

function selectCard(currentSelectedCard) {
    items.equations.get(currentSelectedCard.rowNumber).isValidationImageVisible = false;
    if(previousSelectedCard != undefined) {
        if(previousSelectedCard.rowNumber == currentSelectedCard.rowNumber) {
            swapCards(currentSelectedCard, previousSelectedCard)
        }
        items.equations.get(currentSelectedCard.rowNumber).listmodel.get(currentSelectedCard.columnNumber).selected = false;
        items.equations.get(previousSelectedCard.rowNumber).listmodel.get(previousSelectedCard.columnNumber).selected = false;
        previousSelectedCard = undefined;
    }
    else {
        previousSelectedCard = currentSelectedCard;
    }

}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function nextDatasetLevel() {
    if(numberOfDatasetLevel <= ++currentDatasetLevel) {
        currentDatasetLevel = 0;
    }
    items.currentLevel = 0;
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function checkAnswer() {
    var isAllCorrect = true;
    for(var indexOfRows = 0; indexOfRows < items.equations.count; indexOfRows++) {
        var numberCardCounter = 0;
        var sum = 0;
        var isRowCorrect = true;
        var currentRow = items.equations.get(indexOfRows);
        var currentEquation = currentRow.listmodel;
        for(var indexOfCards = 0; indexOfCards < currentEquation.count - 1; indexOfCards++) {
            var currentCard = currentEquation.get(indexOfCards);
            if(currentCard.type == "numberCard") {
                if(numberCardCounter != 2) {
                    sum += parseInt(currentCard.value);
                }
                numberCardCounter++;
                if(numberCardCounter == 2) {
                    if(sum != 10) {
                        isRowCorrect = false;
                        break;
                    }
                    numberCardCounter = 0;
                    sum = 0;
                }
            }
        }
        currentRow.isGood = isRowCorrect;
        currentRow.isValidationImageVisible = true;
        isAllCorrect = isAllCorrect & isRowCorrect;
    }
    if(isAllCorrect) {
        items.bonus.good("flower");
    }
    else {
        items.bonus.bad("flower");
    }
}
