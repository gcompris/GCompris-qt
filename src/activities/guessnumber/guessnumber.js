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
.import QtQuick 2.9 as Quick

var currentLevel = 0
var numberOfLevel
var items
var numberToGuess = 0

function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {
}

function initLevel() {
    numberOfLevel = items.levels.length
    items.bar.level = currentLevel + 1
    items.currentMax = items.levels[currentLevel].maxNumber
    items.helico.init()
    items.helico.state = "horizontal"
    items.infoText.text = ""
    items.numpad.resetText()
    numberToGuess = getRandomInt(1, items.levels[currentLevel].maxNumber)
    items.textArea.text = items.levels[currentLevel].objective
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel ) {
        currentLevel = 0
    }
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel();
}

function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min);
}

function setUserAnswer(value){
    if(value === 0)
        return;
    if(value > items.levels[currentLevel].maxNumber){
        items.infoText.text = qsTr("Your number is too high")
        return;
    }
    if(value > numberToGuess){
        items.infoText.text = qsTr("Your number is too high")
    }
    if(value < numberToGuess){
        items.infoText.text = qsTr("Your number is too low")
    }
    items.helico.state = "advancing"
    if(value === numberToGuess) {
        items.infoText.text = qsTr("You found the number!")
        items.bonus.good("tux")
        items.helico.x = items.background.width
        items.helico.y = items.background.height / 2 - items.helico.height / 2
    } else {
        var diff = Math.abs(numberToGuess-value) / items.levels[currentLevel].maxNumber
        items.helico.x = (items.background.width-items.helico.width) - diff * items.background.width
        items.helico.y = items.background.height / 2 +
                ((numberToGuess-value) / items.levels[currentLevel].maxNumber) * (items.background.height/2) - items.helico.height / 2
    }
}
