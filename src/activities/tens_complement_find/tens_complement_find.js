/* GCompris - tens_complement_find.js
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-FileCopyrightText: 2022 Timothée Giet <animtim@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 */
.pragma library
.import "../../core/core.js" as Core

var numberOfLevel;
var numberOfSubLevel;
var items;

// stored values for Client data
var proposedNumbers = [];
var questionList = [];

function start(items_) {
    items = items_;
    numberOfLevel = items.levels.length;
    items.currentLevel = Core.getInitialLevel(numberOfLevel);
    items.score.currentSubLevel = 0;
    initLevel();
}

function stop() {
}

function initLevel() {
    proposedNumbers = [];
    questionList = []
    items.okButton.visible = false;
    items.cardListModel.clear();
    items.holderListModel.clear();
    items.selectedIndex = -1;

    var currentDataset = items.levels[items.currentLevel];
    var equations = [];
    var cards = [];
    var firstOperands = [];
    if(currentDataset.randomValues) {
        numberOfSubLevel = currentDataset.numberOfSublevels;
        var numberOfAdditions = currentDataset.numberOfAdditions;
        // Safety check to limit to 2 additions as the layout can not fit more.
        if(numberOfAdditions > 3) {
            console.log("Warning: dataset numberOfAdditions must not be greater than 3.");
            numberOfAdditions = 3;
        }

        var cardToDisplayIndex = 0;
        for(var equationIndex = 0 ; equationIndex < numberOfAdditions ; ++ equationIndex) {
            // First fill the first operands
            var minValue = currentDataset.minimumFirstValue;
            var maxValue = currentDataset.maximumFirstValue;
            var generatedNumber = 0;
            var numberAlreadyExists = true;
            var tryCount = 10; // Avoid too many attempts. There should not be too much duplicates.
            while(numberAlreadyExists && tryCount > 0) {
                generatedNumber = Math.floor(Math.random() * (maxValue - minValue + 1)) + minValue;
                numberAlreadyExists = false;
                // We check if the number is already in the list.
                // This way, for levels where all numbers have to be found, we are sure to not have duplicates
                for(var i = 0 ; i < firstOperands.length ; ++ i) {
                    if(generatedNumber == firstOperands[i].value) {
                        numberAlreadyExists = true;
                    }
                }
                tryCount --;
            }
            firstOperands.push(generatedNumber);

            var rightHandSide = 10 - generatedNumber;
            var card = {
                "value": rightHandSide.toString(),
                "visibility": true,
                "isSignSymbol": false,
                "clickable": true
            }
            cards.push(card);

            if(currentDataset.findBothNumbers) {
                var card = {
                    "value": generatedNumber.toString(),
                    "visibility": true,
                    "isSignSymbol": false,
                    "clickable": true
                } 
                cards.push(card);
            }

            var toShuffleQuestionValue;
            if(!currentDataset.findBothNumbers) {
                toShuffleQuestionValue = [generatedNumber.toString(), "?"];
                if(currentDataset.shuffleOperand) {
                    Core.shuffle(toShuffleQuestionValue);
                }
            }
            else {
                toShuffleQuestionValue = ["?", "?"];
            }
            equations.push(createEquation(toShuffleQuestionValue));
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
    }
    // Fixed dataset with !currentDataset.randomValues
    else {
        var subLevel = currentDataset.values[items.score.currentSubLevel];
        numberOfSubLevel = currentDataset.values.length;

        firstOperands = subLevel.firstOperands.slice(0);
        var cardNumbers = [];
        var numberOfAdditions = firstOperands.length;
        // Safety check to limit to 3 additions as the layout can not fit more.
        if(numberOfAdditions > 3) {
            console.log("Warning: dataset firstOperands must not contain more than 3 numbers.")
            numberOfAdditions = 3;
        }
        for(var equationIndex = 0 ; equationIndex < numberOfAdditions ; ++ equationIndex ) {
            cardNumbers.push(10 - firstOperands[equationIndex]);
            if(currentDataset.findBothNumbers) {
                cardNumbers.push(firstOperands[equationIndex]);
            }
        }

        var extraCards = subLevel.extraCards.slice(0);
        var numberOfCards = cardNumbers.length + extraCards.length;
        if(numberOfCards > 6) {
            console.log("Warning: dataset extraCards is too large, the total number of cards must not be greater than 6.");
            var maxEtraAllowed = 6 - cardNumbers.length;
            var numbersToRemove = extraCards.length - maxEtraAllowed;
            extraCards.splice(maxEtraAllowed, numbersToRemove);
            numberOfCards = 6;
        }

        for(var i = 0; i < extraCards.length; i++) {
            cardNumbers.push(extraCards[i]);
        }

        // populate cards
        for(var cardToDisplayIndex = 0 ; cardToDisplayIndex < numberOfCards ; cardToDisplayIndex++) {
            var card = {
                "value": cardNumbers[cardToDisplayIndex].toString(),
                "visibility": true,
                "isSignSymbol": false,
                "clickable": true
            }
            cards.push(card);
        }

        for(var equationIndex = 0 ; equationIndex < numberOfAdditions ; equationIndex++) {
            var toShuffleQuestionValue;
            if(currentDataset.findBothNumbers) {
                toShuffleQuestionValue = ["?", "?"];
            } else {
                toShuffleQuestionValue = [firstOperands[equationIndex].toString(), "?"];
                if(currentDataset.shuffleOperands) {
                    Core.shuffle(toShuffleQuestionValue);
                }
            }
            equations.push(createEquation(toShuffleQuestionValue));
        }
    }

    Core.shuffle(cards);
    for(var i = 0 ; i < cards.length ; ++ i) {
        cards[i].index = i;
        items.cardListModel.append(cards[i]);
    }
    Core.shuffle(equations);
    for(var i = 0 ; i < equations.length ; ++ i) {
        equations[i].rowIndex = i;
        items.holderListModel.append(equations[i]);
    }

    // store fixed Client data
    for(var numberIndex = 0; numberIndex < items.cardListModel.count; numberIndex++) {
        proposedNumbers.push(items.cardListModel.get(numberIndex).value)
    }
    for(var questionIndex = 0; questionIndex < items.holderListModel.count; questionIndex++) {
        var additionString = "";
        var equation = items.holderListModel.get(questionIndex);
        var addition = equation.addition
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

function createEquation(values) {
    return {
        "addition": [
            {
                "value": values[0],
                "visibility": true,
                "clickable": values[0] === "?",
                "isSignSymbol": false
            },
            {
                "value": "+",
                "visibility": true,
                "clickable": false,
                "isSignSymbol": true
            },
            {
                "value": values[1],
                "visibility": true,
                "clickable": values[1] === "?",
                "isSignSymbol": false
            },
            {
                "value": "=",
                "visibility": true,
                "clickable": false,
                "isSignSymbol": true
            },
            {
                "value": "10",
                "visibility": true,
                "clickable": false,
                "isSignSymbol": false
            }
        ],
        "firstCardClickable": values[0] == "?" ? true : false,
        "secondCardClickable": values[1] == "?" ? true : false,
        "isCorrect": false,
        "tickVisibility": false
    }
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

function reappearNumberCard(value) {
    var cardsToDisplay = items.cardListModel.count;
    for(var i = 0 ; i < cardsToDisplay ; i++) {
        if(value == items.cardListModel.get(i).value && !items.cardListModel.get(i).visibility) {
            items.cardListModel.setProperty(i, "visibility", true);
            break;
        }
    }
}

function getSelectedValue() {
    var selectedValue = items.selectedIndex != -1 ? items.cardListModel.get(items.selectedIndex).value.toString() : "?";
    return selectedValue;
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

function updateVisibility(rowIndex) {
    items.holderListModel.get(rowIndex).tickVisibility = false;
    if(items.selectedIndex != -1) {
        // Unselect it
        items.cardListModel.setProperty(selected, "selected", false);
        items.cardListModel.setProperty(selected, "visibility", false);
        items.selectedIndex = -1;
    }
    items.okButton.visible = showOkButton();
}

function showOkButton() {
    var checkQuestionMark = true;
    for(var i = 0; i < items.holderListModel.count; i++) {
        var equation = items.holderListModel.get(i).addition;
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
    var isAllCorrect = true;
    for(var i = 0 ; i < items.holderListModel.count ; i ++) {
        var equation = items.holderListModel.get(i);
        var solution = equation.addition
        var isGood = parseInt(solution.get(0).value) + parseInt(solution.get(2).value) == 10 ? true : false;
        equation.isCorrect = isGood;
        equation.tickVisibility = true;
        isAllCorrect = isGood & isAllCorrect;

        // store answer string for Client data
        var answerString = "";
        for(var j = 0; j < solution.count; j++) {
            answerString += solution.get(j).value;
        }
        questionList[i].answer = answerString;
        questionList[i].isCorrect = isGood;
    }

    items.client.sendToServer(isAllCorrect);

    if(isAllCorrect) {
        items.buttonsBlocked = true;
        items.score.currentSubLevel++
        items.score.playWinAnimation()
        items.goodAnswerSound.play()
    }
    else {
        items.badAnswerSound.play()
    }
}
