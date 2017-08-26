/* GCompris - Calendar.js
 *
 * Copyright (C) 2017 Amit Sagtani <asagtani06@gmail.com>
 *
 * Authors:
 *   "Amit Sagtani" <asagtani06@gmail.com>
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
.import GCompris 1.0 as GCompris //for ApplicationInfo
.import "qrc:/gcompris/src/core/core.js" as Core

var currentLevel = 0
var numberOfLevel
var currentSubLevel = 1
var currentDataSet
var currentLevelConfig
var dataset
var AllLevelConfigurations
var items
var dateSelected = new Date(2018, 2, 1)
var daySelected
var monthSelected
var yearSelected = 2018
var correctAnswer

function start(items_, dataset_, levelConfigurations_) {
    items = items_
    dataset = dataset_.get()
    AllLevelConfigurations = levelConfigurations_.getConfig()
    numberOfLevel = dataset.length
    currentLevel = 0
    initLevel();
}

function stop() {
}

function initLevel() {
    currentSubLevel = 1;
    items.bar.level = currentLevel + 1
    currentLevelConfig = AllLevelConfigurations[currentLevel][0]
    setCalendarConfigurations()
    initQuestion();
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

// Set properties of calendar here.
function setCalendarConfigurations() {
    items.calendar.navigationBarVisible = currentLevelConfig["navigationBarVisible"]
    items.calendar.minimumDate = currentLevelConfig["minimumDate"]
    items.calendar.maximumDate = currentLevelConfig["maximumDate"]
    items.calendar.visibleYear = currentLevelConfig["visibleYear"]
    items.calendar.visibleMonth = currentLevelConfig["visibleMonth"]
    items.answerChoices.visible = currentLevelConfig["answerChoiceVisible"]
    items.okButton.visible = currentLevelConfig["okButtonVisible"]
    currentDataSet = dataset[currentLevel]
    currentDataSet = Core.shuffle(currentDataSet)
    items.score.numberOfSubLevels = dataset[currentLevel].length
    items.score.currentSubLevel = currentSubLevel
}

function initQuestion() {
    if(currentDataSet.length < currentSubLevel) {
        items.bonus.good("flower")
        nextLevel()
    }
    else {
        items.score.currentSubLevel = currentSubLevel
        items.questionItem.text = currentDataSet[currentSubLevel-1]["question"]
        correctAnswer = currentDataSet[currentSubLevel-1]["answer"]
    }
}

function checkAnswer() {
    switch(items.bar.level) {
    case 1:
        if(dateSelected.getDay() === correctAnswer) {
            if(currentDataSet.length > currentSubLevel)
                items.bonus.good("lion")
            items.questionDelay.start()
        }
        else
            items.okButtonParticles.burst(20)
        break;
    case 2:
        if(dateSelected.getDate() === correctAnswer) {
            if(currentDataSet.length > currentSubLevel)
                items.bonus.good("lion")
            items.questionDelay.start()
        }
        else
            items.okButtonParticles.burst(20)
        break;
    case 3:
        if(monthSelected+yearSelected === correctAnswer) {
            if(currentDataSet.length > currentSubLevel)
                items.bonus.good("lion")
            items.questionDelay.start()
        }
        else
            items.okButtonParticles.burst(20)
        break;
    case 4:
        if(daySelected === correctAnswer) {
            if(currentDataSet.length > currentSubLevel)
                items.bonus.good("lion")
            items.questionDelay.start()
        }
        else
            items.okButtonParticles.burst(20)
        break;
    case 5:
        if(dateSelected.getDate() === correctAnswer) {
            if(currentDataSet.length > currentSubLevel)
                items.bonus.good("lion")
            items.questionDelay.start()
        }
        else
            items.okButtonParticles.burst(20)
        break;
    case 6:
        if(dateSelected.getDate()+dateSelected.getDay()+dateSelected.getFullYear() === correctAnswer) {
            if(currentDataSet.length > currentSubLevel)
                items.bonus.good("lion")
            items.questionDelay.start()
        }
        else
            items.okButtonParticles.burst(20)
        break;
    }
}
