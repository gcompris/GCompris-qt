/* GCompris - solar_system.js
 *
 * Copyright (C) 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Aman Kumar Gupta <gupta2140@gmail.com>
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
.import "Dataset.js" as Dataset
.import "qrc:/gcompris/src/core/core.js" as Core

var currentLevel = 0
var numberOfLevel
var items
var dataset
var currentPlanetLevels
var currentSubLevel
var indexOfSelectedPlanet
var assessmentModeQuestions = []
var allQuestions = []

function start(items_) {
    items = items_
    currentLevel = 0
    dataset = Dataset.get()

    for(var i = 0;  i < dataset.length; ++i) {
        items.planetsModel.append({
            "realImg": dataset[i].realImg,
            "bodyName": dataset[i].bodyName,
            "bodySize": dataset[i].bodySize
        });
    }

    if(items.assessmentMode)
        startAssessmentMode()
}

function stop() {
}

function initLevel() {
    currentSubLevel = 0
    items.bar.level = currentLevel + 1
    items.mainQuizScreen.score.numberOfSubLevels = currentPlanetLevels.length
    Core.shuffle(currentPlanetLevels)
    nextSubLevel(false)
}

function nextSubLevel(isAssessmentMode) {
    items.mainQuizScreen.score.currentSubLevel = currentSubLevel
    var optionListShuffle = []

    if(!isAssessmentMode) {
        items.mainQuizScreen.closenessMeterValue = 0

        if(currentSubLevel+1 > items.mainQuizScreen.score.numberOfSubLevels) {
            items.bonus.good("flower")
            return
        }
        else {
            items.mainQuizScreen.question = currentPlanetLevels[currentSubLevel].question
            for(var i = 0 ; i < 4 ; i ++) {
                optionListShuffle.push({
                    "optionValue": currentPlanetLevels[currentSubLevel].options[i],
                    "closeness": currentPlanetLevels[currentSubLevel].closeness[i]
                });
            }
        }
    }
    else if(!items.mainQuizScreen.restartAssessmentMessage.visible) {
        items.mainQuizScreen.question = assessmentModeQuestions[0].question
        for(var i = 0 ; i < 4 ; i ++) {
            optionListShuffle.push({
                "optionValue": assessmentModeQuestions[0].options[i],
                "closeness": assessmentModeQuestions[0].closeness[i]
            });
        }
    }

    items.mainQuizScreen.closenessMeter.stopAnimations()

    if((currentSubLevel + 1) <= items.mainQuizScreen.score.numberOfSubLevels) {
        items.mainQuizScreen.optionListModel.clear()
        Core.shuffle(optionListShuffle)

        for(var i = 0 ; i < optionListShuffle.length ; i ++)
            items.mainQuizScreen.optionListModel.append(optionListShuffle[i])

        currentSubLevel++
    }
}

function showSolarModel() {
    items.quizScreenVisible = false
    items.solarSystemVisible = true
}

function startAssessmentMode() {
    items.solarSystemVisible = false
    items.quizScreenVisible = true
    items.mainQuizScreen.numberOfCorrectAnswers = 0
    items.mainQuizScreen.score.numberOfSubLevels = 20
    currentSubLevel = 0
    assessmentModeQuestions = []
    allQuestions = []

    for(var i = 0; i < dataset.length; i++) {
        for(var j = 0; j < dataset[i].levels.length; j++)
            allQuestions.push(dataset[i].levels[j])
    }

    Core.shuffle(allQuestions)
    assessmentModeQuestions = allQuestions.slice(0, 20)
    nextSubLevel(true)
}

function appendAndAddQuestion() {
    var incorrectAnsweredQuestion = assessmentModeQuestions.shift()
    assessmentModeQuestions.push(incorrectAnsweredQuestion)

    if(items.mainQuizScreen.score.numberOfSubLevels == 24)
        items.mainQuizScreen.score.numberOfSubLevels++
    else if(items.mainQuizScreen.score.numberOfSubLevels < 24) {
        assessmentModeQuestions.push(allQuestions[items.mainQuizScreen.score.numberOfSubLevels])
        items.mainQuizScreen.score.numberOfSubLevels += 2
    }
    else if(items.mainQuizScreen.numberOfCorrectAnswers)
        items.mainQuizScreen.numberOfCorrectAnswers--

    nextSubLevel(true)
}

function showQuizScreen(index) {
    currentLevel = 0
    indexOfSelectedPlanet = index

    items.solarSystemVisible = false
    items.quizScreenVisible = true

    currentPlanetLevels = dataset[indexOfSelectedPlanet].levels
    items.mainQuizScreen.planetRealImage = dataset[indexOfSelectedPlanet].realImg

    if(indexOfSelectedPlanet != 0) {
        items.temperatureHint = dataset[indexOfSelectedPlanet].temperatureHint
        items.lengthOfYearHint = dataset[indexOfSelectedPlanet].lengthOfYearHint
    }

    initLevel()
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel) {
        currentLevel = 0
    }
    if(!items.assessmentMode)
        initLevel()
    else
        startAssessmentMode()
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel();
}
