/* GCompris - tens_complement_use.js
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 */
.pragma library
.import "../../core/core.js" as Core

var numberOfLevel;
var numberOfSubLevel;
var items;
var questionArrayValue = [null, "+", null, "=", null];
var answerArrayValue = ["(", null, "+", null, ")", "+", null, "=", null];
var indexOfNumberInAnswerArray = [1, 3, 6];

// store dataset values in case of fixed levels to allow shuffling them.
var datasetValues = [];

// stored values for Client data
var proposedNumbers = [];
var questionList = [];

function start(items_) {
    items = items_
    numberOfLevel = items.levels.length;
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    items.score.currentSubLevel = 0
    initLevel()
}

function stop() {
}

function initLevel() {
    items.okButton.visible = false;
    clearAllListModels();
    var currentDataset = items.levels[items.currentLevel];
    if(currentDataset.randomValues) {
        numberOfSubLevel = currentDataset.numberOfSubLevels;

        var cards = [];
        var numberOfAdditions = currentDataset.numberOfAdditions;
        // Safety check to limit to 2 additions as the layout can not fit more.
        if(numberOfAdditions > 2) {
            console.log("Warning: dataset numberOfAdditions must not be greater than 2.");
            numberOfAdditions = 2;
        }
        // Fill the right panel
        for(var additionIndex = 0; additionIndex < numberOfAdditions; additionIndex ++) {
            var questionsModel = {
                "addition": [],
                "secondRow": [],
                "tickVisibility": false,
                "isGood": false
            };

            var resultToFind = Math.floor(Math.random() * (currentDataset.maxResult - currentDataset.minResult + 1)) + currentDataset.minResult;

            // Add the last number to find first
            cards.push({
                "value": (resultToFind-10).toString(),
                "visibility": true,
                "isSignSymbol": false,
                "clickable": true
            });
            // Ensure we have at least two numbers where the sum is ten
            var firstNumberOfSum = Math.floor(Math.random() * 9) + 1;
            var counterpart = (10 - firstNumberOfSum).toString();
            cards.push({
                "value": counterpart,
                "visibility": true,
                "isSignSymbol": false,
                "clickable": true
            });

            var indexCounter = 0;
            var questionValue = [firstNumberOfSum, resultToFind-firstNumberOfSum, resultToFind];
            for(var i = 0; i < questionArrayValue.length; i++) {
                var isNumber = true;
                if(questionArrayValue[i] == "+" || questionArrayValue[i] == "(" || questionArrayValue[i] == ")" || questionArrayValue[i] == "=") {
                    isNumber = false;
                }
                else {
                    questionArrayValue[i] = questionValue[indexCounter].toString();
                    indexCounter++;
                }
                var card = {
                    "value": questionArrayValue[i].toString(),
                    "visibility": true,
                    "isSignSymbol": !isNumber,
                    "clickable": false
                }
                questionsModel.addition.push(card);
            }
            indexCounter = 0;
            var splitValue = [firstNumberOfSum, "?", "?", resultToFind];
            for(var i = 0; i < answerArrayValue.length; i++) {
                var isNumber = true;
                if(answerArrayValue[i] == "+" || answerArrayValue[i] == "(" || answerArrayValue[i] == ")" || answerArrayValue[i] == "=") {
                    isNumber = false;
                }
                else {
                    answerArrayValue[i] = splitValue[indexCounter].toString();
                    indexCounter++;
                }
                var card = {
                    "value": answerArrayValue[i].toString(),
                    "visibility": true,
                    "clickable": (answerArrayValue[i] === "?"),
                    "isSignSymbol": !isNumber
                }
                questionsModel.secondRow.push(card);
            }
            items.holderListModel.append(questionsModel);
        }

        var numberOfCards = cards.length + currentDataset.numberOfExtraCards;
        // Safety check to limit to 6 cards as the layout can not fit more.
        if(numberOfCards > 6) {
            console.log("Warning: dataset numberOfExtraCards is too large, the total number of cards must not be greater than 6.");
            numberOfCards = 6;
        }
        // Fill left container
        var numberOfCardsToFill = numberOfCards - cards.length;
        for(var i = 0; i < numberOfCardsToFill; i++) {
            var randomNumber = Math.floor(Math.random() * 9) + 1;
            var card = {
                "value": randomNumber.toString(),
                "visibility": true,
                "isSignSymbol": false,
                "clickable": true
            }
            cards.push(card);
        }
        // Shuffle and add to the model
        Core.shuffle(cards);
        for(var i = 0 ; i < cards.length ; ++ i) {
            items.cardListModel.append(cards[i]);
        }
    }
    // Fixed dataset with !currentDataset.randomValues
    else {
        // init datasetValues on first subLevel
        if(items.score.currentSubLevel === 0 || datasetValues === []) {
            datasetValues = currentDataset.values;
            if(currentDataset.shuffle) {
                Core.shuffle(datasetValues);
            }
        }

        var sublevel = datasetValues[items.score.currentSubLevel];
        numberOfSubLevel = datasetValues.length;
        var cardNumbers = []
        var questionStrings = sublevel.additions;
        // Safety check to limit to 2 additions as the layout can not fit more.
        if(questionStrings.length > 2) {
            console.log("Warning: dataset additions must not contain more than 2 questions.")
            questionStrings.splice(2, questionStrings.length - 2);
        }

        // Convert question strings to number arrays
        var questions = [];
        for(var i = 0; i < questionStrings.length; i++) {
            var currenString = questionStrings[i];
            // Extract number sequences from the string, and convert them to Number type
            var questionOperands = questionStrings[i].match(/\d+/g).map(Number);
            // If there's not exactly 2 numbers, or first number is not between 1 and 9, stop here.
            if(questionOperands.length != 2 || questionOperands[0] < 1 || questionOperands[0] > 9) {
                console.log("Warning: invalid addition, failed to load level.");
                return;
            }
            questions.push(questionOperands);
        }

        // Generate needed card numbers for given questions
        for(var i = 0; i < questions.length; i++) {
            var firstNumberToAdd = 10 - questions[i][0];
            var secondNumberToAdd = questions[i][1] - firstNumberToAdd;
            cardNumbers.push(firstNumberToAdd);
            cardNumbers.push(secondNumberToAdd);
        }

        var extraCards = sublevel.extraCards;
        var numberOfCards = cardNumbers.length + extraCards.length;
        // Safety check to make sure we don't have more than 6 cards
        if(numberOfCards > 6) {
            console.log("Warning: dataset extraCards is too large, the total number of cards must not be greater than 6.")
            var maxExtraAllowed = 6 - cardNumbers.length;
            var numbersToRemove = extraCards.length - maxExtraAllowed;
            extraCards.splice(maxExtraAllowed, numbersToRemove);
        }

        for(var i = 0; i < extraCards.length; i++) {
            cardNumbers.push(extraCards[i]);
        }

        // Shuffle cards
        Core.shuffle(cardNumbers);
        // Fill left container
        for(var i = 0; i < cardNumbers.length; i++) {
            var card = {
                "value": cardNumbers[i].toString(),
                "visibility": true,
                "isSignSymbol": false,
                "clickable": true
            }
            items.cardListModel.append(card);
        }

        for(var additionIndex = 0; additionIndex < questions.length; additionIndex ++) {
            var questionsModel = {
                "addition": [],
                "secondRow": [],
                "tickVisibility": false,
                "isGood": false
            };

            var question = questions[additionIndex];
            // Calculate result from given addition
            var result = question[0] + question[1];

            questionArrayValue[0] = question[0].toString();
            questionArrayValue[2] = question[1].toString();
            questionArrayValue[4] = result.toString();
            for(var i = 0; i < questionArrayValue.length; i++) {
                var isNumber = true;
                if(questionArrayValue[i] == "+" || questionArrayValue[i] == "=") {
                    isNumber = false;
                }
                var card = {
                    "value": questionArrayValue[i],
                    "visibility": true,
                    "isSignSymbol": !isNumber,
                    "clickable": false
                }
                questionsModel.addition.push(card);
            }

            answerArrayValue[1] = question[0].toString();
            answerArrayValue[3] = "?";
            answerArrayValue[6] = "?";
            answerArrayValue[8] = result.toString();
            for(var i = 0; i < answerArrayValue.length; i++) {
                var isNumber = true;
                if(answerArrayValue[i] == "+" || answerArrayValue[i] == "(" || answerArrayValue[i] == ")" || answerArrayValue[i] == "=") {
                    isNumber = false;
                }
                var card = {
                    "value": answerArrayValue[i],
                    "visibility": true,
                    "clickable": (answerArrayValue[i] === "?"),
                    "isSignSymbol": !isNumber
                }
                questionsModel.secondRow.push(card);
            }
            items.holderListModel.append(questionsModel);
        }
    }
    // store fixed Client data
    for(var numberIndex = 0; numberIndex < items.cardListModel.count; numberIndex++) {
        proposedNumbers.push(items.cardListModel.get(numberIndex).value)
    }

    for(var questionIndex = 0; questionIndex < items.holderListModel.count; questionIndex++) {
        var additionString = "";
        var question = items.holderListModel.get(questionIndex);
        var addition = question.addition
        for(var i = 0; i < addition.count; i++) {
            additionString += addition.get(i).value;
        }
        questionList[questionIndex] = {
            "addition": additionString,
            "answer": "",
            "isCorrect": false
        }
    }

    items.score.numberOfSubLevels = numberOfSubLevel;
    items.buttonsBlocked = false;
    items.client.startTiming();
}

