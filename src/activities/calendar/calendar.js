/* GCompris - calendar.js
 *
 * Copyright (C) 2017 Amit Sagtani <asagtani06@gmail.com>
 *
 * Authors:
 *   Amit Sagtani <asagtani06@gmail.com>
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
.import QtQuick 2.6 as Quick
.import QtQml 2.2 as Qml
.import GCompris 1.0 as GCompris //for ApplicationInfo
.import "qrc:/gcompris/src/core/core.js" as Core

var currentLevel = 0
var numberOfLevel
var currentSubLevel = 1
var currentDataSet
var currentLevelConfig
var dataset
var items
var daySelected = 1
var monthSelected = 2
var yearSelected = 2018
var dayOfWeekSelected
var minRange //sum of min. visible month and year on calendar for navigation bar next/prev button visibility.
var maxRange //sum of max. visible month and year on calendar for navigation bar next/prev button visibility.
var correctAnswer
var mode

function start(items_, dataset_) {
    items = items_
    dataset = dataset_.get()
    numberOfLevel = dataset.length
    currentLevel = 0

    if(Qt.locale(GCompris.ApplicationSettings.locale).firstDayOfWeek == Qml.Locale.Monday) {
        items.daysOfTheWeekModel.move(0, items.daysOfTheWeekModel.count - 1, 1)
    }
    initLevel();
}

function stop() {
}

function initLevel() {
    currentSubLevel = 1;
    items.bar.level = currentLevel + 1
    currentLevelConfig = dataset[currentLevel][0][0]
    setCalendarConfigurations()
    initQuestion();
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel) {
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

// Configure calendar properties for every level.
function setCalendarConfigurations() {
    minRange = Number(currentLevelConfig["minimumDate"].slice(5,7)) + Number(currentLevelConfig["minimumDate"].slice(0,4)) - 1;
    maxRange = Number(currentLevelConfig["maximumDate"].slice(5,7)) + Number(currentLevelConfig["maximumDate"].slice(0,4)) - 1;
    mode = currentLevelConfig["mode"]
    items.calendar.navigationBarVisible = currentLevelConfig["navigationBarVisible"]
    items.calendar.minimumDate = currentLevelConfig["minimumDate"]
    items.calendar.maximumDate = currentLevelConfig["maximumDate"]
    items.calendar.visibleYear = currentLevelConfig["visibleYear"]
    yearSelected = currentLevelConfig["visibleYear"]
    items.calendar.visibleMonth = currentLevelConfig["visibleMonth"]
    monthSelected = currentLevelConfig["visibleMonth"]
    items.answerChoices.visible = (mode === "findDayOfWeek") ? true : false
    items.okButton.visible = !items.answerChoices.visible
    currentDataSet = dataset[currentLevel][1]
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
        items.bonus.bad("lion")
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
        if(monthSelected === correctAnswer["month"] && daySelected === correctAnswer["day"] && yearSelected === correctAnswer["year"]) {
            isCorrectAnswer = true
        }
    }
    updateScore(isCorrectAnswer)
}

