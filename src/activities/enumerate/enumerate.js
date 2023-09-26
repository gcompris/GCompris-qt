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
.import QtQuick 2.12 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var url = "qrc:/gcompris/src/activities/enumerate/resource/";
var url2 = "qrc:/gcompris/src/activities/algorithm/resource/";
var items;
var maxSubLevel;
var dataset;
var currentSubLevel;
var numberOfLevel;
var numberOfItemType;
var numberOfItemMax;
var itemIcons = [
            url2 + "apple.svg",
            url2 + "banana.svg",
            url2 + "cherries.svg",
            url + "grapes.svg",
            url2 + "lemon.svg",
            url2 + "orange.svg",
            url + "peach.svg",
            url2 + "pear.svg",
            url2 + "plum.svg",
            url + "strawberry.svg",
            url + "watermelon.svg",
        ];
var numberOfTypes = itemIcons.length;
var userAnswers = new Array();
var answerToFind = new Array();
var answersMode;
var lockKeyboard = true;


// We keep a globalZ across all items. It is increased on each
// item selection to put it on top
var globalZ = 0;

function start(items_) {
    items = items_;
    answersMode = items.mode;
    dataset = items.levels;
    numberOfLevel = dataset.length;
    items.currentLevel = Core.getInitialLevel(numberOfLevel);
    initLevel();
}

function stop() {
    cleanUp();
}

function initLevel() {
    if(items.levels) {
        items.instructionText = items.levels[items.currentLevel].objective;
        items.instruction.opacity = 0.8;
    }
    currentSubLevel = 0;
    numberOfItemType = dataset[items.currentLevel].numberOfItemType;
    numberOfItemMax = dataset[items.currentLevel].numberOfItemMax;
    maxSubLevel = dataset[items.currentLevel].sublevels;
    items.score.numberOfSubLevels = maxSubLevel;
    initSubLevel();
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function cleanUp() {
    userAnswers = new Array();
    answerToFind = new Array();
    items.answerColumn.model = null;
    items.itemListModel = null;
}

function setUserAnswer(imgPath, userValue) {
    userAnswers[imgPath] = userValue;
    if (answersMode === 1) {
        return userAnswers[imgPath] === answerToFind[imgPath];
    }
}

function checkAnswersAuto() {
    for (var key in answerToFind) {
        if(userAnswers[key] !== answerToFind[key]) {
            return;
        }
    }
    nextSubLevel();
}

function checkAnswers() {
    items.okButton.enabled = false;
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
        playAudio();
        nextSubLevel();
    }
    else
        items.bonus.bad("smiley");
}

function resetAnswerAreaColor() {
     for(var i = 0; i < numberOfItemType; i++ )
         items.answerColumn.itemAt(i).state = "default";
}

function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min);
}

var currentAnswerItem;

function registerAnswerItem(item) {
    currentAnswerItem = item;
    item.forceActiveFocus();
}

function initSubLevel() {
    cleanUp();
    itemIcons = Core.shuffle(itemIcons);
    items.score.currentSubLevel = currentSubLevel + 1;
    items.okButton.enabled = false;
    var enumItems = new Array();
    var types = new Array();
    for(var type = 0; type < numberOfItemType; type++) {
        var nbItems = getRandomInt(1, numberOfItemMax);
        for(var j = 0; j < nbItems; j++) {
            enumItems.push(itemIcons[type]);
        }
        answerToFind[itemIcons[type]] = nbItems;
        types.push(itemIcons[type]);
    }
    items.answerColumn.model = types;
    items.itemListModel = enumItems;
    lockKeyboard = false;
}

function nextSubLevel() {
    lockKeyboard = true;
    if( ++currentSubLevel >= maxSubLevel) {
        items.okButton.enabled = false;
        items.bonus.good("smiley");
        currentSubLevel = 0;
    }
    else
        items.score.playWinAnimation();
}

function enableOkButton() {
    for (var key in answerToFind) {
        if(typeof userAnswers[key] == 'undefined')
            return;
    }
    items.okButton.enabled = true;
}

function playAudio() {
    items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/win.wav");
}

function focusAnswerInput() {
    if(items && items.answerColumn) {
        registerAnswerItem(items.answerColumn.itemAt(items.answerColumn.currentIndex));
    }
}
