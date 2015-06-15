/* GCompris - quiz.js
 *
 * Copyright (C) 2014 Holger Kaelberer <holger.k@elberer.de> (Qt Quick port of imageid)
 *
 *
 * Authors:
 *   Pascal Georges (pascal.georges1@free.fr) (GTK+ version)
 *   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port of imageid)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Integration Lang dataset)
 *   Siddhesh suthar <siddhesh.it@gmail.com> (Qt Quick port of lang)
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
.import GCompris 1.0 as GCompris
.import "qrc:/gcompris/src/core/core.js" as Core
.import "qrc:/gcompris/src/activities/lang/lang_api.js" as Lang
.import "qrc:/gcompris/src/activities/lang/spell_it.js" as SpellActivity

var items;
var quizItems;
var wordList;
var subLevelsLeft
var currentSubLevel
var miniGame

function initQuiz(items_,wordList_){

    items = items_
    wordList = wordList_
    miniGame = 1

    items.quiz.source = "Quiz.qml"
    quizItems = items.quiz.item
    console.log(quizItems + "loaded")

    initQuizMiniGame()

}

function initQuizMiniGame(){

    subLevelsLeft = [];
    for(var i in wordList){
        subLevelsLeft.push(i)   // This is available in all editors.
    }

    Core.shuffle(subLevelsLeft)

    items.score.currentSubLevel = 0
    items.score.visible = false
    items.bar.visible = false
    items.repeatItem.visible = false
    items.imageFrame.visible = false
    items.wordTextbg.visible = false

    if(miniGame==3){
        quizItems.wordImage.visible = false
        quizItems.imageFrame.visible = false
    }
    else {
        quizItems.wordImage.visible = true
        quizItems.imageFrame.visible = true
    }

    currentSubLevel =0
    quizItems.bar.visible = true
    quizItems.repeatItem.visible = true
    quizItems.score.currentSubLevel = 0
    quizItems.score.numberOfSubLevels = wordList.length
    quizItems.score.visible = true

    initSubLevelQuiz()
}

function initSubLevelQuiz(){

    if(quizItems.score.currentSubLevel < quizItems.score.numberOfSubLevels)
        quizItems.score.currentSubLevel = quizItems.score.currentSubLevel + 1;
    else
        quizItems.score.visible = false

    quizItems.goodWordIndex = subLevelsLeft.pop()
    quizItems.goodWord = wordList[quizItems.goodWordIndex]

    var selectedWords = []
    selectedWords.push([quizItems.goodWord.translatedTxt,"qrc:/gcompris/data/"+ quizItems.goodWord.image])


    for (var i = 0; i < wordList.length; i++) {
        if(wordList[i].translatedTxt !== selectedWords[0][0]){
            selectedWords.push([wordList[i].translatedTxt,"qrc:/gcompris/data/"+ wordList[i].image])
        }
        if(selectedWords.length > 4)
            break
    }

    // Push the result in the model
    quizItems.wordListModel.clear();
    Core.shuffle(selectedWords);

    for (var j = 0; j < selectedWords.length; j++) {
        quizItems.wordListModel.append({"word": selectedWords[j][0], "image": selectedWords[j][1]})
    }

    quizItems.wordImage.changeSource("qrc:/gcompris/data/" + quizItems.goodWord.image)

}

function nextSubLevelQuiz(){
    ++currentSubLevel
    if(subLevelsLeft.length === 0) {
        if(miniGame==3){
            items.imageFrame.visible = true
            quizItems.displayed = false

            //destroying previous loaded quiz
            items.quiz.source = ""
            miniGame = 1
            quizItems.bonus.good("flower")
            SpellActivity.initSpell(items,wordList);
//            these things to be put in spell activity's bonus function
//            items.bonus.good("smiley")
        }
        else{
            ++miniGame;
            quizItems.bonus.good("flower")
        }
    } else {
        initSubLevelQuiz();
    }
}

// Append to the front of queue of words for the sublevel the error
function badWordSelected(wordIndex) {
    if (subLevelsLeft[0] != wordIndex)
        subLevelsLeft.unshift(wordIndex);
    quizItems.score.currentSubLevel = quizItems.score.currentSubLevel -1
}
