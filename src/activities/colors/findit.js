/* GCompris - findit.js
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

.pragma library
.import QtQuick 2.12 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var url = "qrc:/gcompris/src/activities/colors/resource/"

var currentLevel
var numberOfLevel
var items
var dataset

var currentQuestion

var hasWon

var tempModel = []

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
    items.modelCopied = false
    tempModel = []
    items.containerModel.clear()
    currentQuestion = 0
    items.objectCount = dataset[currentLevel].length
    dataset[currentLevel] = Core.shuffle(dataset[currentLevel])

    for(var i = 0;  i < dataset[currentLevel].length; ++i) {
        tempModel.push(dataset[currentLevel][i])
    }

    items.score.numberOfSubLevels = dataset[currentLevel].length

    // Shuffle again not to ask the question in the model order
    dataset[currentLevel] = Core.shuffle(dataset[currentLevel])
    hasWon = false
    items.initAnim.restart()
    items.objectSelected = false
}

function tempModelToContainer() {
    for(var i = 0;  i < tempModel.length; ++i) {
        items.containerModel.append(tempModel[i])
    }
    items.modelCopied = true
}

function nextQuestion() {
    if(dataset[currentLevel].length <= currentQuestion + 1) {
        items.fadeOutAnim.restart()
        items.bonus.good("flower")
        hasWon = true
    } else {
        currentQuestion++
        items.score.currentSubLevel++
        items.nextAnim.restart()
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
