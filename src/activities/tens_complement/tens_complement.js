/* GCompris - tens_complement.js
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
var cardsToDisplay;
var items;
var datasets = [];
var selected = -1; // "-1" indicates no item selected
var shuffledDataset = [];

function start(items_) {
    items = items_;
    currentLevel = 0;
    datasets.length = 0;
    for(var indexForDataset = 0; indexForDataset < items.levels.length; indexForDataset++) {
        for(var indexForLevel = 0; indexForLevel < items.levels[indexForDataset].value.length; indexForLevel++) {
            var shuffledValues = items.levels[indexForDataset].value[indexForLevel];
            Core.shuffle(shuffledValues)
            var levelObj = {
                value: shuffledValues,
                randomQuestionPosition: items.levels[indexForDataset].randomQuestionPosition
            }
            datasets.push(levelObj);
        }
    }
    numberOfLevel = datasets.length;
    initLevel();
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1;
    numberOfSubLevel = datasets[currentLevel].value.length;
    items.score.currentSubLevel = currentSubLevel + 1;
    items.score.numberOfSubLevels = numberOfSubLevel;
    items.okButton.visible = false;
    shuffledDataset = datasets[currentLevel].value;
    cardsToDisplay = shuffledDataset[currentSubLevel].numberValue.length;
    items.cardListModel.clear();
    items.holderListModel.clear();
    for(var cardToDisplayIndex = 0; cardToDisplayIndex < cardsToDisplay; cardToDisplayIndex++) {
        var card = {
            "value": shuffledDataset[currentSubLevel].numberValue[cardToDisplayIndex].toString(),
            "visibility": true,
            "index": cardToDisplayIndex,
            "selected": false
        }
        items.cardListModel.append(card);
    }
    var questionCardToDisplay = shuffledDataset[currentSubLevel].questionValue.length;
    for(var cardToDisplayIndex = 0; cardToDisplayIndex < questionCardToDisplay; cardToDisplayIndex++) {
        var toShuffleQuestionValue = [shuffledDataset[currentSubLevel].questionValue[cardToDisplayIndex].toString(), "?"];
        if(datasets[currentLevel].randomQuestionPosition) {
            Core.shuffle(toShuffleQuestionValue);
        }
        var questionCard = {
            "questionValueFirst": toShuffleQuestionValue[0],
            "questionValueSecond": toShuffleQuestionValue[1],
            "firstCardClickable": toShuffleQuestionValue[0] == "?" ? true : false,
            "secondCardClickable": toShuffleQuestionValue[1] == "?" ? true : false,
            "rowIndex": cardToDisplayIndex,
            "isCorrect": true,
            "tickVisibility": false
        }
        items.holderListModel.append(questionCard);
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

function updateCardsToInitialSize() {
    for(var i = 0; i < cardsToDisplay; i++) {
        items.cardListModel.setProperty(i, "selected", false);
    }
}

function selectedCard(index) {
    updateCardsToInitialSize();
    selected = index;
    updateSize();
}

function updateSize() {
    if(selected != -1) {
        items.cardListModel.setProperty(selected, "selected", true);
    }
}

function reappearNumberCard(value) {
    for(var i = 0; i < cardsToDisplay; i++) {
        if(value == shuffledDataset[currentSubLevel].numberValue[i]) {
            items.cardListModel.setProperty(i, "visibility", true);
            break;
        }
    }
    updateCardsToInitialSize();
}

function getSelectedValue() {
    var selectedValue = selected != -1 ? items.cardListModel.get(selected).value.toString() : "?";
    return selectedValue;
}

function updateVisibility(rowIndex) {
    items.holderListModel.get(rowIndex).tickVisibility = false;
    if(selected != -1) {
        items.cardListModel.setProperty(selected, "visibility", false);
        selected = -1;
    }
    showOkButton();
}

function showOkButton() {
    var checkQuestionMark = true;
    for(var i = 0; i < items.holderListModel.count; i++) {
        var equation = items.holderListModel.get(i);
        if(equation.questionValueFirst == "?" || equation.questionValueSecond == "?") {
            checkQuestionMark = false;
            break;
        }
    }
    items.okButton.visible = checkQuestionMark;
}

function checkAnswer() {
    var isAllCorrect = true;
    for(var i=0;i<items.holderListModel.count;i++) {
        var equation = items.holderListModel.get(i);
        var isGood = parseInt(equation.questionValueFirst) + parseInt(equation.questionValueSecond) == 10 ? true : false;
        items.holderListModel.get(i).isCorrect = isGood;
        items.holderListModel.get(i).tickVisibility = true;
        isAllCorrect = isGood & isAllCorrect
    }
    isAllCorrect ? items.bonus.good("flower") : items.bonus.bad("flower");
}
