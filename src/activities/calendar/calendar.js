/* GCompris - calendar.js
 *
 * SPDX-FileCopyrightText: 2017 Amit Sagtani <asagtani06@gmail.com>
 *
 * Authors:
 *   Amit Sagtani <asagtani06@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

.pragma library
.import QtQuick 2.12 as Quick
.import QtQml 2.12 as Qml
.import GCompris 1.0 as GCompris //for ApplicationInfo
.import "qrc:/gcompris/src/core/core.js" as Core

var numberOfLevel
var currentSubLevel = 1
var currentDataSet
var currentLevelConfig
var dataset
var items
var daySelected = 1
var dayOfWeekSelected
var correctAnswer
var mode

function start(items_, dataset_) {
    items = items_
    dataset = dataset_.get()
    numberOfLevel = dataset.length
    items.currentLevel = Core.getInitialLevel(numberOfLevel)

    if(Qt.locale(GCompris.ApplicationSettings.locale).firstDayOfWeek == Qml.Locale.Monday) {
        items.daysOfTheWeekModel.move(0, items.daysOfTheWeekModel.count - 1, 1)
    }
    initLevel();
}

function stop() {
}

function initLevel() {
    currentSubLevel = 1;
    currentLevelConfig = dataset[items.currentLevel][0][0]
    setCalendarConfigurations()
    initQuestion();
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

// Configure calendar properties for every level.
function setCalendarConfigurations() {
    mode = currentLevelConfig["mode"]
    items.calendar.navigationBarVisible = currentLevelConfig["navigationBarVisible"]
    items.calendar.selectedDay = 1;
    items.calendar.minimumDate = new Date(currentLevelConfig["minimumDate"])
    items.calendar.minimumDate.setHours(0);
    items.calendar.maximumDate = new Date(currentLevelConfig["maximumDate"])
    items.calendar.maximumDate.setHours(0);
    items.calendar.currentDate = new Date(currentLevelConfig["visibleYear"], currentLevelConfig["visibleMonth"], items.calendar.selectedDay)
    items.answerChoices.visible = (mode === "findDayOfWeek") ? true : false
    items.okButton.visible = !items.answerChoices.visible
    currentDataSet = dataset[items.currentLevel][1]
    currentDataSet = Core.shuffle(currentDataSet)
    items.score.numberOfSubLevels = currentDataSet.length
    items.score.currentSubLevel = currentSubLevel
}

function initQuestion() {
    if(currentDataSet.length < currentSubLevel) {
        items.bonus.good("lion")
    }
    else {
        items.score.currentSubLevel = currentSubLevel
        items.questionItem.text = currentDataSet[currentSubLevel-1]["question"]
        correctAnswer = currentDataSet[currentSubLevel-1]["answer"]
    }
}

function updateScore(isCorrectAnswer) {
    if(isCorrectAnswer) {
        items.questionDelay.start()
        items.okButtonParticles.burst(20)
        items.score.playWinAnimation()
        currentSubLevel++;
    }
    else
        items.bonus.bad("lion", items.bonus.checkAnswer)
}

function checkAnswer() {
    var isCorrectAnswer = false
    // For levels having questions based on day of week only.
    if(mode === "findDayOfWeek") {
        if(dayOfWeekSelected === correctAnswer["dayOfWeek"]) {
            isCorrectAnswer = true
        }
    }
    // For levels having question based on month only.
    else if(mode === "findMonthOnly") {
        if(correctAnswer["month"].indexOf(monthSelected) >= 0) {
            isCorrectAnswer = true
        }
    }
    // For levels having questions based on dayOfWeek, month and year.
    else if(mode !== "findDayOfWeek") {
        if(items.calendar.currentDate.getMonth() === correctAnswer["month"] && daySelected === correctAnswer["day"] && items.calendar.currentDate.getFullYear() === correctAnswer["year"]) {
            isCorrectAnswer = true
        }
    }
    updateScore(isCorrectAnswer)
}
