/* GCompris - braille_alphabets.js
 *
 * Copyright (C) 2014 Arkit Vora <arkitvora123@gmail.com>
 *
 * Authors:
 *   Srishti Sethi <srishakatux@gmail.com> (GTK+ version)
 *   Arkit Vora <arkitvora123@gmail.com> (Qt Quick port)
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
.pragma library
.import QtQuick 2.6 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var url = "qrc:/gcompris/src/activities/braille_alphabets/resource/"

var currentLevel
var numberOfLevel
var items
var dataset
var currentQuestion
var currentDataSet

function start(items_, dataset_) {
    items = items_
    dataset = dataset_.get()
    currentLevel = 0
    numberOfLevel = dataset.length * 2
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    items.containerModel.clear()
    currentQuestion = 0

    switch(currentLevel) {
        case 0:
            items.instructions = ""
            items.brailleCodeSeen = true
            currentDataSet = dataset[0]
            break
        case 1:
            items.instructions = qsTr("Now it's a little bit harder without the braille map.")
            items.brailleCodeSeen = false
            currentDataSet = dataset[0]
            break
        case 2:
            items.instructions = qsTr("Look at the Braille character map and observe how similar the first and second line are.")
            items.brailleCodeSeen = true
            currentDataSet = dataset[1]
            break
        case 3:
            items.instructions = qsTr("Now it's a little bit harder without the braille map.")
            items.brailleCodeSeen = false
            currentDataSet = dataset[1]
            break
        case 4:
            items.instructions = qsTr("Again, similar as the first line but take care, the 'W' letter was added afterwards.")
            items.brailleCodeSeen = true
            currentDataSet = dataset[2]
            break
        case 5:
            items.instructions = qsTr("Now it's a little bit harder without the braille map.")
            items.brailleCodeSeen = false
            currentDataSet = dataset[2]
            break
        case 6:
            items.instructions = qsTr("This is easy, numbers are the same as letters from A to J.")
            items.brailleCodeSeen = true
            currentDataSet = dataset[3]
            break
        case 7:
            items.instructions = qsTr("Now it's a little bit harder without the braille map.")
            items.brailleCodeSeen = false
            currentDataSet = dataset[3]
            break
        case 8:
            items.instructions = ""
            items.brailleCodeSeen = true
            currentDataSet = dataset[4]
            break
        case 9:
            items.instructions = qsTr("Now it's a little bit harder without the braille map.")
            items.brailleCodeSeen = false
            currentDataSet = dataset[4]
            break
    }

    for(var i = 0;  i < currentDataSet.length; ++i) {
        items.containerModel.append(currentDataSet[i])
    }

    // Shuffle not to ask the question in the model order
    currentDataSet = Core.shuffle(currentDataSet)

    items.score.numberOfSubLevels = currentDataSet.length;
    items.score.currentSubLevel = 0;

    items.playableChar.isLetter = currentDataSet[0].letter >= "A" && currentDataSet[0].letter <= "Z"
    // Trig the next question
    items.questionItem.opacity = 0.1
    items.questionItem.opacity = 0
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel) {
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

function nextQuestion() {
    if(currentDataSet.length <= ++currentQuestion) {
        items.bonus.good("flower")
    } else {
        // Let's not change the question immediately to let the
        // children see his answer.
        // We just set the opacity to 0, the questionItem will then grab
        // the new question by itself
        items.questionItem.opacity = 0.1
        items.questionItem.opacity = 0
        items.score.currentSubLevel ++
    }
}

function getCurrentTextQuestion() {
    return currentDataSet[currentQuestion].text.arg(getCurrentLetter())
}

function getCurrentLetter() {
    return currentDataSet[currentQuestion].letter
}

