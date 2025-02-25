/* GCompris - click_on_letter.js
 *
 * SPDX-FileCopyrightText: 2014 Holger Kaelberer
 * 
 * Authors:
 *   Pascal Georges <pascal.georges1@free.fr> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ Mostly full rewrite)
 *   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

.pragma library
.import QtQuick 2.12 as Quick
.import core 1.0 as GCompris //for ApplicationInfo
.import "qrc:/gcompris/src/core/core.js" as Core

var url = "qrc:/gcompris/src/activities/click_on_letter/resource/"
var defaultLevelsFile = ":/gcompris/src/activities/click_on_letter/resource/levels-en.json";
var maxLettersPerLine = 6;

var levels;
var numberOfLevel;
var currentLetter;
var level;
var questions;
var answers;
var items;
var mode;
var locale;

function start(_items, _mode)
{
    Core.checkForVoices(_items.activityPage);

    items = _items;
    mode = _mode;

    // register the voices for the locale
    locale = GCompris.ApplicationInfo.getVoicesLocale(items.locale)
    GCompris.DownloadManager.updateResource(GCompris.GCompris.VOICES, {"locale": locale})
    loadLevels();
    items.score.currentSubLevel = 0;
    numberOfLevel = levels.length;
    items.currentLevel = Core.getInitialLevel(numberOfLevel);
    initLevel();
}

function validateLevels(levels)
{
    var i;
    for (i = 0; i < levels.length; i++) {
        if (undefined === levels[i].questions
            || typeof levels[i].questions != "string"
            || levels[i].questions.length < 1
            || typeof levels[i].answers != "string"
            || levels[i].answers.length < 1)
            return false;
    }
    if (i < 1)
        return false;
    return true;
}

function loadLevels()
{
    var ret;
    var filename = GCompris.ApplicationInfo.getLocaleFilePath(url + "levels-" + locale + ".json");
    levels = items.parser.parseFromUrl(filename);
    if (levels == null) {
        console.warn("Click_on_letter: Invalid levels file " + filename);
        // fallback to default Latin (levels-en.json) file:
        levels = items.parser.parseFromUrl(defaultLevelsFile);
        if (levels == null) {
            console.error("Click_on_letter: Invalid default levels file "
                + defaultLevelsFile + ". Can't continue!");
            // any way to error-exit here?
            return;
        }
    }
    // at this point we have valid levels
    for (var i = 0; i < levels.length; i++) {
        if (mode === "lowercase") {
            levels[i].questions = levels[i].questions.toLocaleLowerCase();
            levels[i].answers = levels[i].answers.toLocaleLowerCase();
        } else {
            levels[i].questions = levels[i].questions.toLocaleUpperCase();
            levels[i].answers = levels[i].answers.toLocaleUpperCase();
        }
    }
}

function stop()
{
}

function shuffleString(s)
{
    var a = s.split("|");
    var n = a.length;

    for(var i = n-1; i>0; i--) {
        var j = Math.floor(Math.random() * (i + 1));
        var tmp = a[i];
        a[i] = a[j];
        a[j] = tmp;
    }
    return a.join("|");
}

function initLevel() {
    items.errorRectangle.resetState();
    if (items.score.currentSubLevel == 0) {
        level = levels[items.currentLevel];
        items.score.numberOfSubLevels = level.questions.split("|").length;
        questions = shuffleString(level.questions);
        answers = shuffleString(level.answers);

        var answerArr = answers.split("|");
        items.trainModel.clear();
        for (var i = 0; i < answerArr.length; i++) {                
            items.trainModel.append({
                "letter": answerArr[i],
            });
        }
    }

    currentLetter = questions.split("|")[items.score.currentSubLevel];
    // Maybe we will display it if sound fails
    items.questionItem.text = currentLetter;
    if (GCompris.ApplicationSettings.isAudioVoicesEnabled &&
            GCompris.DownloadManager.haveLocalResource(
                GCompris.DownloadManager.getVoicesResourceForLocale(locale))) {
        appendVoices(locale);
    } else {
        // no sound -> show question
        items.questionItem.visible = true;
        items.repeatItem.visible = false
    }
    items.buttonsBlocked = false;
}

function appendVoices() {
    if(GCompris.DownloadManager.areVoicesRegistered(items.locale)) {
        items.audioVoices.append(GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/"+locale+"/misc/click_on_letter.$CA"));
        items.audioVoices.silence(100);
        playLetter(currentLetter);
    } else {
        items.voiceTimer.start();
    }
}

function playLetter(letter) {
    var letterAudio = GCompris.ApplicationInfo.getAudioFilePath(
        "voices-$CA/"+locale+"/alphabet/" + Core.getSoundFilenamForChar(letter))
     if(items.audioVoices.append(letterAudio)) {
         items.questionItem.visible = false
         items.repeatItem.visible = true
    } else {
        // no sound -> show question
        items.questionItem.visible = true;
        items.repeatItem.visible = false
    }
}

function nextLevel() {
    items.score.stopWinAnimation();
    items.audioVoices.clearQueue();
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    items.score.currentSubLevel = 0;
    initLevel();
}

function previousLevel() {
    items.score.stopWinAnimation();
    items.audioVoices.clearQueue();
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    items.score.currentSubLevel = 0;
    initLevel();
}

function nextSubLevel() {
    items.audioVoices.clearQueue()
    if(items.score.currentSubLevel >= items.score.numberOfSubLevels) {
        items.bonus.good("flower")
    } else {
        initLevel();
    }
}

function checkAnswer(index) {
    var modelEntry = items.trainModel.get(index);
    if (modelEntry.letter === currentLetter) {
        items.score.currentSubLevel++;
        items.score.playWinAnimation();
        items.winSound.play();
        return true
    } else {
        return false
    }
}

function focusEventHandler() {
    if (items && items.eventHandler)
        items.eventHandler.forceActiveFocus();
}
