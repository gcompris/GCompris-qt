/* GCompris - positions.js
 *
 * SPDX-FileCopyrightText: 2021 Mariam Fahmy <mariamfahmy66@gmail.com>
 *
 * Authors:
 *   Mariam Fahmy <mariamfahmy66@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.6 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core


var currentLevel;
var numberOfLevel;
var items;
var position;
var dataset;
var questionList = [];

var rightPosition = 0x0000;
var leftPosition = 0x0001;
var abovePosition = 0x0002;
var underPosition = 0x0004;
var insidePosition = 0x0008;
var behindPosition = 0x0010;
var inFrontOfPosition = 0x0020;
var currentQuestionIndex;

function start(items_) {
    items = items_;
    dataset = items.levels;
    numberOfLevel = dataset.length;
    currentLevel = 0;
    items.score.currentSubLevel = 1;
    initLevel();
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1;
    questionList = [];

    questionList = dataset[currentLevel].questions;
    items.score.numberOfSubLevels = questionList.length;
    items.currentLevel = items.bar.level;
    currentQuestionIndex = -1;

    if(dataset[currentLevel].generateRandomPositions) {
        questionList = Core.shuffle(questionList);
    }

    nextSubLevel();
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

function verifyAnswer() {
    if(items.selectedPosition === items.checkState) {
        items.bonus.good("flower");
    }
    else {
        items.bonus.bad("flower");
    }
}

function nextSubLevel() {
    currentQuestionIndex++;
    if(currentQuestionIndex >= questionList.length) {
        nextLevel();
        return;
    }
    items.positionModels.clear();
    items.checkState = questionList[currentQuestionIndex]["id"];
    if(questionList[currentQuestionIndex].text !== undefined) {
        items.questionText = questionList[currentQuestionIndex]["text"];
    }
    items.view.currentIndex = -1;
    getRandomPositions();
    items.score.currentSubLevel = currentQuestionIndex;
}

function getRandomPositions() {
    var randomPositions = [];
    var correctAnswer = questionList[currentQuestionIndex]["id"];
    randomPositions.push(questionList[currentQuestionIndex]);
    for(var i = 1 ; i < questionList.length / 2 ; i++ ) {
        getRandomElement(randomPositions);
    }
    randomPositions = Core.shuffle(randomPositions);
    for(var j = 0; j < randomPositions.length ; j++) {
        items.positionModels.append( {"stateId" : randomPositions[j].id,
                                      "stateName" : randomPositions[j].position } );
    }
}

function getRandomElement(randomPositions) {
    var randomElement = questionList[Math.floor(Math.random() * questionList.length)];
    while(randomPositions.indexOf(randomElement) !== -1) {
        randomElement = questionList[Math.floor(Math.random() * questionList.length)];
    }
    randomPositions.push(randomElement);
}
