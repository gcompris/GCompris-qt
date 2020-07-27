/* GCompris - learn_digits.js
 *
 * Copyright (C) 2020 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
.pragma library
.import QtQuick 2.6 as Quick
.import GCompris 1.0 as GCompris
.import "qrc:/gcompris/src/core/core.js" as Core

var currentLevel = 0;
var numberOfLevel;
var items;
var questionsLeft;
var questionsArray;

function start(items_) {
    items = items_;
    numberOfLevel = items.levels.length;
    currentLevel = 0;
    initLevel();
}

function stop() {
    items.audioVoices.stop();
    items.audioVoices.clearQueue();
}

function initLevel() {
    items.circlesModel = 0
    items.question = 0
    items.answer = 0
    items.bar.level = currentLevel + 1;
    questionsArray = items.levels[currentLevel].questionsArray;
    questionsLeft = questionsArray.slice(0);
    console.log("questionsLeft is " + questionsLeft)
    items.circlesModel = items.levels[currentLevel].circlesModel;
    items.currentSubLevel = 0;
    items.nbSubLevel = questionsArray.length;
    initQuestion();
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel) {
        currentLevel = 0;
    }
    items.currentSubLevel = 0;
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1;
    }
    items.currentSubLevel = 0;
    initLevel();
}

function removeLastQuestion() {
     for(var i = 0; i < questionsLeft.length; i++) {
        if(questionsLeft[i] === items.question)
            questionsLeft.splice(i, 1);
     }
}

function initQuestion() {
    resetCircles();
    items.answer = 0;
    var questionIndex = Math.floor(Math.random() * Math.floor(questionsLeft.length - 1));
    console.log("questionIndex is " + questionIndex)
    items.question = questionsLeft[questionIndex];
    playLetter(items.question.toString());
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
