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
var dataset
var items
var levels
var targetNotes = []
var newNotesSequence = []
var currentNoteIndex
var noteIndexToDisplay

function start(items_) {
    items = items_
    currentLevel = 0
    dataset = items.dataset.item
    levels = dataset.levels
    numberOfLevel = levels.length
    items.message.intro = [dataset.objective]
}

function stop() {
    newNotesSequence = []
    items.multipleStaff.pauseNoteAnimation()
    items.wrongAnswerAnimation.stop()
    items.addNoteTimer.stop()
}

function initLevel() {
    targetNotes = []
    newNotesSequence = []
    items.bar.level = currentLevel + 1
    items.background.clefType = levels[currentLevel]["clef"]
    items.piano.currentOctaveNb = 1
    items.piano2.currentOctaveNb = 1
    items.multipleStaff.pauseNoteAnimation()
    items.wrongAnswerAnimation.stop()
    items.addNoteTimer.stop()
    items.multipleStaff.initClefs(items.background.clefType)
    targetNotes = JSON.parse(JSON.stringify(levels[currentLevel]["sequence"]))
    items.isTutorialMode = true
    items.multipleStaff.coloredNotes = dataset.referenceNotes[items.background.clefType]
    showTutorial()
}

function showTutorial() {
    items.messageBox.visible = false
    if(targetNotes.length) {
        displayNote(targetNotes[0])
        items.messageBox.visible = true
        targetNotes.shift()
    }
    else {
        items.isTutorialMode = false
        startGame()
    }
}

function formNewNotesSequence() {
    targetNotes = JSON.parse(JSON.stringify(levels[currentLevel]["sequence"]))
    for(var i = 0; i < currentLevel && newNotesSequence.length < 25; i++) {
        if(levels[currentLevel]["clef"] === levels[i]["clef"]) {
            for(var j = 0; j < levels[i]["sequence"].length && newNotesSequence.length < 25; j++)
                newNotesSequence.push(levels[i]["sequence"][j])
        }
    }

    for(var i = 0; newNotesSequence.length && newNotesSequence.length < 25; i++)
        newNotesSequence.push(newNotesSequence[i % newNotesSequence.length])

    for(var i = 0; newNotesSequence.length < 50; i++)
        newNotesSequence.push(targetNotes[i % targetNotes.length])

    Core.shuffle(newNotesSequence)
}

function startGame() {
    currentNoteIndex = 0
    noteIndexToDisplay = 0
    items.progressBar.percentage = 0
    formNewNotesSequence()
    displayNote(newNotesSequence[0])
}

function displayNote(currentNote) {
    items.multipleStaff.addMusicElement("note", currentNote, "Quarter", false, false, items.background.clefType)
    if(!items.isTutorialMode) {
        items.addNoteTimer.interval = items.addNoteTimer.timerNormalInterval
        items.addNoteTimer.start()
    }
}

function wrongAnswer() {
    if(items.multipleStaff.musicElementRepeater.itemAt(1).x === (3 * items.multipleStaff.height / 25)) {
        items.multipleStaff.musicElementModel.remove(1)
        currentNoteIndex = (currentNoteIndex + 1) % newNotesSequence.length
    }

    items.progressBar.percentage = Math.max(0, items.progressBar.percentage - 4)
    items.multipleStaff.resumeNoteAnimation()
    if(items.multipleStaff.musicElementModel.count <= 1)
        items.addNoteTimer.restart()
}

function correctAnswer() {
    currentNoteIndex = (currentNoteIndex + 1) % newNotesSequence.length
    items.multipleStaff.pauseNoteAnimation()
    items.multipleStaff.musicElementModel.remove(1)
    items.multipleStaff.resumeNoteAnimation()
    items.progressBar.percentage += 2
    if(items.progressBar.percentage === 100) {
        items.multipleStaff.pauseNoteAnimation()
        items.wrongAnswerAnimation.stop()
        items.addNoteTimer.stop()
        items.bonus.good("flower")
    }
    else if(items.multipleStaff.musicElementModel.count <= 1)
        items.addNoteTimer.restart()
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

