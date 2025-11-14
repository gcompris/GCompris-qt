/* GCompris - learn_digits.js
 *
 * SPDX-FileCopyrightText: 2020 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick as Quick
.import core 1.0 as GCompris
.import "qrc:/gcompris/src/core/core.js" as Core

var numberOfLevel;
var items;
var operationMode;
var questionsArray;
var currentQuestionIndex = -1;
var randomOrder = true;
var url = ""

function start(items_, operationMode_) {
    items = items_;
    operationMode = operationMode_;
    if(!operationMode && items.voicesEnabled)
        Core.checkForVoices(items_.activityPage);
    numberOfLevel = items.levels.length;
    items.currentLevel = Core.getInitialLevel(numberOfLevel);
}

function stop() {
    items.audioVoices.stop();
    items.audioVoices.clearQueue();
}

function initLevel() {
    items.errorRectangle.resetState();
    items.circlesModel = 0
    items.question = 0
    items.questionText = ""
    items.answer = 0
    currentQuestionIndex = -1;
    randomOrder = items.levels[items.currentLevel].randomOrder;
    questionsArray = items.levels[items.currentLevel].questionsArray.slice(0);
    items.circlesModel = items.levels[items.currentLevel].circlesModel;
    items.score.currentSubLevel = 0;
    items.nbSubLevel = questionsArray.length;
    if(items.mode === 2)
        url = "qrc:/gcompris/src/activities/learn_digits/resource/dots-";
    else if(items.mode === 3)
        url = "qrc:/gcompris/src/activities/learn_digits/resource/hands-";
    else
        url = "";
    if(!items.iAmReady.visible)
        initQuestion();
    if(items.selectedCircle >= 0)
        items.selectedCircle = 0;
}

function nextLevel() {
    items.score.stopWinAnimation();
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    items.score.currentSubLevel = 0;
    initLevel();
}

function previousLevel() {
    items.score.stopWinAnimation();
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    items.score.currentSubLevel = 0;
    initLevel();
}

function removeLastQuestion() {
    questionsArray.splice(currentQuestionIndex, 1);
}

function initQuestion() {
    resetCircles();
    items.answer = 0;
    if(randomOrder) {
        currentQuestionIndex = Math.round(Math.random() * (questionsArray.length - 1));
    } else {
        currentQuestionIndex = 0;
    }
    if(operationMode) {
        items.question = eval?.(`"use strict";(${questionsArray[currentQuestionIndex]})`);
        items.questionText = questionsArray[currentQuestionIndex];
    } else {
        items.question = parseInt(questionsArray[currentQuestionIndex]);
        items.questionText = items.question;
        if(items.voicesEnabled)
            playLetter(items.questionText);
    }
    if(items.mode != 1) {
        items.imageSource = url + items.questionText + ".svg"
    }
    items.inputLocked = false;
    items.client.startTiming()      // for server version
}

function resetCircles() {
    for(var i = 0; i < items.circlesLine.count; i++) {
        if(items.circlesLine.itemAt(i) != undefined)
            items.circlesLine.itemAt(i).resetCircle();
    }
}

function checkAnswer() {
    items.inputLocked = true
    if(items.answer === items.question) {
        items.client.sendToServer(true)
        ++items.score.currentSubLevel;
        items.score.playWinAnimation();
        items.goodAnswerSound.play();
        removeLastQuestion();
    } else {
        items.client.sendToServer(false)
        items.errorRectangle.startAnimation();
        items.badAnswerSound.play();
    }
}

function nextSubLevel() {
    if(items.score.currentSubLevel >= items.nbSubLevel) {
        items.bonus.good('flower');
    } else {
        initQuestion();
    }
}

function playLetter(letter) {
    var locale = GCompris.ApplicationInfo.getVoicesLocale(items.locale);
    var voiceFile = GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/"+locale+"/alphabet/"
                                                                       + Core.getSoundFilenamForChar(letter))
    stopVoice();
    if(items.fileId.exists(voiceFile)) {
        items.audioVoices.append(voiceFile);
    }
}

function stopVoice() {
    items.audioVoices.stop();
    items.audioVoices.clearQueue();
}

function processKey(event) {
    if(items.inputLocked)
        return;
    if(items.iAmReady.visible) {
        items.iAmReady.clicked();
        return;
    }
    if(event.key === Qt.Key_Right || event.key === Qt.Key_Down) {
        if(items.selectedCircle < items.circlesModel - 1 )
            ++items.selectedCircle;
        else
            items.selectedCircle = 0;
    } else if(event.key === Qt.Key_Left || event.key === Qt.Key_Up) {
        if(items.selectedCircle > 0)
            --items.selectedCircle;
        else
            items.selectedCircle = items.circlesModel - 1;
    } else if(event.key === Qt.Key_Space) {
        if(items.selectedCircle >= 0)
            items.circlesLine.itemAt(items.selectedCircle).clickCircle();
    } else if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
        checkAnswer();
    } else if(event.key === Qt.Key_Tab && !operationMode && items.voicesEnabled) {
        playLetter(items.question.toString());
    }
}