function nextLevel() {
    items.score.stopWinAnimation();
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    items.score.currentSubLevel = 0;
    initLevel();
}

function nextSubLevel() {
    if(items.score.currentSubLevel >= numberOfSubLevel) {
        items.bonus.good("flower");
    } else {
        initLevel();
    }
}

function previousLevel() {
    items.score.stopWinAnimation();
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    items.score.currentSubLevel = 0;
    initLevel();
}

function getEnteredCard() {
    if(items.selectedIndex == -1) {
        return "?";
    }
    items.cardListModel.setProperty(items.selectedIndex, "visibility", false);
    var tempSelected = items.selectedIndex;
    items.selectedIndex = -1;
    return items.cardListModel.get(tempSelected).value.toString();
}

function reappearNumberCard(value) {
    for(var i = 0; i < items.cardListModel.count; i++) {
        var card = items.cardListModel.get(i);
        if(value == card.value && card.visibility == false) {
            items.cardListModel.setProperty(i, "visibility", true);
            break;
        }
    }
}

function clearAllListModels() {
    items.cardListModel.clear();
    items.holderListModel.clear();
    proposedNumbers = [];
    questionList = [];
}

function showOkButton() {
    var checkQuestionMark = true;
    for(var i = 0; i < items.holderListModel.count; i++) {
        var addition = items.holderListModel.get(i).secondRow;
        for(var j = 0; j < addition.count; j++) {
            var answer = addition.get(j);
            if(answer.value == "?") {
                checkQuestionMark = false;
                break;
            }
        }
    }

    items.okButton.visible = checkQuestionMark;
}

function checkAnswer() {
    var allOk = true;
    for(var i = 0; i < items.holderListModel.count; i++) {
        var check = true;
        var addition = items.holderListModel.get(i);
        var solution = addition.secondRow;
        if(parseInt(solution.get(indexOfNumberInAnswerArray[0]).value) + parseInt(solution.get(indexOfNumberInAnswerArray[1]).value) != 10) {
            check = false;
        }
        var rest = parseInt(solution.get(solution.count-1).value)-10;
        if(parseInt(solution.get(indexOfNumberInAnswerArray[2]).value) != rest) {
            check = false;
        }
        if(!check) {
            allOk = false;
        }
        addition.tickVisibility = true;
        addition.isGood = check;

        // store answer string for Client data
        var answerString = "";
        for(var j = 0; j < solution.count; j++) {
            answerString += solution.get(j).value;
        }
        questionList[i].answer = answerString;
        questionList[i].isCorrect = check;
    }

    items.client.sendToServer(allOk);
    if(allOk) {
        items.buttonsBlocked = true;
        items.score.currentSubLevel++
        items.score.playWinAnimation()
        items.goodAnswerSound.play()
    }
    else {
        items.badAnswerSound.play()
    }
}
