/* GCompris - tens_complement_find.js
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 */
.pragma library
.import "../../core/core.js" as Core

var currentLevel = 0;
var numberOfLevel;
var currentSubLevel = 0;
var numberOfSubLevel;
var items;
var selected = -1; // "-1" indicates no item selected

function start(items_) {
    items = items_;
    currentLevel = 0;
    numberOfLevel = items.levels.length;
    initLevel();
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1;
    items.score.currentSubLevel = currentSubLevel + 1;
    items.okButton.visible = false;
    items.cardListModel.clear();
    items.holderListModel.clear();

    var currentDataset = items.levels[currentLevel];
    var equations = [];
    var cards = [];
    if(currentDataset.randomValues) {
        numberOfSubLevel = currentDataset.numberOfSublevels;
        var cardToDisplayIndex = 0;
        for(var equationIndex = 0 ; equationIndex < currentDataset.numberOfEquations ; ++ equationIndex) {
            // First fill the left hand containers with all the numbers
            var minValue = currentDataset.minimumFirstValue;
            var maxValue = currentDataset.maximumFirstValue;
            var leftHandSide;
            var numberAlreadyExists = true;
            var tryCount = 10; // Avoid too many attemps. There should not be too much duplicates.
            while(numberAlreadyExists && tryCount > 0) {
                leftHandSide = Math.floor(Math.random() * (maxValue - minValue + 1)) + minValue;
                numberAlreadyExists = false;
                // We check if the tens complement of the number is already used.
                // This way, for levels where all numbers have to be found, we are sure to not have duplicates
                for(var i = 0 ; i < cards.length ; ++ i) {
                    var counterpart = (10 - leftHandSide).toString();
                    if(counterpart == cards[i].value) {
                        numberAlreadyExists = true;
                    }
                }
                tryCount --;
            }

            var rightHandSide = 10 - leftHandSide;
            var card = {
                "value": rightHandSide.toString(),
                "visibility": true,
                "selected": false
            }
            cards.push(card);

            if(currentDataset.findBothNumbers) {
                var card = {
                    "value": leftHandSide.toString(),
                    "visibility": true,
                    "selected": false
                } 
                cards.push(card);
            }

            var toShuffleQuestionValue;
            if(!currentDataset.findBothNumbers) {
                toShuffleQuestionValue = [leftHandSide.toString(), "?"];
            }
            else {
                toShuffleQuestionValue = ["?", "?"];
            }
            if(currentDataset.randomQuestionPosition) {
                Core.shuffle(toShuffleQuestionValue);
            }
            equations.push(createEquation(toShuffleQuestionValue));
        }
        // Append more random cards if needed between 1 and 9
        for(var i = cards.length ; i < currentDataset.numberOfNumbersInLeftContainer ; ++ i) {
            var randomNumber = Math.floor(Math.random() * 9) + 1;
            var card = {
                "value": randomNumber.toString(),
                "visibility": true,
                "selected": false
            } 
            cards.push(card);
        }
    }
    else {
        var sublevel = currentDataset.values[currentSubLevel];
        numberOfSubLevel = currentDataset.values.length;

        var cardsToDisplay = sublevel.numberValue.length;
        for(var cardToDisplayIndex = 0 ; cardToDisplayIndex < cardsToDisplay ; cardToDisplayIndex++) {
            var card = {
                "value": sublevel.numberValue[cardToDisplayIndex].toString(),
                "visibility": true,
                "selected": false
            }
            cards.push(card);
        }

        var equationsToDisplay = sublevel.questionValue;
        for(var equationIndex = 0 ; equationIndex < equationsToDisplay.length ; equationIndex++) {
            var toShuffleQuestionValue = [equationsToDisplay[equationIndex].toString(), "?"];
            if(currentDataset.randomQuestionPosition) {
                Core.shuffle(toShuffleQuestionValue);
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
    items.score.numberOfSubLevels = numberOfSubLevel;
}

function createEquation(values) {
    return {
        "leftValue": values[0].toString(),
        "rightValue": values[1].toString(),
        "firstCardClickable": values[0] == "?" ? true : false,
        "secondCardClickable": values[1] == "?" ? true : false,
        "isCorrect": false,
        "tickVisibility": false
    }
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel) {
        currentLevel = 0;
    }
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
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1;
    }
    currentSubLevel = 0;
    initLevel();
}

function selectCard(index) {
    // Unselect previous card if one was selected
    if(selected != -1) {
        items.cardListModel.setProperty(selected, "selected", false);
    }
    selected = index;
    items.cardListModel.setProperty(selected, "selected", true);
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
    var selectedValue = selected != -1 ? items.cardListModel.get(selected).value.toString() : "?";
    return selectedValue;
}

function click(index, rowIndex) {
    var equation = items.holderListModel.get(rowIndex);
    var property = (index == 0) ? "leftValue" : "rightValue";
    var value = equation[property];
    if(value != "?") {
        reappearNumberCard(value);
    }
    items.holderListModel.setProperty(rowIndex, property, getSelectedValue());
    updateVisibility(rowIndex)
}


function updateVisibility(rowIndex) {
    items.holderListModel.get(rowIndex).tickVisibility = false;
    if(selected != -1) {
        // Unselect it
        items.cardListModel.setProperty(selected, "selected", false);
        items.cardListModel.setProperty(selected, "visibility", false);
        selected = -1;
    }
    items.okButton.visible = shouldShowOkButton();
}

function shouldShowOkButton() {
    var checkQuestionMark = true;
    for(var i = 0; i < items.holderListModel.count; i++) {
        var equation = items.holderListModel.get(i);
        if(equation.leftValue == "?" || equation.rightValue == "?") {
            checkQuestionMark = false;
            break;
        }
    }
    return checkQuestionMark;
}

function checkAnswer() {
    var isAllCorrect = true;
    for(var i = 0 ; i < items.holderListModel.count ; i ++) {
        var equation = items.holderListModel.get(i);
        var isGood = parseInt(equation.leftValue) + parseInt(equation.rightValue) == 10 ? true : false;
        equation.isCorrect = isGood;
        equation.tickVisibility = true;
        isAllCorrect = isGood & isAllCorrect;
    }
    if(isAllCorrect) {
        items.bonus.good("flower");
    }
    else {
        items.bonus.bad("flower");
    }
}
