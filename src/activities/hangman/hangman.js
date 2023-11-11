/* GCompris - hangman.js
 *
 *   SPDX-FileCopyrightText: 2015 Rajdeep Kaur <rajdeep1994@gmail.com>
 *
 *    Authors:
 *    Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *    Rajdeep kaur <rajdeep51994@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

.pragma library
.import QtQuick 2.12 as Quick
.import GCompris 1.0 as GCompris
.import "qrc:/gcompris/src/core/core.js" as Core
.import "qrc:/gcompris/src/activities/lang/lang_api.js" as Lang

var currentSubLevel
var numberOfLevel
var maxSubLevel
var items

var currentWord
var sp ="_ "
var dataset = null
var lessons
var wordList
var subLevelsLeft
var alreadyTypedLetters

// js strings are immutable, can't replace letter like that...
// http://stackoverflow.com/questions/1431094/how-do-i-replace-a-character-at-a-particular-index-in-javascript
String.prototype.replaceAt = function(index, character) {
    return this.substr(0, index) + character + this.substr(index+character.length);
}

function start(items_) {
    items = items_
    currentSubLevel = 0;
    items.remainingLife = 6;

    var locale = GCompris.ApplicationInfo.getVoicesLocale(items.locale)

    var resourceUrl = "qrc:/gcompris/src/activities/lang/resource/"

    // register the voices for the locale
    GCompris.DownloadManager.updateResource(GCompris.GCompris.VOICES, {"locale": locale})

    var data = Lang.loadDataset(items.parser, resourceUrl, locale);
    dataset = data["dataset"];
    items.background.englishFallback = data["englishFallback"];
    lessons = Lang.getAllLessons(dataset)
    numberOfLevel = lessons.length
    items.currentLevel = Core.getInitialLevel(numberOfLevel);
    initLevel();
}

function stop() {
    items.winTimer.stop();
}

function initLevel() {
    // If clicking on previous/next level after winning, we prevent to skip the next word
    if(items.winTimer.running) {
        items.winTimer.stop();
    }

    var currentLesson = lessons[items.currentLevel];
    wordList = Lang.getLessonWords(dataset, currentLesson);
    Core.shuffle(wordList);

    maxSubLevel = wordList.length;
    items.score.numberOfSubLevels = maxSubLevel;
    items.score.visible = true;

    subLevelsLeft = []
    for(var i in wordList)
        subLevelsLeft.push(i)

    initSubLevel();

    //to set the layout...populate
    var letters = new Array();
    for (var i = 0; i < wordList.length; i++) {
        var word = wordList[i].translatedTxt;
        for (var j = 0; j < word.length; j++) {
            var letter = word.charAt(j).toLocaleLowerCase();
            if (letters.indexOf(letter) === -1)
                letters.push(letter);
        }
    }
    letters = GCompris.ApplicationInfo.localeSort(letters, items.locale);
    // Remove space character if in list
    var indexOfSpace = letters.indexOf(' ')
    if(indexOfSpace > -1)
        letters.splice(indexOfSpace, 1)
    // generate layout from letter map
    var layout = new Array();
    var row = 0;
    var offset = 0;
    while (offset < letters.length-1) {
        var cols = letters.length <= 10
                ? letters.length : (Math.ceil((letters.length-offset) / (3 - row)));
        layout[row] = new Array();
        for (var j = 0; j < cols; j++)
            layout[row][j] = { label: letters[j+offset] };
        offset += j;
        row++;
    }
    items.keyboard.layout = layout;
}

function processKeyPress(text) {
    if(items.remainingLife === 0 || items.goodIcon.visible) {
        return
    }

    text = text.toLocaleLowerCase()

    // Check if the character has already been typed
    if(alreadyTypedLetters.indexOf(text) !== -1) {
        // Character already typed, do nothing
        return;
    }
    // Add the character to the already typed characters
    alreadyTypedLetters.push(text);

    // add the typed character in the "Attempted characters" text field
    createAttemptedText()

    // Get all the indices of this letter in the word
    var indices = [];
    for(var i = 0 ; i < currentWord.length ; i ++) {
        if (currentWord[i].toLocaleLowerCase() === text) {
            indices.push(i);
        }
    }

    if(indices.length == 0) {
        // The letter is not in the word to find
        // If no more life, we display the good word and show the bonus
        if(--items.remainingLife == 0) {
            items.hidden.text = items.goodWord.translatedTxt;
            items.playWord()
            items.bonus.bad("lion");
            return;
        }
    } else {
        // For all the indices found, we replace the "_" by the letter
        for(var index = 0 ; index < indices.length ; index ++) {
            // Characters in the word displayed are separated by spaces, this is why we do 2*index
            items.hidden.text = items.hidden.text.replaceAt(2*indices[index],
                                                            currentWord[indices[index]]);
        }
    }

    // If no more '_' in the word to find, we have found all letters, show bonus
    if(items.hidden.text.indexOf("_") === -1) {
        items.maskThreshold = 0;
        items.playWord();
        items.hidden.text = items.goodWord.translatedTxt;
        items.goodIcon.visible = true
        items.winTimer.start();
    }
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    currentSubLevel = 0;
    initLevel();
}


function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    currentSubLevel = 0;
    initLevel();
}

function initSubLevel() {
    // initialize sublevel
    if(items.score.currentSubLevel < items.score.numberOfSubLevels)
        items.score.currentSubLevel = currentSubLevel + 1;
    else
        items.score.visible = false
    items.goodWordIndex = subLevelsLeft.pop()
    items.ok.visible = false
    items.goodIcon.visible = false
    items.goodWord = wordList[items.goodWordIndex]
    items.wordImage.changeSource(items.goodWord.image);
    items.remainingLife = 6;
    alreadyTypedLetters = new Array();
    currentWord = items.goodWord.translatedTxt;
    items.hidden.text = ""
    createAttemptedText()

    for(var i = 0; i < currentWord.length ; ++ i) {
        if(currentWord[i] == " ") {
            items.hidden.text = items.hidden.text + " " + " "
        } else {
            items.hidden.text = items.hidden.text + sp;
        }
    }
}

function createAttemptedText() {
    alreadyTypedLetters.sort()
    items.guessedText.text = qsTr("Attempted: %1").arg(alreadyTypedLetters.join(", "))
}

function nextSubLevel() {
    if( ++currentSubLevel >= maxSubLevel) {
        currentSubLevel = 0;
        nextLevel();
    } else {
        initSubLevel();
    }
}

function focusTextInput() {
    if (!GCompris.ApplicationInfo.isMobile && items && items.textinput)
        items.textinput.forceActiveFocus();
}
