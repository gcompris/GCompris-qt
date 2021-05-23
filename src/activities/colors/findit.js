/* GCompris - findit.js
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

.pragma library
.import QtQuick 2.9 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var url = "qrc:/gcompris/src/activities/colors/resource/"

var currentLevel
var numberOfLevel
var items
var dataset

var currentQuestion

var hasWon

function start(items_, dataset_, mode_) {
    if (mode_ === "Colors")
        Core.checkForVoices(items_.activityPage);
    items = items_
    dataset = dataset_.get()
    currentLevel = 0
    numberOfLevel = dataset.length
    items.firstQuestion = true
    items.audioOk = false
    items.score.currentSubLevel = 1
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    items.containerModel.clear()
    currentQuestion = 0
    dataset[currentLevel] = Core.shuffle(dataset[currentLevel])

    for(var i = 0;  i < dataset[currentLevel].length; ++i) {
        items.containerModel.append(dataset[currentLevel][i])
    }

    items.score.numberOfSubLevels = dataset[currentLevel].length

    // Shuffle again not to ask the question in the model order
    dataset[currentLevel] = Core.shuffle(dataset[currentLevel])
    hasWon = false
    initQuestion()
}

function initQuestion() {
    // We just set the opacity to 0, the questionItem will then grab
    // the new question by itself
    // Need to set opacity to 0.1 before in order to be sure it's changed and trigger the questionItem onOpacityChanged
    items.questionItem.opacity = 0.1
    items.questionItem.opacity = 0
}

function nextQuestion() {
    if(dataset[currentLevel].length <= currentQuestion + 1) {
        items.bonus.good("flower")
        hasWon = true
    } else {
        currentQuestion++
        items.score.currentSubLevel++
        initQuestion()
    }
}

function nextLevel() {
    items.score.currentSubLevel = 1
    if(numberOfLevel <= ++currentLevel) {
        currentLevel = 0
    }
    initLevel();
}

function previousLevel() {
    items.score.currentSubLevel = 1
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
