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
    items.addNoteTimer.stop()
    items.multipleStaff.pauseNoteAnimation()
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
    for(var i = 0; i < currentLevel; i++) {
        if(levels[currentLevel]["clef"] === levels[i]["clef"]) {
            for(var j = 0; j < levels[i]["sequence"].length; j++)
                newNotesSequence.push(levels[i]["sequence"][j])
        }
    }

    Core.shuffle(newNotesSequence)

    if(targetNotes.length >= newNotesSequence.length) {
        for(var i = 0; newNotesSequence[i] != undefined; i += 2)
            newNotesSequence.splice(i + 1, 0, targetNotes.shift())

        while(targetNotes.length)
            newNotesSequence.push(targetNotes.shift())
    }
    else {
        var notesPerInterval = Math.floor(newNotesSequence.length / targetNotes.length)
        for(var i = notesPerInterval; targetNotes.length; i += notesPerInterval) {
            newNotesSequence.splice(i, 0, targetNotes.shift())
        }
    }
}

function startGame() {
    currentNoteIndex = 0
    noteIndexToDisplay = 0
    items.progressBar.percentage = 0
    formNewNotesSequence()
    targetNotes = JSON.parse(JSON.stringify(levels[currentLevel]["sequence"]))
    displayNote(newNotesSequence[0])
}

function displayNote(currentNote) {
    console.log("New:" + JSON.stringify(newNotesSequence))
    items.multipleStaff.addMusicElement("note", currentNote, "Quarter", false, false, items.background.clefType)
    if(!items.isTutorialMode) {
        items.addNoteTimer.interval = items.addNoteTimer.timerNormalInterval
        items.addNoteTimer.start()
    }
}

function wrongAnswer() {
    if(noteIndexToDisplay >= newNotesSequence.length)
        noteIndexToDisplay -= 2
    else
        noteIndexToDisplay--
    items.progressBar.updatePercentage(targetNotes.indexOf(newNotesSequence[currentNoteIndex]) != 1, false)
    newNotesSequence.push(newNotesSequence[currentNoteIndex])
    newNotesSequence.splice(currentNoteIndex, 1)
    items.multipleStaff.musicElementModel.remove(1)
    items.multipleStaff.resumeNoteAnimation()
}

function correctAnswer() {
    items.progressBar.updatePercentage(targetNotes.indexOf(newNotesSequence[currentNoteIndex]) != -1, true)
    currentNoteIndex++
    items.multipleStaff.pauseNoteAnimation()
    items.multipleStaff.musicElementModel.remove(1)
    items.multipleStaff.resumeNoteAnimation()
    if(currentNoteIndex >= newNotesSequence.length)
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

