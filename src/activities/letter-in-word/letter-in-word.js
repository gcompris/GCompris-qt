/* GCompris - letter-in-word.js
 *
 * SPDX-FileCopyrightText: 2014 Holger Kaelberer
 *               2016 Akshat Tandon
 *               2020 Timothée Giet
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port of click-on-letter)
 *   Akshat Tandon    <akshat.tandon@research.iiit.ac.in>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

.pragma library
.import QtQuick 2.12 as Quick
.import GCompris 1.0 as GCompris //for ApplicationInfo
.import "qrc:/gcompris/src/core/core.js" as Core
.import "qrc:/gcompris/src/activities/lang/lang_api.js" as Lang

var url = "qrc:/gcompris/src/activities/letter-in-word/resource/"
var resUrl = "qrc:/gcompris/src/activities/braille_fun/resource/"

var levels;
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
    items = _items;
    // register the voices for the locale
    locale = GCompris.ApplicationInfo.getVoicesLocale(items.locale);
    GCompris.DownloadManager.updateResource(GCompris.GCompris.VOICES, {"locale": locale})
    loadDataset();
    levels = Lang.getAllLessons(dataset);
    currentSubLevel = 0;
    maxLevel = levels.length;
    items.currentLevel = Core.getInitialLevel(maxLevel);
    initLevel();
}

function loadDataset() {
    var resourceUrl = "qrc:/gcompris/src/activities/lang/resource/";
    var data = Lang.loadDataset(items.parser, resourceUrl, locale);
    dataset = data["dataset"];
    items.background.englishFallback = data["englishFallback"];
    if(!items.background.englishFallback)
        Core.checkForVoices(items.activityPage);
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
    if (currentSubLevel == 0 && !incorrectFlag) {
        var level = levels[items.currentLevel];
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
                                        "voice": words[i].voice,
                                        "selected": false
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
    items.question = currentLetter;
    items.animateX.restart();

    if(items.currentLetterCase == Quick.Font.MixedCase) {
        items.questionItem.font.capitalization = (Math.floor(Math.random() * 2) < 1) ? Quick.Font.AllLowercase : Quick.Font.AllUppercase
    }
    else {
        items.questionItem.font.capitalization = items.currentLetterCase
    }

    if (GCompris.ApplicationSettings.isAudioVoicesEnabled &&
            GCompris.DownloadManager.haveLocalResource(
                GCompris.DownloadManager.getVoicesResourceForLocale(locale))) {
        items.audioVoices.silence(100)
        playLetter(currentLetter)
    }
}

function calculateFrequency() {
    var freq = [];
    for(var i = 0; i < words.length; i++) {
        var currentWord = words[i].translatedTxt;
        for(var j = 0; j < currentWord.length; j++) {
            var character = currentWord.charAt(j);
            //consider the character if it is not a space
            if(character != " ") {
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
    items.currentLevel = Core.getNextLevel(items.currentLevel, maxLevel);
    currentSubLevel = 0;
    initLevel();
}

function previousLevel() {
    items.audioVoices.clearQueue()
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, maxLevel);
    currentSubLevel = 0;
    initLevel();
}

function nextSubLevel() {
    if( ++currentSubLevel >= maxSubLevel) {
        currentSubLevel = 0
        nextLevel()
    } else {
        initLevel();
    }
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
        items.bonus.bad("flower", items.bonus.checkAnswer);
   }
}

function checkWord(index) {
    var itemStatus = !items.wordsModel.get(index).selected;
    items.wordsModel.setProperty(index, "selected", itemStatus);
    return itemStatus;
}
