/* GCompris
 *
 * Copyright (C) 2014 Bruno Coudoin
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

var dataset

var currentLevel = 0
var numberOfLevel
var main
var background
var bar
var bonus
var containerModel
var questionItem

var currentQuestion

function start(main_, background_, bar_, bonus_,
               containerModel_, questionItem_, dataset_) {
    main = main_
    background = background_
    bar = bar_
    bonus = bonus_
    currentLevel = 0
    containerModel = containerModel_
    questionItem = questionItem_
    dataset = dataset_
    numberOfLevel = dataset.length
    initLevel()
}

function stop() {
}

function initLevel() {
    bar.level = currentLevel + 1
    containerModel.clear()
    currentQuestion = 0
    dataset[currentLevel] = shuffle(dataset[currentLevel])

    for(var i = 0;  i < dataset[currentLevel].length; ++i) {
        containerModel.append(dataset[currentLevel][i])
    }

    // Shuffle again not to ask the question in the model order
    dataset[currentLevel] = shuffle(dataset[currentLevel])
    initQuestion()
}

function initQuestion() {
    // We just set the opacity to 0, the questionItem will then grab
    // the new question by itself
    questionItem.opacity = 0
}

function nextQuestion() {
    if(dataset[currentLevel].length <= ++currentQuestion ) {
        bonus.good("flower")
    } else {
        initQuestion()
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

function getCurrentTextQuestion() {
    return dataset[currentLevel][currentQuestion].text
}

function getCurrentAudioQuestion() {
    return dataset[currentLevel][currentQuestion].audio
}

function lost() {
    bonus.bad("flower")
}

function shuffle(o) {
    for(var j, x, i = o.length; i;
        j = Math.floor(Math.random() * i), x = o[--i], o[i] = o[j], o[j] = x);
    return o;
}
