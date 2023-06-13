/* GCompris - spell_it.js
*
* Copyright (C) Siddhesh suthar <siddhesh.it@gmail.com> (Qt Quick port)
*
* Authors:
*   Pascal Georges (pascal.georges1@free.fr) (GTK+ version)
*   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port of imageid)
*   Siddhesh suthar <siddhesh.it@gmail.com> (Qt Quick port)
*   Bruno Coudoin <bruno.coudoin@gcompris.net> (Integration Lang dataset)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
.pragma library
.import QtQuick 2.12 as Quick
.import GCompris 1.0 as GCompris
.import "qrc:/gcompris/src/core/core.js" as Core
.import "qrc:/gcompris/src/activities/lang/lang_api.js" as Lang

var spellItems;
var wordList;
var remainingWords

// @return true if the quiz was ran
function init(loadedItems_, wordList_, mode_) {
    spellItems = loadedItems_
    wordList = wordList_
    // Do not set the focus on mobile or the mobile OS keyboard will pop up
    // instead of ours.
    if(!GCompris.ApplicationInfo.isMobile)
        spellItems.answer.forceActiveFocus()
    initLevel()
    return true
}

function initLevel() {
    remainingWords = wordList.slice();
    Core.shuffle(remainingWords)

    spellItems.score.currentSubLevel = 0
    spellItems.score.numberOfSubLevels = wordList.length

    /* populate VirtualKeyboard for mobile:
     * 1. for < 10 letters print them all in the same row
     * 2. for > 10 letters create 3 rows with equal amount of keys per row
     *    if possible, otherwise more keys in the upper rows
     */
    // first generate a map of needed letters
    var letters = [];
    for (var i = 0; i < wordList.length; i++) {
        var currentWord = wordList[i].translatedTxt;
        for (var j = 0; j < currentWord.length; j++) {
            var letter = currentWord.charAt(j);

            if(letters.indexOf(letter) === -1)
                letters.push(currentWord.charAt(j));
        }
    }
    letters = GCompris.ApplicationInfo.localeSort(letters, spellItems.locale);
    // generate layout from letter map
    var layout = [];
    var row = 0;
    var offset = 0;
    while (offset < letters.length-1) {
        var cols = letters.length <= 10
                ? letters.length
                : (Math.ceil((letters.length-offset) / (3 - row)));
        layout[row] = new Array();
        for (var j = 0; j < cols; j++)
            layout[row][j] = { label: letters[j+offset] };
        offset += j;
        row++;
    }
    layout[row-1].push({ label: spellItems.keyboard.backspace });
    spellItems.keyboard.layout = layout;

    initSubLevel()
}

function initSubLevel() {
    spellItems.score.currentSubLevel++
    spellItems.goodWord = wordList[spellItems.score.currentSubLevel - 1]
    spellItems.wordImage.changeSource(spellItems.goodWord.image)
    spellItems.hintText.changeHint(spellItems.goodWord.translatedTxt[0])
    spellItems.hintText.visible = true
    spellItems.answer.text = ""
    spellItems.maximumLengthAnswer = spellItems.goodWord.translatedTxt.length + 1
}

function nextSubLevel() {
    if(spellItems.score.currentSubLevel == spellItems.score.numberOfSubLevels ) {
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
        badWordSelected(spellItems.score.currentSubLevel - 1, answer_)
    }
}

// Append to the front of queue of words for the sublevel the error
function badWordSelected(wordIndex, answer) {
    if (remainingWords[0] != wordIndex)
        remainingWords.unshift(wordIndex);

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
        } else {
            if(firstIncorrectIndex == 0) {
                hint = hint + goodChar
                firstIncorrectIndex = i
            } else {
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
    if ( text == spellItems.keyboard.backspace) {
        backspace(answer)
        return
    }
    answer.insert(answer.length,text)
}

function backspace(answer) {
    answer.text = answer.text.slice(0, -1)
    if(answer.text.length === 0) {
        answer.text = ""
    }
}
