/* GCompris - braille_fun.js
 *
 * Copyright (C) 2014 Arkit Vora
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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
.pragma library
.import QtQuick 2.0 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var currentLevel = 0
var numberOfLevel = 3
var items
var currentQuestion
var currentSubLevel ;
var maxSubLevel;
var set = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
var questionArray = [];

var url = "qrc:/gcompris/src/activities/braille_fun/resource/"

function start(items_ ) {
    items = items_
    currentLevel = 0
    currentSubLevel = 0;
    initLevel()
}

function stop() {
}

function initQuestion() {
    // We just set the opacity to 0, the questionItem will then grab
    // the new question by itself
    items.questionItem.opacity = 0
    items.planeQuestion.opacity = 0

    items.animateX.restart();
    items.animateY.restart();
}

function nextQuestion() {

    if(++currentQuestion == set.length ) {
        while(questionArray.length > 0) {
            questionArray.pop();
        }

        items.bonus.good("flower")
    } else {
        initQuestion()
    }
}

function initLevel() {
    items.bar.level = currentLevel + 1
    currentQuestion = 0
    items.score.numberOfSubLevels = set.length;
    items.score.currentSubLevel = "0";
    items.cardRepeater.model = currentLevel + 1 ;

    initQuestion()
    items.animateSadTux.stop();

    switch(currentLevel) {
    case 0:
        for(var i = 0;  i < set.length; i++) {
            questionArray[i] = set[i];
        }
        break
    case 1:
        for(var i = 0;  i < set.length; i++) {
            questionArray[i] = set[i] + " " +
                    set[Math.floor(Math.random() * set.length)];
        }
        break
    case 2:
        for(var i = 0;  i < set.length; i++) {
            questionArray[i] = set[i] + " " +
                    set[Math.floor(Math.random() * set.length)] + " " +
                    set[Math.floor(Math.random() * set.length)];
        }
        break
    }
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


function getCurrentLetter() {
    return questionArray[currentQuestion];
}
