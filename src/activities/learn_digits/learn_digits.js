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
.import QtQuick 2.12 as Quick
.import GCompris 1.0 as GCompris
.import "qrc:/gcompris/src/core/core.js" as Core

var numberOfLevel;
var items;
var operationMode;
var questionsArray;
var answersArray;
var url = ""

function start(items_, operationMode_) {
    items = items_;
    operationMode = operationMode_;
    if(!operationMode && items.voicesEnabled)
        Core.checkForVoices(items_.activityPage);
    numberOfLevel = items.levels.length;
    items.currentLevel = Core.getInitialLevel(numberOfLevel);
    initLevel();
}

function stop() {
    items.audioVoices.stop();
    items.audioVoices.clearQueue();
}

function initLevel() {
    items.circlesModel = 0
    items.question = 0
    items.questionText = ""
    items.answer = 0
    questionsArray = items.levels[items.currentLevel].questionsArray.slice(0);
    if(operationMode) {
        answersArray = items.levels[items.currentLevel].answersArray.slice(0);
    }
    items.circlesModel = items.levels[items.currentLevel].circlesModel;
    items.currentSubLevel = 0;
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
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    items.currentSubLevel = 0;
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    items.currentSubLevel = 0;
    initLevel();
}

function removeLastQuestion() {
    if(operationMode) {
        for(var i = 0; i < questionsArray.length; i++) {
            if(questionsArray[i] === items.questionText) {
                questionsArray.splice(i, 1);
                answersArray.splice(i, 1);
                return;
            }
        }
    } else {
        for(var i = 0; i < questionsArray.length; i++) {
            if(questionsArray[i] === items.question) {
                questionsArray.splice(i, 1);
                return;
            }
        }
    }
}

function initQuestion() {
    resetCircles();
    items.answer = 0;
    var questionIndex = Math.floor(Math.random() * Math.floor(questionsArray.length - 1));
    if(operationMode) {
        items.question = answersArray[questionIndex];
        items.questionText = questionsArray[questionIndex];
    } else {
        items.question = questionsArray[questionIndex];
        items.questionText = items.question.toString()
        if(items.voicesEnabled)
            playLetter(items.questionText);
    }
    if(items.mode != 1) {
        items.imageSource = url + items.questionText + ".svg"
    }
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
        items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/win.wav");
        ++items.currentSubLevel;
        items.score.playWinAnimation();
        removeLastQuestion();
    } else {
        items.bonus.bad('flower');
    }
    if(items.currentSubLevel === items.nbSubLevel) {
        items.bonus.good('flower');
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
