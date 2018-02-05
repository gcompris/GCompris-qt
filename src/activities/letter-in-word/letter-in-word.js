/* GCompris - letter-in-word.js
 *
 * Copyright (C) 2014 Holger Kaelberer
 *               2016 Akshat Tandon
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port of click-on-letter)
 *   Akshat Tandon    <akshat.tandon@research.iiit.ac.in>
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
.import "qrc:/gcompris/src/activities/lang/lang_api.js" as Lang

var url = "qrc:/gcompris/src/activities/letter-in-word/resource/"
var resUrl = "qrc:/gcompris/src/activities/braille_fun/resource/"
var resUrl2 = "qrc:/gcompris/src/activities/click_on_letter/resource/"

var levels;
var currentLevel;
var maxLevel;
var currentSubLevel;
var currentLetter;
var maxSubLevel;
var questions;
var words;
var items;
var dataset = null;
var frequency;
var incorrectFlag = false;
var locale;

function start(_items) {
    Core.checkForVoices(_items.main);
    items = _items;
    // register the voices for the locale
    locale = GCompris.ApplicationInfo.getVoicesLocale(items.locale)
    GCompris.DownloadManager.updateResource(GCompris.DownloadManager.getVoicesResourceForLocale(locale))
    loadDataset();
    levels = Lang.getAllLessons(dataset)
    currentLevel = 0;
    currentSubLevel = 0;
    maxLevel = levels.length;
    initLevel();
}

function loadDataset() {
    var resourceUrl = "qrc:/gcompris/src/activities/lang/resource/"
    var data = Lang.loadDataset(items.parser, resourceUrl, locale);
    dataset = data["dataset"];
    items.background.englishFallback = data["englishFallback"];
}

function stop() {
    items.animateX.stop()
}

function shuffleString(s) {
    var a = s;
    var n = a.length;

    for(var i = n-1; i > 0; --i) {
        var j = Math.floor(Math.random() * (i + 1));
        var tmp = a[i];
        a[i] = a[j];
        a[j] = tmp;
    }
    return a.join("");
}

function initLevel() {
    items.bar.level = currentLevel + 1;
    if (currentSubLevel == 0 && !incorrectFlag) {
        var level = levels[currentLevel];
        words = Lang.getLessonWords(dataset, level);
        Core.shuffle(words);
        var limit = Math.min(items.currentMode, words.length);
        words = words.slice(0, limit);
        frequency = calculateFrequency();
        var tempQuestions = generateQuestions();
        maxSubLevel = tempQuestions.length;
        items.score.numberOfSubLevels = maxSubLevel;
        items.score.currentSubLevel = 1;
        questions = shuffleString(tempQuestions);
        items.wordsModel.clear();
        for (var i = 0; i < words.length; i++) {
            items.wordsModel.append({
                                        "spelling": words[i].translatedTxt,
                                        "imgurl": words[i].image,
                                        "selected": false,
                                        "voice": words[i].voice
                                    });
        }
    }
    else {
        items.score.currentSubLevel = currentSubLevel + 1;
    }

    incorrectFlag = false;

    for(var i = 0; i < words.length; i++) {
        items.wordsModel.setProperty(i, "selected", false);
    }

    currentLetter = questions[currentSubLevel];
    items.question = currentLetter
    items.animateX.restart();

    if (GCompris.ApplicationSettings.isAudioVoicesEnabled &&
            GCompris.DownloadManager.haveLocalResource(
                GCompris.DownloadManager.getVoicesResourceForLocale(locale))) {
        items.audioVoices.silence(100)
        playLetter(currentLetter)
    }
}

function calculateFrequency() {
    var freq = [];
    //regex pattern to detect whether the character is an english alphabet or some accented latin chacarcter
    var pattern = /[A-Za-z\u00C0-\u017F]/;
    for(var i = 0; i < words.length; i++) {
        var currentWord = words[i].translatedTxt;
        for(var j = 0; j < currentWord.length; j++) {
            var character = currentWord.charAt(j);
            //consider the character if and only if it is an alphabet or an accented latin character
            if(pattern.test(character)) {
                if(freq[character]) {
                    freq[character]++;
                }
                else {
                    freq[character] = 1;
                }
            }
        }
    }
    return freq;
}

function generateQuestions() {
    var freqArr = [];
    var ques = [];

    for(var character in frequency) {
        freqArr.push([character, frequency[character]]);
    }

    freqArr.sort(function(a, b) {return b[1] - a[1]});

    var limit = Math.min(10, freqArr.length);
    for(var i = 0; i < limit; i++) {
        ques.push(freqArr[i][0])
    }
    return ques;
}

function playLetter(letter) {
    items.audioVoices.append(GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/"+locale+"/alphabet/"
                                                                       + Core.getSoundFilenamForChar(letter)))
}

function nextLevel() {
    items.audioVoices.clearQueue()
    if(maxLevel <= ++currentLevel) {
        currentLevel = 0
    }
    currentSubLevel = 0;
    initLevel();
}

function previousLevel() {
    items.audioVoices.clearQueue()
    if(--currentLevel < 0) {
        currentLevel = maxLevel - 1
    }
    currentSubLevel = 0;
    initLevel();
}

function nextSubLevel() {
    if( ++currentSubLevel >= maxSubLevel) {
        currentSubLevel = 0
        nextLevel()
    }
    initLevel();
}

function checkAnswer() {
    var allCorrectSelected = true
    var modelEntry;
    var letterIndex;
    for(var i = 0; i < words.length; i++) {
        modelEntry = items.wordsModel.get(i);
        letterIndex = modelEntry.spelling.indexOf(currentLetter);
        if(letterIndex != -1 && modelEntry.selected == false) {
            allCorrectSelected = false;
            break;
        }
        if(letterIndex == -1 && modelEntry.selected == true) {
            allCorrectSelected = false;
            break;
        }
    }
    if(allCorrectSelected == true) {
        items.bonus.good("flower");
    }
    else {
        items.bonus.bad("flower");
   }
}

function checkWord(index) {
    var modelEntry = items.wordsModel.get(index);
    items.wordsModel.setProperty(index, "selected", !modelEntry.selected);
    return modelEntry.selected;
}
