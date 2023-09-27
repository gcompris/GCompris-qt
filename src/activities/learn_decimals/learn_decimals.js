/* GCompris - learn_decimals.js
 *
 * SPDX-FileCopyrightText: 2021 Mariam Fahmy <mariamfahmy66@gmail.com>
 *
 * Authors:
 *   Mariam Fahmy <mariamfahmy66@gmail.com>
 *   Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 */
.pragma library
.import QtQuick 2.12 as Quick
.import GCompris 1.0 as GCompris
.import "qrc:/gcompris/src/core/core.js" as Core

var numberOfLevel;
var items;
var dataset;
var generatedNumber;
var minimumValue;
var maximumValue;
var firstNumber;
var secondNumber = 0;
var squaresNumber = 10;
var correctAnswer;
var lastBarSquareUnits;
var firstNumberList;
var numberOfPossibleQuestions;

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
                "instruction": qsTr("If the answer is correct, type the corresponding result, and click on the OK button to validate your answer."),
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
                "instruction": qsTr("If the answer is correct, type the corresponding result, and click on the OK button to validate your answer."),
                "instructionQml": "qrc:/gcompris/src/activities/learn_decimals/resource/tutorial8.qml"
            }
        ];

var quantityInstructions = [
            {
                "instruction": qsTr("A quantity is requested. The arrow allows to select up to 10 oranges."),
                "instructionQml": "qrc:/gcompris/src/activities/learn_decimals/resource/tutorial1.qml"
            },
            {
                "instruction": qsTr("Drag the arrow to select a number of oranges, and drag the selected oranges to the empty area. Repeat these steps until the number of oranges corresponds to the requested quantity. Then click on the OK button to validate your answer."),
                "instructionQml": "qrc:/gcompris/src/activities/learn_decimals/resource/tutorial2.qml"
            }
        ];

function start(items_) {
    items = items_;
    dataset = items.levels;
    numberOfLevel = dataset.length;
    items.currentLevel = Core.getInitialLevel(numberOfLevel);
    items.score.currentSubLevel = 1;
    firstNumberList = [];

    if(!items.tutorialImage.visible) {
        initLevel();
    }
}

function stop() {
}

function initLevel() {
    var data = dataset[items.currentLevel];
    items.score.numberOfSubLevels = data.numberOfSubLevels;
    items.draggedItems.clear();
    items.droppedItems.clear();
    items.largestNumberRepresentation.clear();
    items.typeResult = false;
    minimumValue = dataset[items.currentLevel].minValue;
    maximumValue = dataset[items.currentLevel].maxValue;

    checkAvailableQuestions();

    displayDecimalNumberQuestion()

    if(!items.isSubtractionMode) {
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
        var largestNumber = firstNumber * squaresNumber;
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
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    items.score.currentSubLevel = 1;
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    items.score.currentSubLevel = 1;
    initLevel();
}

function nextSubLevel() {
    if(items.score.currentSubLevel >= items.score.numberOfSubLevels) {
        nextLevel();
        return;
    }

    items.droppedItems.clear();

    // In case number of sublevels are greater than the number of possibilities of the current level.
    checkAvailableQuestions();

    displayDecimalNumberQuestion();

    items.score.currentSubLevel++;
}

function checkAvailableQuestions() {
    // In case all possible values from the provided range in the dataset are all displayed.
    var isAllDisplayed = true;
    numberOfPossibleQuestions = 0;

    for(var i = minimumValue; i <= maximumValue; i += items.unit) {
        numberOfPossibleQuestions += 1;
        // i += items.unit can sometimes return weird numbers like 0.30000000000000004 or 0.7999999999999999
        // so rounding it is needed for a safe check
        var j = Math.round(i * 10) / 10;
        if(firstNumberList.indexOf(j) == -1) {
            isAllDisplayed = false;
        }
    }

    if(isAllDisplayed) {
        firstNumberList = [];
    }
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

function generateFirstNumber() {
    if(items.isAdditionMode) {
        maximumValue -= minimumValue;
    }
    generatedNumber = generateDecimalNumbers(minimumValue, maximumValue);
    var loopCheck = 0;
    // if the number has already been asked, try to get a new one
    while(firstNumberList.indexOf(generatedNumber) !== -1) {
        generatedNumber = generateDecimalNumbers(minimumValue, maximumValue);
        //safety check to avoid stuck loop in case of js bugs
        loopCheck += 1;
        if(loopCheck > numberOfPossibleQuestions)
            firstNumberList = []
    }

    return generatedNumber;
}

function generateSecondNumber() {
    if(items.isAdditionMode) {
        maximumValue = dataset[items.currentLevel].maxValue;
        maximumValue -= generatedNumber;
    }

    do {
        generatedNumber = generateDecimalNumbers(minimumValue, maximumValue);
    }
    while(generatedNumber === firstNumber && items.isSubtractionMode);

    return generatedNumber;
}

function displayDecimalNumberQuestion() {
    firstNumber = generateFirstNumber();

    if(items.isAdditionMode || items.isSubtractionMode)
        secondNumber = generateSecondNumber();

    // The first number must be greater than the second number to avoid having negative results.
    if(items.isSubtractionMode) {
        if(firstNumber < secondNumber) {
            var temp = firstNumber;
            firstNumber = secondNumber;
            secondNumber = temp;
        }
    }

    // Storing the first decimal number in a list to avoid displaying the same number again for the rest of the levels.
    firstNumberList.push(firstNumber);

    if(items.isQuantityMode)
        items.largestNumber = firstNumber.toString();
    else {
        items.largestNumber = toDecimalLocaleNumber(firstNumber);
        items.smallestNumber = toDecimalLocaleNumber(secondNumber);
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

    if(!items.isQuantityMode)
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
        correctAnswer = (firstNumber * squaresNumber - secondNumber * squaresNumber) / squaresNumber;
    }
    else if(items.isAdditionMode) {
        correctAnswer = (firstNumber * squaresNumber + secondNumber * squaresNumber) / squaresNumber;
    }
    else {
        correctAnswer = firstNumber;
    }
}

function verifyNumberTyping(typedAnswer) {
    typedAnswer = typedAnswer.replace("," , ".");
    if(parseFloat(typedAnswer) === parseFloat(correctAnswer)) {
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
    if(items.isQuantityMode)
        return Math.round(generatedNumber);
    else
        return Math.round((generatedNumber + Number.EPSILON) * squaresNumber) / squaresNumber;
}

function toDecimalLocaleNumber(decimalNumber) {
    var locale = GCompris.ApplicationSettings.locale;
    if(locale === "system") {
        locale = Qt.locale().name === "C" ? "en_US" : Qt.locale().name;
    }
    var decimalLocale = Core.convertNumberToLocaleString(decimalNumber, locale, 'f', 1);
    return decimalLocale;
}
