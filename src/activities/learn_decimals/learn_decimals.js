/* GCompris - learn_decimals.js
 *
 * SPDX-FileCopyrightText: 2021 Mariam Fahmy <mariamfahmy66@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 */
.pragma library
.import QtQuick 2.9 as Quick
.import GCompris 1.0 as GCompris

var currentLevel;
var numberOfLevel;
var items;
var dataset;
var generatedNumber;
var firstNum;
var secondNum;
var decimalNumberList = [];
var squaresNumber = 10;
var correctAnswer;
var lastBarSquareUnits;

var tutorialInstructions = [
            {
                "instruction": qsTr("A decimal number is displayed. The bar with the arrow represents a full unit, and each square in it represents one tenth of this unit."),
                "instructionQml": "qrc:/gcompris/src/activities/learn_decimals/resource/tutorial1.qml"
            },
            {
                "instruction": qsTr("Drag the arrow to select a part of the bar, and drag the selected part of the bar to the empty area. Repeat these steps until the number of dropped bars corresponds to the displayed decimal number. Then click on the OK button to validate your answer."),
                "instructionQml": "qrc:/gcompris/src/activities/learn_decimals/resource/tutorial2.qml"
            }
        ];

var subtractionInstructions = [
            {
                "instruction": qsTr("A subtraction with two decimal numbers is displayed. Below it, the first number from the subtraction is represented with bars. One bar represents a full unit, and each square in it represents one tenth of this unit."),
                "instructionQml": "qrc:/gcompris/src/activities/learn_decimals/resource/tutorial3.qml"
            },
            {
                "instruction": qsTr("Click on the squares to subtract them and display the result of the operation, and click on the OK button to validate your answer."),
                "instructionQml": "qrc:/gcompris/src/activities/learn_decimals/resource/tutorial4.qml"
            },
            {
                "instruction": qsTr("If the result is correct, type the corresponding result, and click on the OK button to validate your answer."),
                "instructionQml": "qrc:/gcompris/src/activities/learn_decimals/resource/tutorial5.qml"
            }
        ];

var additionInstructions = [
            {
                "instruction": qsTr("An addition with two decimal numbers is displayed. The bar with the arrow represents a full unit, and each square in it represents one tenth of this unit."),
                "instructionQml": "qrc:/gcompris/src/activities/learn_decimals/resource/tutorial6.qml"
            },
            {
                "instruction": qsTr("Drag the arrow to select a part of the bar, and drag the selected part of the bar to the empty area. Repeat these steps until the number of dropped bars corresponds to the result of the addition, and click on the OK button to validate your answer."),
                "instructionQml": "qrc:/gcompris/src/activities/learn_decimals/resource/tutorial7.qml"
            },
            {
                "instruction": qsTr("If the result is correct, type the corresponding result, and click on the OK button to validate your answer."),
                "instructionQml": "qrc:/gcompris/src/activities/learn_decimals/resource/tutorial8.qml"
            }
        ];



function start(items_) {
    items = items_;
    currentLevel = 0;
    dataset = items.levels;
    numberOfLevel = dataset.length;
    items.score.currentSubLevel = 1;
    initLevel();
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1;
    var data = dataset[currentLevel];
    items.score.numberOfSubLevels = data.numberOfSubLevels;
    items.draggedItems.clear();
    items.droppedItems.clear();
    items.largestNumberRepresentation.clear();
    items.typeResult = false;
    decimalNumberList = [];
    firstNum = 0;

    displayDecimalNumbers();

    if(!items.isSubtractionMode) {
        if(items.isAdditionMode) {
            generateSecondNumber();
        }
        //resetting the selected bar to 0.1 (the least draggable part)
        items.draggedItems.append({"selectedSquareNumbers" : 1 });

        if(items.background.horizontalLayout) {
            items.scrollBar.arrowX = items.scrollBar.arrowOrigin;
        }
        else {
            items.scrollBar.arrowY = items.scrollBar.arrowOrigin;
        }
        items.scrollBar.currentStep = 0;
    }
    else {
        generateSecondNumber();
        var largestNumber = firstNum * squaresNumber;
        while(largestNumber > 0) {
            if(largestNumber > squaresNumber) {
                items.largestNumberRepresentation.append({"selectedSquareNumbers" : squaresNumber });
            }
            else {
                items.largestNumberRepresentation.append({"selectedSquareNumbers" : largestNumber });
                lastBarSquareUnits = largestNumber;
            }
            largestNumber -= squaresNumber;
        }
    }
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel) {
        currentLevel = 0;
    }
    items.score.currentSubLevel = 1;
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1;
    }
    items.score.currentSubLevel = 1;
    initLevel();
}

