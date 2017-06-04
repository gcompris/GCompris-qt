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
var question_selected = []
var answer_selected = []
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
        items.repeaterModel = dataset[0].questions.length
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
    question = dataset[currentLevel].questions
    answer = dataset[currentLevel].answers
    table = dataset[currentLevel].tableName
    for (i = 0; i < question.length; i++) {
        items.repeater.itemAt(i).questionText = qsTr(question[i])
    }
}

function loadSelectedQuestions() {
    var i = 0
    question_selected = selectedQuestions
    answer_selected = selectedAnswers
    for (i = 0; i < question_selected.length; i++) {
        items.repeater.itemAt(i).questionText = qsTr(question_selected[i])
    }
}

function loadSchoolMode() {
    items.repeaterModel = selectedQuestions
}

function flushQuestionsAnswers() {
    selectedQuestions = []
    selectedAnswers = []
    question_selected = []
    answer_selected = []
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
    var answer_item
    for (answer_item = 0; answer_item < question.length; answer_item++) {
        var repeater_item = items.repeater.itemAt(answer_item)
        repeater_item.questionImageOpacity = 1
        repeater_item.questionImage = url + "wrong.svg"
        if (repeater_item.answerText.toString() == answer[answer_item]) {
            scoreCounter = scoreCounter + 1
            repeater_item.questionImage = url + "right.svg"
            repeater_item.questionImageOpacity = 1
        }
    }
    items.score.text = qsTr("Your Score :-  %1").arg(scoreCounter.toString())
}

function verifySelectedAnswer() {
    var answer_item
    for (answer_item = 0; answer_item < question_selected.length; answer_item++) {
        var repeater_item = items.repeater.itemAt(answer_item)
        repeater_item.questionImageOpacity = 1
        repeater_item.questionImage = url + "wrong.svg"
        if (repeater_item.answerText.toString() == answer_selected[answer_item]) {
            scoreCounter = scoreCounter + 1
            repeater_item.questionImage = url + "right.svg"
            repeater_item.questionImageOpacity = 1
        }
    }
    items.score.text = qsTr("Your Score :-  %1").arg(scoreCounter.toString())
}

function canAnswer(answerOrNot) {
    var q
    var questionList = []
    questionList = question
    if (items.modeType == "school") {
        questionList = question_selected
    }
    for (q = 0; q < questionList.length; q++) {
        var repeater_item = items.repeater.itemAt(q)
        repeater_item.answerTextReadonly = true
        if(answerOrNot){
            repeater_item.answerTextReadonly = false
        }
    }
}

function resetvalue() {
    var k
    var questionList = []
    questionList = question
    if (items.modeType == "school") {
        questionList = question_selected
    }
    for (k = 0; k < questionList.length; k++) {
        var repeater_item = items.repeater.itemAt(k)
        repeater_item.answerText = ""
        repeater_item.questionImageOpacity = 0
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
