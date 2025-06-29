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
.import QtQuick as Quick
.import core 1.0 as GCompris
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

function start(items_) {
    items = items_;
    dataset = items.levels;
    numberOfLevel = dataset.length;
    items.currentLevel = Core.getInitialLevel(numberOfLevel);
    items.score.currentSubLevel = 0;
    firstNumberList = [];

    if(items.tutorialImage.visible) {
        loadTutorialText();
    } else {
        initLevel();
    }
}

function stop() {
}

function initLevel() {
    items.errorRectangle.resetState();
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

        if(items.activityBackground.horizontalLayout) {
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
    items.buttonsBlocked = false;
}

function nextLevel() {
    items.score.stopWinAnimation();
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    items.score.currentSubLevel = 0;
    initLevel();
}

function previousLevel() {
    items.score.stopWinAnimation();
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    items.score.currentSubLevel = 0;
    initLevel();
}

function nextSubLevel() {
    if(items.score.currentSubLevel >= items.score.numberOfSubLevels) {
        items.bonus.good('flower');
    } else {
        items.droppedItems.clear();

        // In case number of sublevels are greater than the number of possibilities of the current level.
        checkAvailableQuestions();

        displayDecimalNumberQuestion();
        items.buttonsBlocked = false;
    }
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
    items.buttonsBlocked = true;
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
            items.goodAnswerSound.play();
            items.numpad.resetText();
            items.typeResult = true;
            items.buttonsBlocked = false;
        }
        else {
            items.score.currentSubLevel += 1;
            items.score.playWinAnimation();
            items.goodAnswerSound.play();
        }
    }
    else {
        items.errorRectangle.startAnimation();
        items.badAnswerSound.play();
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
    items.buttonsBlocked = true;
    typedAnswer = typedAnswer.replace("," , ".");
    if(parseFloat(typedAnswer) === parseFloat(correctAnswer)) {
        items.goodAnswerSound.play();
        items.bonus.good('flower')
    }
    else {
        items.errorRectangle.startAnimation();
        items.badAnswerSound.play();
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

function loadTutorialText() {
    var largestNumber = items.isQuantityMode ? "15" : toDecimalLocaleNumber(1.5);
    var smallestNumber = toDecimalLocaleNumber(0.3);

    if(items.isSubtractionMode) {
        items.tutorialSection.tutorialQml.instructionText = items.instructionPanel.subtractionQuestion.arg(largestNumber).arg(smallestNumber);
    }
    else if(items.isAdditionMode) {
        items.tutorialSection.tutorialQml.instructionText = items.instructionPanel.additionQuestion.arg(largestNumber).arg(smallestNumber);
    }
    else if(items.isQuantityMode) {
        items.tutorialSection.tutorialQml.instructionText = items.instructionPanel.quantityQuestion.arg(largestNumber);
    }
    else {
        items.tutorialSection.tutorialQml.instructionText = items.instructionPanel.decimalQuestion.arg(largestNumber);
    }
    items.tutorialSection.tutorialQml.answerText = items.answerBackground.resultText.arg(" ")
}
