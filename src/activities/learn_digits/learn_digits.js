/* GCompris - learn_digits.js
 *
 * Copyright (C) 2018 YOUR NAME <xx@yy.org>
 *
 * Authors:
 *   <THE GTK VERSION AUTHOR> (GTK+ version)
 *   "YOUR NAME" <YOUR EMAIL> (Qt Quick port)
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

function start(items_) {
    items = items_;
    currentLevel = 0;
    loadDatasets();
    initLevel();
}

function stop() {
    items.audioVoices.stop();
    items.audioVoices.clearQueue();
}

function loadDatasets() {
    numberOfLevel = items.levels.length;
}

function initLevel() {
    items.circlesModel = 0
    items.questionsArray = []
    items.questionsLeft = []
    items.question = 0
    items.answer = 0
    items.bar.level = currentLevel + 1;
    items.circlesModel = items.levels[currentLevel].circlesModel;
    items.questionsArray = items.levels[currentLevel].questionsArray;
    items.questionsLeft = items.questionsArray;
    items.score.currentSubLevel = 0;
    items.score.numberOfSubLevels = items.questionsArray.length;
    initQuestion();
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel) {
        currentLevel = 0;
    }
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1;
    }
    initLevel();
}

function removeLastQuestion() {
     for(var i = 0; i < items.questionsLeft.length; i++) {
        if(items.questionsLeft[i] === items.question)
            items.questionsLeft.splice(i, 1);
     }
}

function initQuestion() {
    items.circlesLine.model = 0;
    items.circlesLine.model = items.circlesModel;
    items.answer = 0;
    var questionIndex = Math.floor(Math.random() * Math.floor(items.questionsLeft.length - 1));
    items.question = items.questionsLeft[questionIndex];
    playLetter(items.question.toString());
}

function checkAnswer() {
    items.inputLocked = true
    if(items.answer === items.question) {
        items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/win.wav");
        ++items.score.currentSubLevel;
        items.score.playWinAnimation();
        removeLastQuestion();
    } else {
        items.bonus.bad('flower');
    }
    if(items.score.currentSubLevel === items.score.numberOfSubLevels) {
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
