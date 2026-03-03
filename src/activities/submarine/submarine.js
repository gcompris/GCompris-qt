/* GCompris - submarine.js
 *
 * SPDX-FileCopyrightText: 2017 Rudra Nil Basu <rudra.nil.basu.1996@gmail.com>
 *
 * Authors:
 *   Pascal Georges <pascal.georges1@free.fr> (GTK+ version)
 *   Rudra Nil Basu <rudra.nil.basu.1996@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import core 1.0 as GCompris
.import QtQuick as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var items

function start(items_) {
    items = items_
    items.currentLevel = Core.getInitialLevel(items.numberOfLevel)
    initLevel()
}

function stop() {
}

function initLevel() {

    /* Tutorial Levels, display tutorials */
    if (items.currentLevel < 3) {
        items.tutorial.visible = true
        items.tutorial.index = 0
    } else {
        items.tutorial.visible = false
    }

    setUpLevelElements()
}

function setUpLevelElements() {
    /* Set up initial position and state of the submarine */
    items.submarine.resetSubmarine()

    if(items.ship.visible) {
        items.ship.reset()
    }

    items.crown.reset()
    items.whale.reset()
    items.controls.resetVannes()

    items.processingAnswer = false

    resetUpperGate()
}

function resetUpperGate() {
    if (items && items.crown && !items.crown.visible && items.upperGate && items.upperGate.visible) {
        items.upperGate.isGateOpen = true
    }
}

function closeGate() {
    if (items.upperGate.visible) {
        items.upperGate.isGateOpen = false
    }
}

function finishLevel(win) {
    if (items.processingAnswer)
        return
    items.processingAnswer = true
    if (win) {
        items.bonus.good("flower")
    } else {
        items.submarine.destroySubmarine()
        items.bonus.bad("flower")
    }
}

function nextLevel() {
    items.processingAnswer = true
    closeGate()

    items.currentLevel = Core.getNextLevel(items.currentLevel, items.numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.processingAnswer = true
    closeGate()

    items.currentLevel = Core.getPreviousLevel(items.currentLevel, items.numberOfLevel);
    initLevel();
}
