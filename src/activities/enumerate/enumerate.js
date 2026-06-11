/* GCompris - enumerate.js
*
* SPDX-FileCopyrightText: 2014 Thib ROMAIN <thibrom@gmail.com>
*
* Authors:
*   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
*   Thib ROMAIN <thibrom@gmail.com> (Qt Quick port)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
.pragma library
.import QtQuick as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var url = "qrc:/gcompris/src/activities/enumerate/resource/";
var items;
var maxSubLevel;
var dataset;
var itemNames = [
            "apple",
            "banana",
            "cherries",
            "grapes",
            "lemon",
            "orange",
            "peach",
            "pear",
            "plum",
            "strawberry",
            "watermelon",
        ];
var numberOfTypes = itemNames.length;
var userAnswers = new Object();
var answerToFind = new Object();
var answersMode;

// We keep a globalZ across all items. It is increased on each
// item selection to put it on top
var globalZ = 0;

function start(items_) {
    items = items_;
    answersMode = items.mode;
    dataset = items.levels;
    items.numberOfLevel = dataset.length;
    items.currentLevel = Core.getInitialLevel(items.numberOfLevel);
    initLevel();
}

function stop() {
    cleanUp();
}

function initLevel() {
    items.instructionPanel.opacity = 0.9;
    items.score.currentSubLevel = 0;
    items.numberOfItemType = dataset[items.currentLevel].numberOfItemType;
    items.numberOfItemMax = dataset[items.currentLevel].numberOfItemMax;
    maxSubLevel = dataset[items.currentLevel].subLevels;
    items.score.numberOfSubLevels = maxSubLevel;
    initSubLevel();
}

function nextLevel() {
    items.score.stopWinAnimation();
    items.currentLevel = Core.getNextLevel(items.currentLevel, items.numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.score.stopWinAnimation();
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, items.numberOfLevel);
    initLevel();
}

function cleanUp() {
    userAnswers = new Object();
    answerToFind = new Object();
    items.answerColumn.model = null;
    items.itemListModel = null;
}

function setUserAnswer(imgName, userValue) {
    userAnswers[imgName] = userValue;
    if (answersMode === 1) {
        return userAnswers[imgName] === answerToFind[imgName];
    }
}

function checkAnswersAuto() {
    for (var key in answerToFind) {
        if(userAnswers[key] !== answerToFind[key]) {
            return;
        }
    }
    items.buttonsBlocked = true;
    items.score.currentSubLevel += 1;
    items.score.playWinAnimation();
    items.goodAnswerSound.play();
    items.client.sendToServer(true);
}

function checkAnswers() {
    items.okButtonBlocked = true;
    items.buttonsBlocked = true;
    var i = 0;
    var isAnswerGood =  true;
    for (var key in answerToFind) {
        if(userAnswers[key] !== answerToFind[key]) {
            items.answerColumn.itemAt(i).state = "badAnswer";
            isAnswerGood = false;
        }
        else
            items.answerColumn.itemAt(i).state = "goodAnswer";
         i++;
    }

    if(isAnswerGood) {
        items.score.currentSubLevel += 1;
        items.score.playWinAnimation();
        items.goodAnswerSound.play();
        items.client.sendToServer(true);
    } else {
        items.badAnswerSound.play();
        items.errorRectangle.startAnimation();
        items.client.sendToServer(false);
    }
}

function resetAnswerAreaColor() {
     for(var i = 0; i < items.numberOfItemType; i++ )
         items.answerColumn.itemAt(i).state = "default";
}

function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min);
}

function initSubLevel() {
    items.errorRectangle.resetState()
    cleanUp();
    itemNames = Core.shuffle(itemNames);
    items.okButtonBlocked = true;
    var enumItems = new Array();
    var types = new Array();
    for(var type = 0; type < items.numberOfItemType; type++) {
        var nbItems = getRandomInt(1, items.numberOfItemMax);
        for(var j = 0; j < nbItems; j++) {
            enumItems.push(itemNames[type]);
        }
        answerToFind[itemNames[type]] = nbItems;
        types.push(itemNames[type]);
    }
    items.answerColumn.model = types;
    items.itemListModel = enumItems;
    items.buttonsBlocked = false;
}

function nextSubLevel() {
    items.buttonsBlocked = true;
    if( items.score.currentSubLevel >= maxSubLevel) {
        items.okButtonBlocked = true;
        items.bonus.good("smiley");
    }
    else
        initSubLevel();
}

function enableOkButton() {
    for (var key in answerToFind) {
        if(typeof userAnswers[key] == 'undefined')
            return;
    }
    items.okButtonBlocked = false;
}

function selectItem(itemIndex) {
    items.answerColumn.currentIndex = itemIndex;
}

function appendText(text, currentItem) {
    var number = parseInt(text)
    if(isNaN(number))
        return

    currentItem.itemText = text;

    if(answersMode === 1) {
        currentItem.valid = setUserAnswer(currentItem.imgName, number);
        checkAnswersAuto();
    } else {
        setUserAnswer(currentItem.imgName, number);
        enableOkButton();
    }
}
