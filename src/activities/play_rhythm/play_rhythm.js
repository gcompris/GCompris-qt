/* GCompris - play_rhythm.js
 *
 * SPDX-FileCopyrightText: 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
 *   Aman Kumar Gupta <gupta2140@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.12 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var numberOfLevel
var currentNote = 0
var items
var levels
var isIntroductoryAudioPlaying = false

function start(items_) {
    items = items_
    levels = items.parser.parseFromUrl("qrc:/gcompris/src/activities/play_rhythm/resource/dataset.json").levels
    numberOfLevel = levels.length
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    items.introductoryAudioTimer.start()
    initLevel()
}

function stop() {
    items.introductoryAudioTimer.stop()
    items.metronomeOscillation.stop()
    items.multipleStaff.stopAudios()
    items.score.stopWinAnimation()
}

function initLevel() {
    items.score.currentSubLevel = 0
    Core.shuffle(levels[items.currentLevel].melodies)
    items.multipleStaff.isPulseMarkerDisplayed = levels[items.currentLevel].pulseMarkerVisible
    items.isMetronomeVisible = levels[items.currentLevel].metronomeVisible
    nextSubLevel()
    currentNote = 0
}

function nextSubLevel() {
    if(items.score.currentSubLevel >= items.score.numberOfSubLevels)
        items.bonus.good("note")
    else
        initSubLevel()
}

function checkAnswer(pulseMarkerX) {
    currentNote++
    if(currentNote < items.multipleStaff.musicElementModel.count) {
        var accuracyLowerLimit = items.multipleStaff.musicElementRepeater.itemAt(currentNote).x
        var accuracyUpperLimit = accuracyLowerLimit + items.multipleStaff.musicElementRepeater.itemAt(currentNote).width
        if(pulseMarkerX >= accuracyLowerLimit && pulseMarkerX <= accuracyUpperLimit)
            items.multipleStaff.indicateAnsweredNote(true, currentNote)
        else {
            items.multipleStaff.indicateAnsweredNote(false, currentNote)
            items.isWrongRhythm = true
        }
    }
    if(currentNote > 0 && !items.multipleStaff.isMusicPlaying) {
        items.isWrongRhythm = true
        items.buttonsBlocked = true
        items.answerFeedbackTimer.restart()
    } else if((currentNote >= items.multipleStaff.musicElementModel.count - 1)) {
        items.buttonsBlocked = true
        items.answerFeedbackTimer.restart()
    }
}

function answerFeedback() {
    if(!items.isWrongRhythm) {
        items.score.currentSubLevel += 1
        items.score.playWinAnimation()
        items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/completetask.wav")
    } else {
        items.audioEffects.play("qrc:/gcompris/src/core/resource/sounds/crash.wav")
        items.crashPlayed = true
        items.answerFeedbackTimer.restart()
    }
}

function initSubLevel() {
    items.metronomeOscillation.stop()
    items.multipleStaff.stopAudios()
    currentNote = 0
    var currentSubLevelMelody = levels[items.currentLevel].melodies[items.score.currentSubLevel]
    items.multipleStaff.loadFromData(currentSubLevelMelody)
    items.background.isRhythmPlaying = true
    items.isWrongRhythm = false

    if(!isIntroductoryAudioPlaying && !items.iAmReady.visible)
        items.multipleStaff.play()

    items.buttonsBlocked = false
}

function nextLevel() {
    items.score.stopWinAnimation()
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel()
}

function previousLevel() {
    items.score.stopWinAnimation()
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel()
}
