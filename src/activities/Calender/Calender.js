/* GCompris - Calender.js
 *
 * Copyright (C) 2017 YOUR NAME <xx@yy.org>
 *
 * Authors:
 *   <THE GTK VERSION AUTHOR> (GTK+ version)
 *   "YOUR NAME" <YOUR EMAIL> (Qt Quick port)
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
var numbersOfSublevel
var currentSubLevel = 1
var currentDataSet
var itemsconnect
var dataset
var items
var dateSelected
var correctAnswer


function start(items_, dataset_) {
    items = items_
    dataset = dataset_.get()
    numberOfLevel = dataset.length
    currentLevel = 0
    initLevel()
}

function stop() {
}

function initLevel() {
    currentSubLevel = 1;
    items.bar.level = currentLevel + 1
    levelConfigurations()
    initQuestion()

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

function levelConfigurations() {
    switch(items.bar.level) {
    case 1:
        items.calender.navigationBarVisible = false
        items.calender.visibleMonth = 2
        items.calender.visibleYear = 2018
        items.calender.minimumDate = "2018-03-01"
        items.calender.maximumDate = "2018-03-31"
        currentDataSet = dataset[0]
        break;
    case 2:
        items.calender.navigationBarVisible = true
        items.calender.visibleMonth = new Date().getMonth()
        items.calender.visibleYear = new Date().getFullYear()
        currentDataSet = dataset[1]
        break;

    }
    items.score.numberOfSubLevels = dataset[currentLevel].length
    items.score.currentSubLevel = currentSubLevel

}

function initQuestion() {
    if(currentDataSet.length === currentSubLevel) {
        items.bonus.good("flower")
        nextLevel()
    }
    else {
        items.questionItem.text = currentDataSet[currentSubLevel-1]["question"]
        correctAnswer = currentDataSet[currentSubLevel-1]["answer"]
    }


}

function checkAnswer() {
    switch(items.bar.level) {
     case 1:
         if(dateSelected.getDate() === correctAnswer) {
             console.log("Right Answer")
             currentSubLevel ++
             initQuestion()
         }


    }
}
