/* GCompris - readingh.js
 *
 * SPDX-FileCopyrightText: 2015 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Johnny Jazeix <jazeix@gmail.com> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (graphics and improvements)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.12 as Quick
.import GCompris 1.0 as GCompris //for ApplicationInfo
.import "qrc:/gcompris/src/core/core.js" as Core

var items
var maxLevel

var url = "qrc:/gcompris/src/activities/readingh/resource/"
var dataSetUrl= "qrc:/gcompris/src/activities/wordsgame/resource/"

//
var level
// words to display
var words

function start(items_) {
    items = items_
    items.score.currentSubLevel = 0
    var locale = items.locale == "system" ? "$LOCALE" : items.locale

    items.wordlist.loadFromFile(GCompris.ApplicationInfo.getLocaleFilePath(
            dataSetUrl + "default-"+locale+".json"));
    // If wordlist is empty, we try to load from short locale and if not present again, we switch to default one
    var localeUnderscoreIndex = locale.indexOf('_')
    // probably exist a better way to see if the list is empty
    if(items.wordlist.maxLevel == 0) {
        var localeShort;
        // We will first look again for locale xx (without _XX if exist)
        if(localeUnderscoreIndex > 0) {
            localeShort = locale.substring(0, localeUnderscoreIndex)
        }
        else {
            localeShort = locale;
        }
        // If not found, we will use the default file
        items.wordlist.useDefault = true
        items.wordlist.loadFromFile(GCompris.ApplicationInfo.getLocaleFilePath(
        dataSetUrl + "default-"+localeShort+".json"));
        // We remove the using of default file for next time we enter this function
        items.wordlist.useDefault = false
    }
    maxLevel = items.wordlist.maxLevel;
    items.currentLevel = Core.getInitialLevel(maxLevel);
    initLevel();
}

function stop() {
    items.wordDropTimer.stop();
}

function initLevel() {
    items.score.currentSubLevel = 0
    items.wordDropTimer.stop();
    items.answerButtonsFlow.visible = false;

    // initialize level
    level = items.wordlist.getLevelWordList(items.currentLevel + 1);
    items.wordlist.initRandomWord(items.currentLevel + 1)
    items.score.numberOfSubLevels = Math.min(10, Math.floor(level.words.length))
    initSubLevel();
}

function initSubLevel() {
    items.answerButtonsFlow.visible = false;
    items.textToFind = items.wordlist.getRandomWord()
    Core.shuffle(level.words)
    words = level.words.slice(0, 15)
    // add 1/2 probablity for yes/no answer
    var probability = Math.random()
    if(probability > 0.5) {     // answer should be yes
        if(words.indexOf(items.textToFind) == -1) {
            words.pop()
            words.push(items.textToFind)
        }
    } else if(words.indexOf(items.textToFind) > -1) {    // answer should be no
        var wordIndex = words.indexOf(items.textToFind)  // if word is included, remove it
        words.splice(wordIndex, 1)
        for(var i=level.words.length - 1; i == 0; i--) { // try to get a word from the whole list different from textToFind and not yet in words
            if(level.words[i] != items.textToFind && words.indexOf(level.words[i]) == -1) {
                var wordToAdd = level.words[i]
                words.push(wordToAdd)
                break
            }
        }
    }
    Core.shuffle(words)

    items.currentIndex = -1

    items.wordDisplayRepeater.model = words
    items.wordDisplayRepeater.idToHideBecauseOverflow = 0
    items.answerButtonFound.isCorrectAnswer = words.indexOf(items.textToFind) != -1
    items.iAmReady.visible = true
    items.buttonsBlocked = false
}

function retrySubLevel() {
    items.wordlist.appendRandomWord(items.textToFind);
    initSubLevel();
}

function nextSubLevel() {
    if(items.score.currentSubLevel >= items.score.numberOfSubLevels) {
        items.bonus.good("flower")
    } else {
        initSubLevel();
    }
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, maxLevel);
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, maxLevel);
    initLevel();
}

function run() {
    items.wordDropTimer.start();
}

function dropWord() {
    if(++items.currentIndex < words.length) {
        // Display next word
    }
    else {
        items.wordDropTimer.stop();
        items.answerButtonsFlow.visible = true
    }
}