function nextSubLevel() {
    if(items.score.currentSubLevel >= items.score.numberOfSubLevels) {
        nextLevel();
        return;
    }

    items.droppedItems.clear();
    displayDecimalNumbers();

    items.score.currentSubLevel++;
}

function organizeDroppedBars() {
    var totalSquareUnits = 0;
    for(var i = 0; i < items.droppedItems.count; i++) {
        totalSquareUnits += items.droppedItems.get(i).selectedSquareNumbers;
    }

    items.droppedItems.clear();

    while(totalSquareUnits > 0) {
        if(totalSquareUnits >= squaresNumber) {
            items.droppedItems.append({"selectedSquareNumbers" : squaresNumber });
        }
        else {
            items.droppedItems.append({"selectedSquareNumbers" : totalSquareUnits });
        }
        totalSquareUnits -= squaresNumber;
    }
}

function generateSecondNumber() {
    firstNum = generatedNumber;
    displayDecimalNumbers();
    secondNum = generatedNumber;

    // In case of subtraction mode, the first number must be greater than the second number to avoid having negative results.
    if(firstNum < secondNum) {
        var temp = firstNum;
        firstNum = secondNum;
        secondNum = temp;
    }

    items.largestNumber = toDecimalLocaleNumber(firstNum);
    items.smallestNumber = toDecimalLocaleNumber(secondNum);
}

function displayDecimalNumbers() {
    var maxValue;
    var minValue = dataset[currentLevel].minValue;

    if(items.isSubtractionMode) {
        maxValue = dataset[currentLevel].maxValue;
    }
    else {
        maxValue = dataset[currentLevel].maxValue - firstNum;
    }

    generatedNumber = generateDecimalNumbers(minValue, maxValue);

    while(decimalNumberList.indexOf(generatedNumber) !== -1 || generatedNumber === 0) {
        generatedNumber = generateDecimalNumbers(minValue, maxValue);
    }
    decimalNumberList.push(generatedNumber);
    if(!items.isSubtractionMode && !items.isAdditionMode) {
        items.largestNumber = toDecimalLocaleNumber(generatedNumber);
    }
}

function verifyNumberRepresentation() {
    var i;
    var sum = 0;

    //calculating the correct answer.
    calculateCorrectAnswer();

    //calculating the displayed units in the answerZone.
    if(!items.isSubtractionMode) {
        for(i = 0; i < items.droppedItems.count; i++) {
            sum += items.droppedItems.get(i).selectedSquareNumbers;
        }
    }
    else {
        for(i = 0; i < items.largestNumberRepresentation.count; i++) {
            sum += items.largestNumberRepresentation.get(i).selectedSquareNumbers;
        }
    }

    sum /= squaresNumber;
    if(sum === correctAnswer) {
        if(items.isSubtractionMode || items.isAdditionMode) {
            items.numpad.resetText();
            items.typeResult = true;
        }
        else {
            items.bonus.good("flower");
        }
    }
    else {
        items.bonus.bad("flower");
    }
}

function calculateCorrectAnswer() {
    if(items.isSubtractionMode) {
        correctAnswer = (firstNum * squaresNumber - secondNum * squaresNumber) / squaresNumber;
    }
    else if(items.isAdditionMode) {
        correctAnswer = (firstNum * squaresNumber + secondNum * squaresNumber) / squaresNumber;
    }
    else {
        correctAnswer = generatedNumber;
    }
}

function verifyNumberTyping(typedAnswer) {
    if(parseFloat(typedAnswer) === parseFloat(toDecimalLocaleNumber(correctAnswer))) {
        items.bonus.good("flower");
    }
    else {
        items.bonus.bad("flower");
    }
}

function changeSingleBarVisibility(currentSquareNumber) {
    items.draggedItems.setProperty(0, "selectedSquareNumbers", currentSquareNumber);
}

function changeMultiBarVisibility(barIndex, currentSquareNumber) {
    items.largestNumberRepresentation.setProperty(barIndex, "selectedSquareNumbers", currentSquareNumber);
}

function generateDecimalNumbers(minValue, maxValue) {
    var generatedNumber = Math.random() * (maxValue - minValue) + minValue;
    return Math.round((generatedNumber + Number.EPSILON) * squaresNumber) / squaresNumber;
}

function toDecimalLocaleNumber(decimalNumber) {
    var locale = GCompris.ApplicationSettings.locale;
    if(locale === "system") {
        locale = Qt.locale().name === "C" ? "en_US" : Qt.locale().name;
    }
    var decimalLocale = decimalNumber.toLocaleString(Qt.locale(locale), 'f', 1);
    return decimalLocale;
}
