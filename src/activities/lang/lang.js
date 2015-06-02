/* GCompris - lang.js
 *
 * Copyright (C) 2014 <Siddhesh suthar>
 *
 * Authors:
 *   Pascal Georges (pascal.georges1@free.fr) (GTK+ version)
 *   Siddhesh suthar <siddhesh.it@gmail.com> (Qt Quick port)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Integration Lang dataset)
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
 */.pragma library
.import QtQuick 2.0 as Quick
.import GCompris 1.0 as GCompris
.import "qrc:/gcompris/src/core/core.js" as Core
.import "qrc:/gcompris/src/activities/lang/lang_api.js" as Lang

var currentLevel = 0;
var currentSubLevel = 0;
var level = null;
var maxLevel;
var maxSubLevel;
var items;
var baseUrl = "qrc:/gcompris/src/activities/lang/resource/";
var dataset = null;
var lessons
var wordList
var subLevelsLeft
var backFlag
var flag

function init(items_) {
    items = items_
    maxLevel = 0
    maxSubLevel = 0
    currentLevel = 0
    currentSubLevel = 0
}

function start() {
    currentLevel = 0;
    currentSubLevel = 0;

    dataset = Lang.load(items.parser, baseUrl, "words.json", "content-$LOCALE.json")
    if(!dataset) {
        // English fallback
        items.background.englishFallback = true
        dataset = Lang.load(items.parser, baseUrl, "words.json", "content-en.json")
    } else {
        items.background.englishFallback = false
    }

    lessons = Lang.getAllLessons(dataset)
    maxLevel = lessons.length

    initLevel();

}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1;

    var currentLesson = lessons[currentLevel]
    wordList = Lang.getLessonWords(dataset, currentLesson);
//    Core.shuffle(wordList);

    backFlag = 0
    flag =0
    maxSubLevel = wordList.length;
    items.score.numberOfSubLevels = maxSubLevel;
    items.score.visible = true
    console.log(currentLesson.name)
    items.categoryText.changeCategory(currentLesson.name);

    subLevelsLeft = [];
    for(var i in wordList){
        subLevelsLeft.push(i)   // This is available in all editors.
     }

    initSubLevel()
}

function initSubLevel() {
    // initialize sublevel
    items.score.currentSubLevel = currentSubLevel + 1;

    if(flag === maxSubLevel || flag === -maxSubLevel){
        items.bonus.good("smiley");
    }

    else{
        if(backFlag === 1 ){
            items.goodWordIndex = subLevelsLeft.shift()
            subLevelsLeft.push(items.goodWordIndex)

        }
        if(backFlag === 0) {
            items.goodWordIndex = subLevelsLeft.pop()
            subLevelsLeft.unshift(items.goodWordIndex)
        }

        items.goodWord = wordList[items.goodWordIndex]
        items.wordImage.changeSource("qrc:/" + items.goodWord.image)
        items.wordText.changeText(items.goodWord.translatedTxt)
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
    flag++;
    if(maxSubLevel <= ++currentSubLevel ) {
        currentSubLevel = 0
    }
    if(backFlag === 1){
       subLevelsLeft.pop()
       subLevelsLeft.unshift(items.goodWordIndex)
    }
    backFlag = 0
    initSubLevel();

}

function prevSubLevel() {
    flag--;
    if(--currentSubLevel < 0) {
        currentSubLevel = maxSubLevel - 1
    }
    if(backFlag === 0){
       subLevelsLeft.shift()
       subLevelsLeft.push(items.goodWordIndex)
    }
    backFlag =1
    initSubLevel()
}


// Append to the queue of words for the sublevel the error
function badWordSelected(wordIndex) {
    if (subLevelsLeft[0] != wordIndex)
        subLevelsLeft.unshift(wordIndex);
}
