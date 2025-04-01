/* GCompris - penalty.js
 *
 * SPDX-FileCopyrightText: 2014 Stephane Mankowski <stephane@mankowski.fr>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Stephane Mankowski <stephane@mankowski.fr> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (refactoring)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick 2.12 as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var numberOfLevel = 9
var items

var url = "qrc:/gcompris/src/activities/penalty/resource/"

function start(items_) {
    items = items_
    items.currentLevel = Core.getInitialLevel(numberOfLevel)
    initLevel()
}

function stop() {
}

function initLevel() {
    items.timerFail.stop()
    items.ballAnim.stop()
    if(items.currentLevel === 0) items.duration = 1000
    else if(items.currentLevel === 1) items.duration = 800
    else if(items.currentLevel === 2) items.duration = 700
    else if(items.currentLevel === 3) items.duration = 600
    else if(items.currentLevel === 4) items.duration = 500
    else if(items.currentLevel === 5) items.duration = 400
    else if(items.currentLevel === 6) items.duration = 350
    else if(items.currentLevel === 7) items.duration = 300
    else if(items.currentLevel === 8) items.duration = 250
    resetLevel()
}

function resetLevel() {
    items.ballToReturn = false
    items.ball.ballState = "INITIAL"
    items.saveBallState = "INITIAL"
    resetProgressBars();
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, numberOfLevel);
    initLevel();
}

function setBallToRetun() {
    resetProgressBars();
    items.ballToReturn = true;
    items.textItem.text = items.ball.resetBallInstruction;
}

function resetProgressBars() {
    items.progressRight.ratio = 0;
    items.progressLeft.ratio = 0;
    items.progressTop.ratio = 0;
}

function levelFailed() {
    items.timerFail.restart();
}

function changeBallState(side_, progress_) {
    /* This is a shoot */
    if(items.saveBallState === "INITIAL") { // if first click
        items.saveBallState = side_;
    } else if(items.ball.ballState === "FAIL" || // if already failed
        items.saveBallState != side_ || // or if first click on another side
        items.ball.ballState === side_) { // or if already win
        return;
    }

    if(progress_.ratio > 0) {
        /* Second click, stop animation */
        progress_.anim.running = false;

        /* Play sound */
        items.brickSound.play()

        /* Success or not */
        if(progress_.ratio < 1) {
            /* Success */
            items.ball.ballState = side_
        } else {
            /* failure */
            items.ball.ballState = "FAIL"
        }
    } else {
        /* First click, start animation*/
        progress_.anim.running = true;

        /* Play sound */
        items.flipSound.play()
    }
}
