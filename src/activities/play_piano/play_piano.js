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
    items.score.currentSubLevel = 0
    Core.shuffle(levels[items.currentLevel])
    nextSubLevel()
}

function initSubLevel() {
    var currentSubLevelMelody = levels[items.currentLevel][items.score.currentSubLevel]
    noteIndexAnswered = -1
    items.multipleStaff.loadFromData(currentSubLevelMelody)

    if(!isIntroductoryAudioPlaying && !items.iAmReady.visible)
        items.multipleStaff.play()
    items.buttonsBlocked = false
}

function nextSubLevel() {
    incorrectAnswers = []
    if(items.score.currentSubLevel >= levels[items.currentLevel].length)
        items.bonus.good("note")
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
    var currentSubLevelNotes = levels[items.currentLevel][items.score.currentSubLevel].split(' ')
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
            items.buttonsBlocked = true
            items.answerFeedbackTimer.restart()
        }
    }
}

function answerFeedback() {
    if(incorrectAnswers.length === 0) {
        items.score.currentSubLevel += 1
        items.score.playWinAnimation()
        items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/completetask.wav")
    } else {
        items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/crash.wav")
        items.buttonsBlocked = false
    }
}

function nextLevel() {
    items.score.stopWinAnimation()
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.score.stopWinAnimation()
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}
