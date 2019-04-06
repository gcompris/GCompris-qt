/* GCompris - braille_fun.js
 *
 * Copyright (C) 2014 Arkit Vora <arkitvora123@gmail.com>
 *
 * Authors:
 *   Srishti Sethi (GTK+ version)
 *   Arkit Vora <arkitvora123@gmail.com> (Qt Quick port)
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
.pragma library
.import QtQuick 2.6 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var currentLevel = 0
var numberOfLevel = 3
var items
var currentQuestion
var maxSubLevel;
var set = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
var questionArray = [];

var url = "qrc:/gcompris/src/activities/braille_fun/resource/"

function start(items_ ) {
    items = items_
    currentLevel = 0
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
    items.bar.level = currentLevel + 1
    currentQuestion = 0
    items.score.numberOfSubLevels = set.length;
    items.score.currentSubLevel = 0;
    questionArray = []

    switch(currentLevel) {
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
    items.cardRepeater.model = currentLevel + 1;
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel ) {
        currentLevel = 0
    }
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel();
}
