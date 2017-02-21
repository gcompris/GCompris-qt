/* GCompris - multiplication_tables.js
*
* Copyright (C) 2016 Nitish Chauhan <nitish.nc18@gmail.com>
*
* Authors:
*
*   "Nitish Chauhan" <nitish.nc18@gmail.com> (Qt Quick port)
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
var schoolMode
var items
var mode
var dataset
var numberOfLevel
var url
var table
var question = []
var answer = []
var allQuestions = []
var questionOfLevel = []
var scoreCounter = 0

function start(_items, _mode, _dataset, _url) {
    items = _items
    mode = _mode
    dataset = _dataset.get()
    url = _url
    numberOfLevel = dataset.length
    currentLevel = 0
    initLevel()
    loadQuestions2()
}

function stop() {}

function initLevel() {
    items.bar.level = currentLevel + 1
    resetvalue();
    items.startButton.text = qsTr("START")
    items.score.visible = false
    items.time.text = "--"
    loadQuestions()
    cannotAnswer()
   // saveCheckedBoxes()
}

function loadQuestions() {
    var i
    var j
    question = dataset[currentLevel].questions
    answer = dataset[currentLevel].answers
    table = dataset[currentLevel].tableName

    for (i = 0; i < question.length; i++) {
        items.repeater.itemAt(i).questionText = qsTr(question[i]) + " = "
    }
}

////to be implemented
//function saveCheckedBoxes(){
//    for (var i = 0; i < allQuestions.length; i++) {
//    }
//}


function loadQuestions2() {
    var i
    var j
    var t = 0
    for (i = 0; i < numberOfLevel; i++) {
          questionOfLevel = dataset[i].questions
          for(j = 0; j < questionOfLevel.length;j++){
                allQuestions[t] = questionOfLevel[j]
                t = t + 1
          }
    }
}

function verifyAnswer() {
    var j
    for (j = 0; j < question.length; j++) {
        if (items.repeater.itemAt(j).answerText.toString() == answer[j]) {
            scoreCounter = scoreCounter + 1
            items.repeater.itemAt(j).questionImage = url + "right.svg"
            items.repeater.itemAt(j).questionImageOpacity = 1
        }
        else if(items.repeater.itemAt(j).answerText.toString() != answer[j] && items.repeater.itemAt(j).answerText.toString() != ""){
            items.repeater.itemAt(j).questionImageOpacity = 1
            items.repeater.itemAt(j).questionImage = url + "wrong.svg"
        }
    }
    items.score.text = qsTr("Your Score :-  %1").arg(scoreCounter.toString())
}

function canAnswer() {
    var q
    for (q = 0; q < question.length; q++) {
        items.repeater.itemAt(q).answerTextReadonly = false
    }
}

function cannotAnswer() {
    var r
    for (r = 0; r < question.length; r++) {
        items.repeater.itemAt(r).answerTextReadonly = true
    }
}

function resetvalue() {
    var k
    for (k = 0; k < question.length; k++) {
        items.repeater.itemAt(k).answerText = ""
        items.repeater.itemAt(k).questionImageOpacity = 0
        scoreCounter = 0
        items.score.visible = false
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
