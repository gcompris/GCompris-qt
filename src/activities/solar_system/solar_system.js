/* GCompris - solar_system.js
 *
 * SPDX-FileCopyrightText: 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Aman Kumar Gupta <gupta2140@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.12 as Quick
.import "Dataset.js" as Dataset
.import "qrc:/gcompris/src/core/core.js" as Core

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
    items.currentLevel = 0
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
            items.hintProvided = currentPlanetLevels[currentSubLevel].hintProvided
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
    items.currentLevel = 0
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
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    if(!items.assessmentMode)
        initLevel()
    else
        startAssessmentMode()
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}
