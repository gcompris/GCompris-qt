/* GCompris - spell_it.js
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
var items;
var spellItems;
var wordList;
var subLevelsLeft
var currentSubLevel
var miniGame

function initSpell(items_,wordList_){

    items = items_
    wordList = wordList_
    miniGame = 1

    items.spellIt.source = "Spell_it.qml"
    spellItems = items.spellIt.item
    console.log("new " + spellItems + " loaded")
    spellItems.answer.forceActiveFocus()

    initLevel()

}

function initLevel(){

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
    items.categoryTextbg.visible = false

    currentSubLevel =0
    spellItems.bar.visible = true
    spellItems.repeatItem.visible = true
    spellItems.score.currentSubLevel = 0
    spellItems.score.numberOfSubLevels = wordList.length
    spellItems.score.visible = true
    spellItems.displayed = true

    initSubLevel()
}

function initSubLevel(){

    if(spellItems.score.currentSubLevel < spellItems.score.numberOfSubLevels)
        spellItems.score.currentSubLevel = spellItems.score.currentSubLevel + 1;
    else
        spellItems.score.visible = false

    spellItems.goodWord = wordList[spellItems.score.currentSubLevel-1]
    spellItems.wordImage.changeSource("qrc:/gcompris/data/" + spellItems.goodWord.image)
    spellItems.hintText.changeHint(spellItems.goodWord.translatedTxt[0])
    spellItems.hintText.visible = true
    spellItems.answer.text = ""
}

function nextSubLevel(){
    if(spellItems.score.currentSubLevel == spellItems.score.numberOfSubLevels ) {
        //destroying previous loaded spellIt
        spellItems.bar.visible = false
        spellItems.repeatItem.visible = false
        spellItems.score.visible = false
        spellItems.displayed = false
        spellItems.bonus.good("smiley")
    } else {
        initSubLevel();
    }
}

function checkAnswer(answer_){
    if(spellItems.goodWord.translatedTxt == answer_){
        nextSubLevel()
    }
    else{
        badWordSelected(currentSubLevel-1,answer_)
    }
}

// Append to the front of queue of words for the sublevel the error
function badWordSelected(wordIndex,answer) {
    if (subLevelsLeft[0] != wordIndex)
        subLevelsLeft.unshift(wordIndex);

    spellItems.hintText.visible = true
    //showing hint
    var hint = ""
    var firstIncorrectIndex = 0

    for (var i=0 ; i< spellItems.goodWord.translatedTxt.length; i++) {

        var goodChar = spellItems.goodWord.translatedTxt[i]
        if( goodChar == answer[i]) {
            hint = hint + goodChar
        }
        else {
            if(firstIncorrectIndex == 0){
                hint = hint + goodChar
                firstIncorrectIndex = i
            }
            else{
                hint = hint + "."
            }
        }
    }

    spellItems.hintText.changeHint(hint)
}
