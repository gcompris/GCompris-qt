/* GCompris - note_names.js
 *
 * SPDX-FileCopyrightText: 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Aman Kumar Gupta <gupta2140@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.12 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var numberOfLevel
var dataset
var items
var levels
var targetNotes = []
var newNotesSequence = []
var currentNoteIndex
var noteIndexToDisplay
var percentageDecreaseValue = 4
var percentageIncreaseValue = 2
var timerNormalInterval

function start(items_, timerNormalInterval_) {
    items = items_
    timerNormalInterval = timerNormalInterval_
    dataset = items.dataset.item
    levels = dataset.levels
    numberOfLevel = levels.length
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    items.doubleOctave.coloredKeyLabels = dataset.referenceNotes[levels[0]["clef"]]
    items.doubleOctave.currentOctaveNb = 1
    items.introMessage.intro = [dataset.objective]
    initLevel()
}

function stop() {
    newNotesSequence = []
    items.multipleStaff.pauseNoteAnimation()
    items.displayNoteNameTimer.stop()
    items.addNoteTimer.stop()
}

function initLevel() {
    targetNotes = []
    newNotesSequence = []
    items.background.clefType = levels[items.currentLevel]["clef"]
    items.doubleOctave.coloredKeyLabels = dataset.referenceNotes[items.background.clefType]
    if(items.background.clefType === "Treble")
        items.doubleOctave.currentOctaveNb = 1
    else
        items.doubleOctave.currentOctaveNb = 2

    items.multipleStaff.pauseNoteAnimation()
    items.displayNoteNameTimer.stop()
    items.addNoteTimer.stop()
    items.multipleStaff.initClefs(items.background.clefType)
    targetNotes = JSON.parse(JSON.stringify(levels[items.currentLevel]["sequence"]))
    items.isTutorialMode = true
    items.progressBar.percentage = 0
    items.multipleStaff.coloredNotes = dataset.referenceNotes[items.background.clefType]
    if(!items.iAmReady.visible  && !items.introMessage.visible)
        showTutorial()
}

function showTutorial() {
    items.messageBox.visible = false
    if(targetNotes.length) {
        displayNote(targetNotes[0])
        items.messageBox.visible = true
        targetNotes.shift()
    }
    else if (!items.iAmReady.visible) {
        items.isTutorialMode = false
        startGame()
    }
}

// The principle is to fill half sequence (length 25) with the notes from previous levels and another half with current level's target notes and shuffle them.
function formNewNotesSequence() {
    var halfSequenceLength = 25
    var fullSequenceLength = 50
    targetNotes = JSON.parse(JSON.stringify(levels[items.currentLevel]["sequence"]))
    for(var i = 0; i < items.currentLevel && newNotesSequence.length < halfSequenceLength; i++) {
        if(levels[items.currentLevel]["clef"] === levels[i]["clef"]) {
            for(var j = 0; j < levels[i]["sequence"].length && newNotesSequence.length < halfSequenceLength; j++)
                newNotesSequence.push(levels[i]["sequence"][j])
        }
    }

    for(var i = 0; newNotesSequence.length && newNotesSequence.length < halfSequenceLength; i++)
        newNotesSequence.push(newNotesSequence[i % newNotesSequence.length])

    for(var i = 0; newNotesSequence.length < fullSequenceLength; i++)
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
    items.multipleStaff.playNoteAudio(currentNote, "Quarter", items.background.clefType, 500)
    if(!items.isTutorialMode) {
        items.addNoteTimer.interval = timerNormalInterval
        items.addNoteTimer.start()
    }
}

function wrongAnswer() {
    if(items.multipleStaff.musicElementRepeater.itemAt(1).x <= items.multipleStaff.clefImageWidth) {
        items.multipleStaff.musicElementModel.remove(1)
        currentNoteIndex = (currentNoteIndex + 1) % newNotesSequence.length
    }

    items.progressBar.percentage = Math.max(0, items.progressBar.percentage - percentageDecreaseValue)
    items.multipleStaff.resumeNoteAnimation()
    if(items.multipleStaff.musicElementModel.count <= 1)
        items.addNoteTimer.restart()
}

function correctAnswer() {
    currentNoteIndex = (currentNoteIndex + 1) % newNotesSequence.length
    items.multipleStaff.pauseNoteAnimation()
    items.multipleStaff.musicElementModel.remove(1)
    items.multipleStaff.resumeNoteAnimation()
    items.progressBar.percentage += percentageIncreaseValue
    if(items.progressBar.percentage === 100) {
        items.multipleStaff.pauseNoteAnimation()
        items.displayNoteNameTimer.stop()
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
        items.displayNoteNameTimer.start()
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel)
    initLevel()
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel()
}
