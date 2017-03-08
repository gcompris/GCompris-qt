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
var question2 = []
var answer2 = []
var allQuestions = []
var allAnswers = []
var questionOfLevel = []
var answerOfLevel = []
var scoreCounter = 0
var uppercaseOnly;
var selectedQuestions = []
var selectedAnswers = []

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
    if(items.isSchoolMode == "school"){
        loadSchoolMode()
        console.log("school mode")
        resetvalue2();
        items.startButton.text = qsTr("START")
        items.score.visible = false
        items.time.text = "--"
        loadSelectedQuestions()
        cannotAnswer2()
    }

    else{
    console.log("normad mode")
    resetvalue();
    items.startButton.text = qsTr("START")
    items.score.visible = false
    items.time.text = "--"
    loadQuestions()
    cannotAnswer()
}

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


function loadSelectedQuestions() {
    var i
    var j
    question2 = selectedQuestions
    answer2 = selectedAnswers
    for (i = 0; i < question2.length; i++) {
        items.repeater.itemAt(i).questionText = qsTr(question2[i]) + " = "
    }
}


function loadSchoolMode() {
    items.repeaterModel = selectedQuestions
}


function loadQuestions2() {
    var i
    var j
    var t1 = 0
    var t2 = 0
    for (i = 0; i < numberOfLevel; i++) {
          questionOfLevel = dataset[i].questions
          answerOfLevel = dataset[i].answers
          for(j = 0; j < questionOfLevel.length;j++){
                allQuestions[t1] = questionOfLevel[j]
                t1 = t1 + 1
          }
          for(j = 0; j < answerOfLevel.length;j++){
                allAnswers[t2] = answerOfLevel[j]
                t2 = t2 + 1
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

function verifyAnswer2() {
    var j
    for (j = 0; j < question2.length; j++) {
        if (items.repeater.itemAt(j).answerText.toString() == answer2[j]) {
            scoreCounter = scoreCounter + 1
            items.repeater.itemAt(j).questionImage = url + "right.svg"
            items.repeater.itemAt(j).questionImageOpacity = 1
        }
        else if(items.repeater.itemAt(j).answerText.toString() != answer2[j] && items.repeater.itemAt(j).answerText.toString() != ""){
            items.repeater.itemAt(j).questionImageOpacity = 1
            items.repeater.itemAt(j).questionImage = url + "wrong.svg"
        }
    }
    items.score.text = qsTr("Your Score :-  %1").arg(scoreCounter.toString())
}


function processKeyPress(text) {
    var typedText = uppercaseOnly ? text.toLocaleUpperCase() : text;

    if (currentWord !== null) {
        // check against a currently typed word
        if (!currentWord.checkMatch(typedText)) {
            currentWord = null;
            audioCrashPlay()
        } else {
            playLetter(text)
        }
    } else {
        // no current word, check against all available words
        var found = false
        for (var i = 0; i< droppedWords.length; i++) {
            if (droppedWords[i].checkMatch(typedText)) {
                // typed correctly
                currentWord = droppedWords[i];
                playLetter(text)
                found = true
                break;
            }
        }
        if(!found) {
            audioCrashPlay()
        }
    }
    if (currentWord !== null && currentWord.isCompleted()) {
        // win!
        currentWord.won();  // note: deleteWord() is triggered after fadeout
        successRate += 0.1
        currentWord = null
        nextSubLevel();
    }
}


function canAnswer() {
    var q
    for (q = 0; q < question.length; q++) {
        items.repeater.itemAt(q).answerTextReadonly = false
    }
}

function canAnswer2() {
    var q
    for (q = 0; q < question2.length; q++) {
        items.repeater.itemAt(q).answerTextReadonly = false
    }
}

function cannotAnswer() {
    var r
    for (r = 0; r < question.length; r++) {
        items.repeater.itemAt(r).answerTextReadonly = true
    }
}

function cannotAnswer2() {
    var r
    for (r = 0; r < question2.length; r++) {
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

function resetvalue2() {
    var k
    for (k = 0; k < question2.length; k++) {
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
