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
.import "dataset.js" as Dataset
.import "qrc:/gcompris/src/core/core.js" as Core

var currentLevel = 0
var numberOfLevel = 18
var items
var dataset
var currentLevelData
var currentSublevelData
var correctAnswerCount = []

function start(items_) {
    items = items_
    currentLevel = 0
    items.piano.currentOctaveNb = 0
    dataset = Dataset.getData()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    currentLevelData = dataset[currentLevel]
    Core.shuffle(currentLevelData)
    items.score.currentSubLevel = 1
    items.piano.currentOctaveNb = 0
    if(currentLevel < 12) {
        items.background.clefType = "Treble"
        items.piano.currentOctaveNb = currentLevel % 4
    }
    else {
        items.background.clefType = "Bass"
        items.piano.currentOctaveNb = currentLevel % 2
    }
    items.multipleStaff.initClefs(items.background.clefType)

    initSubLevel()
}

function initSubLevel() {
    currentSublevelData = currentLevelData[items.score.currentSubLevel - 1].split(" ")
    correctAnswerCount = []
    displayNote(currentSublevelData[0])
}

function nextSubLevel () {
    items.score.currentSubLevel++
    if(items.score.currentSubLevel > items.score.numberOfSubLevels)
        nextLevel()
    else
        initSubLevel()
}

function displayNote(currentNote) {
    var noteName, noteType
    if(currentNote[1] === '#' || currentNote[1] === 'b') {
        noteName = currentNote.substr(0, 3)
        noteType = currentNote.substr(3, currentNote.length)
    }
    else {
        noteName = currentNote.substr(0, 2)
        noteType = currentNote.substr(2, currentNote.length)
    }

    items.multipleStaff.addMusicElement("note", noteName, noteType, false, false, items.background.clefType)
}

function wrongAnswer() {
    if(correctAnswerCount[currentSublevelData[0]]) {
        for(var i = 0; i < correctAnswerCount[currentSublevelData[0]]; i++)
            currentSublevelData.push(currentSublevelData[0])
    }

    correctAnswerCount[currentSublevelData[0]] = 0

    if(currentSublevelData[currentSublevelData.length - 1] != currentSublevelData[0])
        currentSublevelData.push(currentSublevelData.shift())
    else {
        currentSublevelData.push(currentSublevelData[1])
        currentSublevelData.push(currentSublevelData.shift())
        currentSublevelData.shift()
    }
    items.multipleStaff.musicElementModel.remove(1)
    console.log("Wrong answer...New sequence:")
    for(var i = 0; i < currentSublevelData.length; i++) {
        console.log(currentSublevelData[i])
    }

    displayNote(currentSublevelData[0])
}

function correctAnswer() {
    if(correctAnswerCount[currentSublevelData[0]] == undefined)
        correctAnswerCount[currentSublevelData[0]] = 0

    correctAnswerCount[currentSublevelData[0]]++
    items.multipleStaff.musicElementModel.remove(1)
    currentSublevelData.shift()
    console.log("Correct answer...New sequence:")
    for(var i = 0; i < currentSublevelData.length; i++) {
        console.log(currentSublevelData[i])
    }
    if(currentSublevelData.length != 0)
        displayNote(currentSublevelData[0])
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

