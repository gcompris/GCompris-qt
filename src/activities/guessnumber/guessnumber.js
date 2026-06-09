/* GCompris - guessnumber.js
 *
 * SPDX-FileCopyrightText: 2014 Thib ROMAIN <thibrom@gmail.com>
 *
 * Authors:
 *   Clement Coudoin <clement.coudoin@free.fr> (GTK+ version)
 *   Thib ROMAIN <thibrom@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
.pragma library
.import QtQuick as Quick
.import "qrc:/gcompris/src/core/core.js" as Core

var items

function start(items_) {
    items = items_
    items.numberOfLevel = items.levels.length
    items.currentLevel = Core.getInitialLevel(items.numberOfLevel)
    initLevel()
}

function stop() {
}

function initLevel() {
    items.currentMin = items.levels[items.currentLevel].minNumber
    items.currentMax = items.levels[items.currentLevel].maxNumber
    items.helico.init()
    items.helico.state = "horizontal"
    items.infoText = ""
    items.numpad.resetText()
    items.answerText = "0"
    items.numberToGuess = getRandomInt(items.currentMin, items.currentMax)
    items.guessSteps = []
    items.client.startTiming()      // for server version.
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, items.numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, items.numberOfLevel);
    initLevel();
}

function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min);
}

function setUserAnswer(value){
    if(value === 0)
        return;

    items.guessSteps.push(value);

    if(value > items.numberToGuess){
        items.infoText = qsTr("Your number is too high.")
    }
    if(value < items.numberToGuess){
        items.infoText = qsTr("Your number is too low.")
    }
    items.helico.state = "advancing"
    if(value === items.numberToGuess) {
        items.helico.correctAnswerMove()
        items.infoText = qsTr("You found the number!")
        items.bonus.good("tux")
        items.client.sendToServer(true)
    } else {
        var diff = Core.clamp((items.numberToGuess - value) / items.numberToGuess, -1, 1)
        items.helico.diffX = Math.abs(diff)
        items.helico.diffY = diff
    }
}
