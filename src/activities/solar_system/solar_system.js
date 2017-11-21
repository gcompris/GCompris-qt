/* GCompris - solar_system.js
 *
 * Copyright (C) 2017 Aman Kumar Gupta <gupta2140@gmail.com>
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

function start(items_) {
    items = items_
    currentLevel = 0
    dataset= Dataset.get()
    for(var i = 0;  i < dataset.length; ++i) {
        items.containerModel.append({
                "clipImg": dataset[i].clipImg,
                "bodyName": dataset[i].bodyName
        });
    }
    items.solarSystemVisible = true
}

function stop() {
}

function initLevel() {
    currentSubLevel = 0
    items.bar.level = currentLevel + 1
    items.mainQuizScreen.score.numberOfSubLevels = currentPlanetLevels.length
    Core.shuffle(currentPlanetLevels)
    nextSubLevel();
}

function showSolarModel() {
    currentLevel = 0
    items.quizScreenVisible = false
    items.solarSystemVisible = true
}

function showQuizScreen(index) {
    items.solarSystemVisible = false
    items.quizScreenVisible = true
    currentPlanetLevels = dataset[index].levels
    items.mainQuizScreen.planetRealImage = dataset[index].realImg
    initLevel();
}

function nextSubLevel() {
    items.mainQuizScreen.closenessValueInMeter = "0%"
    if(currentSubLevel+1 > items.mainQuizScreen.score.numberOfSubLevels)
        items.bonus.good("flower")
    else {
        items.mainQuizScreen.question = currentPlanetLevels[currentSubLevel].question
        items.mainQuizScreen.optionListModel.clear()
        for(var i=0; i<4; i++) {
            items.mainQuizScreen.optionListModel.append({
                   "optionValue": currentPlanetLevels[currentSubLevel].options[i],
                   "closeness": currentPlanetLevels[currentSubLevel].closeness[i]
            });
        }
        currentSubLevel++;
        items.mainQuizScreen.score.currentSubLevel = currentSubLevel
    }
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
