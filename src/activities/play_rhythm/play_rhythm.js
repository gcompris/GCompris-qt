/* GCompris - play_rhythm.js
 *
 * Copyright (C) 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
 *   Aman Kumar Gupta <gupta2140@gmail.com> (Qt Quick port)
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
.pragma library
.import QtQuick 2.6 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var currentLevel = 0
var numberOfLevel
var currentSubLevel = 0
var currentNote = 0
var items
var levels
var isIntroductoryAudioPlaying = false

function start(items_) {
    items = items_
    currentLevel = 0
    levels = items.parser.parseFromUrl("qrc:/gcompris/src/activities/play_rhythm/resource/dataset.json").levels
    numberOfLevel = levels.length
    items.introductoryAudioTimer.start()
    initLevel()
}

function stop() {
    items.metronomeOscillation.stop()
    items.multipleStaff.stopAudios()
}

function initLevel() {
    items.bar.level = currentLevel + 1
    currentSubLevel = 0
    Core.shuffle(levels[currentLevel].melodies)
    items.multipleStaff.isPulseMarkerDisplayed = levels[currentLevel].pulseMarkerVisible
    items.isMetronomeVisible = levels[currentLevel].metronomeVisible
    nextSubLevel()
    currentNote = 0
}

function nextSubLevel() {
    currentSubLevel++
    items.score.currentSubLevel = currentSubLevel
    if(currentSubLevel > items.score.numberOfSubLevels)
        nextLevel()
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
    if((currentNote >= items.multipleStaff.musicElementModel.count - 1)) {
        if(!items.isWrongRhythm)
            items.bonus.good("flower")
        else
            items.bonus.bad("flower")
    }
}

function initSubLevel() {
     items.metronomeOscillation.stop()
     items.multipleStaff.stopAudios()
     currentNote = 0
     var currentSubLevelMelody = levels[currentLevel].melodies[currentSubLevel - 1]
     items.multipleStaff.loadFromData(currentSubLevelMelody)
     items.background.isRhythmPlaying = true
     items.isWrongRhythm = false

     if(!isIntroductoryAudioPlaying && !items.iAmReady.visible)
         items.multipleStaff.play()
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel) {
        currentLevel = 0
    }
    initLevel()
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel()
}
