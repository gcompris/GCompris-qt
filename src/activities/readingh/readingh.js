/* GCompris - readingh.js
 *
 * Copyright (C) 2015 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Johnny Jazeix <jazeix@gmail.com> (Qt Quick port)
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
.import QtQuick 2.6 as Quick
.import GCompris 1.0 as GCompris //for ApplicationInfo
.import "qrc:/gcompris/src/core/core.js" as Core

var currentLevel = 0
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
    currentLevel = 0
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
    initLevel();
}

function stop() {
    items.wordDropTimer.stop();
}

function initLevel() {
    items.bar.level = currentLevel + 1;
    items.wordDropTimer.stop();
    items.answerButtonsFlow.visible = false;

    // initialize level
    level = items.wordlist.getLevelWordList(currentLevel + 1);
    items.wordlist.initRandomWord(currentLevel + 1)
    items.textToFind = items.wordlist.getRandomWord()
    Core.shuffle(level.words)
    words = level.words.slice(0, 15)
    items.currentIndex = -1

    items.wordDisplayRepeater.model = words
    items.wordDisplayRepeater.idToHideBecauseOverflow = 0
    items.answerButtonFound.isCorrectAnswer = words.indexOf(items.textToFind) != -1
    items.iAmReady.visible = true
}

function nextLevel() {
    if(maxLevel <= ++currentLevel) {
        currentLevel = 0
    }
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = maxLevel - 1
    }
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
