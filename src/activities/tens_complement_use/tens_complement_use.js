/* GCompris - tens_complement_use.js
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 */
.pragma library
.import "../../core/core.js" as Core

var numberOfLevel;
var currentSubLevel = 0;
var numberOfSubLevel;
var items;
var questionArrayValue = [null, "+", null, "=", null];
var answerArrayValue = ["(", null, "+", null, ")", "+", null, "=", null];
var indexOfNumberInAnswerArray = [1, 3, 6];

function start(items_) {
    items = items_
    numberOfLevel = items.levels.length;
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    currentSubLevel = 0
    initLevel()
}

function stop() {
}

function initLevel() {
    items.score.currentSubLevel = currentSubLevel + 1;
    items.okButton.visible = false;
    clearAllListModels();
    var currentDataset = items.levels[items.currentLevel];
    if(currentDataset.randomValues) {
        numberOfSubLevel = currentDataset.numberOfSublevels;

        var cards = [];
        // Fill the right panel
        for(var equationIndex = 0; equationIndex < currentDataset.numberOfEquations; equationIndex ++) {
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

        // Fill left container
        for(var i = 0; i < currentDataset.numberOfNumbersInLeftContainer-cards.length+1; i++) {
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
    else {
        var sublevel = currentDataset.values[currentSubLevel];
        numberOfSubLevel = currentDataset.values.length;
        var numberValue = sublevel.numberValue;

        // Fill left container
        for(var i = 0; i < numberValue.length; i++) {
            var card = {
                "value": numberValue[i].toString(),
                "visibility": true,
                "isSignSymbol": false,
                "clickable": true
            }
            items.cardListModel.append(card);
        }

        for(var equationIndex = 0; equationIndex < sublevel.questions.length; equationIndex ++) {
            var questionsModel = {
                "addition": [],
                "secondRow": [],
                "tickVisibility": false,
                "isGood": false
            };

            var question = sublevel.questions[equationIndex];
            var indexCounter = 0;
            for(var i = 0; i < questionArrayValue.length; i++) {
                var isNumber = true;
                if(questionArrayValue[i] == "+" || questionArrayValue[i] == "(" || questionArrayValue[i] == ")" || questionArrayValue[i] == "=") {
                    isNumber = false;
                }
                else {
                    questionArrayValue[i] = question.questionValue[indexCounter].toString();
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
            for(var i = 0; i < answerArrayValue.length; i++) {
                var isNumber = true;
                if(answerArrayValue[i] == "+" || answerArrayValue[i] == "(" || answerArrayValue[i] == ")" || answerArrayValue[i] == "=") {
                    isNumber = false;
                }
                else {
                    answerArrayValue[i] = question.splitValue[indexCounter].toString();
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
    }
    items.score.numberOfSubLevels = numberOfSubLevel;
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
}

function showOkButton() {
    var checkQuestionMark = true;
    for(var i = 0; i < items.holderListModel.count; i++) {
        var equation = items.holderListModel.get(i).secondRow;
        for(var j = 0; j < equation.count; j++) {
            var answer = equation.get(j);
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
        var equation = items.holderListModel.get(i);
        var solution = equation.secondRow;
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
        equation.tickVisibility = true;
        equation.isGood = check;
    }
    if(allOk) {
        items.bonus.good("flower");
    }
    else {
        items.bonus.bad("flower");
    }
}
