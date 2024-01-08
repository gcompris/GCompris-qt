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
.import QtQuick 2.12 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core


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
    items.currentLevel = Core.getInitialLevel(numberOfLevel);
    initLevel();
}

function stop() {
}

function initLevel() {
    items.score.stopWinAnimation();
    items.errorRectangle.resetState();
    questionList = [];

    questionList = dataset[items.currentLevel].questions;
    items.score.currentSubLevel = 0;
    items.score.numberOfSubLevels = questionList.length;
    currentQuestionIndex = -1;

    if(dataset[items.currentLevel].generateRandomPositions) {
        questionList = Core.shuffle(questionList);
    }

    nextSubLevel();
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function verifyAnswer() {
    items.buttonsBlocked = true;
    if(items.selectedPosition === items.checkState) {
        items.score.currentSubLevel += 1;
        items.score.playWinAnimation();
        items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/completetask.wav");
    }
    else {
        items.errorRectangle.startAnimation();
        items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/crash.wav");
    }
}

function nextSubLevel() {
    currentQuestionIndex++;
    if(currentQuestionIndex >= questionList.length) {
        items.bonus.good("flower");
        return;
    }
    items.positionModels.clear();
    items.checkState = questionList[currentQuestionIndex]["id"];
    if(questionList[currentQuestionIndex].text !== undefined) {
        items.questionText = questionList[currentQuestionIndex]["text"];
    }
    items.view.currentIndex = -1;
    getRandomPositions();
    items.buttonsBlocked = false;
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
