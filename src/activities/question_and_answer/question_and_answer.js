/* GCompris - question_and_answer.js
 *
 * Copyright (C) 2018 Amit Sagtani <asagtani06@gmail.com>
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

var currentLevel = 0
var numberOfLevel
var numberOfSubActivities
var currentActivityIndex = 0
var items
var dataset
var questions

function init(items_, dataset_) {
    items = items_
    dataset = dataset_.get()
    numberOfSubActivities = dataset.length
    items.menuModel.clear();
    initializeMenuScreen()
    start()
}

function initializeMenuScreen() {
    for(var i = 0; i < numberOfSubActivities; i++) {
        var data = {
            name: dataset[i]["category"],
            image: dataset[i]["category_image_src"],
        }
        items.menuModel.append(data)
    }
}

function start() {
    currentLevel = 0
    launchMenuScreen()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    items.startFinishButton.visibility = true
    items.showAnswerStatus = false
    items.levelStarted = false
    setQuestions()
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel) {
        currentLevel = 0
    }
    items.questionsGrid.visible = false
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    items.questionsGrid.visible = false
    initLevel();
}

function setQuestions() {
    //questions = []
    if(items.currentMode === "freeMode") {
        items.questions = dataset[currentActivityIndex]["questions"][currentLevel]
        items.answers = dataset[currentActivityIndex]["answers"][currentLevel]
    }
    //items.questions = questions
    items.questionsGrid.visible = true
}

function initializeSubActivity(index) {
    currentActivityIndex = index
    currentLevel = 0
    numberOfLevel = dataset[currentActivityIndex]["questions"].length
    items.noOfQuestions = numberOfLevel
    initLevel()
}

function launchMenuScreen() {
    items.menuScreen.start()
}

function checkAnswer() {

}
