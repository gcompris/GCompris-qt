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
var items
var mode
var dataset
var numberOfLevel
var url
var table
var question = []
var answer = []
var score_cnt = 0


function start(_items, _mode, _dataset, _url) {

    items = _items
    mode = _mode
    dataset = _dataset.get()
    url = _url
    numberOfLevel = dataset.length
    currentLevel = 0
    initLevel()

}


function stop() {}

function initLevel() {

    items.bar.level = currentLevel + 1
    loadQuestions()

}


function loadQuestions() {

    var i

    question = dataset[currentLevel].questions
    answer = dataset[currentLevel].answers
    table = dataset[currentLevel].TableName


    for (i = 0; i < question.length; i++) {

        items.repeater.itemAt(i).questionText = qsTr("%1 = ").arg(question[i])

    }

}


function verifyAnswer() {

    var j

    for (j = 0; j < question.length; j++) {

        if (items.repeater.itemAt(j).answerText.toString() == answer[j]) {

            score_cnt = score_cnt + 1
            items.repeater.itemAt(j).questionImage = url + "right.svg"
            items.repeater.itemAt(j).questionImage_visible = 1


        } else {

            items.repeater.itemAt(j).questionImage_visible = 1
            items.repeater.itemAt(j).questionImage = url + "wrong.svg"

        }

    }


    items.score.text = qsTr("Your Score :-  %1").arg(score_cnt.toString())

}



function resetvalue() {

    var k

    for (k = 0; k < question.length; k++) {


        items.repeater.itemAt(k).answerText = ""
        items.repeater.itemAt(k).questionImage_visible = 0


        score_cnt = 0
        items.score.visible = false

    }

    score_cnt = 0
    items.score.visible = false

}




function nextLevel() {


    if (numberOfLevel <= ++currentLevel) {
        currentLevel = 0
    }
    initLevel();
    resetvalue();
    items.start_button.text = qsTr("START")
    items.score.visible = false
    items.time.text = qsTr("--")
}

function previousLevel() {
    if (--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel();
    resetvalue();
    items.score.visible = false
    items.time.text = qsTr("--")
}
