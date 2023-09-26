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
    items.okButton.visible = false;
    items.cardListModel.clear();
    items.holderListModel.clear();
    items.selectedIndex = -1;

    var currentDataset = items.levels[items.currentLevel];
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
                "isSignSymbol": false,
                "clickable": true
            }
            cards.push(card);

            if(currentDataset.findBothNumbers) {
                var card = {
                    "value": leftHandSide.toString(),
                    "visibility": true,
                    "isSignSymbol": false,
                    "clickable": true
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
                "isSignSymbol": false,
                "clickable": true
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
                "isSignSymbol": false,
                "clickable": true
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
    }
    if(isAllCorrect) {
        items.bonus.good("flower");
    }
    else {
        items.bonus.bad("flower");
    }
}
