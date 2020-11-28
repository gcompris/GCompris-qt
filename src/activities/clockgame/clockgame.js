/* GCompris - clockgame.js
 *
 * SPDX-FileCopyrightText: 2014 Stephane Mankowski <stephane@mankowski.fr>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Stephane Mankowski <stephane@mankowski.fr> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
var currentLevel = 0;
var numberOfLevel = 10;
var items;
var selectedArrow;
var pastQuestionsH = [];
var pastQuestionsM = [];
var pastQuestionsS = [];

function start(items_) {
    items = items_;
    currentLevel = 0;
    numberOfLevel = items.levels.length;
    items.currentTry = 0;
    pastQuestionsH = [];
    pastQuestionsM = [];
    pastQuestionsS = [];
    initLevel();
}

function stop() {}

function initLevel() {
    items.bar.level = currentLevel + 1;

    items.numberOfTry = items.levels[currentLevel].numberOfSubLevels;

    differentTargetH();
    differentCurrentH();

    items.minutesHandVisible = items.levels[currentLevel].displayMinutesHand;
    if(!items.minutesHandVisible) {
        items.currentM = 0;
        items.targetM = 0;
    }
    else if(items.levels[currentLevel].fixedMinutes !== undefined) {
        items.targetM = items.levels[currentLevel].fixedMinutes;
        differentCurrentM();
    }
    else {
        differentTargetM();
        differentCurrentM();
    }

    items.secondsHandVisible = items.levels[currentLevel].displaySecondsHand;
    if(!items.secondsHandVisible) {
        items.currentS = 0;
        items.targetS = 0;
    }
    else if(items.levels[currentLevel].fixedSeconds !== undefined) {
        items.targetS = items.levels[currentLevel].fixedSeconds;
        differentCurrentS();
    }
    else {
        differentTargetS();
        differentCurrentS();
    }

    if(items.levels[currentLevel].zonesVisible !== undefined) {
        items.zonesVisible = items.levels[currentLevel].zonesVisible;
    }
    else {
        items.zonesVisible = true;
    }

    if(items.levels[currentLevel].hoursMarksVisible !== undefined) {
        items.hoursMarksVisible = items.levels[currentLevel].hoursMarksVisible;
    }
    else {
        items.hoursMarksVisible = true;
    }

    if(items.levels[currentLevel].hoursVisible !== undefined) {
        items.hoursVisible = items.levels[currentLevel].hoursVisible;
    }
    else {
        items.hoursVisible = true;
    }

    if(items.levels[currentLevel].minutesVisible !== undefined) {
        items.minutesVisible = items.levels[currentLevel].minutesVisible;
    }
    else {
        items.minutesVisible = true;
    }

    if(items.levels[currentLevel].noHint !== undefined) {
        items.noHint = items.levels[currentLevel].noHint;
    }
    else {
        items.noHint = false;
    }
}

function differentTargetH() {
    items.targetH = Math.floor(Math.random() * 12);
    while(pastQuestionsH.indexOf(items.targetH) != -1) {
        items.targetH = Math.floor(Math.random() * 12);
    }
    pastQuestionsH.push(items.targetH);
}

function differentTargetM() {
    items.targetM = Math.floor(Math.random() * 60);
    while(pastQuestionsM.indexOf(items.targetM) != -1) {
        items.targetM = Math.floor(Math.random() * 60);
    }
    pastQuestionsM.push(items.targetM);
}

function differentTargetS() {
    items.targetS = Math.floor(Math.random() * 60);
    while(pastQuestionsS.indexOf(items.targetS) != -1) {
        items.targetS = Math.floor(Math.random() * 60);
    }
    pastQuestionsS.push(items.targetS);
}

function differentCurrentH() {
    items.currentH = Math.floor(Math.random() * 12);
    while(items.currentH === items.targetH) {
        items.currentH = Math.floor(Math.random() * 12);
    }
}

function differentCurrentM() {
    items.currentM = Math.floor(Math.random() * 60);
    while(items.currentM === items.targetM) {
        items.currentM = Math.floor(Math.random() * 60);
    }
}

function differentCurrentS() {
    items.currentS = Math.floor(Math.random() * 60);
    while(items.currentS === items.targetS) {
        items.currentS = Math.floor(Math.random() * 60);
    }
}

function nextTry() {
    if (items.numberOfTry <= ++items.currentTry) {
        items.currentTry = 0;
        nextLevel();
    } else {
        initLevel();
    }
}

function checkAnswer() {
    if (items.currentH === items.targetH
                    && items.currentM === items.targetM
                    && items.currentS === items.targetS) {
        items.bonus.good("gnu");
    }
    else {
        items.bonus.bad("gnu");
    }
}

function nextLevel() {
    if (numberOfLevel <= ++currentLevel) {
        currentLevel = 0;
    }
    items.currentTry = 0;
    pastQuestionsH = [];
    pastQuestionsM = [];
    pastQuestionsS = [];
    initLevel();
}

function previousLevel() {
    if (--currentLevel < 0) {
        currentLevel = numberOfLevel - 1;
    }
    items.currentTry = 0;
    pastQuestionsH = [];
    pastQuestionsM = [];
    pastQuestionsS = [];
    initLevel();
}

function get2CharValue(i) {
    if (String(i).length === 1)
        return "0" + i;
    return i;
}
