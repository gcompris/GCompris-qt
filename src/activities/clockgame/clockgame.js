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

.import "qrc:/gcompris/src/core/core.js" as Core

var numberOfLevel = 10;
var items;
var selectedArrow;
var pastQuestionsH = [];
var pastQuestionsM = [];
var pastQuestionsS = [];
var targetHour;

function start(items_) {
    items = items_;
    numberOfLevel = items.levels.length;
    items.currentLevel = Core.getInitialLevel(numberOfLevel);
    items.currentTry = 0;
    pastQuestionsH = [];
    pastQuestionsM = [];
    pastQuestionsS = [];
    initLevel();
}

function stop() {}

function initLevel() {

    items.numberOfTry = items.levels[items.currentLevel].numberOfSubLevels;

    differentTargetH();
    differentCurrentH();

    items.minutesHandVisible = items.levels[items.currentLevel].displayMinutesHand;
    if(!items.minutesHandVisible) {
        items.currentM = 0;
        items.targetM = 0;
    }
    else if(items.levels[items.currentLevel].fixedMinutes !== undefined) {
        items.targetM = items.levels[items.currentLevel].fixedMinutes;
        differentCurrentM();
    }
    else {
        differentTargetM();
        differentCurrentM();
    }

    items.secondsHandVisible = items.levels[items.currentLevel].displaySecondsHand;
    if(!items.secondsHandVisible) {
        items.currentS = 0;
        items.targetS = 0;
    }
    else if(items.levels[items.currentLevel].fixedSeconds !== undefined) {
        items.targetS = items.levels[items.currentLevel].fixedSeconds;
        differentCurrentS();
    }
    else {
        differentTargetS();
        differentCurrentS();
    }

    if(items.levels[items.currentLevel].zonesVisible !== undefined) {
        items.zonesVisible = items.levels[items.currentLevel].zonesVisible;
    }
    else {
        items.zonesVisible = true;
    }

    if(items.levels[items.currentLevel].hoursMarksVisible !== undefined) {
        items.hoursMarksVisible = items.levels[items.currentLevel].hoursMarksVisible;
    }
    else {
        items.hoursMarksVisible = true;
    }

    if(items.levels[items.currentLevel].hoursVisible !== undefined) {
        items.hoursVisible = items.levels[items.currentLevel].hoursVisible;
    }
    else {
        items.hoursVisible = true;
    }

    if(items.levels[items.currentLevel].minutesVisible !== undefined) {
        items.minutesVisible = items.levels[items.currentLevel].minutesVisible;
    }
    else {
        items.minutesVisible = true;
    }

    if(items.levels[items.currentLevel].noHint !== undefined) {
        items.noHint = items.levels[items.currentLevel].noHint;
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

    // converting 12-hour system to 24-hour system
    if(!items.useTwelveHourFormat) {
        items.targetH += 12;
    }
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
    targetHour = items.targetH % 12;
    items.currentH = Math.floor(Math.random() * 12);
    while(items.currentH === targetHour) {
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
    if (items.currentH === targetHour
                    && items.currentM === items.targetM
                    && items.currentS === items.targetS) {
        items.bonus.good("gnu");
    }
    else {
        items.bonus.bad("gnu");
    }
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    items.currentTry = 0;
    pastQuestionsH = [];
    pastQuestionsM = [];
    pastQuestionsS = [];
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
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
