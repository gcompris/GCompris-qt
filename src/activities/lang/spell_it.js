/* GCompris - lang.qml
*
* Copyright (C) Siddhesh suthar <siddhesh.it@gmail.com> (Qt Quick port)
*
* Authors:
*   Pascal Georges (pascal.georges1@free.fr) (GTK+ version)
*   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port of imageid)
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
var items;
var spellItems;
var spellWordList;
var subLevelsLeft
var currentSubLevel

function init(items_, loadedItems_, spellWordList_, mode_) {

    items = items_
    spellItems = loadedItems_
    spellWordList = spellWordList_

    console.log("new " + spellItems + " loaded")
    spellItems.answer.forceActiveFocus()

    initLevel()

}

function initLevel() {

    subLevelsLeft = [];
    for(var i in spellWordList) {
        subLevelsLeft.push(i)   // This is available in all editors.
    }

    Core.shuffle(subLevelsLeft)

    items.score.currentSubLevel = 0
    items.imageFrame.visible = false
    items.wordTextbg.visible = false
    items.categoryTextbg.visible = false

    currentSubLevel =0

    /* populate VirtualKeyboard for mobile:
             * 1. for < 10 letters print them all in the same row
             * 2. for > 10 letters create 3 rows with equal amount of keys per row
             *    if possible, otherwise more keys in the upper rows
             */
    // first generate a map of needed letters
    var letters = [];
    for (var i = 0; i < spellWordList.length; i++) {
        var currentWord = spellWordList[i].translatedTxt;
        for (var j = 0; j < currentWord.length; j++) {
            var letter = currentWord.charAt(j);

            if(letters.indexOf(letter) === -1)
                letters.push(currentWord.charAt(j));
        }
    }
    letters.sort();
    // generate layout from letter map
    var layout = [];
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
    layout[row-1].push({ label: items.keyboard.backspace });
    items.keyboard.layout = [];
    items.keyboard.layout = layout;
    items.keyboard.visibleFlag = true;

    initSubLevel()
}

function initSubLevel() {

    if(items.score.currentSubLevel < items.score.numberOfSubLevels)
        items.score.currentSubLevel = items.score.currentSubLevel + 1;
    else
        items.score.visible = false

    spellItems.goodWord = spellWordList[items.score.currentSubLevel-1]
    spellItems.wordImage.changeSource("qrc:/gcompris/data/" + spellItems.goodWord.image)
    spellItems.hintText.changeHint(spellItems.goodWord.translatedTxt[0])
    spellItems.hintText.visible = true
    spellItems.answer.text = ""
    spellItems.maximumLengthAnswer = spellItems.goodWord.translatedTxt.length + 1
}

function nextSubLevel() {
    if(items.score.currentSubLevel == items.score.numberOfSubLevels ) {
        spellItems.displayed = false
        spellItems.bonus.good("smiley")
    } else {
        initSubLevel();
    }
}

function checkAnswer(answer_) {
    if(spellItems.goodWord.translatedTxt == answer_) {
        nextSubLevel()
        return true
    }
    else {
        badWordSelected(currentSubLevel-1,answer_)
    }
}

// Append to the front of queue of words for the sublevel the error
function badWordSelected(wordIndex,answer) {
    if (subLevelsLeft[0] != wordIndex)
        subLevelsLeft.unshift(wordIndex);

    provideHint(answer)
}

//function to construct hint based on the answer entered by user
function provideHint(answer_) {
    var answer = answer_
    var hint = ""
    var firstIncorrectIndex = 0

    for (var i=0 ; i< spellItems.goodWord.translatedTxt.length; i++) {

        var goodChar = spellItems.goodWord.translatedTxt[i]

        //skipping hint if the suggestion is a space
        if( goodChar == " ") {
            hint = hint + " "
            continue
        }

        if( answer[i] == goodChar) {
            hint = hint + goodChar
        }
        else {
            if(firstIncorrectIndex == 0) {
                hint = hint + goodChar
                firstIncorrectIndex = i
            }
            else {
                hint = hint + "."
            }
        }

    }

    spellItems.hintText.changeHint(hint)
    spellItems.hintText.visible = true

}

// to handle virtual key board key press events
function processKeyPress(text_){
    var answer = spellItems.answer
    var text  = text_
    if ( text == items.keyboard.backspace) {
        backspace(answer)
        return
    }
    answer.insert(answer.length,text)
}

function backspace(answer) {
    answer.text = answer.text.slice(0, -1)
    if(answer.text.length === 0) {
        answer.text = ""
    } else {
        checkAnswer(answer.text)
    }
}
