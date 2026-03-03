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
var numberToGuess = 0

function start(items_) {
    items = items_
    items.numberOfLevel = items.levels.length
    items.currentLevel = Core.getInitialLevel(items.numberOfLevel)
    initLevel()
}

function stop() {
}

function initLevel() {
    items.currentMax = items.levels[items.currentLevel].maxNumber
    items.helico.init()
    items.helico.state = "horizontal"
    items.infoText.text = ""
    items.numpad.resetText()
    numberToGuess = getRandomInt(1, items.levels[items.currentLevel].maxNumber)
    items.textArea.text = items.levels[items.currentLevel].objective
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
    if(value > numberToGuess){
        items.infoText.text = qsTr("Your number is too high")
    }
    if(value < numberToGuess){
        items.infoText.text = qsTr("Your number is too low")
    }
    items.helico.state = "advancing"
    if(value === numberToGuess) {
        items.helico.correctAnswerMove()
        items.infoText.text = qsTr("You found the number!")
        items.bonus.good("tux")
    } else {
        var diff = Core.clamp((numberToGuess - value) / numberToGuess, -1, 1)
        items.helico.diffX = Math.abs(diff)
        items.helico.diffY = diff
    }
}
