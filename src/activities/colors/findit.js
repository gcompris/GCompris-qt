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
    numberOfLevel = dataset.length
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    items.firstQuestion = true
    items.audioOk = false
    items.score.currentSubLevel = 1
    initLevel()
}

function stop() {
}

function initLevel() {
    items.modelCopied = false
    tempModel = []
    items.containerModel.clear()
    currentQuestion = 0
    items.objectCount = dataset[items.currentLevel].length
    dataset[items.currentLevel] = Core.shuffle(dataset[items.currentLevel])

    for(var i = 0;  i < dataset[items.currentLevel].length; ++i) {
        tempModel.push(dataset[items.currentLevel][i])
    }

    items.score.numberOfSubLevels = dataset[items.currentLevel].length

    // Shuffle again not to ask the question in the model order
    dataset[items.currentLevel] = Core.shuffle(dataset[items.currentLevel])
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
    if(dataset[items.currentLevel].length <= currentQuestion + 1) {
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
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.score.currentSubLevel = 1
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function getCurrentTextQuestion() {
    return dataset[items.currentLevel][currentQuestion].text
}

function getCurrentAudioQuestion() {
    return dataset[items.currentLevel][currentQuestion].audio
}
