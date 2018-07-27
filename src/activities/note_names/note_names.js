/* GCompris - note_names.js
 *
 * Copyright (C) 2016 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
 *   Johnny Jazeix <jazeix@gmail.com> (Qt Quick port)
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
.import QtQuick 2.0 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var currentLevel = 0
var numberOfLevel
var items
var dataset
var correctAnswerCount = []
var sequence

function start(items_) {
    items = items_
    currentLevel = 0
    dataset = items.dataset.item.levels
    numberOfLevel = dataset.length
}

function stop() {
}

function initLevel() {
    correctAnswerCount = []
    sequence = []
    items.bar.level = currentLevel + 1
    items.background.clefType = dataset[currentLevel]["clef"]
    items.piano.currentOctaveNb = 1
    items.piano2.currentOctaveNb = 1
    items.multipleStaff.stopNoteAnimation()
    items.wrongAnswerAnimation.stop()
    items.multipleStaff.initClefs(items.background.clefType)
    sequence = JSON.parse(JSON.stringify(dataset[currentLevel]["sequence"]))
    items.isTutorialMode = true
    showTutorial()
}

function showTutorial() {
    items.messageBox.visible = false
    if(sequence.length) {
        displayNote(sequence[0])
        items.messageBox.visible = true
        sequence.shift()
    }
    else {
        items.isTutorialMode = false
        startGame()
    }
}

function startGame() {
    sequence = JSON.parse(JSON.stringify(dataset[currentLevel]["sequence"]))
    for(var i = 0; i < 2; i++) {
        for(var j = 0; j < dataset[currentLevel]["sequence"].length; j++)
            sequence.push(dataset[currentLevel]["sequence"][j])
    }
    Core.shuffle(sequence)
    displayNote(sequence[0])
}

function displayNote(currentNote) {
    items.multipleStaff.addMusicElement("note", currentNote, "Quarter", false, false, items.background.clefType)
}

function wrongAnswer() {
    if(sequence.length) {
        if(correctAnswerCount[sequence[0]]) {
            for(var i = 0; i < correctAnswerCount[sequence[0]]; i++)
                sequence.push(sequence[0])
        }

        correctAnswerCount[sequence[0]] = 0

        if(sequence[sequence.length - 1] != sequence[0])
            sequence.push(sequence.shift())
        else {
            sequence.push(sequence[1])
            sequence.push(sequence.shift())
            sequence.shift()
        }
        items.multipleStaff.musicElementModel.remove(1)
        console.log("Wrong answer...New sequence:")
        for(var i = 0; i < sequence.length; i++) {
            console.log(sequence[i])
        }

        displayNote(sequence[0])
    }
}

function correctAnswer() {
    if(correctAnswerCount[sequence[0]] == undefined)
        correctAnswerCount[sequence[0]] = 0

    correctAnswerCount[sequence[0]]++
    items.multipleStaff.musicElementModel.remove(1)
    sequence.shift()
    console.log("Correct answer...New sequence:")
    for(var i = 0; i < sequence.length; i++) {
        console.log(sequence[i])
    }
    if(sequence.length != 0)
        displayNote(sequence[0])
    else
        items.bonus.good("flower")
}

function checkAnswer(noteName) {
    if(noteName === items.multipleStaff.musicElementModel.get(1).noteName_)
        correctAnswer()
    else
        items.wrongAnswerAnimation.start()
}

function nextLevel() {
    if(!items.iAmReady.visible) {
        if(numberOfLevel <= ++ currentLevel) {
            currentLevel = 0
        }
        initLevel()
    }
}

function previousLevel() {
    if(!items.iAmReady.visible) {
        if(--currentLevel < 0) {
            currentLevel = numberOfLevel - 1
        }
        initLevel()
    }
}

