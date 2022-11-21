/* GCompris - tens_complement_2.js
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 */
.pragma library

var currentLevel = 0;
var numberOfLevel;
var items;
var datasets = [];
var currentDatasetLevel = 0;
var numberOfDatasetLevel;
var previousSelectedCard = undefined;

function start(items_) {
    items = items_
    currentLevel = 0
    datasets.length = 0;
    for(var indexForDataset = 0; indexForDataset < items.levels.length; indexForDataset++) {
        for(var indexForLevel = 0; indexForLevel < items.levels[indexForDataset].value.length; indexForLevel++) {
            datasets.push(items.levels[indexForDataset].value[indexForLevel]);
        }
    }
    numberOfDatasetLevel = items.levels.length;
    numberOfLevel = datasets.length;
    initLevel()
}

function stop() {
    destroyListModels();
}

function initLevel() {
    items.bar.level = currentLevel + 1;
    destroyListModels();
    for(var indexOfListModel = 0; indexOfListModel < datasets[currentLevel].length; indexOfListModel++) {
        var model = createNewListModel(items.background);
        var valueArray = getValueArray(datasets[currentLevel][indexOfListModel].numberValue);
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
            model.append(card);
        }
        var resultCard = {
            "type": "resultCard",
            "value": valueArray[valueArray.length - 1].toString(),
        }
        model.append(resultCard);
        items.equations.append({
            "listmodel": model,
            "isGood": false,
            "isValidationImageVisible": false
        });
    }
}

/*
 * This function destroys list models to prevent memory leak.
 */
function destroyListModels() {
    for(var i = 0; i < items.equations.count; i++) {
        items.equations.get(i).listmodel.destroy();
    }
    items.equations.clear();
}

/*
 * This function creates a new list model and attaches it to a parent qml item.
 */
function createNewListModel(parent) {
    var newListModel = Qt.createQmlObject('import QtQuick 2.2; \ ListModel {}', parent);
    return newListModel;
}

/*
 * For a given array of numbers this function returns an array of elements to be displayed.
 * It calculates the number of pairs to display and an additional number if the size is odd.
 */
function getValueArray(numberArray) {
    var valueArray = [];
    var countOfNumbers = numberArray.length;
    var totalSum = 0;
    var numberOfPairs = Math.floor(countOfNumbers/2);
    var indexOfNumberValue = 0;
    for(var i = 0; i < numberOfPairs; i++) {
        valueArray.push("(");
        valueArray.push(numberArray[indexOfNumberValue].toString());
        totalSum += numberArray[indexOfNumberValue];
        indexOfNumberValue++;
        valueArray.push("+");
        valueArray.push(numberArray[indexOfNumberValue].toString());
        totalSum += numberArray[indexOfNumberValue];
        indexOfNumberValue++;
        valueArray.push(")");
        if(i != numberOfPairs - 1) {
            valueArray.push("+");
        }
    }
    if(countOfNumbers % 2 != 0) {
        valueArray.push("+");
        valueArray.push(numberArray[indexOfNumberValue].toString());
        totalSum += numberArray[indexOfNumberValue];
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
    if(numberOfLevel <= ++currentLevel) {
        currentLevel = 0;
    }
    initLevel();
}

function nextDatasetLevel() {
    if(numberOfDatasetLevel <= ++currentDatasetLevel) {
        currentDatasetLevel = 0;
    }
    currentLevel = 0;
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1;
    }
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
    isAllCorrect ? items.bonus.good("flower") : items.bonus.bad("flower");
}
