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

var defaultLevelsFile = ":/gcompris/src/activities/click_on_letter/resource/levels-en.json";
var maxLettersPerLine = 6;

var levels;
var levelsFile;
var currentLevel;
var maxLevel;
var currentSubLevel;
var currentLetter;
var maxSubLevel;
var bar;
var bonus;
var trainModel;
var questionItem;
var score;
var nextLevelAudio;
var letterAudio;
var level;
var questions;
var answers;
var mode;

function start(_bar, _bonus, _trainModel, _nextLevelAudio, _letterAudio,
        _questionItem, _score, _levelsFile, _mode)
{
    bar = _bar;
    bonus = _bonus;
    nextLevelAudio = _nextLevelAudio;
    letterAudio = _letterAudio;
    trainModel = _trainModel;
    questionItem = _questionItem;
    score = _score;
    levelsFile = _levelsFile
    mode = _mode

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
    var json = levelsFile.read(GCompris.ApplicationInfo.getAudioFilePath("click_on_letter/levels-$LOCALE.json")); // FIXME: this should be something like ApplicationInfo.getDataPath() + "click_on_letter" + "levels-" + ApplicationInfo.getCurrentLocale() + ".json" once it is there.
    if (json == "" || !parseLevels(json)) {
        console.warn("Click_on_letter: Invalid levels file " + levelsFile.name);
        // fallback to default Latin (levels-en.json) file:
        json = levelsFile.read(defaultLevelsFile);
        if (json == "" || !parseLevels(json)) {
            console.error("Click_on_letter: Invalid default levels file "
                + levelsFile.name + ". Can't continue!");
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
    bar.level = currentLevel + 1;
    if (currentSubLevel == 0) {
        level = levels[currentLevel];
        maxSubLevel = level.questions.length;
        score.numberOfSubLevels = maxSubLevel;
        score.currentSubLevel = "1";
        questions = shuffleString(level.questions);
        answers = shuffleString(level.answers);

        var answerArr = answers.split("");
        trainModel.clear();
        for (var i = 0; i < answerArr.length; i++) {                
            trainModel.append({
                "image": i < maxLettersPerLine ? 
                        "qrc:/gcompris/src/activities/click_on_letter/resource/carriage-off.png":
                        "qrc:/gcompris/src/activities/click_on_letter/resource/cloud-off.png",
                "letter": answerArr[i],
                "type": i < maxLettersPerLine ? "carriage" : "cloud"
            });
        }
    } else {
        // reset all images:
        for (var i = 0; i < trainModel.count; i++) {
            trainModel.setProperty(i, "image", i < maxLettersPerLine ? 
                "qrc:/gcompris/src/activities/click_on_letter/resource/carriage-off.png":
                "qrc:/gcompris/src/activities/click_on_letter/resource/cloud-off.png");
        }
        score.currentSubLevel = currentSubLevel + 1;
    }

    currentLetter = questions.split("")[currentSubLevel];
    if (getSetting("fx")) {
        nextLevelAudio.stop();
        nextLevelAudio.play();
        letterAudio.source = "resource/voices/" + GCompris.ApplicationInfo.locale +  // FIXME: adjust to voices path
            "/alphabet/" + getSoundFilenamForChar(currentLetter);
        letterAudio.playDelayed(1500);
    } //else 
    if (!getSetting("fx") || GCompris.ApplicationInfo.isMobile) {  // FIXME once we have voices on mobile 
        // no sound -> show question
        questionItem.visible = true;
        questionItem.text = currentLetter;
    }
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
    var modelEntry = trainModel.get(index);
    if (modelEntry.letter == currentLetter)
        bonus.good("flower");
    else {
        bonus.bad("flower");
        modelEntry.image = index < maxLettersPerLine ? 
            "qrc:/gcompris/src/activities/click_on_letter/resource/carriage-on.png" :
            "qrc:/gcompris/src/activities/click_on_letter/resource/cloud-on.png";
    }
}


//the following are probably candidates for refactoring out to core/

// from soundutil.c
/** return a string representing of a letter or a number audio file
 *  get alphabet sound file name
 *
 * the returned sound has the suffix .ogg
 *
 * \return a newly allocated string of the form U0033.ogg
 */
function getSoundFilenamForChar(c)
{
    var result = "U";
    var codeHex = c.toLowerCase().charCodeAt(0).toString(16).toUpperCase();
    while (codeHex.length < 4) {
        codeHex = "0" + codeHex;
    }
    result += codeHex + ".ogg";
    return result;
}

/** Return settings value for passed key
 * 
 * @return: settings value for valid key, null for invalid key */
function getSetting(key)
{
    if (key == "fx")
        return false;
    else
        return null;
}
