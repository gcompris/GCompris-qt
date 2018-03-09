/* GCompris - solar_system.js
 *
 * Copyright (C) 2017 Aman Kumar Gupta <gupta2140@gmail.com>
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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
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
        items.containerModel.append({
                "clipImg": dataset[i].clipImg,
                 "bodyName": dataset[i].bodyName
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
    nextSubLevel(false);
}

function showSolarModel() {
    items.quizScreenVisible = false
    items.solarSystemVisible = true
    items.mainQuizScreen.restartAssessmentMessage.visible = false
}

function startAssessmentMode() {
    items.solarSystemVisible = false
    items.quizScreenVisible = true
    items.mainQuizScreen.restartAssessmentMessage.visible = false
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
    else if(items.mainQuizScreen.score.numberOfSubLevels < 24){
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
    currentPlanetLevels = dataset[index].levels
    items.mainQuizScreen.planetRealImage = dataset[index].realImg
    if(indexOfSelectedPlanet != 0) {
        items.temperatureHint = dataset[indexOfSelectedPlanet].temperatureHint
        items.lengthOfYearHint = dataset[indexOfSelectedPlanet].lengthOfYearHint
    }
    initLevel()
}

function nextSubLevel(isAssessmentMode) {
    items.mainQuizScreen.closenessValueInMeter = 0
    if(items.assessmentMode && (items.mainQuizScreen.numberOfSubLevels >= 25 || currentSubLevel+1 > items.mainQuizScreen.score.numberOfSubLevels)) {
        items.mainQuizScreen.restartAssessmentMessage.visible = true
    }
    else if(currentSubLevel+1 > items.mainQuizScreen.score.numberOfSubLevels) {
        items.bonus.good("flower")
    }
    else {
        if(!isAssessmentMode)
            items.mainQuizScreen.question = currentPlanetLevels[currentSubLevel].question
        else {
            items.mainQuizScreen.question = assessmentModeQuestions[0].question
        }

        items.mainQuizScreen.optionListModel.clear()
        var optionListShuffle = [];
        if(!isAssessmentMode) {
            for(var i=0; i<4; i++) {
                optionListShuffle.push({
                       "optionValue": currentPlanetLevels[currentSubLevel].options[i],
                       "closeness": currentPlanetLevels[currentSubLevel].closeness[i]
                });
            }
        }
        else {
            for(var i=0; i<4; i++) {
                optionListShuffle.push({
                       "optionValue": assessmentModeQuestions[0].options[i],
                       "closeness": assessmentModeQuestions[0].closeness[i]
                });
            }
        }

        Core.shuffle(optionListShuffle)

        for(var i=0; i<4; i++) {
            items.mainQuizScreen.optionListModel.append(optionListShuffle[i])
        }

        currentSubLevel++
        items.mainQuizScreen.score.currentSubLevel = currentSubLevel
    }
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel ) {
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
