/* GCompris - jumbled_words.js
 *
 * Copyright (C) 2016  Komal Parmaar <parmaark@gmail.com>
 *
 * Authors:
 *   <THE GTK VERSION AUTHOR> (GTK+ version)
 *    Komal Parmaar <parmaark@gmail.com> (Qt Quick port)
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

var url = "qrc:/gcompris/src/activities/jumbled_words/resource/"
var defaultLevelsFile = ":/gcompris/src/activities/jumbled_words/resource/levels-en.json";

var currentLevel
var maxLevel
var maxSubLevel
var currentSubLevel
var items
var levels;
var level;
var questions;
var answers;
var items;
var generate;

function start(items_) {
    items = items_
    loadLevels();
    currentLevel = 0;
    currentSubLevel = 0;
    maxLevel = levels.length;
    initLevel()
}

function loadLevels()
{
    var filename = GCompris.ApplicationInfo.getLocaleFilePath(url + "levels-$LOCALE.json");
    levels = items.parser.parseFromUrl(filename);
    if (levels == null) {
        console.warn("Jumbled_words: Invalid levels file " + filename);
        // fallback to default Latin (levels-en.json) file:
        levels = items.parser.parseFromUrl(defaultLevelsFile);
        if (levels == null) {
            console.error("Jumbled_words: Invalid default levels file "
                + defaultLevelsFile + ". Can't continue!");
            // any way to error-exit here?
            return;
        }
    }
}


function stop() {
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
    items.bar.level = currentLevel + 1
    items.hint.text = "hint";

    if (currentSubLevel == 0) {
            level = levels[currentLevel];
            maxSubLevel = level.questions.length;
            items.score.numberOfSubLevels = maxSubLevel;
            items.score.currentSubLevel = "1";
            answers = level.questions[Math.floor(Math.random()*maxSubLevel)];
            var copy = answers;
        var demo = shuffleString(answers);
        if(demo == answers)
        {
            demo = shuffleString(answers);
        }
        else
            questions = demo;
    } else {
        generate = level.questions[Math.floor((Math.random()*maxSubLevel))];
        while(copy==generate)
        {
            generate = level.questions[Math.floor((Math.random()*maxSubLevel))];
        }
        copy=generate;
        answers=generate;
         demo = shuffleString(answers);
        if(demo == answers)
        {
            demo = shuffleString(answers);
        }
        else
            questions = demo;
        items.score.currentSubLevel = currentSubLevel + 1;
        }
    items.questionItem.visible = true
    items.questionItem.text = questions;

}

function validateLevels(levels)
{
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
    return true;
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

function checkAnswer()
{
    var modelEntry = items.edit.getText(0, items.edit.text.length)
    var value = modelEntry.replace(/\s\s*$/, '') //to remove leading white spaces
    value = modelEntry.replace(/^\s\s*/, '') //to remove trailing white spaces
    if (value === answers) {
        items.bonus.good("flower");
        items.edit.text = "";
        items.hint.text = "hint";
        return true
    } else {
        return false
    }
}

function showHint()
{
    items.hint.text=level.category;
}
