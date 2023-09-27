/* GCompris - braille_fun.js
 *
 * SPDX-FileCopyrightText: 2014 Arkit Vora <arkitvora123@gmail.com>
 *
 * Authors:
 *   Srishti Sethi (GTK+ version)
 *   Arkit Vora <arkitvora123@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.12 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var numberOfLevel = 3
var items
var currentQuestion
var maxSubLevel;
var set = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
var questionArray = [];

var url = "qrc:/gcompris/src/activities/braille_fun/resource/"

function start(items_ ) {
    items = items_
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    initLevel()
}

function stop() {
    items.animateX.stop()
}

function initQuestion() {
    items.question = questionArray[currentQuestion]
    items.charBg.clickable(true)
    items.charBg.clearAllLetters()
    items.animateX.restart()
}

function nextQuestion() {
    if(++currentQuestion == set.length) {
        nextLevel()
    } else {
        initQuestion()
    }
}

function initLevel() {
    currentQuestion = 0
    items.score.numberOfSubLevels = set.length;
    items.score.currentSubLevel = 0;
    questionArray = []

    switch(items.currentLevel) {
    case 0:
        for(var i = 0;  i < set.length; i++) {
            questionArray[i] = set[i];
        }
        break
    case 1:
        for(var i = 0;  i < set.length; i++) {
            questionArray[i] = set[i] +
                    set[Math.floor(Math.random() * set.length)];
        }
        break
    case 2:
        for(var i = 0;  i < set.length; i++) {
            questionArray[i] = set[i] +
                    set[Math.floor(Math.random() * set.length)] +
                    set[Math.floor(Math.random() * set.length)];
        }
        break
    }

    initQuestion()
    items.cardRepeater.model = items.currentLevel + 1;
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}
