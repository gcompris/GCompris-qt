/* GCompris - lang.js
 *
 * Copyright (C) 2014 Siddhesh suthar<siddhesh.it@gmail.com>
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
var quizItems;
var baseUrl = "qrc:/gcompris/src/activities/lang/resource/";
var dataset = null;
var lessons
var wordList
var subLevelsLeft
var miniGame

function init(items_,quiz_) {
    items = items_
    quizItems = quiz_
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
    //    stopped shuffling for testing purposes.

    maxSubLevel = wordList.length;
    items.score.numberOfSubLevels = maxSubLevel;
    items.score.visible = true
    items.count = 0;
    miniGame = 1;
    items.categoryText.changeCategory(currentLesson.name);

    subLevelsLeft = [];
    for(var i in wordList){
        subLevelsLeft.push(i)   // This is available in all editors.
    }

    initSubLevel()
}

function initSubLevel() {
    // initialize sublevel

    items.goodWord = wordList[items.score.currentSubLevel]
    items.wordImage.changeSource("qrc:/gcompris/data/" + items.goodWord.image)
    items.wordText.changeText(items.goodWord.translatedTxt)
}

function nextLevel() {
    if(maxLevel <= ++currentLevel ) {
        currentLevel = 0
    }
    items.score.currentSubLevel = 0;
    items.imageFrame.visible = true
    items.quiz.displayed = false
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = maxLevel - 1
    }
    items.score.currentSubLevel = 0;
    items.imageFrame.visible = true
    items.quiz.displayed = false
    initLevel();
}

function nextSubLevel() {
    ++items.score.currentSubLevel;
    if(items.score.currentSubLevel == items.score.numberOfSubLevels){
        //        items.score.visible = false
        //        items.bonus.good("smiley");
        //here logic for starting quiz game
        items.imageFrame.visible = false
        items.quiz.displayed = true
        initQuiz()
    }
    else{
        initSubLevel();
    }
}

function prevSubLevel() {
    if(--items.score.currentSubLevel < 0) {
        //TO DO
        //should not allow beyond zero. what to do display an error message
        // not changing it for quickly passing through the main activity while testing.
        items.score.currentSubLevel = maxSubLevel - 1;
    }
    initSubLevel()
}


// Append to the queue of words for the sublevel the error
function badWordSelected(wordIndex) {
    if (subLevelsLeft[0] != wordIndex)
        subLevelsLeft.unshift(wordIndex);
}

function initQuiz(){

    subLevelsLeft = [];
    for(var i in wordList){
        subLevelsLeft.push(i)   // This is available in all editors.
    }

    items.score.currentSubLevel = 0
    quizItems.score.currentSubLevel = 0
    initSubLevelQuiz()


}

function initSubLevelQuiz(){

    if(quizItems.score.currentSubLevel < quizItems.score.numberOfSubLevels)
        quizItems.score.currentSubLevel = quizItems.score.currentSubLevel + 1;
    else
        quizItems.score.visible = false

    quizItems.goodWordIndex = subLevelsLeft.pop()
    quizItems.goodWord = wordList[quizItems.score.currentSubLevel]

    var selectedWords = []
    var selectedImages = []
    selectedWords.push(quizItems.goodWord.translatedTxt)
    selectedImages.push("qrc:/gcompris/data/"+ quizItems.goodWord.image)

    for (var i = 0; i < wordList.length; i++) {
        if(wordList[i].translatedTxt !== selectedWords[0]){
            selectedWords.push(wordList[i].translatedTxt)
            selectedImages.push("qrc:/gcompris/data/"+ wordList[i].image)
        }
        if(selectedWords.length > 4)
            break
    }

    // Push the result in the model
    quizItems.wordListModel.clear();

    var y = Math.random();
    shuffle(selectedWords,y);
    shuffle(selectedImages,y);

    for (var j = 0; j < selectedWords.length; j++) {
        quizItems.wordListModel.append({"word": selectedWords[j], "image": selectedImages[j]})
    }

    quizItems.wordImage.changeSource("qrc:/gcompris/data/" + quizItems.goodWord.image)

    if(miniGame==3){
        quizItems.wordImage.visible = false
        quizItems.imageFrame.visible = false
    }
}

function nextSubLevelQuiz(){
    ++quizItems.score.currentSubLevel
    if(subLevelsLeft.length === 0) {

        if(miniGame==3){
            items.imageFrame.visible = true
            items.quiz.displayed = false
            items.bonus.good("smiley")
        }
        else{
            ++miniGame;
            initQuiz()
        }

    } else {
        initSubLevelQuiz();
    }
}

//used from core, modified for shuffling the image and words in the same way
function shuffle(o,y) {
    for(var j, x, i = o.length; i;
        j = Math.floor(y * i), x = o[--i], o[i] = o[j], o[j] = x);
    return o;
}
