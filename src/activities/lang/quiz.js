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
var filteredWordList;
var subLevelsLeft
var currentSubLevel
var mode

function init(items_, loadedItems_, filteredWordList_, mode_) {

    items = items_
    quizItems = loadedItems_
    filteredWordList = filteredWordList_
    mode = mode_

    items.score.currentSubLevel = 0
    items.imageFrame.visible = false
    items.wordTextbg.visible = false
    items.categoryTextbg.visible = false

    if(mode==3) {
        quizItems.wordImage.visible = false
        quizItems.imageFrame.visible = false

        for (var j = 0; j < filteredWordList.length ; j++) {
            if(!quizItems.checkWordExistence (filteredWordList[j]) || items.repeatItem.visible == false) {
                filteredWordList.splice(j,1)
                j--;
            }
        }
        items.score.numberOfSubLevels = filteredWordList.length
    }
    else {
        quizItems.wordImage.visible = true
        quizItems.imageFrame.visible = true
    }

    subLevelsLeft = [];
    for(var i in filteredWordList) {
        subLevelsLeft.push(i)   // This is available in all editors.
    }

    Core.shuffle(subLevelsLeft)
    currentSubLevel =0

    if(subLevelsLeft.length === 0) {
        quizItems.bonus.good("smiley")
    } else {
        initSubLevelQuiz();
    }

}

function initSubLevelQuiz() {

    if(items.score.currentSubLevel < items.score.numberOfSubLevels)
        items.score.currentSubLevel = items.score.currentSubLevel + 1;
    else
        items.score.visible = false

    quizItems.goodWordIndex = subLevelsLeft.pop()
    quizItems.goodWord = filteredWordList[quizItems.goodWordIndex]

    var selectedWords = []
    selectedWords.push([quizItems.goodWord.translatedTxt,"qrc:/gcompris/data/"+ quizItems.goodWord.image])


    for (var i = 0; i < filteredWordList.length; i++) {
        if(filteredWordList[i].translatedTxt !== selectedWords[0][0]){
            selectedWords.push([filteredWordList[i].translatedTxt,"qrc:/gcompris/data/"+ filteredWordList[i].image])
        }
        if(selectedWords.length > 4)
            break
    }

    // Push the result in the model
    quizItems.wordListModel.clear();
    Core.shuffle(selectedWords);

    for (var j = 0; j < selectedWords.length; j++) {
        quizItems.wordListModel.append( {"word": selectedWords[j][0], "image": selectedWords[j][1]})
    }

    quizItems.wordImage.changeSource("qrc:/gcompris/data/" + quizItems.goodWord.image)
}

function nextSubLevelQuiz() {
    ++currentSubLevel
    if(subLevelsLeft.length === 0) {
        quizItems.bonus.good("smiley")
    } else {
        initSubLevelQuiz();
    }
}

// Append to the front of queue of words for the sublevel the error
function badWordSelected(wordIndex) {
    if (subLevelsLeft[0] != wordIndex)
        subLevelsLeft.unshift(wordIndex);
    items.score.currentSubLevel = items.score.currentSubLevel -1
}
