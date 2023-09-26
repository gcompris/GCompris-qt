/* GCompris - play_piano.js
 *
 * SPDX-FileCopyrightText: 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
 *   Aman Kumar Gupta <gupta2140@gmail.com> (Qt Quick port)
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.12 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var currentSubLevel = 0
var numberOfLevel = 10
var noteIndexAnswered
var items
var levels
var incorrectAnswers = []
var isIntroductoryAudioPlaying = false

function start(items_) {
    items = items_
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    levels = items.parser.parseFromUrl("qrc:/gcompris/src/activities/play_piano/dataset.json").levels
    items.introductoryAudioTimer.start()
    initLevel()
}

function stop() {
    items.introductoryAudioTimer.stop()
    items.multipleStaff.stopAudios()
}

function initLevel() {
    currentSubLevel = 0
    Core.shuffle(levels[items.currentLevel])
    nextSubLevel()
}

function initSubLevel() {
    var currentSubLevelMelody = levels[items.currentLevel][currentSubLevel - 1]
    noteIndexAnswered = -1
    items.multipleStaff.loadFromData(currentSubLevelMelody)

    if(!isIntroductoryAudioPlaying && !items.iAmReady.visible)
        items.multipleStaff.play()
}

function nextSubLevel() {
    currentSubLevel++
    incorrectAnswers = []
    items.score.currentSubLevel = currentSubLevel
    if(currentSubLevel > levels[items.currentLevel].length)
        nextLevel()
    else
        initSubLevel()
}

function undoPreviousAnswer() {
    if(noteIndexAnswered >= 0) {
        items.multipleStaff.revertAnswer(noteIndexAnswered + 1)
        if(incorrectAnswers.indexOf(noteIndexAnswered) != -1)
            incorrectAnswers.pop()

        noteIndexAnswered--
    }
}

function checkAnswer(noteName) {
    var currentSubLevelNotes = levels[items.currentLevel][currentSubLevel - 1].split(' ')
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
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}
