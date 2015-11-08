/* GCompris - explore.js
*
* Copyright (C) 2015 Djalil MESLI <djalilmesli@gmail.com>
*
* Authors:
*   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
*   Djalil MESLI <djalilmesli@gmail.com> (Qt Quick port)
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
*   along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

.pragma library
.import GCompris 1.0 as GCompris
.import "qrc:/gcompris/src/core/core.js" as Core

var numberOfLevel
var items
var dataset

var questionOrder

function start(items_,var_) {
    items = items_
    dataset = var_
    items.currentLevel = 0
    items.score.currentSubLevel = 0
    items.score.numberOfSubLevels = items.dataModel.count
    numberOfLevel = items.hasAudioQuestions ? 3 : 2;
    // create table of size N filled with numbers from 0 to N
    questionOrder = Array.apply(null, {length: items.dataModel.count}).map(Number.call, Number)

    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = items.currentLevel + 1
    // randomize the questions for level 2 and 3
    Core.shuffle(questionOrder);

    items.score.currentSubLevel = 0
    reload();
    changeOpacity();
    setQuestionText();
    setInstruction();
}

function nextLevel() {
    if (numberOfLevel <= ++items.currentLevel) {
        items.currentLevel = 0
    }
    initLevel();
    if (items.currentLevel == 1) {
        items.score.currentSubLevel --;
        nextSubLevel();
    }
}

function previousLevel() {
    if(--items.currentLevel < 0) {
        items.currentLevel = numberOfLevel - 1
    }
    initLevel();
}

function isComplete() {
    for(var i = 0 ; i < items.dataModel.count ; ++ i) {
        if(!items.dataModel.itemAt(i).starVisible)
            return false;
    }
    return true;
}

function nextSubLevel() {
    items.score.currentSubLevel ++;
    if(items.score.currentSubLevel == items.dataModel.count) {
        items.bonus.good("smiley");
        items.score.currentSubLevel = 0;
        nextLevel();
    }
    else if(items.currentLevel == 1 && items.hasAudioQuestions) {
        items.audioEffects.play(getCurrentQuestion().audio);
    }
    else if(items.currentLevel != 0) {
        setQuestionText();
    }
}

function reload() {
    for(var i = 0 ; i < items.dataModel.count ; ++ i) {
        items.dataModel.itemAt(i).starVisible = false;
    }
}

function repeat() {
    items.audioEffects.play(getCurrentQuestion().audio);
}

function changeOpacity() {
    if (items.currentLevel == 2 || (items.currentLevel == 1 && !items.hasAudioQuestions)) {
        items.question.opacity = 0.8;
        items.questionText.opacity = 1;
    }
    else {
        items.question.opacity = 0;
        items.questionText.opacity = 0;
    }
}

function getCurrentQuestion() {
    return dataset.tab[questionOrder[items.score.currentSubLevel]];
}

function setQuestionText() {
    items.questionText.text = getCurrentQuestion().text2;
}

function setInstruction() {
    items.instructionText.text = dataset.instruction[items.currentLevel].text
}
