/* GCompris - jumbled_words.js
 *
 * Copyright (C) 2016  Komal Parmaar <parmaark@gmail.com>
 *
 * Authors:
 *    Komal Parmaar <parmaark@gmail.com>
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

var url = "qrc:/gcompris/src/activities/jumbled_words/resource/"
var defaultLevelsFile = "qrc:/gcompris/src/activities/lang/resource/words.json";

var currentLevel
var maxLevel
var maxSubLevel
var currentSubLevel
var levels
var level
var items
var index
var answers
var jumble=[]

function start(items_) {

    items = items_
    loadLevels();
    currentLevel = 0
    currentSubLevel = 0
    maxLevel = levels.length
    initLevel()
}

function loadLevels()
{
    var filename = GCompris.ApplicationInfo.getLocaleFilePath(defaultLevelsFile); //To extend to more languages(future)
    levels = items.parser.parseFromUrl(filename);
    if (levels === null) {
        console.warn("Jumbled_words: Invalid levels file " + filename);
        levels = items.parser.parseFromUrl(defaultLevelsFile);
        if (levels === null) {
            console.error("Jumbled_words: Invalid default levels file "
                + defaultLevelsFile + ". Can't continue!");
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

function generateKeyboard(questions){
    var letters = new Array();
    items.keyboard.shiftKey = false;
    var a = questions.split("");
    var n = a.length;
    for(var i = n-1; i>=0; i--)
    {
     letters.push(a[i]);
    }
    // generate layout from letter map
    var layout = new Array();
    var row = 0;
    var offset = 0;
    while (offset < letters.length-1) {
        var cols = letters.length <= 10 ? letters.length : (Math.ceil((letters.length-offset) / (3 - row)));
        layout[row] = new Array();
        for (var j = 0; j < cols; j++)
            layout[row][j] = { label: letters[j+offset] };
        offset += j;
        row++;
    }
    items.keyboard.layout = layout;
}

function initLevel()
{
    items.bar.level = currentLevel + 1
    var questions
    items.hintimage.source=Qt.binding(function() { return ""});
    if (currentSubLevel === 0) {
        level = levels[currentLevel];
        maxSubLevel = level.content[0].content.length;
        jumble=[];
        for(var i=0;i<maxSubLevel ; i++)
        {
           jumble.push(i);
        }
        jumble=Core.shuffle(jumble);
        items.score.numberOfSubLevels = maxSubLevel;
        items.score.currentSubLevel = 1;
    }
    else {
        items.score.currentSubLevel = currentSubLevel + 1;
    }
    index=jumble[currentSubLevel];
    answers = level.content[0].content[index].description;
    do{
       questions = shuffleString(answers);
    }while(questions === answers);

    items.questionItem.text = questions;
    generateKeyboard(questions);
}

function nextLevel() {
    if(maxLevel <= ++currentLevel) {
        currentLevel = 0
    }
    currentSubLevel = 0;
    initLevel()
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = maxLevel - 1
    }
    currentSubLevel = 0;
    initLevel()
}

function nextSubLevel() {
    if(++currentSubLevel >= maxSubLevel) {
        currentSubLevel = 0
        nextLevel();
    }
    initLevel();
}

function checkAnswer()
{
    showHint()
    var userInput = items.edit.getText(0, items.edit.text.length)
    var value = userInput.trim() //to remove leading and trailing white spaces
    if (value === answers) {
        items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/win.wav")
        items.bonus.good("flower");
        return true
    } else {
        items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/lose.wav")
        items.bonus.bad("flower");
        return false
    }
}

function processkey(text)
{
}

function showHint()
{
    items.hintimage.source=level.imgPrefix+level.content[0].content[index].image;
}
