/* GCompris - multiplication_tables.js
*
* Copyright (C) 2016 Nitish Chauhan <nitish.nc18@gmail.com>
*
* Authors:
*
*   "Nitish Chauhan" <nitish.nc18@gmail.com>
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
.import QtQuick 2.2 as Quick
.import GCompris 1.0 as GCompris //for ApplicationInfo
.import "qrc:/gcompris/src/core/core.js" as Core

var currentLevel = 0
var items
var dataset
var numberOfLevel
var url
var table
var question = []
var answer = []
var question2 = []
var answer2 = []
var allQuestions = []
var allAnswers = []
var questionOfLevel = []
var answerOfLevel = []
var scoreCounter = 0
var selectedQuestions = []
var selectedAnswers = []

function start(_items, _dataset, _url) {
    items = _items
    dataset = _dataset.get()
    url = _url
    numberOfLevel = dataset.length
    currentLevel = 0
    initLevel()
    loadAllQuestionAnswer()
}

function stop() {}

function initLevel() {
    items.bar.level = currentLevel + 1
    if (items.modeType == "school") {
        loadSchoolMode()
        loadSelectedQuestions()
    } else {
        loadAllQuestionAnswer()
        items.repeaterModel = 10
        loadQuestions()
    }
    items.startButton.text = qsTr("START")
    items.score.visible = false
    items.time.text = "--"
    resetvalue()
    canAnswer(false)
}

function loadQuestions() {
    var i
    var j
    question = dataset[currentLevel].questions
    answer = dataset[currentLevel].answers
    table = dataset[currentLevel].tableName
    for (i = 0; i < question.length; i++) {
        items.repeater.itemAt(i).questionText = qsTr(question[i])
    }
}

function loadSelectedQuestions() {
    var i = 0
    question2 = selectedQuestions
    answer2 = selectedAnswers
    for (i = 0; i < question2.length; i++) {
        items.repeater.itemAt(i).questionText = qsTr(question2[i])
    }
}

function loadSchoolMode() {
    items.repeaterModel = selectedQuestions
}

function flushQuestionsAnswers() {
    selectedQuestions = []
    selectedAnswers = []
    question2 = []
    answer2 = []
}

function loadAllQuestionAnswer() {
    var i
    for (i = 0; i < numberOfLevel; i++) {
        questionOfLevel = dataset[i].questions
        answerOfLevel = dataset[i].answers
        allQuestions = allQuestions.concat(questionOfLevel)
        allAnswers = allAnswers.concat(answerOfLevel)
    }
}

function verifyAnswer() {
    var j
    for (j = 0; j < question.length; j++) {
        var repeater_item = items.repeater.itemAt(j)
        if (repeater_item.answerText.toString() == answer[j]) {
            scoreCounter = scoreCounter + 1
            repeater_item.questionImage = url + "right.svg"
            repeater_item.questionImageOpacity = 1
        } else if (repeater_item.answerText.toString() != "") {
            repeater_item.questionImageOpacity = 1
            repeater_item.questionImage = url + "wrong.svg"
        }
    }
    items.score.text = qsTr("Your Score :-  %1").arg(scoreCounter.toString())
}

function verifySelectedAnswer() {
    var j
    for (j = 0; j < question2.length; j++) {
        var repeater_item = items.repeater.itemAt(j)
        if (repeater_item.answerText.toString() == answer2[j]) {
            scoreCounter = scoreCounter + 1
            repeater_item.questionImage = url + "right.svg"
            repeater_item.questionImageOpacity = 1
        } else if (repeater_item.answerText.toString() != "") {
            repeater_item.questionImageOpacity = 1
            repeater_item.questionImage = url + "wrong.svg"
        }
    }
    items.score.text = qsTr("Your Score :-  %1").arg(scoreCounter.toString())
}

function canAnswer(answerOrNot) {
    var q
    var questionList
    questionList = question
    if (items.modeType == "school") {
        questionList = question2
    }
    for (q = 0; q < questionList.length; q++) {
        if(answerOrNot){
            items.repeater.itemAt(q).answerTextReadonly = false
        }
        else{
        items.repeater.itemAt(q).answerTextReadonly = true
        }
    }
}

function resetvalue() {
    var k
    var questionList
    if (items.modeType == "school") {
        questionList = question2
    } else {
        questionList = question
    }
    for (k = 0; k < questionList.length; k++) {
        items.repeater.itemAt(k).answerText = ""
        items.repeater.itemAt(k).questionImageOpacity = 0
    }
    scoreCounter = 0
    items.score.visible = false
}

function nextLevel() {
    if (numberOfLevel <= ++currentLevel) {
        currentLevel = 0
    }
    initLevel();
}

function previousLevel() {
    if (--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel();
}
