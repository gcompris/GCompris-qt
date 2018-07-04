/* GCompris - play_piano.js
 *
 * Copyright (C) 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
 *   Aman Kumar Gupta <gupta2140@gmail.com> (Qt Quick port)
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
.pragma library
.import QtQuick 2.6 as Quick
.import "dataset.js" as Dataset
.import "qrc:/gcompris/src/core/core.js" as Core

var currentLevel = 0
var currentSubLevel = 0
var numberOfLevel = 12
var noteIndexAnswered
var items
var levels
var incorrectAnswers = []
var isIntroductoryAudioPlaying = false

function start(items_) {
    items = items_
    currentLevel = 0
    levels = Dataset.getData()
    items.piano.currentOctaveNb = 0
    items.introductoryAudioTimer.start()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    if([6, 11].indexOf(items.bar.level) === -1)
        items.piano.useSharpNotation = true
    else
        items.piano.useSharpNotation = false

    currentSubLevel = 0
    var threeNotesMelody = levels[currentLevel].slice(0, 3)
    var fourNotesMelody = levels[currentLevel].slice(3, 5)
    Core.shuffle(threeNotesMelody)
    Core.shuffle(fourNotesMelody)
    levels[currentLevel] = threeNotesMelody
    levels[currentLevel].push(fourNotesMelody[0])
    levels[currentLevel].push(fourNotesMelody[1])
    nextSubLevel()
}

function initSubLevel() {
    if(!items.iAmReady.visible) {
        var currentSubLevelMelody = levels[currentLevel][currentSubLevel - 1]
        noteIndexAnswered = -1
        items.multipleStaff.loadFromData(currentSubLevelMelody)

        if(items.bar.level === 1 || items.bar.level === 8)
            items.piano.currentOctaveNb = 0
        else if(items.bar.level === 2 || items.bar.level === 9)
            items.piano.currentOctaveNb = 1
        else if(items.bar.level === 3)
            items.piano.currentOctaveNb = 2
        else if(items.bar.level === 4)
            items.piano.currentOctaveNb = 3
        else
            items.piano.currentOctaveNb = items.piano.defaultOctaveNb

        if(!isIntroductoryAudioPlaying)
            items.multipleStaff.play()
    }
}

function nextSubLevel() {
    currentSubLevel++
    incorrectAnswers = []
    items.score.currentSubLevel = currentSubLevel
    if(currentSubLevel > levels[currentLevel].length)
        nextLevel()
    else
        initSubLevel()
}

// Function will be written when activity logic will be implemented.
function undoPreviousAnswer() {
    if(noteIndexAnswered >= 0) {
        items.multipleStaff.revertAnswer(noteIndexAnswered + 1)
        if(incorrectAnswers.indexOf(noteIndexAnswered) != -1)
            incorrectAnswers.pop()

        noteIndexAnswered--
    }
}

function checkAnswer(noteName) {
    var currentSubLevelNotes = levels[currentLevel][currentSubLevel - 1].split(' ')
    if(noteIndexAnswered < (currentSubLevelNotes.length - 2)) {
        noteIndexAnswered++
        var currentNote = currentSubLevelNotes[noteIndexAnswered + 1]
        if((noteName + "Quarter") === currentNote)
            items.multipleStaff.indicateAnsweredNote(true, noteIndexAnswered + 1)
        else {
            incorrectAnswers.push(noteIndexAnswered)
            items.multipleStaff.indicateAnsweredNote(false, noteIndexAnswered + 1)
        }

        if(noteIndexAnswered === (currentSubLevelNotes.length - 2)) {
            if(incorrectAnswers.length === 0)
                items.bonus.good("flower")
            else
                items.bonus.bad("flower")
        }
    }
}

function nextLevel() {
    if(!items.iAmReady.visible) {
        if(numberOfLevel <= ++currentLevel) {
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
