/* GCompris - braille_alphabets.js
 *
 * SPDX-FileCopyrightText: 2014 Arkit Vora <arkitvora123@gmail.com>
 *
 * Authors:
 *   Srishti Sethi <srishakatux@gmail.com> (GTK+ version)
 *   Arkit Vora <arkitvora123@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.12 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var url = "qrc:/gcompris/src/activities/braille_alphabets/resource/"

var numberOfLevel
var items
var dataset
var currentQuestion
var currentDataSet

function start(items_, dataset_) {
    items = items_
    dataset = dataset_.get()
    numberOfLevel = dataset.length * 2
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    initLevel()
}

function stop() {
}

function initLevel() {
    items.levelComplete = false
    items.containerModel.clear()
    currentQuestion = 0

    switch(items.currentLevel) {
        case 0:
            items.instructions = ""
            items.brailleCodeSeen = true
            currentDataSet = dataset[0].slice()
            break
        case 1:
            items.instructions = qsTr("Now it's a little bit harder without the reference.")
            items.brailleCodeSeen = false
            currentDataSet = dataset[0].slice()
            break
        case 2:
            items.instructions = qsTr("Look at the braille character chart and observe how similar the first and second lines are.")
            items.brailleCodeSeen = true
            currentDataSet = dataset[1].slice()
            break
        case 3:
            items.instructions = qsTr("Now it's a little bit harder without the reference.")
            items.brailleCodeSeen = false
            currentDataSet = dataset[1].slice()
            break
        case 4:
            items.instructions = qsTr("Again, similar to the first line in the character chart but take care, the 'W' letter was added afterward.")
            items.brailleCodeSeen = true
            currentDataSet = dataset[2].slice()
            break
        case 5:
            items.instructions = qsTr("Now it's a little bit harder without the reference.")
            items.brailleCodeSeen = false
            currentDataSet = dataset[2].slice()
            break
        case 6:
            items.instructions = qsTr("This is easy, numbers are the same as letters from A to J.")
            items.brailleCodeSeen = true
            currentDataSet = dataset[3].slice()
            break
        case 7:
            items.instructions = qsTr("Now it's a little bit harder without the reference.")
            items.brailleCodeSeen = false
            currentDataSet = dataset[3].slice()
            break
        case 8:
            items.instructions = ""
            items.brailleCodeSeen = true
            currentDataSet = dataset[4].slice()
            break
        case 9:
            items.instructions = qsTr("Now it's a little bit harder without the reference.")
            items.brailleCodeSeen = false
            currentDataSet = dataset[4].slice()
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
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function goodAnswer() {
    items.score.currentSubLevel ++
    items.score.playWinAnimation()
    if(currentDataSet.length <= ++currentQuestion) {
        items.levelComplete = true
        items.bonus.good("flower")
    }
}

function nextQuestion() {
    // We just set the opacity to 0, the questionItem will then grab
    // the new question by itself
    items.questionItem.opacity = 0
}

function getCurrentTextQuestion() {
    return currentDataSet[currentQuestion].text.arg(getCurrentLetter())
}

function getCurrentLetter() {
    return currentDataSet[currentQuestion].letter
}

