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
}

function startAssessmentMode() {
    items.solarSystemVisible = false
    items.quizScreenVisible = true
    currentSubLevel = 0
    items.mainQuizScreen.score.numberOfSubLevels = 0
    allQuestions = []
    for(var i = 0; i < dataset.length; i++) {
        for(var j = 0; j < dataset[i].levels.length; j++)
            allQuestions.push(dataset[i].levels[j])
        items.mainQuizScreen.score.numberOfSubLevels += dataset[i].levels.length
    }
    Core.shuffle(allQuestions)
    nextSubLevel(true)
}

function showQuizScreen(index) {
    currentLevel = 0
    indexOfSelectedPlanet = index
    items.solarSystemVisible = false
    items.quizScreenVisible = true
    currentPlanetLevels = dataset[index].levels
    items.mainQuizScreen.planetRealImage = dataset[index].realImg
    items.hintDialog.hint1 = qsTr("1. The <b>farther</b> a planet from the Sun, the <b>lower</b> is it's temperature.<br><font color=\"#3bb0de\">%1</font>").arg(dataset[indexOfSelectedPlanet].temperatureHint)
    items.hintDialog.hint2 = qsTr("2. Duration of an year on a planet <b>increases as we go away from the Sun</b>.<br><font color=\"#3bb0de\">%1</font>").arg(dataset[indexOfSelectedPlanet].lengthOfYearHint)
    initLevel();
}

function nextSubLevel(isAssessmentMode) {
    items.mainQuizScreen.closenessValueInMeter = 0
    if(currentSubLevel+1 > items.mainQuizScreen.score.numberOfSubLevels)
        items.bonus.good("flower")
    else {
        if(!isAssessmentMode)
            items.mainQuizScreen.question = currentPlanetLevels[currentSubLevel].question
        else {
            items.mainQuizScreen.question = allQuestions[currentSubLevel].question
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
                       "optionValue": allQuestions[currentSubLevel].options[i],
                       "closeness": allQuestions[currentSubLevel].closeness[i]
                });
            }
        }

        Core.shuffle(optionListShuffle)

        for(var i=0; i<4; i++) {
            items.mainQuizScreen.optionListModel.append(optionListShuffle[i])
        }

        currentSubLevel++;
        items.mainQuizScreen.score.currentSubLevel = currentSubLevel
    }
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel ) {
        currentLevel = 0
    }
    if(!items.assessmentMode)
        initLevel();
    else
        startAssessmentMode()
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel();
}
