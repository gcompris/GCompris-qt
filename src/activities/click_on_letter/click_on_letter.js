/* GCompris - click_on_letter.js
 *
 * Copyright (C) 2014 Holger Kaelberer 
 * 
 * Authors:
 *   Pascal Georges <pascal.georges1@free.fr> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ Mostly full rewrite)
 *   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port)
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
.import QtQuick 2.0 as Quick
.import GCompris 1.0 as GCompris //for ApplicationInfo
.import "qrc:/gcompris/src/core/core.js" as Core

var url = "qrc:/gcompris/src/activities/click_on_letter/resource/"
var defaultLevelsFile = ":/gcompris/src/activities/click_on_letter/resource/levels-en.json";
var maxLettersPerLine = 6;

var levels;
var currentLevel;
var maxLevel;
var currentSubLevel;
var currentLetter;
var maxSubLevel;
var level;
var questions;
var answers;
var items;
var mode;

function start(_items, _mode)
{
    items = _items;
    mode = _mode;

    loadLevels();
    currentLevel = 0;
    currentSubLevel = 0;
    maxLevel = levels.length;
    initLevel();
}

function parseLevels(json)
{
    try {
        levels = JSON.parse(json);
        // minimal syntax check:
        var i;
        for (i = 0; i < levels.length; i++) {
            if (undefined === levels[i].questions
                || typeof levels[i].questions != "string"
                || levels[i].questions.length < 1
                || typeof levels[i].answers != "string"
                || levels[i].answers.length < 1)
                return false;
        }
        if (i < 1)
            return false;
    } catch(e) {
        console.error("Click_on_letter: Error parsing JSON: " + e)
        return false;
    }
    return true;
}

function loadLevels()
{
    var ret;    
    var json = items.levelsFile.read(
                GCompris.ApplicationInfo.getLocaleFilePath(url +
                                                           "levels-$LOCALE.json"))
    if (json == "" || !parseLevels(json)) {
        console.warn("Click_on_letter: Invalid levels file " +
                items.levelsFile.name);
        // fallback to default Latin (levels-en.json) file:
        json = items.levelsFile.read(defaultLevelsFile);
        if (json == "" || !parseLevels(json)) {
            console.error("Click_on_letter: Invalid default levels file "
                + items.levelsFile.name + ". Can't continue!");
            // any way to error-exit here?
            return;
        }
    }
    // at this point we have valid levels
    for (var i = 0; i < levels.length; i++) {
        if (mode === "lowercase") {
            levels[i].questions = levels[i].questions.toLocaleLowerCase();
            levels[i].answers = levels[i].answers.toLocaleLowerCase();
        } else {
            levels[i].questions = levels[i].questions.toLocaleUpperCase();
            levels[i].answers = levels[i].answers.toLocaleUpperCase();        
        }
    }
}

function stop()
{
}

function shuffleString(s)
{
    var a = s.split("");
    var n = a.length;

    for(var i = n-1; i>0; i--) {
        var j = Math.floor(Math.random() * (i + 1));
        var tmp = a[i];
        a[i] = a[j];
        a[j] = tmp;
    }
    return a.join("");
}

function initLevel() {
    items.bar.level = currentLevel + 1;
    if (currentSubLevel == 0) {
        level = levels[currentLevel];
        maxSubLevel = level.questions.length;
        items.score.numberOfSubLevels = maxSubLevel;
        items.score.currentSubLevel = "1";
        questions = shuffleString(level.questions);
        answers = shuffleString(level.answers);

        var answerArr = answers.split("");
        items.trainModel.clear();
        for (var i = 0; i < answerArr.length; i++) {                
            items.trainModel.append({
                "letter": answerArr[i],
            });
        }
    } else {
        items.score.currentSubLevel = currentSubLevel + 1;
    }

    currentLetter = questions.split("")[currentSubLevel];
    if (GCompris.ApplicationSettings.isAudioEnabled) {
        items.nextLevelAudio.stop();
        items.nextLevelAudio.play();
        items.questionItem.visible = false;
        items.letterAudio.source = GCompris.ApplicationInfo.getAudioFilePath("voices/$LOCALE/alphabet/"
                + Core.getSoundFilenamForChar(currentLetter));
        items.letterAudio.playDelayed(1500);
    } else {
        // no sound -> show question
        items.questionItem.visible = true;
    }
    // Maybe we will display it if sound fails
    items.questionItem.text = currentLetter;
}

function nextLevel() {
    if(maxLevel <= ++currentLevel ) {
        currentLevel = 0
    }
    currentSubLevel = 0;
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = maxLevel - 1
    }
    currentSubLevel = 0;
    initLevel();
}

function nextSubLevel() {
    if( ++currentSubLevel >= maxSubLevel) {
        currentSubLevel = 0
        nextLevel()
    }
    initLevel();
}

function checkAnswer(index)
{
    var modelEntry = items.trainModel.get(index);
    if (modelEntry.letter == currentLetter) {
        items.bonus.good("flower");
        return true
    } else {
        return false
    }
}
